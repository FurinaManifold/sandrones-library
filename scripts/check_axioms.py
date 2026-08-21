#!/usr/bin/env python3
"""Sandrone's Library — 公理依赖审计工具（定理级精确，增量式）。

对 registry 中 verified 条目，从其 .lean 文件里按 `> **Entry**: <id>` docstring 标记
精确定位该条目对应的定理/定义，用 `#print axioms` 获取真实公理依赖，
与 registry 的 `axioms` 字段比对。

增量机制（默认开启）：每条目记录 lean 文件的指纹 `proof_sha`。若 `proof_sha`
与当前 lean 文件哈希一致且 `axioms` 字段已登记，则跳过验证（该条目此前通过且
源文件未变）。`--fix` 在验证通过后回写指纹。`--full` 可强制全量重验。

用法:
    python3 scripts/check_axioms.py <entry-id>   # 检查单个
    python3 scripts/check_axioms.py --all        # 检查全部 verified（增量跳过未变更）
    python3 scripts/check_axioms.py --all --fix  # 不一致/缺字段时回写 registry
    python3 scripts/check_axioms.py --all --fix --full  # 忽略指纹，全量重验

输出: 每条目打印 实际公理 与 登记的对比；不一致时退出码 1（除非 --fix）。
"""
import argparse
import hashlib
import json
import re
import subprocess
import sys
from pathlib import Path

from tqdm import tqdm

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "index" / "registry.json"
LEAN_ROOT = ROOT / "SandronesLibrary"

NAMESPACE_RE = re.compile(r"^namespace\s+([\w.]+)")
END_NS_RE = re.compile(r"^end\s+([\w.]+)\s*$")
DECL_RE = re.compile(r"^(theorem|lemma|def)\s+(\w+)")
ENTRY_RE = re.compile(r">\s*\*\*Entry\*\*:\s*([\w.\-]+)")
AXIOMS_DEP = re.compile(r"depends on axioms:\s*\[([^\]]*)\]")
AXIOMS_NONE = re.compile(r"does not depend on any axioms")


def map_entry_to_decl(lean_text: str) -> dict[str, list[str]]:
    """把每个 `**Entry**: <id>` 关联到紧跟其 docstring 之后的所有定理/定义全名。"""
    # 收集 (字符偏移, entry_id) 与 (字符偏移, full_decl_name)
    entries: list[tuple[int, str]] = []
    decls: list[tuple[int, str]] = []
    stack: list[str] = []
    offset = 0
    for line in lean_text.splitlines():
        stripped = line.strip()
        if m := NAMESPACE_RE.match(stripped):
            stack.append(m.group(1))
        elif m := END_NS_RE.match(stripped):
            if stack:
                stack.pop()
        elif m := ENTRY_RE.search(line):
            entries.append((offset, m.group(1)))
        elif m := DECL_RE.match(stripped):
            full = ".".join(stack + [m.group(2)])
            decls.append((offset, full))
        offset += len(line) + 1
    # 对每个 decl 找它前面最近（且在 docstring 内）的 Entry
    result: dict[str, list[str]] = {}
    for dpos, dname in decls:
        best = None
        for epos, eid in entries:
            if epos < dpos:
                if best is None or epos > best[0]:
                    best = (epos, eid)
            else:
                break
        if best is not None:
            result.setdefault(best[1], []).append(dname)
    return result


def probe_axioms_batch(modules: list[tuple[str, list[str]]]) -> dict[str, dict[str, list[str]]]:
    """批量：每个模块只启动一次 lean 进程，probe 其中所有声明的 axioms。

    modules: [(module, [decls...]), ...]
    returns: {module: {decl: [axioms]}}
    """
    probe = Path("/tmp/opencode/check_axioms_probe.lean")
    probe.parent.mkdir(parents=True, exist_ok=True)
    body: list[str] = []
    for mod, decls in modules:
        body.append(f"import {mod}")
        body.extend(f"#print axioms {d}" for d in decls)
    probe.write_text("\n".join(body))
    env = dict(__import__("os").environ)
    env["PATH"] = str(Path.home() / ".elan/bin") + ":" + env.get("PATH", "")
    r = subprocess.run(
        ["lake", "env", "lean", str(probe)],
        capture_output=True, text=True, cwd=ROOT, env=env)
    out = r.stdout + r.stderr
    result: dict[str, dict[str, list[str]]] = {}
    # 所有声明的扁平列表
    all_decls = [d for _, ds in modules for d in ds]
    # 每个模块的 (start_idx, end_idx)
    acc: dict[str, list[int]] = {}
    i = 0
    for mod, ds in modules:
        acc[mod] = list(range(i, i + len(ds)))
        i += len(ds)
    for mod, idxs in acc.items():
        result[mod] = {}
        for k in idxs:
            d = all_decls[k]
            rest = out[out.index(d) + len(d):]
            seg = rest.split(all_decls[k + 1])[0] if k + 1 < len(all_decls) else rest
            if AXIOMS_NONE.search(seg):
                result[mod][d] = []
            elif m := AXIOMS_DEP.search(seg):
                result[mod][d] = [x.strip() for x in m.group(1).split(",") if x.strip()]
            else:
                result[mod][d] = ["<解析失败>"]
    return result


