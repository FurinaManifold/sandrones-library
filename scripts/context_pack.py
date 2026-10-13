#!/usr/bin/env python3
"""Sandrone's Library — 派工上下文包（dispatch context pack）。

Playbook §8 规定了**尝试**怎么留痕（`sandrones-lean-attempt/1`），但没有规定
**派工时给下级注入什么上下文**。本工具补上这一半：把派工上下文从权威源里
**推导**出来，而不是让负责人凭记忆手写。

    python3 scripts/context_pack.py build \
        --subject analysis --batch AN-MV-R1 \
        --entry analysis.multivariable.hessian-taylor \
        --role subject-maintainer \
        --goal-nl "完成 Hessian 与 Taylor 展开的收尾引理" \
        --out /tmp/pack.json

    python3 scripts/context_pack.py show --pack /tmp/pack.json   # 人类可读视图

设计要点（三条）：
1. **指针优先**：包里存路径、id、行号和哈希，不复制权威源内容（AGENTS §6 的派生
   文件纪律）。唯一由人手写的字段是 `task.goal_nl`。
2. **确定性**：同一个 task 反复生成必须字节相同（除 `generated_at`）。这样
   (pack, trace) 才能当训练样本；负责人每次临场发挥就学不到东西。
3. **两向挂钩**：包写 `pack_id`，trace 记录带同一个 `pack_id`，
   于是"给了什么上下文 → 试了什么 → 编译器回了什么"连成一条完整样本。

退出码: 0=成功; 1=输入或校验错误。
"""
from __future__ import annotations

import argparse
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCHEMA = "sandrones-context-pack/1"
TRACE_SCHEMA = "sandrones-lean-attempt/1"
REGISTRY = ROOT / "index" / "registry.json"
PLAYBOOK = ROOT / "docs" / "LEAN-PLAYBOOK.md"

# ── 所有权表：AGENTS.md §3 是唯一事实源，此处只是它的机器可读投影。
#    改 AGENTS §3 时必须同步本表；`check` 子命令会比对 AGENTS 文本里是否仍出现这些路径。
ROLE_OWNERSHIP: dict[str, dict[str, list[str]]] = {
    "subject-maintainer": {
        "writable": [
            "SandronesLibrary/{Subject}/**",
            "docs/entries/{subject}/**",
            "docs/handoffs/{subject}-*.md",
            "docs/maintenance/{subject}-*.md",
            "traces/lean/{subject}/**",
            "traces/packs/**",
        ],
        "readonly": [
            "SandronesLibrary.lean",
            "index/registry.json",
            "index/rankings.json",
            "reference.bib",
            "docs/entries/README.md",
            "docs/entries/RANKINGS.md",
            "docs/MATHLIB-RADAR.md",
            "docs/ROADMAP-*.md",
            "docs/LEAN-PLAYBOOK.md",
            "docs/subject-packages/**",
            "docs/releases/**",
            "docs/world-formula/**",
            "README.md",
            "AGENTS.md",
            "scripts/**",
        ],
    },
    "sub-agent": {
        "writable": [
            "SandronesLibrary/{Subject}/**",
            "traces/lean/{subject}/**",
            "/tmp/sandrones-library/**",
        ],
        "readonly": [
            "index/registry.json",
            "reference.bib",
            "SandronesLibrary.lean",
            "docs/**",
            "scripts/**",
            "traces/packs/**",
        ],
    },
    "main": {"writable": ["**"], "readonly": []},
}

# §0 的 5 次试错硬规则 + §8.2 的边做边写，是派工契约里必须显式交底的两条。
BUDGET = {
    "max_attempts_per_goal": 5,
    "source": "docs/LEAN-PLAYBOOK.md §0.4（5 次试错硬规则）",
    "escalate_when": [
        "同一目标连续编译失败 ≥ 5 次（含接口不匹配）→ 停止盲试，拆子 todo 或上报负责人",
        "需要改动 frozen.may_not_change 中的任何签名 → 立即升级，不得自行修改",
        "需要写 ownership.writable 之外的路径 → 立即升级",
        "目标本身疑似表述有误（需要改陈述而非改证明）→ 立即升级",
    ],
    "trace_duty": {
        "schema": TRACE_SCHEMA,
        "when": "每次把 tactic 块交给编译器之后立刻追加，失败尝试同样要留",
        "source": "docs/LEAN-PLAYBOOK.md §8.2",
    },
}

