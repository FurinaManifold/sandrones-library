#!/usr/bin/env python3
"""Sandrone's Library — 候选批次发布门（release gate）。

设计来源：`docs/reports/project-introduction/project-introduction.md` §7 发布层与 §8 第 3 项
「按候选批次合并，而非相信旧构建」。发布程序把已验收的学科包叠加到**最新目标分支**，统一
生成共享索引，再检查这个**实际候选整体**；只有候选本身通过，才由唯一发布写者推进最终版本。

本脚本 = 唯一发布写者的验收队列执行器：
    1. 核对每个学科验收包（`scripts/subject_package.py` 产物）的提交确已在 main（patch-id）
    2. 在候选（当前 main 工作树）上按 AGENTS §6 顺序重跑生成器、公理审计、audit、diff 与全库 build
    3. 逐步记录 rc/耗时/输出尾部，产出发布回执 JSON；任一步失败即整体失败，失败批次拆分定位

用法:
    python3 scripts/release_gate.py [--package <pkg.json> ...] [--skip-build] [--receipt <path>] [--json]

退出码: 0=候选整体通过; 1=有步骤或包核对失败
"""
from __future__ import annotations

import argparse
import datetime
import json
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCHEMA = "sandrones-release-receipt/1"


def run(cmd: list[str], timeout: int | None = None) -> tuple[int, str, float]:
    t0 = time.time()
    try:
        p = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True, timeout=timeout)
        out = (p.stdout + p.stderr).strip()
        return p.returncode, out, time.time() - t0
    except subprocess.TimeoutExpired:
        return 124, f"timeout after {timeout}s", time.time() - t0


def git(*args: str) -> tuple[int, str]:
    p = subprocess.run(["git", *args], cwd=ROOT, capture_output=True, text=True)
    return p.returncode, p.stdout.strip()


def main() -> None:
    ap = argparse.ArgumentParser(description="候选批次发布门")
    ap.add_argument("--package", action="append", default=[], help="学科验收包 JSON（可重复）")
    ap.add_argument("--skip-build", action="store_true", help="跳过全库 lake build")
    ap.add_argument("--receipt", default=None)
    ap.add_argument("--json", action="store_true")
    args = ap.parse_args()

    now = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    exceptions: list[dict] = []

    # ---- 候选前提：main 工作树必须清洁且 pkg 提交已在 main ----
    _, status = git("status", "--porcelain")
    if status:
        exceptions.append({"gate": "candidate", "kind": "dirty_main",
                           "detail": f"main 工作树有 {len(status.splitlines())} 处未提交改动"})
    _, head = git("rev-parse", "HEAD")
    _, branch = git("rev-parse", "--abbrev-ref", "HEAD")

    package_reports = []
    for path in args.package:
        p = Path(path)
        pkg = json.loads(p.read_text(encoding="utf-8"))
        # patch-id 核对：包内每个提交应已在 main（`-` = 已应用）
        rc, out = git("cherry", "HEAD", pkg["head"])
        missing = [l for l in out.splitlines() if l.startswith("+")]
        if missing:
            exceptions.append({"gate": "package", "kind": "unmerged_commits",
                               "detail": f"{pkg.get('subject')}: {len(missing)} 个提交未进 main"})
        package_reports.append({
            "subject": pkg.get("subject"), "head": pkg.get("head"),
            "verdict": pkg.get("verdict"), "unmerged": len(missing),
        })

    steps = [
        ("extract_registry_references", [sys.executable, "scripts/extract_registry_references.py"], None),
        ("update_dependency_graph", [sys.executable, "scripts/update_dependency_graph.py"], None),
        ("gen_entries_index", [sys.executable, "scripts/gen_entries_index.py"], None),
        ("gen_entry_rankings", [sys.executable, "scripts/gen_entry_rankings.py"], None),
    ]
    # 新条目所在模块必须先编译，`check_axioms --all --fix` 的探针才能加载 olean。
    if not args.skip_build:
        steps.append(("lake_build", ["lake", "build"], 3600))
    steps += [
        ("check_axioms_fix", [sys.executable, "scripts/check_axioms.py", "--all", "--fix"], None),
        ("check_axioms", [sys.executable, "scripts/check_axioms.py", "--all"], None),
        ("audit", [sys.executable, "scripts/audit.py"], None),
        ("diff_check", ["git", "diff", "--check"], None),
    ]
    if not args.skip_build:
        steps.append(("lake_build_final", ["lake", "build"], 3600))

    results = []
    for name, cmd, timeout in steps:
        rc, out, dt = run(cmd, timeout)
        results.append({
            "step": name, "exit": rc, "seconds": round(dt, 1),
            "tail": "\n".join(out.splitlines()[-4:]),
        })
        if rc != 0:
            exceptions.append({"gate": "step", "kind": name,
                               "detail": f"exit={rc}: " + (out.splitlines()[-1] if out else "")})

    _, derived = git("status", "--porcelain")
    derived_files = [l[3:] for l in derived.splitlines()]

    receipt = {
        "schema": SCHEMA,
        "checked_at": now,
        "branch": branch,
        "head": head,
        "candidate_dirty_before": bool(status),
        "packages": package_reports,
        "steps": results,
        "derived_state_files": derived_files,
        "exceptions": exceptions,
        "verdict": "pass" if not exceptions else "fail",
    }

    receipt_path = Path(args.receipt) if args.receipt else ROOT / "docs" / "releases" / f"release-receipt-{now.replace(':', '')}.json"
    receipt_path.parent.mkdir(parents=True, exist_ok=True)
    receipt_path.write_text(json.dumps(receipt, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    if args.json:
        print(json.dumps(receipt, ensure_ascii=False, indent=2))
    else:
        print(f"候选批次发布门 @ {branch} {head[:9]}")
        for r in results:
            mark = "✅" if r["exit"] == 0 else "❌"
            print(f"  {mark} {r['step']:<28} {r['seconds']:>7.1f}s")
        if exceptions:
            print(f"\n  异常清单（{len(exceptions)}）：")
            for e in exceptions:
                print(f"    [{e['gate']}] {e['kind']}: {e['detail'][:160]}")
        print(f"\n  verdict: {receipt['verdict']}")
        try:
            shown = receipt_path.relative_to(ROOT)
        except ValueError:
            shown = receipt_path
        print(f"  回执：{shown}")

    sys.exit(0 if not exceptions else 1)


if __name__ == "__main__":
    main()
