#!/usr/bin/env python3
"""将 registry.json 中的自由文本来源无损迁移到根目录 reference.bib。

已经是 citation key 的 provenance.ref 保持不变；尚未迁移的文本使用 SHA-256
生成稳定 key。该脚本可重复运行，不会改变已有 key。
"""

import hashlib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "index" / "registry.json"
BIBLIOGRAPHY = ROOT / "reference.bib"
KEY_RE = re.compile(r"^[A-Za-z][A-Za-z0-9_:.+/-]*$")
ENTRY_RE = re.compile(r"@\w+\s*\{\s*([^,\s]+)\s*,")


def bib_escape(text: str) -> str:
    """把原始资料作为一个 BibTeX 字段保存，不改写其中的书名与定位信息。"""
    return (text.replace("\\", "\\textbackslash{}")
                .replace("{", "\\{")
                .replace("}", "\\}")
                .replace("%", "\\%")
                .replace("#", "\\#")
                .replace("&", "\\&"))


def stable_key(text: str) -> str:
    return "sandrones-ref-" + hashlib.sha256(text.encode("utf-8")).hexdigest()[:16]


def main() -> None:
    records = json.loads(REGISTRY.read_text(encoding="utf-8"))
    old_bib = BIBLIOGRAPHY.read_text(encoding="utf-8") if BIBLIOGRAPHY.exists() else ""
    known_keys = set(ENTRY_RE.findall(old_bib))
    additions: dict[str, str] = {}

    for record in records:
        provenance = record.get("provenance", {})
        ref = provenance.get("ref", "").strip()
        if not ref:
            continue
        if ref in known_keys:
            continue
        # 只有已在文献库中声明的字符串才被视为 key；其余全部按旧来源文本迁移。
        key = stable_key(ref)
        previous = additions.get(key)
        if previous is not None and previous != ref:
            raise RuntimeError(f"citation key 碰撞: {key}")
        additions[key] = ref
        provenance["ref"] = key

    header = (
        "% Sandrone's Library 统一参考文献库\n"
        "% registry.json 的 provenance.ref 只存放本文件中的 citation key。\n"
        "% 迁移生成的 @misc 条目保留了历史来源原文；后续可补全为 @book/@article。\n\n"
    )
    blocks = []
    for key, raw in sorted(additions.items()):
        blocks.append(
            f"@misc{{{key},\n"
            f"  title = {{{{{bib_escape(raw)}}}}},\n"
            "  note = {{从 registry.json 历史 provenance 无损迁移}}\n"
            "}\n"
        )

    if not old_bib:
        new_bib = header + "\n".join(blocks)
    elif blocks:
        new_bib = old_bib.rstrip() + "\n\n" + "\n".join(blocks)
    else:
        new_bib = old_bib

    REGISTRY.write_text(json.dumps(records, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    BIBLIOGRAPHY.write_text(new_bib, encoding="utf-8")
    print(f"已迁移 {len(additions)} 条独立来源；Registry 共 {len(records)} 条。")


if __name__ == "__main__":
    main()