# 目标形状 → Playbook 章节的路由规则。宁可多带一章，也不要漏掉一条已经踩过的坑。
PLAYBOOK_RULES: list[tuple[str, list[str], str]] = [
    (r"\|[^|]*\||\babs\b|AbsoluteValue", ["§2.7.0", "§2.7.1"], "目标含绝对值/范数：禁止 linarith"),
    (r"\bsSup\b|\bsInf\b|csSup|csInf", ["§2.7.2"], "条件完备版本 csSup/csInf"),
    (r"⋃|⋂|iUnion|biUnion|sUnion", ["§2.11", "§2.12"], "有界并集易绑架绑定变量"),
    (r"Set\.Infinite|Infinite\s", ["§2.12"], "无限子集枚举"),
    (r"↔", ["§2.9"], "双向蕴含分两半"),
    (r"∃", ["§2.2", "§2.3"], "存在量词的构造与提取"),
    (r"∧", ["§2.4", "§2.5"], "合取的构造与拆解"),
    (r"∨", ["§2.6"], "析取分情况"),
    (r"\bif\b|dite|ite\b", ["§2.13"], "带 if 的分支化简"),
    (r"push_neg|Type\*", ["§2.14"], "已知弃用与 universe 陷阱"),
    (r"=\s*\{|Set\.|∈|⊆", ["§2.1"], "集合/函数等式先 ext"),
    (r"Function\.|∘|comp\b", ["§2.10"], "函数相等：延拓 vs 逐点"),
    (r"<|≤|>|≥|\+|\*", ["§2.7"], "算术/序关系优先自动化策略"),
]
ALWAYS_ON = ["§0", "§1.1", "§1.2", "§1.3", "§3", "§8"]


def sha256_text(s: str) -> str:
    return hashlib.sha256(s.encode("utf-8")).hexdigest()


def sha256_file(p: Path) -> str:
    return sha256_text(p.read_text(encoding="utf-8")) if p.exists() else ""


def load_registry() -> dict[str, dict]:
    if not REGISTRY.exists():
        raise SystemExit(f"[ERR] 找不到 {REGISTRY}")
    return {e["id"]: e for e in json.loads(REGISTRY.read_text(encoding="utf-8"))}


def parse_playbook_sections() -> dict[str, dict]:
    """锚点 → {title, line}。锚点取自标题行开头的 `### 2.7.1 ...` / `## 3. ...`。"""
    out: dict[str, dict] = {}
    if not PLAYBOOK.exists():
        return out
    for n, line in enumerate(PLAYBOOK.read_text(encoding="utf-8").splitlines(), 1):
        m = re.match(r"^(#{2,4})\s+(\d+(?:\.\d+)*)\.?\s+(.*)$", line)
        if m:
            out["§" + m.group(2)] = {"title": m.group(3).strip(), "line": n}
    return out


def premises_closure(registry: dict[str, dict], roots: list[str], depth: int) -> list[dict]:
    """从 roots 沿 registry.premises 做 BFS，返回按层排序的前置闭包。"""
    seen: dict[str, int] = {}
    frontier = [(r, 0) for r in roots]
    while frontier:
        nxt = []
        for eid, d in frontier:
            if eid in seen or d > depth or eid not in registry:
                continue
            seen[eid] = d
            nxt.extend((p, d + 1) for p in registry[eid].get("premises", []))
        frontier = nxt
    rows = []
    for eid, d in sorted(seen.items(), key=lambda kv: (kv[1], kv[0])):
        e = registry[eid]
        rows.append({
            "entry_id": eid,
            "depth": d,
            "lean_file": f"SandronesLibrary/{e.get('lean_file', '?')}",
            "mathlib": e.get("mathlib", []),
            "why": "直接前提（registry.premises）" if d == 0 else "registry.premises 闭包",
        })
    return rows


