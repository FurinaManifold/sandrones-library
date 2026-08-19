#!/usr/bin/env python3
"""Sandrone's Library — 自动生成 docs/entries/README.md 索引。

从 index/registry.json 读取条目，按家族（entry-id 去掉最后一段）分组，
列出每条目的叙述层路径与状态。未注册的计划条目见 ROADMAP-math-analysis.md。

用法:
    python3 scripts/gen_entries_index.py [--out docs/entries/README.md]
"""
import argparse
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "index" / "registry.json"

MARK = {"verified": "✅", "pending": "🕓", "unresolved": "⚠️"}


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=str(ROOT / "docs" / "entries" / "README.md"))
    args = ap.parse_args()

    data = json.loads(REGISTRY.read_text(encoding="utf-8"))
    if not isinstance(data, list):
        sys.exit("registry.json 应为数组")

    groups: dict[str, list[dict]] = {}
    for r in data:
        family = r["id"].rsplit(".", 1)[0]
        groups.setdefault(family, []).append(r)

    now = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    lines = [
        "# Entries 索引",
        "",
        f"> 自动生成（{now}）— 请勿手改；改动 registry 后重跑 `python3 scripts/gen_entries_index.py`。",
        "",
        "> 叙述层按**家族**（entry-id 去掉最后一段）存放在 `docs/entries/<family>/…`。",
        "> 权威数据在 `index/registry.json`。",
        "> 状态图例：✅ verified &#183; 🕓 pending &#183; ⚠️ unresolved。",
        "",
        f"共 **{len(data)}** 个条目（verified "
        f"{sum(1 for r in data if r['state']=='verified')}，pending "
        f"{sum(1 for r in data if r['state']=='pending')}）。",
        "",
    ]

    for family in sorted(groups):
        lines.append(f"## `{family}`")
        lines.append("")
        for r in sorted(groups[family], key=lambda x: x["id"]):
            rel = Path(r["nl_file"]).name
            href = f"{r['id'].rsplit('.', 1)[-1]}.md"
            lines.append(f"- {MARK.get(r['state'], '❓')} [`{rel}`]({'_'.join(href.split('_'))}) — {r['title']}")
        lines.append("")
    lines.append("> 未注册的计划条目见 `docs/ROADMAP-math-analysis.md`。")
    lines.append("")

    out = Path(args.out)
    out.write_text("\n".join(lines), encoding="utf-8")
    print(f"已生成 {out.relative_to(ROOT)}（{len(data)} 条目）")


if __name__ == "__main__":
    main()