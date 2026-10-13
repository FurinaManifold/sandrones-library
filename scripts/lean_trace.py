#!/usr/bin/env python3
"""Sandrone's Library — Lean 验证轨迹语料工具（Playbook §8）。

底层子 Agent 每次把 tactic 块交给编译器之后，就追加一条 JSON 记录：

    traces/lean/<subject>/<task-id>.jsonl

每条记录一行独立 JSON（schema `sandrones-lean-attempt/1`）。本工具负责写入时补默认值、
校验字段，以及批量检查和统计。

用法:
    python3 scripts/lean_trace.py append --file <trace.jsonl> --record <record.json|'-'>
    python3 scripts/lean_trace.py check traces/lean/<subject>/
    python3 scripts/lean_trace.py summary [--subject <subject>] [--root traces/lean]

退出码: 0=通过; 1=校验失败。
"""
from __future__ import annotations

import argparse
import datetime
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCHEMA = "sandrones-lean-attempt/1"
OUTCOMES = {"accepted", "error", "timeout", "sorry_left", "abandoned"}
REQUIRED = [
    "schema", "trace_id", "attempt", "timestamp", "agent", "subject",
    "narration", "goal", "plan", "attempt_code", "outcome",
    "compiler_feedback", "next_step",
]
SECRET_HINTS = ("token", "secret", "password", "credential", "api_key", "apikey")
RAW_LIMIT = 4000


def now_utc() -> str:
    return datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def validate(rec: dict, where: str) -> list[str]:
    errs: list[str] = []
    for k in REQUIRED:
        if k not in rec:
            errs.append(f"{where}: 缺必填字段 `{k}`")
    if rec.get("schema") != SCHEMA:
        errs.append(f"{where}: schema 必须是 {SCHEMA}")
    if rec.get("outcome") not in OUTCOMES:
        errs.append(f"{where}: outcome 非法 {rec.get('outcome')!r}（允许 {sorted(OUTCOMES)}）")
    if not isinstance(rec.get("attempt"), int) or rec.get("attempt", 0) < 1:
        errs.append(f"{where}: attempt 必须是从 1 开始的整数")
    fb = rec.get("compiler_feedback")
    if not isinstance(fb, list):
        errs.append(f"{where}: compiler_feedback 必须是数组")
    else:
        for i, item in enumerate(fb):
            if not isinstance(item, dict):
                errs.append(f"{where}: compiler_feedback[{i}] 必须是对象")
                continue
            if "message" not in item:
                errs.append(f"{where}: compiler_feedback[{i}] 缺 `message`")
            if item.get("severity") not in (None, "error", "warning", "info"):
                errs.append(f"{where}: compiler_feedback[{i}].severity 非法 {item.get('severity')!r}")
    raw = rec.get("feedback_raw")
    if raw is not None and (not isinstance(raw, str) or len(raw) > RAW_LIMIT):
        errs.append(f"{where}: feedback_raw 必须是 ≤ {RAW_LIMIT} 字符的字符串（完整输出放 feedback_sha256）")
    for k in rec:
        if any(h in k.lower() for h in SECRET_HINTS):
            errs.append(f"{where}: 字段 `{k}` 疑似凭据，Playbook §8.4 禁止写入")
    for k in ("trace_id", "agent", "subject", "narration", "goal", "plan", "attempt_code", "next_step"):
        v = rec.get(k)
        if isinstance(v, str) and not v.strip():
            errs.append(f"{where}: `{k}` 不能为空")
    return errs


def load_lines(path: Path) -> list[dict]:
    out = []
    for n, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        if not line.strip():
            continue
        try:
            out.append(json.loads(line))
        except json.JSONDecodeError as e:
            raise ValueError(f"{path}:{n}: 不是合法 JSON：{e}") from e
    return out


def last_attempt(recs: list[dict], trace_id: str) -> int:
    return max((r.get("attempt", 0) for r in recs if r.get("trace_id") == trace_id), default=0)


