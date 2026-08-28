# S1 支配模型与联合可测密度 Main 验收

结论：通过，学科提交 `a0b17e1` 已由 Main 集成。

本批直接使用 `P.rnDeriv (Kernel.const Θ ν)`，保留联合可测选择所需的
`CountableOrCountablyGenerated`、有限参考测度、绝对连续性和 `ℝ≥0∞` 值域。逐参数 a.e. 一致、
withDensity 重建、集合积分、总积分一与 a.e. 非无穷组成了真实消费者链，没有用逐参数任意选择的
`Measure.rnDeriv` 冒充联合可测似然。

后续权限：`statistics.estimator.definition` 转为 `research_open`，只调查可测估计量、损失与风险
carrier 并提交签名 handoff；MLE、Fisher 信息和一般估计定理继续冻结。
