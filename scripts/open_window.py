#!/usr/bin/env python3
"""开一个并行窗口：建 worktree → 接线 → 每个 Entry 生成 pack → 渲染简令。

Playbook §10.2 的机械化实现。窗口定义是数据（`docs/dispatch/windows/<窗口>.json`），
本脚本不含任何窗口特有的散文——散文只允许出现在 `--note` 片段里（§10.1）。

    python3 scripts/open_window.py --spec docs/dispatch/windows/e1.json [--dry-run]

spec 字段：
    window, subject, batch, role, branch, worktree, slug, note(可选), entries[]
    entries[]: id, lean_file, premises[], mathlib[], goal_nl, registered(可选，默认自动判定)

对每个 Entry 生成一个 pack；目标 Entry 未登记 Registry 时自动走 `--new-entry` 计划模式。
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(Path(__file__).resolve().parent))
import context_pack as cp  # noqa: E402
import dispatch_brief as db  # noqa: E402


def sh(*args: str, cwd: Path | None = None, check: bool = True) -> str:
    r = subprocess.run(args, cwd=cwd or ROOT, capture_output=True, text=True)
    if check and r.returncode != 0:
        raise SystemExit(f"[ERR] {' '.join(args)}\n{r.stdout}{r.stderr}")
    return r.stdout.strip()


def verify_mathlib(names: list[str]) -> list[str]:
    """对窗口定义里的 `mathlib` 候选做真实 `#check`（Playbook §10.7）。

    候选名义上是"未验证提示"，但**错的提示比没有提示更贵**：窗口会花真实时间去试一个
    根本不存在的名字，再回头怀疑自己的方向。2026-10-13 Wave E 实测 42 个候选里 13 个
    不存在（31%），其中多数只是命名空间写错（`Kernel.rnDeriv` 应为
    `ProbabilityTheory.Kernel.rnDeriv`），少数是整个概念在 Mathlib 里没有承载
    （`GenContFract.of_sqrt`、`MeasureTheory.maximalFunction`）——后者恰恰是窗口最需要
    提前知道的边界。所以开窗前必须机械实测，不靠记忆。
    """
    uniq = sorted(set(names))
    if not uniq:
        return []
    tmp = Path(tempfile.mkdtemp(prefix="sandrones-mathlib-probe-")) / "probe.lean"
    tmp.write_text("import Mathlib\n" + "\n".join(f"#check @{n}" for n in uniq) + "\n",
                   encoding="utf-8")
    line_of = {i + 2: n for i, n in enumerate(uniq)}  # 第 1 行是 import
    r = subprocess.run(["lake", "env", "lean", str(tmp)], cwd=ROOT,
                       capture_output=True, text=True)
    bad: list[str] = []
    for m in re.finditer(rf"^{re.escape(str(tmp))}:(\d+):\d+: error", r.stderr, re.M):
        n = line_of.get(int(m.group(1)))
        if n and n not in bad:
            bad.append(n)
    if not bad and r.returncode != 0:
        raise SystemExit("[ERR] Mathlib 候选实测未能运行（不是候选的问题）：\n"
                         f"{r.stdout}{r.stderr}")
    return bad


def main() -> None:
    ap = argparse.ArgumentParser(description="开窗：worktree + pack + 简令")
    ap.add_argument("--spec", required=True)
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--check-only", action="store_true",
                    help="只跑 Mathlib 候选门禁，不开窗")
    ap.add_argument("--skip-mathlib-check", action="store_true",
                    help="跳过候选门禁（仅在 Mathlib 尚未构建等基础设施原因下使用）")
    a = ap.parse_args()

    spec = json.loads(Path(a.spec).read_text(encoding="utf-8"))
    wt = Path(spec["worktree"])
    branch = spec["branch"]
    base = spec.get("base") or sh("git", "rev-parse", "HEAD")
    brief_rel = f"docs/dispatch/{spec['window'].lower()}-{spec['slug']}.md"
    registry = cp.load_registry()

    # ── 0. Mathlib 候选门禁（Playbook §10.7）────────────────────────────────
    # 必须在建 worktree 之前：候选不干净就不该留下半个窗口。
    cands = [m for e in spec["entries"] for m in e.get("mathlib", [])]
    if a.skip_mathlib_check:
        print("[warn] 已跳过 Mathlib 候选门禁")
    else:
        bad = verify_mathlib(cands)
        if bad:
            raise SystemExit(
                "[ERR] 以下 mathlib 候选在真实 Mathlib 中不存在（`#check` 实测）：\n"
                + "\n".join(f"  - {n}" for n in bad)
                + "\n处理方式只有两种：改成实测通过的真名，或从窗口定义里删掉。\n"
                  "不得把不存在的名字写进窗口定义——它会被当成 pack 的未验证提示下发。")
        print(f"[ok  ] mathlib 候选 {len(set(cands))} 个全部实测通过")
    if a.check_only:
        return

    # ── 1. worktree ────────────────────────────────────────────────────────
    listed = sh("git", "worktree", "list", "--porcelain")
    if str(wt) in listed:
        print(f"[skip] worktree 已存在：{wt}")
    elif a.dry_run:
        print(f"[dry ] git worktree add {wt} -b {branch} {base[:8]}")
    else:
        sh("git", "worktree", "add", str(wt), "-b", branch, base)
        print(f"[ok  ] worktree {wt} @ {branch}（基线 {base[:8]}）")

    # ── 2. 接线：.lake/packages 软链到主工作树（不复制 build） ──────────────
    if not a.dry_run and wt.exists():
        pkg = wt / ".lake" / "packages"
        target = ROOT / ".lake" / "packages"
        if not pkg.exists():
            pkg.parent.mkdir(parents=True, exist_ok=True)
            pkg.symlink_to(target)
            print(f"[ok  ] {pkg} -> {target}")
        elif not pkg.is_symlink():
            print(f"[warn] {pkg} 已存在且不是软链，请人工确认")

    # ── 3. 每个 Entry 一个 pack ────────────────────────────────────────────
    pack_paths: list[Path] = []
    for e in spec["entries"]:
        registered = e.get("registered", e["id"] in registry)
        argv = ["--subject", spec["subject"], "--batch", spec["batch"], "--entry", e["id"],
                "--role", spec.get("role", "subject-maintainer"),
                "--goal-nl", e["goal_nl"],
                "--worktree", str(wt), "--branch", branch, "--base", base, "--brief", brief_rel,
                "--out", ""]
        if not registered:
            argv += ["--new-entry", "--lean-file", e["lean_file"],
                     "--premises", ",".join(e.get("premises", [])),
                     "--mathlib", ",".join(e.get("mathlib", []))]
        ns = cp.build(_ns(argv))
        out = wt / "traces" / "packs" / f"{ns['pack_id']}.json"
        if a.dry_run:
            print(f"[dry ] pack {ns['pack_id']} -> {out}")
        else:
            out.parent.mkdir(parents=True, exist_ok=True)
            out.write_text(json.dumps(ns, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
            print(f"[ok  ] pack {ns['pack_id']}"
                  f"（登记={registered}，out_of_scope={len(ns['scope']['out_of_scope'])} 条）")
        pack_paths.append(out)

    # ── 4. 简令（从 pack 渲染，手写残量只来自 note 片段） ──────────────────
    note = spec.get("note")
    note_text = (ROOT / note).read_text(encoding="utf-8") if note else ""
    brief = ROOT / brief_rel
    if a.dry_run:
        print(f"[dry ] brief {brief}")
    else:
        brief.parent.mkdir(parents=True, exist_ok=True)
        packs = [json.loads(p.read_text(encoding="utf-8")) for p in pack_paths]
        brief.write_text(db.render(spec["window"], packs, note_text), encoding="utf-8")
        print(f"[ok  ] brief {brief}")
        print(f"[ok  ] check: ", end="")
        rc = subprocess.run([sys.executable, str(ROOT / "scripts" / "context_pack.py"),
                             "check", *[str(p) for p in pack_paths]],
                            capture_output=True, text=True)
        print(rc.stdout.strip() or rc.stderr.strip())
        if rc.returncode != 0:
            raise SystemExit("[ERR] pack 校验未通过")


def _ns(argv: list[str]):
    """把 CLI 参数喂给 context_pack 的 argparse（复用 build 的唯一实现，不重写逻辑）。"""
    ap = argparse.ArgumentParser()
    ap.add_argument("--subject", required=True)
    ap.add_argument("--batch", required=True)
    ap.add_argument("--entry", required=True)
    ap.add_argument("--new-entry", action="store_true")
    ap.add_argument("--lean-file", default=None)
    ap.add_argument("--premises", default="")
    ap.add_argument("--mathlib", default="")
    ap.add_argument("--role", default="subject-maintainer")
    ap.add_argument("--worker", default=None)
    ap.add_argument("--goal-nl", required=True)
    ap.add_argument("--prototype", default=None)
    ap.add_argument("--depth", type=int, default=2)
    ap.add_argument("--worktree", default=None)
    ap.add_argument("--branch", default=None)
    ap.add_argument("--base", default=None)
    ap.add_argument("--brief", default=None)
    ap.add_argument("--out", required=True)
    return ap.parse_args(argv)


if __name__ == "__main__":
    main()