def probe_axioms(decls: list[str], module: str) -> dict[str, list[str]]:
    probe = Path("/tmp/opencode/check_axioms_probe.lean")
    probe.parent.mkdir(parents=True, exist_ok=True)
    body = [f"import {module}"] + [f"#print axioms {d}" for d in decls]
    probe.write_text("\n".join(body))
    env = dict(__import__("os").environ)
    env["PATH"] = str(Path.home() / ".elan/bin") + ":" + env.get("PATH", "")
    r = subprocess.run(
        ["lake", "env", "lean", str(probe)],
        capture_output=True, text=True, cwd=ROOT, env=env)
    out = r.stdout + r.stderr
    result: dict[str, list[str]] = {}
    for i, d in enumerate(decls):
        rest = out[out.index(d) + len(d):]
        seg = rest.split(decls[i + 1])[0] if i + 1 < len(decls) else rest
        if AXIOMS_NONE.search(seg):
            result[d] = []
        elif m := AXIOMS_DEP.search(seg):
            result[d] = [x.strip() for x in m.group(1).split(",") if x.strip()]
        else:
            result[d] = ["<解析失败>"]
    return result


def file_sha(path: Path) -> str:
    return hashlib.sha1(path.read_bytes()).hexdigest()[:16]


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("entry_id", nargs="?")
    ap.add_argument("--all", action="store_true")
    ap.add_argument("--fix", action="store_true")
    ap.add_argument("--full", action="store_true",
                    help="忽略增量指纹，对全部 verified 全量重验")
    args = ap.parse_args()

    data = json.loads(REGISTRY.read_text(encoding="utf-8"))
    targets = data if args.all else [r for r in data if r["id"] == args.entry_id]
    if not args.all and not targets:
        sys.exit(f"registry 中无此条目: {args.entry_id}")
    targets = [r for r in targets if r["state"] == "verified"]
    if not targets:
        sys.exit("没有 verified 条目可审计")

    bad = 0
    total = len(targets)

    # 第一遍：收集需要实际 probe 的条目（增量跳过的直接打印），按 lean 文件分组
    to_probe: dict[str, list[dict]] = {}      # module -> [rec]
    results: dict[str, dict[str, list[str]]] = {}  # module -> {decl: axioms}
    all_skipped = 0

    for rec in targets:
        lf = LEAN_ROOT / rec["lean_file"]
        if not lf.exists():
            print(f"[SKIP] {rec['id']}: 缺 lean 文件")
            continue
        sha = file_sha(lf)
        rec["_sha"] = sha
        if (not args.full and rec.get("proof_sha") == sha
                and isinstance(rec.get("axioms"), list)):
            all_skipped += 1
            continue
        mapping = map_entry_to_decl(lf.read_text(encoding="utf-8"))
        decls = mapping.get(rec["id"])
        if not decls:
            print(f"[SKIP] {rec['id']}: lean 文件未关联到带 **Entry** 标记的定理")
            continue
        module = "SandronesLibrary." + str(rec["lean_file"]).replace("/", ".")[:-5]
        rec["_module"] = module
        rec["_decls"] = decls
        to_probe.setdefault(module, []).append(rec)

    if not to_probe:
        print(f"[DONE] 全部 {total} 条目增量跳过（{all_skipped} 条）。--full 强制全量。")
        if args.fix:
            json.dump(data, open(REGISTRY, "w"), ensure_ascii=False, indent=2)
            open(REGISTRY, "a").write("\n")
        sys.exit(0)

    # 第二遍：按文件分组批量 probe（每文件只启动一次 lean）
    print(f"[INFO] 需实际审计 {sum(len(v) for v in to_probe.values())} 条 / {total} 条，"
          f"按 {len(to_probe)} 个 lean 文件批量验证", file=sys.stderr)
    bar = tqdm(list(to_probe.items()), desc="审计", unit="文件", file=sys.stderr,
               ncols=100, dynamic_ncols=True)
    for module, recs in bar:
        bar.set_description(f"审计 {module.split('.')[-1]}")
        decls = [d for r in recs for d in r["_decls"]]
        results[module] = probe_axioms_batch([(module, decls)])[module]

    # 第三遍：逐条目比对
    for rec in targets:
        if "_decls" not in rec:
            continue
        module = rec["_module"]
        actual: set[str] = set()
        for d in rec["_decls"]:
            ax = results[module][d]
            print(f"    {d}: {ax}")
            actual.update(ax)
        actual = sorted(actual)
        recorded = sorted(rec.get("axioms", []))
        sha = rec["_sha"]
        rec["proof_sha"] = sha
        if actual != recorded:
            print(f"[DIFF] {rec['id']}:\n   实际={actual}\n   登记={recorded}")
            if args.fix:
                rec["axioms"] = actual
                print(f"  -> 已回写 registry")
            bad += 1
        else:
            print(f"[OK]   {rec['id']}: axioms 一致 ({actual})")
            if args.fix and "axioms" not in rec:
                rec["axioms"] = actual
                print(f"  -> 补充写入 registry")

    if args.fix:
        # 移除临时字段（绝不写回 registry）
        for rec in data:
            for k in ("_sha", "_module", "_decls"):
                rec.pop(k, None)
        json.dump(data, open(REGISTRY, "w"), ensure_ascii=False, indent=2)
        open(REGISTRY, "a").write("\n")
    sys.exit(1 if bad and not args.fix else 0)


if __name__ == "__main__":
    main()
