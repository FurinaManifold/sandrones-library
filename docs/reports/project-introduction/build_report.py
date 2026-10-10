#!/usr/bin/env python3
"""Rebuild the ten-page report from Markdown, its template and the SVG figure."""
from pathlib import Path
import hashlib
import json
import re
import shutil
import subprocess

import cairosvg
import fitz

HERE = Path(__file__).resolve().parent
OUT = HERE / "project-introduction.pdf"


def run(args: list[str]) -> None:
    subprocess.run(args, cwd=HERE, check=True)


def main() -> None:
    for tool in ("pandoc", "xelatex"):
        if shutil.which(tool) is None:
            raise SystemExit(f"Missing executable: {tool}")
    cairosvg.svg2pdf(url=str(HERE / "workflow.svg"), write_to=str(HERE / "workflow.pdf"))
    run([
        "pandoc", "project-introduction.md", "--standalone",
        "--template=report-template.tex", "--pdf-engine=xelatex", "--lua-filter=inline-code.lua",
        "--syntax-highlighting=tango", "-o", str(OUT),
    ])
    with fitz.open(OUT) as doc:
        if doc.page_count != 10:
            raise SystemExit(f"Expected 10 pages, got {doc.page_count}; inspect layout.")
        for i, page in enumerate(doc, 1):
            text = page.get_text()
            if not re.search(rf"(?m)^{i}\s", text):
                raise SystemExit(f"Expected chapter {i} on page {i}; inspect layout.")
            for block in page.get_text("dict")["blocks"]:
                for line in block.get("lines", []):
                    for span in line["spans"]:
                        x0, _, x1, _ = span["bbox"]
                        if x0 < 35 or x1 > page.rect.width - 35:
                            raise SystemExit(f"Text exceeds printable area on page {i}: {span['text']}")
        receipt = {
            "artifact": OUT.name,
            "pages": doc.page_count,
            "sha256": hashlib.sha256(OUT.read_bytes()).hexdigest(),
            "source_sha256": hashlib.sha256((HERE / "project-introduction.md").read_bytes()).hexdigest(),
            "input_sha256": {
                name: hashlib.sha256((HERE / name).read_bytes()).hexdigest()
                for name in ("project-introduction.md", "report-template.tex", "inline-code.lua", "workflow.svg", "build_report.py")
            },
            "checks": {"page_count": "pass", "chapter_per_page": "pass", "printable_text_bounds": "pass"},
        }
    (HERE / "render-receipt.json").write_text(
        json.dumps(receipt, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(f"Rendered {OUT.name}: {receipt['pages']} pages")


if __name__ == "__main__":
    main()
