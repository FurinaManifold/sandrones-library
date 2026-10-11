#!/usr/bin/env python3
"""Read-only Registry/Entry adapter; Archify itself is supplied separately."""
import argparse
import json
import subprocess
from pathlib import Path
from urllib.parse import urlsplit, urlunsplit


def git(root, *args):
    return subprocess.check_output(["git", "-C", str(root), *args], text=True).strip()


def repository(root):
    address = git(root, "remote", "get-url", "origin")
    if "://" in address:
        parsed = urlsplit(address)
        address = urlunsplit((parsed.scheme, parsed.hostname or "", parsed.path, "", ""))
    return {"url": address, "revision": git(root, "rev-parse", "HEAD"), "link_mode": "local-only"}


def source(root, path, label, needle=None):
    result = {"path": path, "label": label}
    if needle:
        lines = (root / path).read_text().splitlines()
        result["line"] = next(i for i, text in enumerate(lines, 1) if needle in text)
    return result


def node_id(entry_id):
    return "entry_" + entry_id.replace(".", "_")


def paper_spec(root):
    entries = json.loads((root / "index/registry.json").read_text())
    proposal = root / "docs/handoffs/functional-analysis-paper-condensation/registry-proposal.json"
    staged = json.loads(proposal.read_text())
    ids = ["functional-analysis.baire.theorem", "functional-analysis.banach-steinhaus",
           "functional-analysis.operator.space", "functional-analysis.condensation",
           "functional-analysis.condensation.divergence"]
    merged = {e["id"]: e for e in entries}
    for e in staged:
        if e["id"] in merged:
            raise ValueError("Staging Entry already exists in Registry; revise overlay explicitly")
        merged[e["id"]] = e
    selected = [merged[i] for i in ids]
    if len({node_id(e["id"]) for e in selected}) != len(selected):
        raise ValueError("Node ID encoding collision")
    labels = ["Baire 范畴定理", "一致有界原理", "连续线性算子空间", "奇点凝聚 I（待集成）", "同时发散 II（待集成）"]
    subtitles = ["可数稠密开集的交仍稠密", "点态有界 → 范数一致有界", "连续线性映射与算子范数",
                 "逐行无界 → 公共无界点", "逐行非 Cauchy → 公共点"]
    positions = [[40, 50], [310, 50], [310, 250], [610, 50], [910, 250]]
    components = []
    for e, label, sub, pos in zip(selected, labels, subtitles, positions):
        components.append({"id": node_id(e["id"]), "type": "backend", "icon": "none",
                           "label": label, "sublabel": sub,
                           "tag": "待 Main 集成" if e["state"] == "staging" else "Main 已登记",
                           "pos": pos, "size": [210, 90],
                           "sources": [source(root, "SandronesLibrary/" + e["lean_file"], "Lean 定义与证明"),
                                       source(root, e["nl_file"], "自然语言与接口对照")]})
    connections = [{"from": node_id(p), "to": node_id(e["id"])}
                   for e in selected for p in e["premises"] if p in ids]
    return {"schema_version": 1, "diagram_type": "architecture",
            "meta": {"title": "Banach–Steinhaus 1927：论文与已有库的关系", "locale": "zh-CN",
                     "output": "paper-dependencies.html", "repository": repository(root),
                     "legend": {"mode": "hidden"},
                     "translations": {"viewer.kind.backend": "定理／数学接口"}},
            "components": components, "connections": connections,
            "cards": [
                {"dot": "emerald", "title": "箭头：前置 Entry → 使用者", "items": [
                    "从 Registry 和本篇论文的 registry-proposal 自动提取声明依赖。",
                    "本图保留这五个 Entry 之间的全部八条边；下层依赖未展开。",
                    "Main 的三个已有条目与两个 staging 论文条目分别标明状态。"]},
                {"dot": "cyan", "title": "同一著名名称下的不同数学接口", "items": [
                    "一致有界原理：点态有界 → 算子范数一致有界。",
                    "定理 I：∀ p, ∃ z, 输出无界 → ∃ x, ∀ p, 每个尾段超过任意阈值。",
                    "定理 II 的非 Cauchy 版本只要求定义域完备；不收敛版本还要求每行值域完备。",
                    "完整前提、量词和 Lean 声明通过节点的源码与教材证据入口核对。"]}]}


