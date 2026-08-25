---
id: functional-analysis.operator.space
kind: theorem
state: verified
title: 算子范数与连续线性算子空间
premises: [functional-analysis.operator.continuous-linear-map, topology.normed-space.banach]
mathlib: [ContinuousLinearMap.le_opNorm, ContinuousLinearMap.opNorm_le_bound, ContinuousLinearMap.instCompleteSpace]
provenance: {source_type: book, ref: "Conway, A Course in Functional Analysis, Chapter I"}
---

# 动机

连续线性算子的统一放大倍数中有一个最佳值，称为算子范数。它使算子本身组成赋范空间，并允许
讨论算子列的 Cauchy 性和极限。

# 教材定义与正式承载

教材算子范数是所有满足 `‖Tx‖≤C‖x‖` 的非负常数中的最小值。Mathlib 在
`ContinuousLinearMap` 上的标准范数具有完全相同的基本估计和最小界性质，因此直接作为正式
承载；本库不再定义平行的 `sInf` 范数。

# 陈述（自然语言）

- `‖T‖≥0`；
- 对每个 `x`，`‖Tx‖≤‖T‖‖x‖`；
- 若非负 `C` 也是全局界，则 `‖T‖≤C`；
- 若值域是 Banach 空间，则连续线性算子空间也是 Banach 空间。

# 陈述（Lean 对照）

对应 `operatorNorm_nonneg`、`norm_apply_le_operatorNorm`、`operatorNorm_le_of_bound`、
`operatorNorm_is_least_bound` 和 `continuousLinearMap_complete`。

# 思维脉络

前两项展示标准范数确实是可用全局界，第三项展示它小于所有竞争界，二者合起来就是教材的
“最佳常数”刻画。完备性则说明逐点极限和一致算子范数控制能组装成新的连续线性算子。

# 自然语言 ↔ Lean 映射

- 连续线性算子空间：`E →L[ℝ] F`。
- 算子范数：`‖T‖`。
- 值域完备：`[BanachSpace F]`。
- 算子空间完备：`CompleteSpace (E →L[ℝ] F)`。

# 依赖

依赖上一条对 `ContinuousLinearMap` 正式承载的教材解释，以及拓扑学已验收的 Banach 完备性。

# 应用与边界

定义域不需要完备，算子空间的完备性只要求值域完备。本条直接复用语义一致的 Mathlib 范数和
完备实例，没有新增包装结构、范数或全局 instance。
