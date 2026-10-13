#!/usr/bin/env python3
"""生成条目依赖排行。

Registry 的 premises 是教材依赖事实源；本脚本只生成可随时重建的
index/rankings.json 和 docs/entries/RANKINGS.md，不把排名写回 Registry。
"""

import json
import math
import re
from collections import Counter, defaultdict, deque
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "index" / "registry.json"
LEAN_ROOT = ROOT / "SandronesLibrary"
JSON_OUT = ROOT / "index" / "rankings.json"
MARKDOWN_OUT = ROOT / "docs" / "entries" / "RANKINGS.md"

ENTRY_DECL_RE = re.compile(
    r">\s*\*\*Entry\*\*:\s*([a-z0-9.-]+).*?-/(?:\s|/\*.*?\*/)*"
    r"(?:private\s+)?(?:theorem|lemma|def|abbrev|structure|class)\s+([A-Za-z_][A-Za-z0-9_']*)",
    re.DOTALL,
)


def subject(entry_id: str) -> str:
    return entry_id.split(".", 1)[0]


def strip_lean_comments_and_strings(text: str) -> str:
    """删除 Lean 的行注释、可嵌套块注释与字符串，保留换行以利于文件级计数。"""
    out: list[str] = []
    i = 0
    block_depth = 0
    in_string = False
    while i < len(text):
        pair = text[i:i + 2]
        if block_depth:
            if pair == "/-":
                block_depth += 1
                i += 2
            elif pair == "-/":
                block_depth -= 1
                i += 2
            else:
                if text[i] == "\n":
                    out.append("\n")
                i += 1
        elif in_string:
            if text[i] == "\\":
                i += 2
            elif text[i] == '"':
                in_string = False
                i += 1
            else:
                if text[i] == "\n":
                    out.append("\n")
                i += 1
        elif pair == "/-":
            block_depth = 1
            i += 2
        elif pair == "--":
            newline = text.find("\n", i)
            if newline == -1:
                break
            out.append("\n")
            i = newline + 1
        elif text[i] == '"':
            in_string = True
            i += 1
        else:
            out.append(text[i])
            i += 1
    return "".join(out)


def percentile(values: dict[str, float]) -> dict[str, float]:
    """使用 mid-rank 百分位，相同原始值得到相同分数。"""
    groups: dict[float, list[str]] = defaultdict(list)
    for key, value in values.items():
        groups[value].append(key)
    n = len(values)
    result: dict[str, float] = {}
    below = 0
    for value in sorted(groups):
        group = groups[value]
        score = 1.0 if n == 1 else (below + (len(group) - 1) / 2) / (n - 1)
        for key in group:
            result[key] = score
        below += len(group)
    return result


def lean_usage_files(records: list[dict]) -> tuple[dict[str, int], dict[str, list[str]]]:
    """估计 Entry 主声明在多少个其他 Lean 文件中被实际提及。"""
    declaration: dict[str, str] = {}
    declaration_file: dict[str, str] = {}
    raw_files: dict[str, str] = {}
    code_files: dict[str, str] = {}
    # rglob 的顺序由文件系统决定；先排序，否则 `declaration.setdefault` 的“先到先得”
    # 与 lean_usage_evidence 的列表顺序都会随运行环境变化。
    for path in sorted(LEAN_ROOT.rglob("*.lean")):
        rel = str(path.relative_to(LEAN_ROOT))
        raw = path.read_text(encoding="utf-8")
        raw_files[rel] = raw
        code_files[rel] = strip_lean_comments_and_strings(raw)
        for entry_id, name in ENTRY_DECL_RE.findall(raw):
            declaration.setdefault(entry_id, name)
            declaration_file.setdefault(entry_id, rel)

    # 同名主声明无法靠文本扫描区分 namespace，为避免虚高，对碰撞项不计 U。
    owners: dict[str, list[str]] = defaultdict(list)
    for entry_id, name in declaration.items():
        owners[name].append(entry_id)

    counts: dict[str, int] = {}
    diagnostics: dict[str, list[str]] = {}
    for record in records:
        entry_id = record["id"]
        name = declaration.get(entry_id)
        if name is None:
            counts[entry_id] = 0
            diagnostics[entry_id] = ["未从 Entry docstring 解析到主声明"]
            continue
        if len(owners[name]) > 1:
            counts[entry_id] = 0
            diagnostics[entry_id] = [f"主声明短名 {name} 有碰撞，未计入文本调用数"]
            continue
        token = re.compile(rf"(?<![A-Za-z0-9_']){re.escape(name)}(?![A-Za-z0-9_'])")
        files = [rel for rel, code in code_files.items()
                 if rel != declaration_file.get(entry_id) and token.search(code)]
        counts[entry_id] = len(files)
        diagnostics[entry_id] = files
    return counts, diagnostics