DECL_RE = re.compile(
    r"^(?P<indent>[ \t]*)(?:@\[[^\]]*\]\s*)?"
    r"(?:(?:private|protected|noncomputable|partial|unsafe)\s+)*"
    r"(?P<kind>theorem|lemma|def|abbrev|structure|class|instance)\s+"
    r"(?P<name>[A-Za-z_][A-Za-z0-9_.'!?₀-₉]*)",
    re.M,
)


def scan_declarations(path: Path) -> list[dict]:
    """扫一个 Lean 文件，取出声明名、签名摘录、是否含 sorry。"""
    if not path.exists():
        return []
    text = path.read_text(encoding="utf-8")
    hits = list(DECL_RE.finditer(text))
    out = []
    for i, m in enumerate(hits):
        end = hits[i + 1].start() if i + 1 < len(hits) else len(text)
        body = text[m.start():end]
        cut = len(body)
        for sep in (":=", " where\n", "\nwhere"):
            j = body.find(sep)
            if 0 <= j < cut:
                cut = j
        sig = re.sub(r"\s+", " ", body[:cut]).strip()
        out.append({
            "name": m.group("name"),
            "kind": m.group("kind"),
            "line": text[:m.start()].count("\n") + 1,
            "signature_excerpt": sig[:400],
            "has_sorry": bool(re.search(r"\bsorry\b", body)),
        })
    return out


def route_playbook(goal_text: str, sections: dict[str, dict]) -> list[dict]:
    anchors = list(ALWAYS_ON)
    reasons = {a: "常驻：工作流铁律 / 调试 / 公理纪律 / 轨迹留痕" for a in ALWAYS_ON}
    for pattern, hits, reason in PLAYBOOK_RULES:
        if re.search(pattern, goal_text, re.I):
            for h in hits:
                if h not in anchors:
                    anchors.append(h)
                reasons.setdefault(h, reason)
    rows = []
    for a in anchors:
        sec = sections.get(a)
        rows.append({
            "anchor": a,
            "title": sec["title"] if sec else "（Playbook 中未找到该锚点）",
            "playbook_line": sec["line"] if sec else None,
            "reason": reasons.get(a, ""),
        })
    return rows


def nl_path_for(entry_id: str) -> str:
    """id → 叙述层路径（audit.py 的 id→路径规范：点转斜杠 + .md）。"""
    return "docs/entries/" + entry_id.replace(".", "/") + ".md"


def normalize_lean_file(raw: str) -> str:
    """把 `--lean-file` 统一成 Registry 口径（相对 `SandronesLibrary/`）。

    CLI 与 Registry 用同一口径；两种写法都接受，避免子 Agent 照抄 pack 里的
    `SandronesLibrary/...` 再传给 CLI 时路径翻倍。
    """
    s = (raw or "").replace("\\", "/").strip().lstrip("./")
    prefix = "SandronesLibrary/"
    return s[len(prefix):] if s.startswith(prefix) else s


def resolve_entry(args: argparse.Namespace, registry: dict[str, dict]) -> dict:
    """取目标 Entry。已登记的正常取；未登记的新条目走 `--new-entry` 计划模式。"""
    entry = registry.get(args.entry)
    if entry is not None:
        return entry
    if not args.new_entry:
        raise SystemExit(
            f"[ERR] registry 中没有 entry `{args.entry}`；"
            "若是本批新条目，请加 `--new-entry --lean-file <路径>` 并给出 `--premises`")
    if not args.lean_file:
        raise SystemExit("[ERR] --new-entry 必须同时给 `--lean-file`（新条目的 Lean 文件相对路径）")
    premises = [p for p in (args.premises or "").split(",") if p.strip()]
    missing = [p for p in premises if p not in registry]
    if missing:
        raise SystemExit(f"[ERR] --premises 中这些 id 不在 registry：{', '.join(missing)}")
    return {
        "id": args.entry,
        "state": "planned",
        "title": args.goal_nl,
        "summary": "（计划中新条目：尚未登记 Registry）",
        "lean_file": normalize_lean_file(args.lean_file),
        "nl_file": nl_path_for(args.entry),
        "premises": premises,
        "mathlib": [m for m in (args.mathlib or "").split(",") if m.strip()],
    }


