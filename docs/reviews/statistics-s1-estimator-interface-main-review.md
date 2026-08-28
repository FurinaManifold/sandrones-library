# S1 估计量与风险接口 Main 预审

结论：研究提交 `276f4b1` 通过，`statistics.estimator.definition` 转为
`development_open`。

Main 实际复跑 `/tmp/StatisticsEstimatorAudit.lean`，Mathlib carrier 与风险接口签名均与 handoff
一致。正式开发冻结如下：

- 随机化估计量使用 `κ : Kernel 𝓧 𝓨` 与 `[IsMarkovKernel κ]`；
- 可测确定性估计量只通过 `Kernel.deterministic` 进入统一接口；
- 损失为联合可测的 `Θ → 𝓨 → ℝ≥0∞`，逐参数风险保持原生 `lintegral`，不另造同义 `risk`；
- 平均风险和 Bayes 风险复用 `avgRisk`、`bayesRisk`，明确下确界不保证最优估计量存在；
- 本批只做定义展开与确定性桥消费者，不含偏差—方差、MLE、Fisher、充分性或一般最优性定理。
