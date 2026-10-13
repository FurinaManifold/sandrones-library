# Banach–Steinhaus (1927) 凝集定理论文批 Main 验收

- 学科 worktree／分支：`sandrones-library-condensation`／`codex/functional-analysis-paper-condensation`
- 学科提交：`0e8706f`（数学与文档）、`8895b2e`（计量）、`27f33e9`（原文扫描归档）
- 已接入 main：`046e9f9`、`4ec485d`、`59ca250`
- Main 集成提交：`1762942`
- Entry：`functional-analysis.condensation`、`functional-analysis.condensation.divergence`
- 来源：`banach-steinhaus-condensation-1927`（*Fundamenta Mathematicae* 9 (1927), 50–61）
- Verdict：`accepted`

## 数学与接口裁决

两文件忠实复现原文 §2 的两个核心定理，量词与假设逐项核对，未发现强度拔高：

- **定理 I**（`Condensation.lean`）：`g : ∀ p, ℕ → E →L[ℝ] F p`，`E` 为实 Banach 空间，
  行内值域固定、行间可不同且不要求完备。假设“每行存在各自输出无界的点”，结论分为
  稠密 Gδ 形式（`condensation_dense_Gδ`）、显式尾段形式（`condensation_exists`）与
  算子范数无界形式（`condensation_of_unbounded_operatorNorm`）。最后一式通过本库既有
  `uniform_operatorNorm_bound_of_pointwise_bounded` 作逆否，未把一致有界原理换标题。
- **定理 II**（`CondensationDivergence.lean`）：Cauchy 形式允许值域不完备，极限形式显式增加
  `[∀ p, BanachSpace (F p)]`。`cauchyPointsSubmodule` 是 `private` 证明后端，未成为公开对象；
  一致范数界下 Cauchy 点集闭、真子空间补集稠密开、无界输出点不可能 Cauchy，三块组装出
  稠密公共非 Cauchy 点集。定理 II 只对证明实际选出的子集声称 Gδ，公共集本身只声称稠密。

`limsup = ∞` 以“每个阈值、每个尾段均可超过”展开，未引入扩充实数上确界约定；头部注释明确
标出“Cauchy 版本不需完备值域、极限版本需要”。这些都是诚实的边界声明，不是数学缺口。

## 独立复验

- 两模块在 main 工作树独立构建：`lake build SandronesLibrary.FunctionalAnalysis.Condensation
  SandronesLibrary.FunctionalAnalysis.CondensationDivergence` → 8713 jobs 成功，仅重放既有
  `Topology/Metric.lean` 与 `FunctionalAnalysis/Baire.lean` linter warning。
- 无 `sorry`／`admit`／`native_decide`／新增全局 instance；`git diff --check` 通过。
- `check_axioms.py --all --fix` 后两条目公理均为标准三项（`propext`、`Classical.choice`、
  `Quot.sound`），`--all` 复核 567 条通过。

## 未越级范围

本批只覆盖原文 §2 的定理 I、II；§3 的正交级数应用仍是后续批次，ROADMAP §15.3.2 的
Banach–Steinhaus 候选条目已按此更新为“§2 已 verified、§3 待开发”。学科 handoff 保留在
`docs/handoffs/functional-analysis-paper-condensation.md` 及其证据目录（含原文扫描件、
`Verify.lean`、`validation.json`）。

## Main 规范化

补顶层导入两条、Registry 两条目（state `verified`）、两篇 Entry 文档 front matter 状态、
`docs/MATHLIB-RADAR.md` 的 11 个新 Mathlib 锚点，并重建依赖图、条目索引与排行。
