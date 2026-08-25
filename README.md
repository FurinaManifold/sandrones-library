# Sandrone's Library

> 以教材解释组织、由 Lean 编译器裁决的可扩展数学库。

Sandrone's Library 以 [mathlib4](https://github.com/leanprover-community/mathlib4) 为形式化地基，
把一个数学知识点同时保存为：

- 教材层的中文解释、直觉、依赖和边界；
- 可编译的 Lean 定义、引理或定理；
- Registry 中的条目身份、依赖图、Mathlib 接口、文献 key 和公理指纹。

本库不以“去 Mathlib 化”为目标。当 Mathlib 对象与教材概念语义一致时，优先直接复用，
同时在课程文档中展开定义、假设和语义边界。只有语义不同、课程需要更弱或更精确的
接口，或 Mathlib 缺少相应对象时，才建立本库定义和显式桥。

## 当前规模（2026-08-25）

- **431** 个 verified Entry，覆盖分析、线性代数、抽象代数、拓扑、实分析、复分析、
  集合论、初等数论与泛函分析。
- **483** 条直接教材依赖边；`premises` 是唯一事实源，`dependedOnBy` 由脚本反向生成。
- **23** 条经出版状态审计的统一参考资料，在 `reference.bib` 维护；Registry 只保存 citation key。
- **429** 个 verified 非兼容桥条目进入依赖排行。
- 最近 Main 全库验收为 **8916 jobs** 构建通过。

阶段状态会持续变化；权威摘要只看
[`docs/ROADMAP-LONGTERM.md`](docs/ROADMAP-LONGTERM.md) §1，不从本页的日期快照推测新批次是否已解锁。

## 快速开始

需要 `elan`、Git 和 Python 3。Lean 版本由 `lean-toolchain` 固定为 4.33.0。

```bash
source ~/.elan/env
lake build
python3 scripts/audit.py
```

修改 Lean 模块时的常用顺序：

```bash
lake env lean SandronesLibrary/<Subject>/<Module>.lean
lake build SandronesLibrary.<Subject>.<Module>
python3 scripts/check_axioms.py --all --fix
python3 scripts/check_axioms.py --all
python3 scripts/audit.py
```

Main 集成多学科提交时的完整流水线：

```bash
python3 scripts/extract_registry_references.py
python3 scripts/update_dependency_graph.py
python3 scripts/gen_entries_index.py
python3 scripts/gen_entry_rankings.py
python3 scripts/check_axioms.py --all --fix
python3 scripts/check_axioms.py --all
python3 scripts/audit.py
git diff --check
lake build
```

## 一个 Entry 包含什么

一个正式 Entry 通常同时具有：

1. `SandronesLibrary/` 下的 Lean 声明，docstring 含唯一 `> **Entry**: ...` 标记；
2. `docs/entries/<family>/...md` 中的教材文档；
3. `index/registry.json` 中的唯一记录；
4. `reference.bib` 中可解析的来源 key；
5. `docs/MATHLIB-RADAR.md` 中对重要 Mathlib 接口的人话解释。

Entry 标题、自然语言强度、Lean 陈述、ROADMAP 状态和 handoff 必须一致。不得把远期目标、
弱化版本或尚未形式化的教材证明写成已完成结果。

## 目录结构

```text
SandronesLibrary/               Lean 形式化模块
  Analysis/                     一元/多元分析
  LinearAlgebra/                线性代数
  AbstractAlgebra/              抽象代数
  Topology/                     点集拓扑与代数拓扑入口
  RealAnalysis/                 测度、积分与 Lp
  ComplexAnalysis/              复分析
  SetTheory/                    集合、序数、基数、可计算性与大数
  NumberTheory/                 初等数论
  FunctionalAnalysis/           泛函分析
  Examples/                     跨学科计算例与反例
docs/entries/                   逐 Entry 教材文档
docs/handoffs/                  学科批次交付记录
docs/reviews/                   已纳入 Git 的 Main 审核闭环
docs/roles/                     Main、学科、维护和 Examples ROLE
index/registry.json             Entry 事实与依赖元数据
index/rankings.json             可重建排行数据
reference.bib                   参考文献唯一维护点
scripts/                        生成、审计和脚手架工具
```

## 依赖图与排行

- `premises`：教材上直接需要的库内 Entry，不混入 Mathlib 名称。
- `dependedOnBy`：由 `premises` 反向生成的查询缓存，禁止手工编辑。
- [`docs/entries/RANKINGS.md`](docs/entries/RANKINGS.md)：加权直接引用、传递影响、
  跨学科影响和 Lean 实际使用四项榜单。
- `index/rankings.json` 和可读榜单都是派生数据，不写回 Registry，不手工修改。

## 开发模式

本库使用独立 worktree 和 staging 分支并行开发：

- 学科负责人开发定理、定义和可审核的课程文档初稿；
- Main 负责共享 imports、Registry、文献、RADAR、ROADMAP、Examples 巡视、审核归档与全库构建；
- 已完成学科的公开接口调整必须按维护 ROLE 先做影响审计，再分桥、迁移和退役三阶段完成。

完整规程见 [`AGENTS.md`](AGENTS.md) 和
[`docs/LEAN-PLAYBOOK.md`](docs/LEAN-PLAYBOOK.md)。自动化工具不代替数学审核；
学科分支局部构建通过也不等于 Main 全库验收。

## 核心文档

| 文档 | 用途 |
|---|---|
| [`docs/ROADMAP-LONGTERM.md`](docs/ROADMAP-LONGTERM.md) | 全库阶段状态、依赖门和长期课程蓝图 |
| [`docs/ROADMAP-examples.md`](docs/ROADMAP-examples.md) | 计算例、正例和反例覆盖账本 |
| [`docs/LEAN-PLAYBOOK.md`](docs/LEAN-PLAYBOOK.md) | 证明工作流、Mathlib 复用规则和多 Codex 协作协议 |
| [`docs/INGESTION_PROTOCOL.md`](docs/INGESTION_PROTOCOL.md) | 新 Entry 的纳入流程 |
| [`docs/SCHEMA.md`](docs/SCHEMA.md) | Registry 和课程文档字段契约 |
| [`docs/MATHLIB-RADAR.md`](docs/MATHLIB-RADAR.md) | 重要 Mathlib API 的人话说明和使用者 |
| [`docs/roles/MAIN-ROLE.md`](docs/roles/MAIN-ROLE.md) | Main 审核与集成职责 |
| [`docs/roles/SUBJECT-MAINTAINER-ROLE.md`](docs/roles/SUBJECT-MAINTAINER-ROLE.md) | 学科开发职责 |
| [`docs/roles/SUBJECT-MAINTENANCE-ROLE.md`](docs/roles/SUBJECT-MAINTENANCE-ROLE.md) | 已完成学科的兼容迁移规程 |

## 保证边界

- 只有 Main 共享集成后的 `lake build` 可以报告为“全库通过”。
- verified 区域不允许 `sorry`、`admit`、`sorryAx` 或用 `native_decide` 逃避证明。
- `#print axioms` 中的选择公理、外延性和商类公理依赖如实登记，不做隐藏。
- 自然语言不得强于 Lean 定理；部分形式化不得冒充整本教材或完整学科。
