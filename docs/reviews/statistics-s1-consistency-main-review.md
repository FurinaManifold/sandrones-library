# S1 估计量相合性 Main 验收

- 学科提交：`00ccb34`
- Main 接收：`7825cae`
- Entry：`statistics.estimator.consistency`
- Verdict：`accepted`

## 数学与 carrier

本批在共同观测空间 `𝓧` 上处理确定性实值估计量序列 `T : ℕ → 𝓧 → ℝ`。固定参数 `θ` 后，逐参数
相合直接以 `TendstoInMeasure (P θ) T atTop (fun _ ↦ τ θ)` 承载；教材文档展开了其偏差概率量词，
没有只挂靠 Mathlib 名称。

`pointwiseConsistency_iff` 给出每个正阈值下误差事件概率趋零的准确等价；
`pointwiseConsistent_of_L2` 真实消费 `eLpNorm` 收敛和 a.e. 强可测性，得到依概率相合。共同空间、
变化样本空间与随机化 kernel 缺少 coupling 的边界均已明确。

## 未越级范围

本批没有从逐参数相合推出一致相合，没有证明 MLE 相合、渐近正态或 Cramér--Rao，也没有把
偏差—方差公式未经桥接直接写成 `eLpNorm` 等式。Main 接收后开放充分统计量与因子分解接口调查为
`research_open`；一致相合和其他渐近理论继续分开门控。
