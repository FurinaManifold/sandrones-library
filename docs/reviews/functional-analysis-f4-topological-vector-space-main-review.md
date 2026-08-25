# Main review：F4 拓扑向量空间基础

- branch: `codex/functional-analysis`
- reviewed_commit: `196d81e`
- integrated_commit: `8533f50`
- reviewer: `main`
- verdict: `accepted`
- reviewed_at: 2026-08-25

## 验收结论

提交直接组合 `IsTopologicalAddGroup E`、`Module ℝ E` 与 `ContinuousSMul ℝ E`，没有为与 Mathlib
语义一致的拓扑向量空间重复造 class。加法、取负、联合数乘连续性和平移自同胚均有公开展开，且
课程文档明确区分一般拓扑向量空间、赋范空间、局部凸性及弱／弱星拓扑。

Main 将 staging 文献字段规范化为 `reference.bib` key，登记 Registry、RADAR、顶层 import、
LONGTERM 和 Examples 缺口。目标模块构建 1669 jobs 通过；四项公开声明的实际公理均为
`Classical.choice`、`Quot.sound`、`propext`；Registry 与文献审计通过。

## 后续权限

F4.4 继续为 `integration_open`；F4.5 与 F4.7 为 `development_open`；F4.8 为 `research_open`。
本条基础定义的接收不重新冻结这些窗口。
