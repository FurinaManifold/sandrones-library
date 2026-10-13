#!/usr/bin/env python3
"""Sandrone's Library — 学科验收包（subject acceptance package）生成与核对。

设计来源：`docs/reports/project-introduction/project-introduction.md` §7「分层审核」与
§8「集成怎样不压垮 Main：五项具体工程安排」。第 2 项要求用**可机器检查的学科验收包**取代
大量散件：Main 只审异常，不再逐份重读聊天记录、猜谁审过、手工补条目。

本脚本是发布层（控制器）的核对入口：给定一个学科 worktree 与其基线，自动核对
**契约 / 签名 / 所有权 / 证据**，产出一份 JSON 包与一份异常清单；无异常即 `pass`。

检查分五组（对应 AGENTS §7/§8 与 introduction §5 的三道门 A/B/C）：

  1. cleanliness   worktree 清洁、`git diff --check` 干净
  2. ownership     未触碰 Main 共享文件（学科只写自己的文件）
  3. semantics(A)  每个新增/修改 Entry 的 id、叙述层、`provenance.ref` 合规且一一对应
  4. proof(B)      无 `sorry/admit/sorryAx/native_decide`；每个 id 至少映射到一个公开声明
  5. coverage(C)   逐 Entry 列出真实声明数与文件，并确认 handoff 存在

用法:
    python3 scripts/subject_package.py --worktree <path> --base <ref> [--subject <name>]
                                       [--out <file.json>] [--json]

退出码: 0=无异常(pass); 1=有异常(needs_changes); 2=用法/环境错误
"""
from __future__ import annotations

import argparse
import datetime
import json
import re
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import check_axioms as ca  # noqa: E402  (复用 map_entry_to_decl / ENTRY_RE)

ROOT = Path(__file__).resolve().parents[1]
BIBLIOGRAPHY = ROOT / "reference.bib"

SCHEMA = "sandrones-subject-package/1"

# Main 共享文件：学科交付不得触碰（AGENTS §3）。前缀匹配。
MAIN_SHARED = (
    "SandronesLibrary.lean",
    "index/registry.json",
    "index/rankings.json",
    "reference.bib",
    "docs/entries/README.md",
    "docs/entries/RANKINGS.md",
    "docs/MATHLIB-RADAR.md",
    "docs/ROADMAP-LONGTERM.md",
    "docs/ROADMAP-examples.md",
    "docs/LEAN-PLAYBOOK.md",
    "docs/DESIGN.md",
    "docs/SCHEMA.md",
    "docs/world-formula/",
    "README.md",
    "AGENTS.md",
    "scripts/",
)
PROHIBITED = re.compile(r"\b(sorry|admit|sorryAx|native_decide)\b")


def git(wt: Path, *args: str) -> tuple[int, str]:
    p = subprocess.run(["git", "-C", str(wt), *args], capture_output=True, text=True)
    return p.returncode, p.stdout


def changed_files(wt: Path, base: str) -> list[str]:
    code, out = git(wt, "diff", "--name-only", base, "HEAD")
    if code != 0:
        raise SystemExit(f"git diff 失败：{base}..HEAD（{wt}）")
    return [x for x in out.split() if x]


def front_matter(path: Path) -> dict[str, str]:
    text = path.read_text(encoding="utf-8")
    m = re.search(r"^---\n(.*?)\n---\n", text, re.S)
    if not m:
        return {}
    fm: dict[str, str] = {}
    for line in m.group(1).splitlines():
        if re.match(r"^\s+\S", line):  # 嵌套键（provenance:）
            continue
        if ":" in line:
            k, v = line.split(":", 1)
            fm[k.strip()] = v.strip().strip('"')
    # provenance.ref
    pm = re.search(r"^\s*ref:\s*(.+)$", m.group(1), re.M)
    if pm:
        fm["provenance.ref"] = pm.group(1).strip().strip('"')
    return fm


def is_main_shared(rel: str) -> bool:
    return any(rel == p or rel.startswith(p) for p in MAIN_SHARED)