def workflow_spec(root):
    protocol = "docs/INGESTION_PROTOCOL.md"
    playbook = "docs/LEAN-PLAYBOOK.md"
    role = "docs/roles/MAIN-ROLE.md"
    definitions = [
        ("paper", "intake", 0, "external", "论文原文", "冻结目标定理和原文位置", protocol),
        ("contract", "intake", 1, "frontend", "数学接口", "对象、前提、量词与版本", protocol),
        ("retrieval", "intake", 2, "database", "前置定理检索", "检查精确接口与定义承载", "docs/DESIGN.md"),
        ("scaffold", "proof", 2, "backend", "拆分证明 DAG", "先检验下层签名能否组装", playbook),
        ("workers", "proof", 3, "backend", "证明工作单元", "隔离分支与文件所有权", playbook),
        ("compile", "proof", 4, "security", "编译与接口检查", "局部闭包、量词、公理", playbook),
        ("maintainer", "integration", 4, "security", "学科负责人", "数学审核与联合导入", playbook),
        ("main", "integration", 5, "security", "Main 集成", "语义审核与共享数据重建", role),
        ("release", "release", 5, "database", "验收发布", "全库构建与人类说明", role)]
    nodes = [{"id": i, "lane": lane, "col": col, "type": kind, "label": label,
              "sublabel": sub, "width": 156, "sources": [source(root, path, "工作规程")]}
             for i, lane, col, kind, label, sub, path in definitions]
    chain = [n[0] for n in definitions]
    edges = [{"id": "flow_" + str(i), "from": a, "to": b} for i, (a, b) in enumerate(zip(chain, chain[1:]))]
    edges.append({"id": "rework", "from": "compile", "to": "workers", "label": "失败返工",
                  "variant": "security", "role": "error", "route": "up-channel"})
    return {"schema_version": 2, "diagram_type": "workflow",
            "meta": {"title": "一篇论文的形式化：分工、审核与集成", "locale": "zh-CN",
                     "output": "paper-workflow.html", "repository": repository(root),
                     "legend": {"mode": "hidden"},
                     "translations": {"viewer.kind.backend": "证明任务", "viewer.kind.security": "验证与审核",
                                      "viewer.kind.database": "知识与交付", "viewer.kind.frontend": "数学接口",
                                      "viewer.kind.external": "论文输入"}},
            "lanes": [{"id": "intake", "label": "原文与数学接口"}, {"id": "proof", "label": "证明工作单元"},
                      {"id": "integration", "label": "分层审核与集成"}, {"id": "release", "label": "库内发布"}],
            "mainPath": chain, "nodes": nodes, "edges": edges,
            "cards": [{"dot": "emerald", "title": "依据现有规程绘制", "items": [
                "工作单元交给学科负责人；Main 接收学科交付包。",
                "源码编译检查形式命题；人类审核核对原文与 Lean 的对象、前提和量词。",
                "这是工作方法图。节点不表示当前任务的实时运行状态。"]},
                {"dot": "cyan", "title": "扩展到数百 Agent 的设计", "items": [
                    "在学科负责人与 Main 之间增加分区集成与机器验证队列。",
                    "稳定接口先冻结；CI 按影响闭包验证；Main 消费验证后的批次摘要与冲突。",
                    "上述队列与分区集成是待实现方案，Archify 可展示其流程。"]}]}


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--repo-root", type=Path, required=True)
    p.add_argument("--paper-root", type=Path, required=True)
    p.add_argument("--output-dir", type=Path, required=True)
    args = p.parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    for name, spec in [("paper-dependencies", paper_spec(args.paper_root)),
                       ("paper-workflow", workflow_spec(args.repo_root))]:
        (args.output_dir / (name + ".json")).write_text(json.dumps(spec, ensure_ascii=False, indent=2) + "\n")


if __name__ == "__main__":
    main()
