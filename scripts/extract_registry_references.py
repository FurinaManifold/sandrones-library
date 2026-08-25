#!/usr/bin/env python3
"""验证 Registry 只引用 reference.bib 中已有的合规 citation key。

自由文本来源不再自动生成为 @misc。新增来源必须先以已出版书籍、已发表论文，
或带 arXiv 编号的论文预印本写入 reference.bib，再把 citation key 写入 Registry。
"""

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "index" / "registry.json"
BIBLIOGRAPHY = ROOT / "reference.bib"
KEY_RE = re.compile(r"^[A-Za-z][A-Za-z0-9_:.+/-]*$")
ENTRY_RE = re.compile(r"@\w+\s*\{\s*([^,\s]+)\s*,")


def main() -> None:
    records = json.loads(REGISTRY.read_text(encoding="utf-8"))
    old_bib = BIBLIOGRAPHY.read_text(encoding="utf-8") if BIBLIOGRAPHY.exists() else ""
    known_keys = set(ENTRY_RE.findall(old_bib))
    unknown: list[tuple[str, str]] = []

    for record in records:
        provenance = record.get("provenance", {})
        ref = provenance.get("ref", "").strip()
        if not ref:
            continue
        if ref in known_keys:
            continue
        unknown.append((record.get("id", "<missing-id>"), ref))

    if unknown:
        details = "\n".join(f"  {eid}: {ref}" for eid, ref in unknown)
        raise RuntimeError(
            "Registry 出现未在 reference.bib 声明的来源。禁止自动生成 @misc；"
            "请先登记合规出版物或 arXiv 论文：\n" + details
        )
    print(f"文献引用验证通过：Registry 共 {len(records)} 条，未生成 @misc。")


if __name__ == "__main__":
    main()
