#!/usr/bin/env python3
"""Check local reader interactions and export native SVG plus browser screenshots."""
import argparse
import json
from pathlib import Path
from playwright.sync_api import sync_playwright


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--samples", type=Path, required=True)
    p.add_argument("--chrome", default="/usr/bin/google-chrome")
    args = p.parse_args()
    root = args.samples.resolve()
    results = {"viewport": [1440, 1050], "device_scale_factor": 1, "runs": []}
    with sync_playwright() as playwright:
        browser = playwright.chromium.launch(executable_path=args.chrome, headless=True, args=["--no-sandbox"])
        for stem in ["paper-dependencies", "paper-workflow"]:
            page = browser.new_page(viewport={"width": 1440, "height": 1050}, device_scale_factor=1)
            requests, errors = [], []
            page.on("pageerror", lambda error: errors.append(str(error)))
            # Readers are loaded over file://; block HTTP to check offline rendering.
            page.route("http://**/*", lambda route: (requests.append(route.request.url), route.abort()))
            page.route("https://**/*", lambda route: (requests.append(route.request.url), route.abort()))
            page.goto((root / (stem + ".html")).as_uri() + "?theme=light", wait_until="load")
            page.evaluate("document.fonts.ready")
            row = {"artifact": stem + ".html", "nodes": page.locator(".diagram-container > svg [data-node-id]").count(),
                   "semantic_edges": page.evaluate("new Set([...document.querySelectorAll('.diagram-container > svg [data-edge-from][data-edge-to]')].map(e=>e.dataset.edgeFrom+'|'+e.dataset.edgeTo)).size")}
            specification = json.loads((root / (stem + ".json")).read_text())
            assert row["semantic_edges"] == len(specification.get("connections", specification.get("edges", [])))
            if stem == "paper-dependencies":
                for query in ["奇点凝聚", "Condensation.lean"]:
                    page.evaluate("Archify.finder.open()")
                    page.locator("#node-finder-input").fill(query)
                    page.wait_for_function("document.querySelectorAll('.node-finder-result').length === 1")
                    row["search_" + query] = page.locator(".node-finder-result").count()
                    page.keyboard.press("Escape")
                node = "entry_functional-analysis_condensation"
                page.evaluate("id=>Archify.focus.set(id, {toggle:false})", node)
                row["interface_status"] = page.locator("#focus-tag").text_content()
                page.evaluate("Archify.focus.reach('upstream')")
                row["upstream"] = page.evaluate("Archify.focus.reachability()")
                assert len(row["upstream"]["nodeIds"]) == 4
                page.evaluate("Archify.focus.clear()")
            with page.expect_download() as download:
                page.evaluate("Archify.exportMenu.run('svg-light')")
            download.value.save_as(root / (stem + ".svg"))
            page.screenshot(path=str(root / (stem + ".png")), full_page=True)
            row.update({"http_requests": requests, "page_errors": errors, "svg_bytes": (root / (stem + ".svg")).stat().st_size})
            assert not requests and not errors
            results["runs"].append(row)
            page.close()
        browser.close()
    (root / "interaction-checks.json").write_text(json.dumps(results, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps(results, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