def cmd_append(args: argparse.Namespace) -> int:
    raw = sys.stdin.read() if args.record == "-" else Path(args.record).read_text(encoding="utf-8")
    rec = json.loads(raw)
    path = Path(args.file)
    rec.setdefault("schema", SCHEMA)
    rec.setdefault("timestamp", now_utc())
    if "trace_id" not in rec:
        rec["trace_id"] = path.stem
    if "subject" not in rec:
        rec["subject"] = path.parent.name
    existing = load_lines(path) if path.exists() else []
    if "attempt" not in rec:
        rec["attempt"] = last_attempt(existing, rec["trace_id"]) + 1
    errs = validate(rec, str(path))
    if errs:
        for e in errs:
            print(f"[ERR] {e}", file=sys.stderr)
        return 1
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as fh:
        fh.write(json.dumps(rec, ensure_ascii=False) + "\n")
    print(f"已追加 {path} 第 {rec['attempt']} 条（outcome={rec['outcome']}）")
    return 0


def iter_files(paths: list[str]) -> list[Path]:
    out: list[Path] = []
    for p in paths:
        path = Path(p)
        if path.is_dir():
            out.extend(sorted(path.rglob("*.jsonl")))
        elif path.exists():
            out.append(path)
        else:
            print(f"[ERR] 路径不存在：{p}", file=sys.stderr)
    return out


def cmd_check(args: argparse.Namespace) -> int:
    files = iter_files(args.paths)
    if not files:
        print("没有找到 .jsonl 记录")
        return 1
    bad = 0
    total = 0
    for f in files:
        try:
            recs = load_lines(f)
        except ValueError as e:
            print(f"[ERR] {e}", file=sys.stderr)
            bad += 1
            continue
        for i, rec in enumerate(recs, 1):
            total += 1
            errs = validate(rec, f"{f}:{i}")
            for e in errs:
                print(f"[ERR] {e}", file=sys.stderr)
            bad += len(errs)
    print(f"检查 {len(files)} 个文件、{total} 条记录：{'通过' if bad == 0 else f'{bad} 个问题'}")
    return 0 if bad == 0 else 1


def cmd_summary(args: argparse.Namespace) -> int:
    root = Path(args.root)
    if args.subject:
        root = root / args.subject
    files = sorted(root.rglob("*.jsonl")) if root.exists() else []
    if not files:
        print(f"没有找到轨迹（{root}）")
        return 0
    total = 0
    by_outcome: dict[str, int] = {}
    per_trace: dict[str, int] = {}
    for f in files:
        recs = load_lines(f)
        for rec in recs:
            total += 1
            by_outcome[rec.get("outcome", "?")] = by_outcome.get(rec.get("outcome", "?"), 0) + 1
            key = rec.get("trace_id", f.stem)
            per_trace[key] = per_trace.get(key, 0) + 1
    print(f"{root}: {len(files)} 个任务、{total} 条尝试")
    for k in sorted(by_outcome):
        print(f"  {k}: {by_outcome[k]}")
    for k in sorted(per_trace):
        print(f"  - {k}: {per_trace[k]} 次尝试")
    return 0


def main() -> None:
    ap = argparse.ArgumentParser(description="Lean 验证轨迹语料工具（Playbook §8）")
    sub = ap.add_subparsers(dest="cmd", required=True)

    a = sub.add_parser("append", help="追加一条尝试记录")
    a.add_argument("--file", required=True, help="traces/lean/<subject>/<task-id>.jsonl")
    a.add_argument("--record", required=True, help="记录 JSON 文件，或 `-` 从 stdin 读")
    a.set_defaults(func=cmd_append)

    c = sub.add_parser("check", help="校验记录")
    c.add_argument("paths", nargs="+", help="文件或目录")
    c.set_defaults(func=cmd_check)

    s = sub.add_parser("summary", help="统计")
    s.add_argument("--subject", default=None)
    s.add_argument("--root", default=str(ROOT / "traces" / "lean"))
    s.set_defaults(func=cmd_summary)

    args = ap.parse_args()
    sys.exit(args.func(args))


if __name__ == "__main__":
    main()