def build(args: argparse.Namespace) -> dict:
    registry = load_registry()
    subject = args.subject
    entry = resolve_entry(args, registry)
    if not entry.get("lean_file", "").lower().startswith(subject.split("-")[0][:4].lower()):
        print(f"[WARN] entry 的 lean_file={entry['lean_file']} 与 --subject {subject} 可能不匹配",
              file=sys.stderr)

    subject_cap = "".join(w.capitalize() for w in re.split(r"[-_]", subject))
    def sub_paths(key: str) -> list[str]:
        return [p.replace("{subject}", subject).replace("{Subject}", subject_cap)
                for p in ROLE_OWNERSHIP[args.role][key]]

    target_lean = ROOT / "SandronesLibrary" / entry["lean_file"]
    decls = scan_declarations(target_lean)

    proto = Path(args.prototype) if args.prototype else None
    frozen_decls = []
    if proto and proto.exists():
        for d in scan_declarations(proto):
            d["file"] = str(proto)
            frozen_decls.append(d)
    else:
        for d in decls:
            if d["has_sorry"]:
                d["file"] = f"SandronesLibrary/{entry['lean_file']}"
                frozen_decls.append(d)

    goal_text = " ".join([args.goal_nl] + [d["signature_excerpt"] for d in frozen_decls] + [args.entry])
    sections = parse_playbook_sections()

    # 同一 Entry 派多个 worker 时，pack_id 与 trace 路径都要能区分，否则 join key 不唯一。
    worker = (getattr(args, "worker", None) or "").strip()
    suffix = f"-{worker}" if worker else ""

    pack = {
        "schema": SCHEMA,
        "pack_id": f"{subject}-{args.batch}-{args.entry}{suffix}",
        "generated_at": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "generator": "scripts/context_pack.py",
        "derived_from": {
            "registry": "index/registry.json",
            "registry_sha256": sha256_file(REGISTRY),
            "playbook": "docs/LEAN-PLAYBOOK.md",
            "playbook_sha256": sha256_file(PLAYBOOK),
            "agonist": "AGENTS.md §3（所有权表）",
        },
        "task": {
            "subject": subject,
            "batch": args.batch,
            "role": args.role,
            "worker": worker or None,
            "entry_id": args.entry,
            "entry_state": entry.get("state"),
            "entry_planned": entry.get("state") == "planned",
            "entry_title": entry.get("title"),
            "entry_summary": entry.get("summary"),
            "goal_nl": args.goal_nl,
            "handwritten_fields": ["task.goal_nl"],
        },
        "ownership": {
            "writable": sub_paths("writable"),
            "readonly": sub_paths("readonly"),
            "forbidden_in_source": ["sorry", "admit", "sorryAx", "native_decide"],
            "source": "AGENTS.md §3 / §5",
            "note": "writable 之外一律只读；需要改动即升级，不自行扩权。",
        },
        "target": {
            "lean_file": f"SandronesLibrary/{entry['lean_file']}",
            "nl_file": entry.get("nl_file"),
            "declarations_in_file": decls,
        },
        "frozen": {
            "prototype": str(proto) if proto else None,
            "declarations": frozen_decls,
            "may_not_change": [d["name"] for d in frozen_decls],
            "rule": "签名先冻结再填证明（AGENTS §5 sorry 框架法）；改签名必须升级。",
        },
        "prerequisites": {
            "closure_depth": args.depth,
            "entries": premises_closure(registry, entry.get("premises", []), args.depth),
            "mathlib": sorted(set(entry.get("mathlib", []))),
            "mathlib_status": (
                "unverified_hint" if entry.get("state") == "planned" else "from_registry"
            ),
        },
        "playbook": {"sections": route_playbook(goal_text, sections)},
        "budget": BUDGET,
        "trace": {
            "path": f"traces/lean/{subject}/{args.entry}{suffix}.jsonl",
            "schema": TRACE_SCHEMA,
            "pack_id_field": "pack_id",
            "note": "每条 attempt 记录必须带同一个 pack_id，否则该轨迹无法与上下文配对。",
        },
    }
    pack["pack_sha256"] = sha256_text(json.dumps(
        {k: v for k, v in pack.items() if k != "generated_at"},
        ensure_ascii=False, sort_keys=True))
    return pack


