# Sandrone's Library

> **LLM 友好且绝对严格的数学大厦。**

以 [mathlib4](https://github.com/leanprover-community/mathlib4) 为地基，
把**人类思维脉络**、**机器可验证的 Lean 形式化**、**面向 LLM 的双语解释**绑定为一条条
可增量扩展的"事实条目"（Fact Entry）。

## 为什么是现在（2026）

- 2024 年：模型没有链式思维，既无法构造 Lean 证明，也无法把人类答案转写成可编译的 Lean。
- 2026 年：模型能读懂人类推理 → 逐句映射为 Lean → 依据编译器报错迭代修复。
  瓶颈从"会不会证明"转移到了"知识如何组织、如何增量累积"。
- Sandrone's Library 就是那个答案：**编译器是唯一裁判**，知识以双语条目增量沉淀。

## 快速开始

```bash
# 依赖：elan（Lean 版本管理器），已配置在 ~/.elan
source ~/.elan/env   # 或 export PATH="$HOME/.elan/bin:$PATH"
lake build           # 构建（首次会拉取 mathlib，之后走缓存）
python3 scripts/audit.py   # 审计库的一致性
```

## 核心文档

| 文档 | 内容 |
|---|---|
| [docs/DESIGN.md](docs/DESIGN.md) | 架构设计：定位、条目结构、依赖图、LLM 友好性 |
| [docs/INGESTION_PROTOCOL.md](docs/INGESTION_PROTOCOL.md) | **纳入协议**：把论文/书结论纳入库中的五步流程 |
| [docs/SCHEMA.md](docs/SCHEMA.md) | 条目的精确字段规范（人 + 机器共读） |
| [docs/ROADMAP-math-analysis.md](docs/ROADMAP-math-analysis.md) | **数学分析学习地图**：一年级主线的章节→条目蓝图 |
| [docs/LEAN-PLAYBOOK.md](docs/LEAN-PLAYBOOK.md) | **自我驯化手册**：tactic 经验（调试工具/语义映射/实战教训） |

## 库结构

```
SandronesLibrary/          # 形式化层（Lean，机器可校验）
docs/entries/              # 叙述层（每个事实的双语解释 + 思维脉络）
index/registry.json        # 元数据（依赖图 / 来源 / 状态）
scripts/new_entry.py       # 纳入工具：生成条目骨架
scripts/audit.py           # 纳入工具：一致性审计
```

## 当前条目

| 条目 | 状态 | 一句话 |
|---|---|---|
| `analysis.real.archimedean` | verified | 阿基米德性质：任意正数放大足够整数倍能超过任何数 |

## 路线图

- **Phase 1**：Schema 定稿 + 若干样板条目（含需要"新定义 + 引理链"的），人工走通全流程
- **Phase 2**：协议工具化（registry 自动维护、依赖图可视化）
- **Phase 3**：ingestion benchmark（量化"可扩展性"：纳入通过率 / 迭代轮数 / 依赖复用率）
- **Phase 4**：从教材（Rudin / Zorich / 中文教材）与论文批量纳入
