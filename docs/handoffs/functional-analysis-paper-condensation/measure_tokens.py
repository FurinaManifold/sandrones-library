#!/usr/bin/env python3
"""Record a request's token delta from Codex's actual session counters."""

import argparse
import json
from pathlib import Path


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--session", type=Path, required=True)
    parser.add_argument("--baseline", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    baseline = json.loads(args.baseline.read_text())
    before = baseline["baseline"]["usage"]
    latest = None
    events = 0
    with args.session.open() as stream:
        for line in stream:
            try:
                event = json.loads(line)
            except json.JSONDecodeError:
                continue  # the session writer may still be appending its last record
            payload = event.get("payload", {})
            if payload.get("type") != "token_count":
                continue
            if event["timestamp"] <= baseline["start_timestamp"]:
                continue
            usage = (payload.get("info") or {}).get("total_token_usage")
            if usage:
                latest = (event["timestamp"], usage)
                events += 1
    if latest is None:
        raise SystemExit("No post-request cumulative token counters found")
    delta = {key: latest[1][key] - before[key] for key in before}
    if any(value < 0 for value in delta.values()):
        raise SystemExit("Session counters reset; aggregate the session segments before reporting")
    if delta["total_tokens"] != delta["input_tokens"] + delta["output_tokens"]:
        raise SystemExit("Unexpected token accounting convention")
    if delta["cached_input_tokens"] > delta["input_tokens"]:
        raise SystemExit("Cached input exceeds total input")
    receipt = {
        "start_timestamp": baseline["start_timestamp"],
        "cutoff_timestamp": latest[0],
        "method": "post-request cumulative counters minus pre-request cumulative counters",
        "usage": delta,
        "uncached_input_tokens": delta["input_tokens"] - delta["cached_input_tokens"],
        "uncached_input_plus_output_tokens": delta["input_tokens"] - delta["cached_input_tokens"]
        + delta["output_tokens"],
        "token_counter_events_observed": events,
        "scope": "this root request through the logged cutoff; no child agents",
        "notes": [
            "input_tokens includes cached_input_tokens; do not add the cache a second time",
            "reasoning_output_tokens is a subset of output_tokens; do not add it a second time",
            "repeated previous conversation context contributes to input and cache counts",
            "the final reply and any operations after the cutoff are outside this receipt",
        ],
    }
    args.output.write_text(json.dumps(receipt, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps(receipt, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
