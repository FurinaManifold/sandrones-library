#!/usr/bin/env python3
"""Sandrone's Library — 新条目脚手架。

用法:
    python3 scripts/new_entry.py analysis.fixedpoint.banach \
        --kind theorem \
        --title "巴拿赫不动点定理" \
        --summary "完备度量空间上的压缩映射有唯一不动点" \
        --premises analysis.metric.complete analysis.metric.contraction \
        --mathlib exists_fixedPoint_of_isContraction \
        --ref "Rudin, Principles of Mathematical Analysis, Thm 9.22"

产物:
    1. docs/entries/<entry-id>.md      （叙述层模板，state=pending）
    2. registry.json 新增记录          （state=pending）
    3. 若 --lean-file 不存在，创建占位 .lean 文件（含条目头占位）
"""
import argparse
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "index" / "registry.json"
ENTRIES = ROOT / "docs" / "entries"
LEAN_ROOT = ROOT / "SandronesLibrary"

KINDS = {"definition", "lemma", "proposition", "theorem", "example"}
STATES = {"verified", "pending", "unresolved"}

ID_RE = re.compile(r"^[a-z][a-z0-9]*(-[a-z0-9]+)*(\.[a-z][a-z0-9]*(-[a-z0-9]+)*)*$")


def load_registry() -> list:
    with open(REGISTRY) as f:
        return json.load(f)


def save_registry(data: list) -> None:
    with open(REGISTRY, "w") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write("\n")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("entry_id")
    ap.add_argument("--kind", default="theorem")
    ap.add_argument("--title", default="")
    ap.add_argument("--summary", default="")
    ap.add_argument("--premises", nargs="*", default=[])
    ap.add_argument("--mathlib", nargs="*", default=[])
    ap.add_argument("--ref", default="")
    ap.add_argument("--lean-file", default=None,
                    help="相对模块路径，如 Analysis/FixedPoint.lean；缺省由 id 推导")
    args = ap.parse_args()

    eid = args.entry_id
    if not ID_RE.match(eid):
        sys.exit(f"非法 entry-id: {eid!r}（应为点分小写路径，如 analysis.fixedpoint.banach）")
    if args.kind not in KINDS:
        sys.exit(f"kind 必须是 {sorted(KINDS)}")
    for p in args.premises:
        if not ID_RE.match(p):
            sys.exit(f"非法 premise id: {p!r}")

    registry = load_registry()
    if any(r["id"] == eid for r in registry):
        sys.exit(f"条目已存在: {eid}")

    # 缺省 Lean 文件路径由 id 推导
    if args.lean_file is None:
        parts = eid.split(".")
        mod = parts[0].capitalize()
        fname = "".join(s.capitalize() for s in parts[1:-1]) or "Basic"
        args.lean_file = f"{mod}/{fname}.lean"

    lean_path = LEAN_ROOT / args.lean_file
    lean_path.parent.mkdir(parents=True, exist_ok=True)
    if not lean_path.exists():
        module = "SandronesLibrary." + args.lean_file.replace("/", ".")[:-5]
        lean_path.write_text(
            f"""import Mathlib

namespace SandronesLibrary

/--
> **Entry**: {eid}
> **状态**: pending（占位，待纳入）
> **一句话**: {args.summary}
-/
-- TODO: 在此填入陈述与证明（见 docs/INGESTION_PROTOCOL.md Step 2-4）

end SandronesLibrary
""")
        print(f"创建 Lean 占位: {lean_path.relative_to(ROOT)}")
    else:
        print(f"Lean 文件已存在，跳过: {lean_path.relative_to(ROOT)}")

    record = {
        "id": eid,
        "kind": args.kind,
        "state": "pending",
        "title": args.title,
        "summary": args.summary,
        "premises": args.premises,
        "mathlib": args.mathlib,
        "provenance": {
            "source_type": "book" if args.ref else "generated",
            "ref": args.ref,
        },
        "lean_file": str(args.lean_file),
        "nl_file": f"docs/entries/{eid}.md",
        "added_by": f"ingestor-{sys.argv[0].split('/')[-1]}",
        "added_at": datetime.now(timezone.utc).isoformat(timespec="seconds").replace("+00:00", "Z"),
        "dependedOnBy": [],
    }
    registry.append(record)
    save_registry(registry)

    md_path = ENTRIES / f"{eid}.md"
    md_path.parent.mkdir(parents=True, exist_ok=True)
    md_path.write_text(
        f"""---
id: {eid}
kind: {args.kind}
state: pending
title: "{args.title}"
premises: {json.dumps(args.premises, ensure_ascii=False)}
mathlib: {json.dumps(args.mathlib, ensure_ascii=False)}
provenance:
  source_type: book
  ref: "{args.ref}"
---

# 动机

# 直觉

# 陈述（自然语言）

# 陈述（Lean 对照）

# 思维脉络（thinking trace）

# 自然语言 ↔ Lean 映射

# 依赖（人话版）

# 应用与陷阱
""")
    print(f"创建叙述层: {md_path.relative_to(ROOT)}")
    print(f"已注册（pending）: {eid}")


if __name__ == "__main__":
    main()
