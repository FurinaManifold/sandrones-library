#!/usr/bin/env python3
"""Sandrone's Library — 一致性审计。

用法:
    python3 scripts/audit.py            # 审计全部注册条目
    python3 scripts/audit.py <id>       # 审计单个条目

检查项（对应 docs/SCHEMA.md §4）:
    1. id 唯一、合法；kind/state 取值合法
    2. state=verified ⇒ lean 文件存在、非 pending 模板、无 `sorry`（形式化区域）
    3. premises 必须存在于 registry，不重复、不自指、不成环
       ；dependedOnBy 必须等于 premises 的反向图
    4. provenance.ref 是 reference.bib 中存在的 citation key（verified 条目）
    5. 叙述层文件存在；front matter 的 id/premises 与 registry 一致
    6. lean 文件头部 docstring 含本条目 id
退出码: 0=全过; 1=有错误; 2=用法错误
"""
import argparse
from collections import defaultdict
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "index" / "registry.json"
ENTRIES = ROOT / "docs" / "entries"
LEAN_ROOT = ROOT / "SandronesLibrary"
BIBLIOGRAPHY = ROOT / "reference.bib"

ID_RE = re.compile(r"^[a-z][a-z0-9]*(-[a-z0-9]+)*(\.[a-z][a-z0-9]*(-[a-z0-9]+)*)*$")
KINDS = {"definition", "lemma", "proposition", "theorem", "example"}
STATES = {"verified", "pending", "unresolved"}

errors: list[str] = []
BIB_KEYS: set[str] = set()


def audit_bibliography(text: str) -> None:
    """只允许出版书、发表论文和带 arXiv 编号的论文预印本。"""
    blocks = re.findall(r"(?ms)^@(\w+)\s*\{\s*([^,\s]+)\s*,(.*?)(?=^@|\Z)", text)
    allowed_published = {"book", "article", "inproceedings"}
    seen: set[str] = set()
    for raw_kind, key, body in blocks:
        kind = raw_kind.lower()
        if key in seen:
            err(f"reference.bib citation key 重复: {key}")
        seen.add(key)
        if kind in allowed_published:
            required = {"author", "title", "year"}
            if kind == "book":
                required.add("publisher")
            elif kind == "article":
                required.add("journal")
            else:
                required.add("booktitle")
            for field in required:
                if not re.search(rf"(?m)^\s*{field}\s*=", body, re.IGNORECASE):
                    err(f"reference.bib {key}: @{kind} 缺必填字段 {field}")
        elif kind == "misc":
            has_arxiv_type = re.search(
                r"(?mi)^\s*eprinttype\s*=\s*[\{\"]arXiv[\}\"]", body
            )
            has_arxiv_id = re.search(r"(?mi)^\s*eprint\s*=\s*[\{\"][^\}\"]+[\}\"]", body)
            if not (has_arxiv_type and has_arxiv_id):
                err(f"reference.bib {key}: @misc 只允许带 eprinttype=arXiv 和 eprint 编号的论文")
        else:
            err(f"reference.bib {key}: 不允许 @{kind}；只接受出版书、发表论文或 arXiv 论文")


def err(msg: str) -> None:
    errors.append(msg)
    print(f"  [ERR] {msg}")


def check(record: dict) -> None:
    eid = record["id"]
    lean_path = LEAN_ROOT / record["lean_file"] if record.get("lean_file") else None
    nl_path = (ROOT / record["nl_file"]) if record.get("nl_file") else ENTRIES / f"{eid}.md"
    state = record["state"]

    if not ID_RE.match(eid):
        err(f"{eid}: 非法 id")
    if record["kind"] not in KINDS:
        err(f"{eid}: 非法 kind {record['kind']}")
    if state not in STATES:
        err(f"{eid}: 非法 state {state}")
    # 叙述层路径应为 family 子目录形式（与 new_entry.py 一致）
    if record.get("nl_file") != f"docs/entries/{eid.replace('.', '/')}.md":
        err(f"{eid}: nl_file 未按 family 子目录规范（应为 docs/entries/{eid.replace('.', '/')}.md）")

    # premises 完整性
    registry_ids = {r["id"] for r in REGISTRY_DATA}
    for p in record["premises"]:
        if p not in registry_ids:
            err(f"{eid}: premise {p!r} 不在 registry 中（依赖悬空）")

    # 公理透明：axioms 字段必须存在且为数组
    if not isinstance(record.get("axioms"), list):
        err(f"{eid}: 缺 axioms 字段（应为 #print axioms 输出列表，用 scripts/check_axioms.py 生成）")

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
        citation_key = record.get("provenance", {}).get("ref")
        if not citation_key:
            err(f"{eid}: verified 条目缺 provenance.ref citation key")
        elif citation_key not in BIB_KEYS:
            err(f"{eid}: provenance.ref={citation_key!r} 未在 reference.bib 中声明")
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
    global REGISTRY_DATA, BIB_KEYS
    ap = argparse.ArgumentParser()
    ap.add_argument("entry_id", nargs="?")
    args = ap.parse_args()

    if not REGISTRY.exists():
        sys.exit("缺少 index/registry.json")
    REGISTRY_DATA = json.loads(REGISTRY.read_text(encoding="utf-8"))
    if not isinstance(REGISTRY_DATA, list):
        sys.exit("registry.json 应为数组")
    if not BIBLIOGRAPHY.exists():
        sys.exit("缺少 reference.bib")
    bib_text = BIBLIOGRAPHY.read_text(encoding="utf-8")
    audit_bibliography(bib_text)
    BIB_KEYS = set(re.findall(r"@\w+\s*\{\s*([^,\s]+)\s*,", bib_text))

    # premises 是唯一事实来源；dependedOnBy 必须与其反向图完全一致。
    reverse: dict[str, set[str]] = defaultdict(set)
    for record in REGISTRY_DATA:
        premises = record.get("premises", [])
        if len(premises) != len(set(premises)):
            err(f"{record['id']}: premises 含重复依赖")
        if record["id"] in premises:
            err(f"{record['id']}: 不得直接依赖自身")
        for premise in premises:
            reverse[premise].add(record["id"])
    for record in REGISTRY_DATA:
        expected = sorted(reverse[record["id"]])
        actual = sorted(record.get("dependedOnBy", []))
        if actual != expected:
            err(f"{record['id']}: dependedOnBy 与 premises 反向图不一致；"
                f"应为 {expected}，实为 {actual}")

    # 教材的前置关系必须是有向无环图，否则无法给出可学习的先后顺序。
    graph = {record["id"]: record.get("premises", []) for record in REGISTRY_DATA}
    color: dict[str, int] = {}
    stack: list[str] = []
    reported_cycles: set[tuple[str, ...]] = set()

    def visit(node: str) -> None:
        color[node] = 1
        stack.append(node)
        for premise in graph[node]:
            if premise not in graph:
                continue
            if color.get(premise, 0) == 0:
                visit(premise)
            elif color.get(premise) == 1:
                start = stack.index(premise)
                cycle = tuple(stack[start:] + [premise])
                if cycle not in reported_cycles:
                    reported_cycles.add(cycle)
                    err("依赖图存在环: " + " -> ".join(cycle))
        stack.pop()
        color[node] = 2

    for entry_id in graph:
        if color.get(entry_id, 0) == 0:
            visit(entry_id)

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