def build_package(wt: Path, base: str, subject: str) -> dict:
    ex: list[dict] = []

    def exception(gate: str, kind: str, detail: str) -> None:
        ex.append({"gate": gate, "kind": kind, "detail": detail})

    now = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    code, head = git(wt, "rev-parse", "HEAD")
    _, branch = git(wt, "rev-parse", "--abbrev-ref", "HEAD")
    _, status = git(wt, "status", "--porcelain")
    dirty = [l for l in status.splitlines() if l.strip()]

    # ---- gate 1: cleanliness ----
    diff_check_rc, diff_check_out = git(wt, "diff", "--check", base, "HEAD")
    if dirty:
        exception("cleanliness", "dirty_worktree", f"{len(dirty)} 个未提交改动（未交付）")
    if diff_check_rc != 0:
        exception("cleanliness", "whitespace", diff_check_out.strip()[:400])
    cleanliness = "pass" if not dirty and diff_check_rc == 0 else "fail"

    files = changed_files(wt, base)

    # ---- gate 2: ownership ----
    touched_main = sorted(f for f in files if is_main_shared(f))
    for f in touched_main:
        exception("ownership", "main_shared_touched", f)
    ownership = "pass" if not touched_main else "fail"

    # ---- source markers / docs ----
    lean_root = wt / "SandronesLibrary"
    marker_files: dict[str, set[str]] = {}
    decls_by_id: dict[str, list[str]] = {}
    for p in sorted(lean_root.rglob("*.lean")):
        rel = str(p.relative_to(wt))
        text = p.read_text(encoding="utf-8")
        for m in ca.ENTRY_RE.finditer(text):
            marker_files.setdefault(m.group(1), set()).add(rel)
        for eid, decls in ca.map_entry_to_decl(text).items():
            decls_by_id.setdefault(eid, []).extend(decls)

    doc_ids: dict[str, list[str]] = {}
    for p in sorted((wt / "docs" / "entries").rglob("*.md")):
        rel = str(p.relative_to(wt))
        fm = front_matter(p)
        if fm.get("id"):
            doc_ids.setdefault(fm["id"], []).append(rel)

    bib_keys = set(re.findall(r"@\w+\s*\{\s*([^,\s]+)\s*,", BIBLIOGRAPHY.read_text(encoding="utf-8")))
    state_ids = {r["id"] for r in json.loads((ROOT / "index" / "registry.json").read_text(encoding="utf-8"))}

    # ---- gate 3: semantics (A) ----
    semantics_issues: list[str] = []
    changed_docs = [f for f in files if f.startswith("docs/entries/") and f.endswith(".md")]
    for rel in changed_docs:
        fm = front_matter(wt / rel)
        eid = fm.get("id")
        if not eid:
            semantics_issues.append(f"{rel}: 叙述层缺 id")
            continue
        if len(doc_ids.get(eid, [])) > 1:
            semantics_issues.append(f"{eid}: 多个叙述层文件 {doc_ids[eid]}")
        expected_nl = f"docs/entries/{eid.replace('.', '/')}.md"
        if rel != expected_nl:
            semantics_issues.append(f"{eid}: 叙述层路径与 id 不一致（{rel}；应为 {expected_nl}）")
        files_with = marker_files.get(eid, set())
        if not files_with:
            semantics_issues.append(f"{eid}: 无源码标记（幽灵 Entry）")
        elif len(files_with) > 1:
            semantics_issues.append(f"{eid}: 标记横跨 {sorted(files_with)}")
        ref = fm.get("provenance.ref")
        if not ref:
            semantics_issues.append(f"{eid}: 缺 provenance.ref")
        elif ref not in bib_keys:
            semantics_issues.append(f"{eid}: provenance.ref={ref!r} 不在 reference.bib")
    # 新增源码标记 id 必须有叙述层
    changed_ids = changed_docs_ids(changed_docs, wt)
    for eid in sorted(marker_files):
        if eid in changed_ids and eid not in doc_ids:
            semantics_issues.append(f"{eid}: 源码有标记但无叙述层")
    for s in semantics_issues:
        exception("semantics", "contract", s)
    semantics = "pass" if not semantics_issues else "fail"

    # ---- gate 4: proof (B) ----
    proof_issues: list[str] = []
    for rel in files:
        if not rel.endswith(".lean"):
            continue
        text = (wt / rel).read_text(encoding="utf-8")
        formal = text.split("#exit")[0]
        for i, line in enumerate(formal.splitlines(), 1):
            if PROHIBITED.search(line) and not line.lstrip().startswith("--"):
                proof_issues.append(f"{rel}:{i}: 禁用占位 {line.strip()[:80]}")
    new_ids = {front_matter(wt / r).get("id") for r in changed_docs} | {
        e for e in marker_files if e not in state_ids
    }
    new_ids.discard(None)
    covered = []
    for eid in sorted(new_ids):
        n = len(decls_by_id.get(eid, []))
        if n == 0:
            proof_issues.append(f"{eid}: 标记下没有可审计的公开声明")
        covered.append({
            "id": eid,
            "in_registry": eid in state_ids,
            "lean_files": sorted(marker_files.get(eid, set())),
            "decls": n,
        })
    for s in proof_issues:
        exception("proof", "placeholder_or_unattributed", s)
    proof = "pass" if not proof_issues else "fail"

    # ---- gate 5: coverage (C) ----
    coverage_issues: list[str] = []
    handoffs = [f for f in files if f.startswith("docs/handoffs/") and f.endswith(".md")]
    if not handoffs:
        coverage_issues.append("无 `docs/handoffs/*.md` 交付说明（AGENTS §7 第 6 条）")
    for s in coverage_issues:
        exception("coverage", "missing_evidence", s)
    coverage = "pass" if not coverage_issues else "fail"

    _, commit_log = git(wt, "log", "--format=%H%x09%s", f"{base}..HEAD")
    commits = []
    for line in commit_log.splitlines():
        if "\t" in line:
            sha, subj = line.split("\t", 1)
            commits.append({"sha": sha, "subject": subj})

    # ---- 验证轨迹语料（Playbook §8）：软门，只统计与提示，不单独否决策包 ----
    lean_changed = [f for f in files if f.startswith("SandronesLibrary/") and f.endswith(".lean")]
    trace_root = wt / "traces" / "lean"
    trace_files = sorted(
        str(p.relative_to(wt)) for p in trace_root.rglob("*.jsonl")
    ) if trace_root.exists() else []
    trace_records = 0
    trace_bad: list[str] = []
    for rel in trace_files:
        try:
            for n, line in enumerate((wt / rel).read_text(encoding="utf-8").splitlines(), 1):
                if not line.strip():
                    continue
                json.loads(line)
                trace_records += 1
        except Exception as e:  # noqa: BLE001 - 记录到包里，交给 Main 判断
            trace_bad.append(f"{rel}: {e}")
    if trace_bad:
        trace_status = "invalid"
        trace_note = "trace 记录不是合法 JSON Lines；Playbook §8.3 要求每行独立可解析"
    elif trace_records:
        trace_status = "present"
        trace_note = f"本批含 {trace_records} 条验证尝试记录"
    elif lean_changed:
        trace_status = "missing"
        trace_note = (
            f"本批改动 {len(lean_changed)} 个 Lean 文件但 traces/lean/ 下无记录"
            "（Playbook §8 软门；若确无验证试错过程，请在 handoff 显式写明）"
        )
    else:
        trace_status = "n/a"
        trace_note = "本批未改动 Lean 源码，不要求 trace"

    return {
        "schema": SCHEMA,
        "subject": subject,
        "worktree": str(wt),
        "branch": branch.strip(),
        "base": base,
        "head": head.strip(),
        "checked_at": now,
        "commits": commits,
        "changed_files": files,
        "gates": {
            "cleanliness": {"status": cleanliness, "dirty_files": dirty},
            "ownership": {"status": ownership, "main_shared_touched": touched_main},
            "semantics": {"status": semantics, "issues": semantics_issues},
            "proof": {"status": proof, "issues": proof_issues, "entries": covered},
            "coverage": {"status": coverage, "issues": coverage_issues, "handoffs": handoffs},
        },
        "traces": {
            "status": trace_status,
            "records": trace_records,
            "files": trace_files,
            "lean_files_changed": lean_changed,
            "note": trace_note,
            "invalid": trace_bad,
        },
        "exceptions": ex,
        "verdict": "pass" if not ex else "needs_changes",
    }