def cmd_build(args: argparse.Namespace) -> int:
    pack = build(args)
    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(pack, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"已生成 {out}（pack_id={pack['pack_id']}）")
    print(f"  冻结声明 {len(pack['frozen']['declarations'])} 条，"
          f"前置 Entry {len(pack['prerequisites']['entries'])} 条，"
          f"Playbook {len(pack['playbook']['sections'])} 节")
    return 0


def cmd_show(args: argparse.Namespace) -> int:
    p = json.loads(Path(args.pack).read_text(encoding="utf-8"))
    t = p["task"]
    print(f"# {p['pack_id']}  ({p['generated_at']})")
    print(f"角色 {t['role']} | 学科 {t['subject']} | 批次 {t['batch']}")
    print(f"目标：{t['goal_nl']}\n")
    print("## 可写")
    for w in p["ownership"]["writable"]:
        print(f"  - {w}")
    print("## 前置（按层）")
    for e in p["prerequisites"]["entries"][:12]:
        print(f"  [d{e['depth']}] {e['entry_id']}  ({e['lean_file']})")
    if p["prerequisites"]["mathlib"]:
        print("## Mathlib 候选：" + ", ".join(p["prerequisites"]["mathlib"]))
    print("## 冻结签名（不可改）")
    for d in p["frozen"]["declarations"] or [{"name": "（无 sorry 原型）", "signature_excerpt": ""}]:
        print(f"  - {d['name']}: {d.get('signature_excerpt','')[:100]}")
    print("## Playbook 必读")
    for s in p["playbook"]["sections"]:
        print(f"  {s['anchor']} L{s['playbook_line']}  {s['title'][:60]}")
    print("## 预算与升级")
    print(f"  每目标最多 {p['budget']['max_attempts_per_goal']} 次编译尝试")
    for w in p["budget"]["escalate_when"]:
        print(f"  ↑ {w}")
    print(f"## 轨迹：{p['trace']['path']}（每条带 pack_id）")
    return 0