def main() -> None:
    records: list[dict] = json.loads(REGISTRY.read_text(encoding="utf-8"))
    by_id = {record["id"]: record for record in records}
    dependents: dict[str, set[str]] = defaultdict(set)
    for record in records:
        for premise in record.get("premises", []):
            dependents[premise].add(record["id"])

    direct: dict[str, float] = {}
    transitive: dict[str, float] = {}
    cross_subject: dict[str, float] = {}
    transitive_users: dict[str, int] = {}
    subject_reach: dict[str, int] = {}

    for record in records:
        entry_id = record["id"]
        weighted = 0.0
        # `dependents` 是 set，而浮点加法不满足结合律：按未排序的 set 迭代会让同一份
        # Registry 在不同 PYTHONHASHSEED 下得到不同的小数位。排序后累加才可复现。
        for user_id in sorted(dependents[entry_id]):
            user = by_id[user_id]
            contribution = 1.0 / max(1, len(user.get("premises", [])))
            if user.get("lean_file") == record.get("lean_file"):
                contribution *= 0.5
            if user.get("kind") == "example":
                contribution *= 0.5
            weighted += contribution
        direct[entry_id] = weighted

        distance: dict[str, int] = {}
        queue = deque((child, 1) for child in sorted(dependents[entry_id]))
        while queue:
            node, depth = queue.popleft()
            if depth > 6 or depth >= distance.get(node, 7):
                continue
            distance[node] = depth
            for child in sorted(dependents[node]):
                queue.append((child, depth + 1))
        transitive_users[entry_id] = len(distance)
        transitive[entry_id] = math.fsum(
            (0.5 ** (depth - 1)) * (0.5 if by_id[node].get("kind") == "example" else 1.0)
            for node, depth in sorted(distance.items())
        )
        near_subjects = Counter(subject(node) for node, depth in sorted(distance.items()) if depth <= 2)
        subject_reach[entry_id] = len(near_subjects)
        cross_subject[entry_id] = math.fsum(
            min(1.0, 0.25 * count) for _, count in sorted(near_subjects.items())
        )

    usage_count, usage_files = lean_usage_files(records)
    usage = {entry_id: math.log2(1 + count) for entry_id, count in usage_count.items()}

    eligible = {
        record["id"] for record in records
        if record.get("state") == "verified"
        and record.get("variant") != "compatibility"
        and "compatibility" not in record["id"]
        and "mathlib-compat" not in record["id"]
    }
    p_direct = percentile({key: direct[key] for key in eligible})
    p_transitive = percentile({key: transitive[key] for key in eligible})
    p_cross = percentile({key: cross_subject[key] for key in eligible})
    p_usage = percentile({key: usage[key] for key in eligible})
    score = {
        key: 100 * (0.30 * p_direct[key] + 0.30 * p_transitive[key]
                    + 0.20 * p_cross[key] + 0.20 * p_usage[key])
        for key in eligible
    }
    order = sorted(eligible, key=lambda key: (-score[key], key))
    rank = {key: index + 1 for index, key in enumerate(order)}

    output = []
    for record in records:
        key = record["id"]
        output.append({
            "id": key,
            "title": record.get("title", ""),
            "eligible": key in eligible,
            "direct_users": len(dependents[key]),
            "weighted_direct": round(direct[key], 6),
            "transitive_users": transitive_users[key],
            "transitive_impact": round(transitive[key], 6),
            "subject_reach": subject_reach[key],
            "cross_subject_impact": round(cross_subject[key], 6),
            "lean_usage_files": usage_count[key],
            "lean_usage_log": round(usage[key], 6),
            "score": round(score[key], 4) if key in eligible else None,
            "rank": rank.get(key),
            "lean_usage_evidence": usage_files[key],
        })
    JSON_OUT.write_text(json.dumps(output, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    def table(keys: list[str], metric) -> str:
        lines = ["| # | 条目 | 标题 | 指标 |", "|---:|---|---|---:|"]
        for index, key in enumerate(keys[:30], 1):
            lines.append(f"| {index} | `{key}` | {by_id[key].get('title', '')} | {metric(key)} |")
        return "\n".join(lines)

    direct_order = sorted(eligible, key=lambda key: (-direct[key], key))
    transitive_order = sorted(eligible, key=lambda key: (-transitive[key], key))
    cross_order = sorted(eligible, key=lambda key: (-cross_subject[key], key))
    usage_order = sorted(eligible, key=lambda key: (-usage_count[key], key))
    markdown = f"""# 条目依赖排行

> 本文件由 `scripts/gen_entry_rankings.py` 生成，请勿手工编辑。

排名只覆盖 `verified` 非兼容桥条目。总分为四项百分位的加权和：加权直接引用 30%、
距离衰减的传递影响 30%、跨学科影响 20%、Lean 实际使用文件数 20%。
Lean 使用采用去注释后的主声明文本扫描；短名碰撞时该项记为 0，详细证据见 JSON。

## 综合榜

{table(order, lambda key: f'{score[key]:.2f}')}

## 教材枢纽榜（加权直接引用）

{table(direct_order, lambda key: f'{direct[key]:.3f}')}

## 基础设施榜（传递影响）

{table(transitive_order, lambda key: f'{transitive[key]:.3f}')}

## 跨学科桥梁榜

{table(cross_order, lambda key: f'{cross_subject[key]:.3f}')}

## 形式化复用榜（Lean 调用文件数）

{table(usage_order, lambda key: str(usage_count[key]))}
"""
    MARKDOWN_OUT.write_text(markdown, encoding="utf-8")
    print(f"已生成 {JSON_OUT.relative_to(ROOT)} 和 {MARKDOWN_OUT.relative_to(ROOT)}；参排 {len(eligible)} 条。")


if __name__ == "__main__":
    main()