def changed_docs_ids(changed_docs: list[str], wt: Path) -> set[str]:
    out = set()
    for rel in changed_docs:
        eid = front_matter(wt / rel).get("id")
        if eid:
            out.add(eid)
    return out


def main() -> None:
    ap = argparse.ArgumentParser(description="生成/核对学科验收包")
    ap.add_argument("--worktree", required=True)
    ap.add_argument("--base", required=True, help="学科分支基线 commit/ref")
    ap.add_argument("--subject", default=None)
    ap.add_argument("--out", default=None, help="写入 JSON 的路径")
    ap.add_argument("--json", action="store_true", help="只打印 JSON")
    args = ap.parse_args()

    wt = Path(args.worktree).resolve()
    if not (wt / ".git").exists():
        sys.exit(f"不是 git worktree: {wt}")
    pkg = build_package(wt, args.base, args.subject or wt.name)

    if args.out:
        Path(args.out).parent.mkdir(parents=True, exist_ok=True)
        Path(args.out).write_text(json.dumps(pkg, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    if args.json:
        print(json.dumps(pkg, ensure_ascii=False, indent=2))
    else:
        print(f"学科验收包 {pkg['subject']}  ({pkg['branch']} @ {pkg['head'][:9]})")
        print(f"  基线 {pkg['base']}｜提交 {len(pkg['commits'])}｜改动文件 {len(pkg['changed_files'])}")
        for name, g in pkg["gates"].items():
            mark = "✅" if g["status"] == "pass" else "❌"
            print(f"  {mark} {name}")
        tr = pkg.get("traces", {})
        tmark = {"present": "✅", "n/a": "➖", "missing": "⚠️", "invalid": "❌"}.get(tr.get("status"), "?")
        print(f"  {tmark} traces（软门）：{tr.get('note', '')}")
        if pkg["exceptions"]:
            print(f"\n  异常清单（{len(pkg['exceptions'])}）——Main 只需审这些：")
            for e in pkg["exceptions"]:
                print(f"    [{e['gate']}] {e['kind']}: {e['detail']}")
        print(f"\n  verdict: {pkg['verdict']}")
        if args.out:
            print(f"  包已写入 {args.out}")

    sys.exit(0 if pkg["verdict"] == "pass" else 1)


if __name__ == "__main__":
    main()
