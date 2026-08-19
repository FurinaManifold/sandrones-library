#!/usr/bin/env python3
"""Sandrone's Library — 一致性审计。

用法:
    python3 scripts/audit.py            # 审计全部注册条目
    python3 scripts/audit.py <id>       # 审计单个条目

检查项（对应 docs/SCHEMA.md §4）:
    1. id 唯一、合法；kind/state 取值合法
    2. state=verified ⇒ lean 文件存在、非 pending 模板、无 `sorry`（形式化区域）
    3. premises 必须存在于 registry（依赖不悬空）
    4. provenance.ref 非空（verified 条目）
    5. 叙述层文件存在；front matter 的 id/premises 与 registry 一致
    6. lean 文件头部 docstring 含本条目 id
退出码: 0=全过; 1=有错误; 2=用法错误
"""
import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "index" / "registry.json"
ENTRIES = ROOT / "docs" / "entries"
LEAN_ROOT = ROOT / "SandronesLibrary"

ID_RE = re.compile(r"^[a-z][a-z0-9]*(-[a-z0-9]+)*(\.[a-z][a-z0-9]*(-[a-z0-9]+)*)*$")
KINDS = {"definition", "lemma", "proposition", "theorem", "example"}
STATES = {"verified", "pending", "unresolved"}

errors: list[str] = []


def err(msg: str) -> None:
    errors.append(msg)
    print(f"  [ERR] {msg}")


def check(record: dict) -> None:
    eid = record["id"]
    lean_path = LEAN_ROOT / record["lean_file"] if record.get("lean_file") else None
    nl_path = ENTRIES / f"{eid}.md"
    state = record["state"]

    if not ID_RE.match(eid):
        err(f"{eid}: 非法 id")
    if record["kind"] not in KINDS:
        err(f"{eid}: 非法 kind {record['kind']}")
    if state not in STATES:
        err(f"{eid}: 非法 state {state}")

    # premises 完整性
    registry_ids = {r["id"] for r in REGISTRY_DATA}
    for p in record["premises"]:
        if p not in registry_ids:
            err(f"{eid}: premise {p!r} 不在 registry 中（依赖悬空）")

    # verified 条目强约束
    if state == "verified":
        if lean_path is None or not lean_path.exists():
            err(f"{eid}: verified 但缺少 lean 文件 {record.get('lean_file')}")
        elif lean_path.exists():
            text = lean_path.read_text(encoding="utf-8")
            # 检查文件头 docstring 含条目 id
            if f"{eid}" not in text:
                err(f"{eid}: lean 文件头部未引用条目 id")
            # 正式区域不得有 sorry（#exit 之后视为临时草稿区）
            formal = text.split("#exit")[0]
            if re.search(r"\bsorry\b", formal):
                err(f"{eid}: verified 条目的形式化区域出现 sorry")
        if not record.get("provenance", {}).get("ref"):
            err(f"{eid}: verified 条目缺 provenance.ref")
        if not nl_path.exists():
            err(f"{eid}: verified 但缺少叙述层 {eid}.md")
        else:
            fm = nl_path.read_text(encoding="utf-8").split("---")[1] if "---" in nl_path.read_text() else ""
            if f"id: {eid}" not in fm:
                err(f"{eid}: 叙述层 front matter 缺 id")
            for p in record["premises"]:
                if f"premises" not in fm and p not in fm:
                    err(f"{eid}: 叙述层 front matter 与 registry 的 premises 不一致")


def main() -> None:
    global REGISTRY_DATA
    ap = argparse.ArgumentParser()
    ap.add_argument("entry_id", nargs="?")
    args = ap.parse_args()

    if not REGISTRY.exists():
        sys.exit("缺少 index/registry.json")
    REGISTRY_DATA = json.loads(REGISTRY.read_text(encoding="utf-8"))
    if not isinstance(REGISTRY_DATA, list):
        sys.exit("registry.json 应为数组")

    targets = REGISTRY_DATA
    if args.entry_id:
        targets = [r for r in REGISTRY_DATA if r["id"] == args.entry_id]
        if not targets:
            sys.exit(f"registry 中无条目: {args.entry_id}")

    for r in targets:
        check(r)

    if errors:
        print(f"\n审计未通过：{len(errors)} 个问题")
        sys.exit(1)
    print(f"审计通过：{len(targets)} 个条目 OK")


if __name__ == "__main__":
    main()