def cmd_check(args: argparse.Namespace) -> int:
    """校验 pack 必备字段，并核对所有权表与 AGENTS §3 是否漂移。"""
    errs: list[str] = []
    seen_ids: dict[str, list[str]] = {}
    for path in args.packs:
        p = Path(path)
        try:
            pack = json.loads(p.read_text(encoding="utf-8"))
        except Exception as e:  # noqa: BLE001
            errs.append(f"{p}: 不是合法 JSON：{e}")
            continue
        if pack.get("schema") != SCHEMA:
            errs.append(f"{p}: schema 必须是 {SCHEMA}")
        for k in ("pack_id", "task", "ownership", "frozen", "prerequisites",
                  "playbook", "budget", "trace", "pack_sha256"):
            if k not in pack:
                errs.append(f"{p}: 缺 `{k}`")
        if not pack.get("task", {}).get("goal_nl", "").strip():
            errs.append(f"{p}: task.goal_nl 不能为空（唯一必须手写的字段）")
        tr = pack.get("trace", {})
        if tr.get("schema") != TRACE_SCHEMA:
            errs.append(f"{p}: trace.schema 必须是 {TRACE_SCHEMA}")
        if pack.get("frozen", {}).get("declarations") and \
                not pack["frozen"].get("may_not_change"):
            errs.append(f"{p}: 有冻结声明却没有 may_not_change")
        pid = pack.get("pack_id")
        if pid:
            seen_ids.setdefault(pid, []).append(str(p))
    # pack_id 是 (pack, trace) 的 join key，必须唯一；同 Entry 多 worker 要用 --worker 区分。
    for pid, paths in sorted(seen_ids.items()):
        if len(paths) > 1:
            errs.append(
                f"pack_id `{pid}` 重复出现在 {len(paths)} 个文件（{', '.join(paths)}）："
                "join key 不再唯一，按 pack.trace.path 收轨迹会漏掉其他 worker 的记录；"
                "请给后续 worker 用 `--worker <短标签>` 重建 pack")
    # AGENTS §3 漂移检查
    agents = (ROOT / "AGENTS.md")
    if agents.exists():
        txt = agents.read_text(encoding="utf-8")
        for probe in ("traces/lean/", "index/registry.json", "docs/LEAN-PLAYBOOK.md"):
            if probe not in txt:
                errs.append(f"AGENTS.md 中不再出现 `{probe}`，所有权表可能已漂移")
    for e in errs:
        print(f"[ERR] {e}", file=sys.stderr)
    print(f"检查 {len(args.packs)} 个 pack：{'通过' if not errs else f'{len(errs)} 个问题'}")
    return 0 if not errs else 1


def main() -> None:
    ap = argparse.ArgumentParser(description="派工上下文包（Playbook §8 的上游一半）")
    sub = ap.add_subparsers(dest="cmd", required=True)

    b = sub.add_parser("build", help="从权威源推导一个上下文包")
    b.add_argument("--subject", required=True)
    b.add_argument("--batch", required=True)
    b.add_argument("--entry", required=True, help="Entry id（= task_id）；新条目配合 --new-entry")
    b.add_argument("--new-entry", action="store_true",
                   help="计划模式：条目尚未登记 Registry（新批次首次派工）")
    b.add_argument("--lean-file", default=None,
                   help="计划模式下新条目的 Lean 文件路径。口径同 Registry：相对 "
                        "`SandronesLibrary/`（如 CommutativeAlgebra/Module/Definition.lean）；"
                        "写成 `SandronesLibrary/...` 也会被自动归一")
    b.add_argument("--worker", default=None,
                   help="同一 Entry 派多个子 Agent 时的短标签（如 lean-core / verify）。"
                        "给了就在 pack_id 与 trace.path 后追加 `-<worker>`，保证 join key 唯一；"
                        "不给则沿用 `<subject>-<batch>-<entry>`")
    b.add_argument("--premises", default="",
                   help="计划模式下的库内前提 id，逗号分隔（必须已在 Registry 中）")
    b.add_argument("--mathlib", default="",
                   help="计划模式下的 Mathlib 候选名，逗号分隔（记为未验证提示）")
    b.add_argument("--role", default="subject-maintainer",
                   choices=sorted(ROLE_OWNERSHIP))
    b.add_argument("--goal-nl", required=True, help="唯一必须手写的字段：本任务的一句话目标")
    b.add_argument("--prototype", default=None, help="含 sorry 的原型文件（默认扫目标文件）")
    b.add_argument("--depth", type=int, default=2, help="premises 闭包深度")
    b.add_argument("--out", required=True)
    b.set_defaults(func=cmd_build)

    s = sub.add_parser("show", help="人类可读视图")
    s.add_argument("--pack", required=True)
    s.set_defaults(func=cmd_show)

    c = sub.add_parser("check", help="校验 pack / 所有权表漂移")
    c.add_argument("packs", nargs="+")
    c.set_defaults(func=cmd_check)

    args = ap.parse_args()
    sys.exit(args.func(args))


if __name__ == "__main__":
    main()
