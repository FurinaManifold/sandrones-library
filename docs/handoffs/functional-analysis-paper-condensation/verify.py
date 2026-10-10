#!/usr/bin/env python3
"""Rebuild and audit the two paper modules, without changing Main's registry."""

import json
import re
import subprocess
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))
from scripts.check_axioms import map_entry_to_decl, parse_probe_segment, probe_block

FILES = {
    "functional-analysis.condensation": (
        "SandronesLibrary/FunctionalAnalysis/Condensation.lean",
        "docs/entries/functional-analysis/condensation.md",
    ),
    "functional-analysis.condensation.divergence": (
        "SandronesLibrary/FunctionalAnalysis/CondensationDivergence.lean",
        "docs/entries/functional-analysis/condensation/divergence.md",
    ),
}
ALLOWED_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}


def run(command, log):
    result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True)
    (OUT / log).write_text(result.stdout + result.stderr)
    if result.returncode:
        sys.stderr.write(result.stdout + result.stderr)
        raise SystemExit(result.returncode)
    return result.stdout + result.stderr


def main():
    modules = [str(Path(src).with_suffix("")).replace("/", ".") for src, _ in FILES.values()]
    run(["lake", "build", *modules], "build.log")
    run(["lake", "env", "lean", str(OUT / "Verify.lean")], "interfaces-and-examples.log")
    declarations = {}
    for entry, (src, doc) in FILES.items():
        text = (ROOT / src).read_text()
        if re.search(r"\b(sorry|admit|sorryAx|native_decide)\b", text):
            raise SystemExit(f"Forbidden proof placeholder/backend: {src}")
        if re.search(r"^\s*(?:@\[[^\]]+\]\s*)?instance\b", text, re.M):
            raise SystemExit(f"Unexpected global instance: {src}")
        mapped = map_entry_to_decl(text)
        if set(mapped) != {entry} or len(mapped[entry]) != 6:
            raise SystemExit(f"Unexpected Entry declaration mapping: {mapped}")
        if not re.search(rf"^id: {re.escape(entry)}$", (ROOT / doc).read_text(), re.M):
            raise SystemExit(f"Entry document mismatch: {doc}")
        declarations[entry] = mapped[entry]

    probe = "\n".join(f"import {module}" for module in modules) + "\n"
    for names in declarations.values():
        for name in names:
            probe += "\n".join(probe_block(name)) + "\n"
    with tempfile.TemporaryDirectory(prefix="sandrones-condensation-") as temporary:
        path = Path(temporary) / "Axioms.lean"
        path.write_text(probe)
        output = run(["lake", "env", "lean", str(path)], "axioms.log")
    axioms = {}
    for names in declarations.values():
        for name in names:
            found = parse_probe_segment(output, name)
            if not set(found) <= ALLOWED_AXIOMS:
                raise SystemExit(f"Unaccepted or unparsed axioms: {name}: {found}")
            axioms[name] = found

    registry = {entry["id"]: entry for entry in json.loads((ROOT / "index/registry.json").read_text())}
    premises = {"functional-analysis.baire.theorem", "functional-analysis.operator.space",
                "functional-analysis.banach-steinhaus"}
    if not premises <= registry.keys() or any(registry[item]["state"] != "verified" for item in premises):
        raise SystemExit("A required course premise is not verified in the registry")
    registration = {}
    for entry, (src, doc) in FILES.items():
        if entry in registry:
            current = registry[entry]
            if current["lean_file"] != src.removeprefix("SandronesLibrary/") or current["nl_file"] != doc:
                raise SystemExit(f"Registered file identity mismatch: {entry}")
            registration[entry] = current["state"]
        else:
            registration[entry] = "pending Main integration"
    if "@article{banach-steinhaus-condensation-1927," not in (ROOT / "reference.bib").read_text():
        raise SystemExit("Missing published paper citation")
    for path in [ROOT / src for src, _ in FILES.values()] + list(OUT.glob("*.py")):
        if any(line.rstrip() != line for line in path.read_text().splitlines()):
            raise SystemExit(f"Trailing whitespace: {path}")
    run(["git", "diff", "--check"], "diff-check.log")

    receipt = {
        "checked_at": datetime.now(timezone.utc).isoformat(),
        "result": "passed",
        "scope": "two paper modules and their transitive import closure",
        "paper_reference": "banach-steinhaus-condensation-1927",
        "source_results": ["section 2 Theorem I", "section 2 Theorem II"],
        "public_declarations": sum(map(len, declarations.values())),
        "entry_declarations": declarations,
        "axioms_by_declaration": axioms,
        "semantic_examples": ["growing scalar operators", "bounded alternating scalar operators"],
        "main_registry_registration": registration,
        "full_repository_build": False,
    }
    (OUT / "validation.json").write_text(json.dumps(receipt, ensure_ascii=False, indent=2) + "\n")
    print("PASS: 12 public declarations, 2 paper theorems, 2 semantic examples, axiom audit.")


if __name__ == "__main__":
    main()
