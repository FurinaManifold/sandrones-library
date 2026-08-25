#!/usr/bin/env python3
"""由 premises 重建 Registry 的反向直接依赖 dependedOnBy。

premises 是依赖图的唯一事实来源；dependedOnBy 只是为查询和排名保留的可重建缓存。
"""

import json
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "index" / "registry.json"


def rebuild(records: list[dict]) -> int:
    known = {record["id"] for record in records}
    reverse: dict[str, set[str]] = defaultdict(set)
    dangling: list[tuple[str, str]] = []
    for record in records:
        for premise in record.get("premises", []):
            if premise not in known:
                dangling.append((record["id"], premise))
            else:
                reverse[premise].add(record["id"])
    if dangling:
        detail = ", ".join(f"{source} -> {target}" for source, target in dangling)
        raise SystemExit(f"存在悬空依赖，拒绝重建: {detail}")

    changed = 0
    for record in records:
        expected = sorted(reverse[record["id"]])
        if record.get("dependedOnBy", []) != expected:
            record["dependedOnBy"] = expected
            changed += 1
    return changed


def main() -> None:
    records = json.loads(REGISTRY.read_text(encoding="utf-8"))
    changed = rebuild(records)
    REGISTRY.write_text(json.dumps(records, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    edge_count = sum(len(record.get("premises", [])) for record in records)
    print(f"依赖图已重建：{edge_count} 条直接边，更新 {changed} 个反向缓存。")


if __name__ == "__main__":
    main()
