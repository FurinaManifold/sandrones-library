#!/usr/bin/env python3
"""Rebuild editable diagrams, vector PDFs, screenshots and the ten-page report."""
from pathlib import Path
import hashlib
import json
import re
import shutil
import subprocess
import sys

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
    run([sys.executable, "draw_figures.py"])
    manifest = json.loads((HERE / "figure-manifest.json").read_text(encoding="utf-8"))
    figure_receipts = []
    for figure in manifest["figures"]:
        stem = figure["stem"]
        cairosvg.svg2pdf(url=str(HERE / f"{stem}.svg"), write_to=str(HERE / f"{stem}.pdf"))
        with fitz.open(HERE / f"{stem}.pdf") as diagram:
            page = diagram[0]
            page.get_pixmap(matrix=fitz.Matrix(2, 2), alpha=False).save(HERE / f"{stem}.png")
            for block in page.get_text("dict")["blocks"]:
                for line in block.get("lines", []):
                    for span in line["spans"]:
                        x0, y0, x1, y1 = span["bbox"]
                        if x0 < 0 or y0 < 0 or x1 > page.rect.width or y1 > page.rect.height:
                            raise SystemExit(f"Diagram text out of bounds in {stem}: {span['text']}")
        points = figure["min_label_font_px"] * figure["report_width_mm"] / 25.4 * 72 / figure["canvas_width_px"]
        if points < 8:
            raise SystemExit(f"Diagram labels smaller than 8pt when embedded: {stem}")
        figure_receipts.append({
            "stem": stem, "minimum_embedded_font_pt": round(points, 2),
            "sha256": {suffix: hashlib.sha256((HERE / f"{stem}.{suffix}").read_bytes()).hexdigest()
                       for suffix in ("svg", "pdf", "png")},
            "checks": {"text_bounds": "pass", "minimum_embedded_font": "pass"},
        })
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
                for name in ("project-introduction.md", "report-template.tex", "inline-code.lua", "build_report.py", "draw_figures.py", "figure-manifest.json") + tuple(f"{f['stem']}.svg" for f in manifest["figures"])
            },
            "figures": figure_receipts,
            "checks": {"page_count": "pass", "chapter_per_page": "pass", "printable_text_bounds": "pass"},
        }
    (HERE / "render-receipt.json").write_text(
        json.dumps(receipt, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(f"Rendered {OUT.name}: {receipt['pages']} pages")


if __name__ == "__main__":
    main()
