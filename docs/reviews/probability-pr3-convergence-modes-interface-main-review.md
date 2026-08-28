# Pr3 收敛模式接口 Main 预审

结论：研究 handoff `f1b6064` 通过，`probability.convergence.modes` 转为
`development_open`。

Main 实际复跑 `/tmp/ProbabilityConvergenceModesAudit.lean`，所列 Mathlib carrier 与关键蕴含接口
全部存在且签名一致。正式开发须遵守以下边界：

- a.s. 收敛直接使用 a.e. 逐点 `Tendsto`；概率收敛使用 `TendstoInMeasure`；
- `Lᵖ` 收敛保留 `eLpNorm` 及 `ℝ≥0∞`，不强制先打包为 `Lp`；
- 分布收敛使用 `TendstoInDistribution`，不得另造较窄 carrier；
- 公开假设不得删除 a.e. 可测／强可测、有限测度、`p ≠ 0`、Borel 与 filter 条件；
- 明确所有逆向一般不成立，“存在 a.s. 收敛子列”不得写成原序列 a.s. 收敛；
- 首批止于四种展开、经典蕴含链、子列定理与连续映射消费者，不含 LLN 或 CLT。
