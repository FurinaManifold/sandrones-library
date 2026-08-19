#!/usr/bin/env python3
"""Sandrone's Library — 公理依赖审计工具（定理级精确）。

对 registry 中 verified 条目，从其 .lean 文件里按 `> **Entry**: <id>` docstring 标记
精确定位该条目对应的定理/定义，用 `#print axioms` 获取真实公理依赖，
与 registry 的 `axioms` 字段比对。

用法:
    python3 scripts/check_axioms.py <entry-id>   # 检查单个
    python3 scripts/check_axioms.py --all        # 检查全部 verified
    python3 scripts/check_axioms.py --all --fix  # 不一致时回写 registry

输出: 每条目打印 实际公理 与 登记的对比；不一致时退出码 1（除非 --fix）。
"""
import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

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
    for line in lean_text.splitlines():
        stripped = line.strip()
        if m := NAMESPACE_RE.match(stripped):
            stack.append(m.group(1))
        elif m := END_NS_RE.match(stripped):
            if stack:
                stack.pop()
        elif m := ENTRY_RE.search(line):
            entries.append((lean_text.index(line), m.group(1)))
        elif m := DECL_RE.match(stripped):
            full = ".".join(stack + [m.group(2)])
            decls.append((lean_text.index(line), full))
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


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("entry_id", nargs="?")
    ap.add_argument("--all", action="store_true")
    ap.add_argument("--fix", action="store_true")
    args = ap.parse_args()

    data = json.loads(REGISTRY.read_text(encoding="utf-8"))
    targets = data if args.all else [r for r in data if r["id"] == args.entry_id]
    if not args.all and not targets:
        sys.exit(f"registry 中无此条目: {args.entry_id}")
    targets = [r for r in targets if r["state"] == "verified"]
    if not targets:
        sys.exit("没有 verified 条目可审计")

    bad = 0
    for rec in targets:
        lf = LEAN_ROOT / rec["lean_file"]
        if not lf.exists():
            print(f"[SKIP] {rec['id']}: 缺 lean 文件")
            continue
        mapping = map_entry_to_decl(lf.read_text(encoding="utf-8"))
        decls = mapping.get(rec["id"])
        if not decls:
            print(f"[SKIP] {rec['id']}: lean 文件未关联到带 **Entry** 标记的定理")
            continue
        module = "SandronesLibrary." + str(rec["lean_file"]).replace("/", ".")[:-5]
        actual: set[str] = set()
        for d, ax in probe_axioms(decls, module).items():
            print(f"  {d}: {ax}")
            actual.update(ax)
        actual = sorted(actual)
        recorded = sorted(rec.get("axioms", []))
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
        json.dump(data, open(REGISTRY, "w"), ensure_ascii=False, indent=2)
        open(REGISTRY, "a").write("\n")
    sys.exit(1 if bad and not args.fix else 0)


if __name__ == "__main__":
    main()
