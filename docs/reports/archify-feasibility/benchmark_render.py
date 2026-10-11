#!/usr/bin/env python3
"""Bounded synthetic chain rendering benchmark; not a production capacity test."""
import argparse
import json
import os
import platform
import signal
import subprocess
import tempfile
import time
from pathlib import Path


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--archify-root", type=Path, required=True)
    p.add_argument("--result", type=Path, required=True)
    p.add_argument("--timeout", type=float, default=15)
    args = p.parse_args()
    cli = args.archify_root / "archify/bin/archify.mjs"
    result = {"kind": "synthetic vertical chain", "quality": "standard",
              "includes": "CLI schema validation, routing and HTML render",
              "excludes": "browser load and interactions, real Registry DAG layout, concurrency",
              "node_version": subprocess.check_output(["node", "--version"], text=True).strip(),
              "platform": platform.platform(), "processor": platform.processor(),
              "cpu_logical": os.cpu_count(), "timeout_seconds": args.timeout,
              "archify_revision": subprocess.check_output(["git", "-C", str(args.archify_root), "rev-parse", "HEAD"], text=True).strip(),
              "runs": []}
    with tempfile.TemporaryDirectory(prefix="archify-chain-") as directory:
        root = Path(directory)
        for n in [100, 565, 1000, 10000]:
            spec = {"schema_version": 1, "diagram_type": "architecture",
                    "meta": {"title": "Synthetic chain", "output": "chain.html", "legend": {"mode": "hidden"}},
                    "components": [{"id": "n"+str(i), "type": "backend", "label": "Entry "+str(i),
                                    "pos": [40, 40+i*100], "size": [180, 60]} for i in range(n)],
                    "connections": [{"from": "n"+str(i), "to": "n"+str(i+1)} for i in range(n-1)]}
            source = root / "chain.json"
            output = root / "chain.html"
            source.write_text(json.dumps(spec))
            output.unlink(missing_ok=True)
            command = ["node", str(cli), "render", "architecture", str(source), str(output), "--quality", "standard"]
            start = time.perf_counter()
            proc = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, start_new_session=True,
                                    env={**os.environ, "ARCHIFY_UPDATE_CHECK_DISABLED": "1"})
            try:
                stdout, stderr = proc.communicate(timeout=args.timeout)
                state = "completed" if proc.returncode == 0 else "failed"
            except subprocess.TimeoutExpired:
                os.killpg(proc.pid, signal.SIGKILL)
                stdout, stderr = proc.communicate()
                state = "timeout"
            row = {"nodes": n, "edges": n-1, "status": state,
                   "seconds": round(time.perf_counter()-start, 3), "returncode": proc.returncode,
                   "html_bytes": output.stat().st_size if output.exists() else None,
                   "diagnostic": (stderr or stdout).decode(errors="replace")[-1600:]}
            result["runs"].append(row)
            print(json.dumps({k:row[k] for k in ["nodes", "status", "seconds", "html_bytes"]}), flush=True)
            args.result.write_text(json.dumps(result, indent=2) + "\n")


if __name__ == "__main__":
    main()
