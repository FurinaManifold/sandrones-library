#!/usr/bin/env python3
"""窗口简令渲染器：**从 pack 生成**派工文档，不允许手写简令再把 pack 抄一遍。

协议依据（AGENTS §7 第 9 条 / Playbook §9）：派工输入是 pack，`task.goal_nl` 是唯一手写字段；
所有权、前提闭包、冻结签名、批次边界（`scope`）、Playbook 必读节、预算、trace 路径与派工坐标
（`dispatch`）全部从权威源推导。所以窗口简令也必须由脚本渲染——手写简令必然与 pack 漂移，
且等于把"负责人不得改写"的字段重新抄成第二份事实源。

唯一允许的手写残量是 `--note` 片段：窗口特有的、无法从 ROADMAP/Registry/AGENTS 推导的判断
（例如"这条的难点是强度，容易退化成换个名字的包装"）。note 片段会被原样嵌入并标注为手写。

用法：
    python3 scripts/dispatch_brief.py --window E1 --pack traces/packs/<a>.json \
        [--pack <b>.json ...] [--note docs/dispatch/notes/e1.md] --out docs/dispatch/e1-*.md
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import context_pack as cp  # noqa: E402


def cell(s: str) -> str:
    return (s or "").replace("|", "\\|").strip() or "—"


def uniq(seq):
    """去重且保持首次出现顺序（pack 之间大量字段本就重复，不能靠 set 打乱）。"""
    seen, out = set(), []
    for x in seq:
        if x not in seen:
            seen.add(x)
            out.append(x)
    return out


def uniq_by(seq, key):
    seen, out = set(), []
    for x in seq:
        k = key(x)
        if k not in seen:
            seen.add(k)
            out.append(x)
    return out


def render(window: str, packs: list[dict], note: str) -> str:
    head = packs[0]
    task = head["task"]
    disp = head.get("dispatch", {})
    L: list[str] = []
    A = L.append

    A(f"# {window}　{task['subject']} / 批次 `{task['batch']}`")
    A("")
    A("> **本文件由 `scripts/dispatch_brief.py` 从 pack 渲染，请勿手改**——"
      "要改范围或边界就改权威源（ROADMAP / AGENTS / Playbook）再重新生成。")
    A("")
    A("| 项 | 值 |")
    A("|---|---|")
    A(f"| worktree | `{cell(disp.get('worktree'))}` |")
    A(f"| 分支 | `{cell(disp.get('branch'))}` |")
    A(f"| 基线 | `{cell(disp.get('base'))}` |")
    A(f"| 学科 / 批次 | `{task['subject']}` / `{task['batch']}` |")
    A(f"| 角色 | `{task['role']}` |")
    A(f"| 本窗 pack 数 | {len(packs)} |")
    A("")
    A("开工先读 `docs/LEAN-PLAYBOOK.md` **§10（并行窗口派工规程）**，再读你自己的 pack 文件原文。")
    A("")

    A("## 1. 范围（本窗要做的 Entry）")
    A("")
    A("| Entry id | 内容 | 前置 | Lean 文件 | pack_id |")
    A("|---|---|---|---|---|")
    for p in packs:
        t = p["task"]
        row = cp.roadmap_row(t["entry_id"]) or {}
        A(f"| `{t['entry_id']}` | {cell(row.get('content') or t.get('entry_summary'))} "
          f"| {cell(row.get('prereq'))} | `{cell(p['target'].get('lean_file'))}` "
          f"| `{p['pack_id']}` |")
    A("")
    A("**目标一句话**（pack 里唯一手写的字段，逐条抄录）：")
    A("")
    for p in packs:
        A(f"- `{p['task']['entry_id']}`：{p['task']['goal_nl']}")
    A("")

    A("## 2. 文件所有权（从 AGENTS §3 推导，pack 原文）")
    A("")
    A("**可写：**")
    A("")
    for w in uniq([w for p in packs for w in p["ownership"]["writable"]]):
        A(f"- `{w}`")
    A("")
    A("**只读（改了即越界）：**")
    A("")
    for r in uniq([r for p in packs for r in p["ownership"]["readonly"]]):
        A(f"- `{r}`")
    A("")
    A(f"禁用占位：{', '.join('`' + x + '`' for x in head['ownership']['forbidden_in_source'])}。"
      f"{head['ownership'].get('note', '')}")
    A("")

    A("## 3. 批次边界（本批明确不做 = `scope.out_of_scope`，由 ROADMAP 推导）")
    A("")
    A("| 批次 | Entry id | ROADMAP 内容 |")
    A("|---|---|---|")
    # 窗口内每个 Entry 都有自己的同族兄弟，必须取并集；只渲染 head 会漏掉其余条目。
    oos = uniq_by([s for p in packs for s in p["scope"]["out_of_scope"]], lambda s: s["entry_id"])
    for s in oos:
        A(f"| {cell(s.get('batch'))} | `{s['entry_id']}` | {cell(s.get('roadmap_content'))} |")
    if not oos:
        A("| — | — | 无同族兄弟条目 |")
    A("")
    A(f"> {head['scope'].get('note', '')}")
    A("")

    A("## 4. 前置闭包（从 Registry 推导）")
    A("")
    if len(packs) == 1:
        A(f"闭包深度 {head['prerequisites']['closure_depth']}；Mathlib 状态："
          f"`{head['prerequisites']['mathlib_status']}`。")
        A("")
    for i, p in enumerate(packs):
        pre = p["prerequisites"]
        if len(packs) > 1:
            A(f"### 4.{i + 1} `{p['task']['entry_id']}`")
            A("")
            A(f"闭包深度 {pre['closure_depth']}；Mathlib 状态：`{pre['mathlib_status']}`。")
            A("")
        A("| 深度 | Entry id | Lean 文件 |")
        A("|---|---|---|")
        for e in pre["entries"]:
            A(f"| d{e.get('depth')} | `{e['entry_id']}` | `{cell(e.get('lean_file'))}` |")
        A("")
        if pre["mathlib"]:
            A("**Mathlib 候选**（计划模式下是**未验证提示**，不是已确认承载——先 `#check` 实测）：")
            A("")
            A("```")
            for m in pre["mathlib"]:
                A(m)
            A("```")
            A("")

    A("## 5. Playbook 必读节（指回去读，不复制正文）")
    A("")
    A("| 锚点 | 标题 | 行号 |")
    A("|---|---|---|")
    for sec in uniq_by([s for p in packs for s in p["playbook"]["sections"]],
                       lambda s: s.get("anchor")):
        A(f"| `{sec.get('anchor')}` | {cell(sec.get('title'))} | L{sec.get('line')} |")
    A("")

    A("## 6. 预算与升级（Playbook §0）")
    A("")
    A("```json")
    A(json.dumps(head["budget"], ensure_ascii=False, indent=2))
    A("```")
    A("")

    A("## 7. 轨迹（Playbook §8）")
    A("")
    # 每个 Entry 一条独立 trace 文件（同 Entry 多 worker 还带 `--worker` 后缀）；
    # 只报 head 的路径会让负责人漏写其余条目的记录，收轨迹时才发现。
    for p in packs:
        A(f"- `{p['task']['entry_id']}`：`{p['trace']['path']}`")
    A(f"- schema：`{head['trace']['schema']}`；join key 字段：`{head['trace']['pack_id_field']}`")
    A(f"- {head['trace'].get('note', '')}")
    A("")

    A("## 8. 冻结声明（目标文件里已冻结、不得改签名的声明）")
    A("")
    for p in packs:
        decls = p["frozen"]["declarations"]
        if len(packs) > 1:
            A(f"**`{p['task']['entry_id']}`**（`{cell(p['target'].get('lean_file'))}`）：")
            A("")
        if decls:
            for d in decls:
                A(f"- `{d.get('name')}`（含 sorry：{d.get('has_sorry')}）")
        else:
            A("本目标文件里没有冻结声明（新文件从零开始）。")
        A("")
    A(f"> {head['frozen'].get('rule', '')}")
    A("")

    if note.strip():
        A("## 9. 窗口手写残量（`--note`，无法从权威源推导的判断）")
        A("")
        A("> 本节是简令里**唯一**手写部分，与 pack 的推导字段分开标注，便于日后审计漂移。")
        A("")
        A(note.strip())
        A("")

    A("---")
    A("")
    A(f"派工坐标与全部推导字段见 `{cell(disp.get('brief') or 'docs/dispatch/README.md')}` 对应的 pack 文件；"
      "简令与 pack 不一致时**以 pack 为准**，并报告 Main 重新生成简令。")
    return "\n".join(L) + "\n"


def main() -> None:
    ap = argparse.ArgumentParser(description="从 pack 渲染窗口简令（不许手写简令）")
    ap.add_argument("--window", required=True, help="窗口名，如 E1")
    ap.add_argument("--pack", action="append", required=True, help="pack JSON（可重复）")
    ap.add_argument("--note", default=None, help="窗口手写残量片段（Markdown）")
    ap.add_argument("--out", required=True)
    a = ap.parse_args()

    packs = []
    for p in a.pack:
        d = json.loads(Path(p).read_text(encoding="utf-8"))
        if d.get("schema") != cp.SCHEMA:
            raise SystemExit(f"[ERR] {p}: schema 必须是 {cp.SCHEMA}")
        packs.append(d)
    subjects = {p["task"]["subject"] for p in packs}
    if len(subjects) != 1:
        raise SystemExit(f"[ERR] 一个窗口只能属于一个学科，收到 {sorted(subjects)}")
    note = Path(a.note).read_text(encoding="utf-8") if a.note else ""
    out = Path(a.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(render(a.window, packs, note), encoding="utf-8")
    print(f"已渲染 {out}（{a.window}，{len(packs)} 个 pack）")


if __name__ == "__main__":
    main()
