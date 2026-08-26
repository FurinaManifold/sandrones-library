#!/usr/bin/env python3
"""缓存米游社观测枢角色页面，并提取供书稿 ROLE 研究使用的可定位文本。

原始页面与提取文本写入 .cache/world-formula/miyoushe，默认不进入 Git。脚本不下载音频、图片，
也不把原文复制到 docs；仓库只维护 ROLE 中的归纳结论和来源定位。
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import time
import urllib.request
from datetime import datetime, timezone
from pathlib import Path

from lxml import etree


HOME_URL = (
    "https://api-static.mihoyo.com/common/blackboard/ys_obc/v1/home/content/list"
    "?app_sn=ys_obc&channel_id=189"
)
DETAIL_URL = (
    "https://act-api-takumi-static.mihoyo.com/hoyowiki/genshin/wapi/entry_page"
    "?entry_page_id={}"
)
USER_AGENT = "SandronesLibrary-WorldFormula/1.0 (private textual research cache)"
DEFAULT_CACHE = Path(".cache/world-formula/miyoushe")


def fetch_json(url: str) -> dict:
    request = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(request, timeout=45) as response:
        payload = json.load(response)
    if payload.get("retcode") != 0:
        raise RuntimeError(f"API error for {url}: {payload.get('message')}")
    return payload


def safe_name(name: str) -> str:
    return re.sub(r"[^0-9A-Za-z\u3400-\u9fff._-]+", "-", name).strip("-")


def compact_text(node: etree._Element) -> str:
    pieces: list[str] = []
    for text in node.itertext():
        cleaned = " ".join(text.split())
        if cleaned:
            pieces.append(cleaned)
    return "\n".join(pieces)


def text_from_component_data(value: object) -> list[str]:
    """从新版观测枢 component data 中提取可读文本，忽略 URL 和布局元数据。"""
    if isinstance(value, dict):
        pieces: list[str] = []
        for key, child in value.items():
            if key in {"url", "icon_url", "image", "audio", "style", "layout"}:
                continue
            pieces.extend(text_from_component_data(child))
        return pieces
    if isinstance(value, list):
        return [piece for child in value for piece in text_from_component_data(child)]
    if not isinstance(value, str) or not value.strip():
        return []
    stripped = value.strip()
    if stripped.startswith(("http://", "https://")):
        return []
    if "<" in stripped and ">" in stripped:
        root = etree.HTML(stripped)
        return [compact_text(root)] if root is not None else []
    return [" ".join(stripped.split())]


def extract_character(page: dict) -> dict:
    sections: list[dict[str, object]] = []
    for module in page.get("modules", []):
        name = module.get("name", "").strip()
        if not (name.startswith("角色故事") or name in {
            "角色详细", "更多描述", "配音展示", "角色关系网"
        }):
            continue
        components: list[dict[str, object]] = []
        for component in module.get("components", []):
            raw_data = component.get("data", "")
            try:
                data = json.loads(raw_data) if isinstance(raw_data, str) else raw_data
            except json.JSONDecodeError:
                data = raw_data
            text = "\n".join(dict.fromkeys(text_from_component_data(data)))
            if text:
                components.append({
                    "component_id": component.get("component_id"),
                    "text": text,
                })
        if components:
            sections.append({"name": name, "components": components})

    return {
        "content_id": page.get("id"),
        "title": page.get("name"),
        "summary": page.get("desc", ""),
        "version": page.get("version"),
        "fetched_at": datetime.now(timezone.utc).isoformat(),
        "source_url": DETAIL_URL.format(page.get("id")),
        "sections": sections,
    }


def character_catalog(home: dict) -> list[dict]:
    roots = home["data"]["list"]
    atlas = next(x for x in roots if x.get("name") == "图鉴")
    characters = next(x for x in atlas.get("children", []) if x.get("name") == "角色")
    return [
        {
            "content_id": item["content_id"],
            "title": item["title"].strip(),
            "summary": item.get("summary", ""),
        }
        for item in characters.get("list", [])
    ]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("names", nargs="*", help="只抓取这些角色；省略时仅刷新目录")
    parser.add_argument("--all-characters", action="store_true", help="抓取目录中的全部角色页面")
    parser.add_argument("--cache-dir", type=Path, default=DEFAULT_CACHE)
    parser.add_argument("--delay", type=float, default=0.25, help="相邻详情请求的最小间隔秒数")
    args = parser.parse_args()

    args.cache_dir.mkdir(parents=True, exist_ok=True)
    raw_dir = args.cache_dir / "raw"
    extracted_dir = args.cache_dir / "characters"
    raw_dir.mkdir(exist_ok=True)
    extracted_dir.mkdir(exist_ok=True)

    home = fetch_json(HOME_URL)
    catalog = character_catalog(home)
    (args.cache_dir / "catalog.json").write_text(
        json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )

    requested = set(args.names)
    if args.all_characters:
        selected = catalog
    elif requested:
        selected = [x for x in catalog if x["title"] in requested]
        missing = requested - {x["title"] for x in selected}
        if missing:
            raise SystemExit(f"目录中没有这些角色：{', '.join(sorted(missing))}")
    else:
        print(f"角色目录已刷新：{len(catalog)} 项；未请求详情页面。")
        return

    manifest: list[dict] = []
    for index, item in enumerate(selected):
        if index:
            time.sleep(max(args.delay, 0))
        content_id = item["content_id"]
        payload = fetch_json(DETAIL_URL.format(content_id))
        raw = json.dumps(payload, ensure_ascii=False, indent=2) + "\n"
        raw_path = raw_dir / f"{content_id}.json"
        raw_path.write_text(raw, encoding="utf-8")
        extracted = extract_character(payload["data"]["page"])
        extracted_path = extracted_dir / f"{safe_name(item['title'])}-{content_id}.json"
        extracted_path.write_text(
            json.dumps(extracted, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
        )
        manifest.append({
            "content_id": content_id,
            "title": item["title"],
            "source_url": DETAIL_URL.format(content_id),
            "raw_sha256": hashlib.sha256(raw.encode()).hexdigest(),
            "section_count": len(extracted["sections"]),
        })
        print(
            f"{item['title']} ({content_id}): "
            f"{len(extracted['sections'])} relevant sections"
        )

    (args.cache_dir / "fetch-manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )


if __name__ == "__main__":
    main()
