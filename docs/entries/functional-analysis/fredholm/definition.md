---
id: functional-analysis.fredholm.definition
kind: definition
state: verified
title: Fredholm 算子与指数
premises: [functional-analysis.closed-range.duality]
mathlib: [ContinuousLinearMap.IsFredholm, LinearMap.index, Submodule.CoFG]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

Fredholm 算子把有限维线性代数中的秩亏现象推广到无限维空间：算子可以不是可逆的，
但其核和余核只允许携带有限维缺陷，值域还必须保持合适的闭性。指数用一个整数记录两侧缺陷之差。

# 教材概念与正式承载

本库直接采用 Mathlib 的 `ContinuousLinearMap.IsFredholm T`，不另建同义谓词。它要求 `T` 是严格映射，
值域闭，核有限维，值域有限余维，并且核有拓扑补空间。对实或复 Banach 空间，这与教材中
“闭值域、有限维核、有限维余核”的表述相容；Mathlib 采用较强的拓扑字段，是为了让接口也适用于
更一般的拓扑向量空间。余核正式写成商空间 `F ⧸ T.range`，`T.range.CoFG` 正是该商有限生成；
在域上这给出有限维性。

# 陈述（自然语言）

Fredholm 条件可以逐字段展开为严格性、闭值域、有限维核、有限维余核和核的拓扑可补性。
Fredholm 算子的值域确实闭，核与余核确实有限维。其指数约定为核维数减去余核维数。

# 陈述（Lean 对照）

定义展开为 `isFredholm_iff_components`。闭值域、有限维核与有限维余核分别由
`ContinuousLinearMap.IsFredholm.isClosed_setRange`、`finiteDimensional_kernel` 和
`finiteDimensional_cokernel` 给出。指数公式是
`fredholmIndex_eq_finrank_ker_sub_finrank_cokernel`，其左侧直接使用 `T.toLinearMap.index`。

# 证明思路

展开定理由 `ContinuousLinearMap.IsFredholm` 的五个结构字段双向组装。值域闭性只把线性子模值域
转换为函数值域的集合表述；核与余核性质直接读取字段。指数公式展开 Mathlib 的
`LinearMap.index`，没有引入额外数学证明或第二套符号。

# 自然语言 ↔ Lean 映射

- 严格映射：`Topology.IsStrictMap T`，表示商到值域的拓扑与值域子空间拓扑吻合。
- 闭值域：`IsClosed (T.range : Set F)`，等价展示为 `IsClosed (Set.range T)`。
- 有限维核：`FiniteDimensional ℝ T.ker`。
- 有限维余核：`FiniteDimensional ℝ (F ⧸ T.range)`，结构字段承载为 `T.range.CoFG`。
- 指数：`T.toLinearMap.index = finrank ker T - finrank (F / range T)`。

# 应用与边界

本条只是定义层：它没有证明恒等减紧算子的 Fredholm 备择，也没有证明紧扰动下指数不变、
指数的同伦稳定性或算子复合的指数公式。具体有限维算子及指数计算属于 Examples E11。

# Mathlib 对接说明

`ContinuousLinearMap.IsFredholm` 是语义一致的正式公开承载，`LinearMap.index` 是正式指数承载；
`Submodule.CoFG` 是余核有限性的结构字段。此处仅提供教材展开和连接既有闭值域语言的上层性质，
没有包装这些接口，也没有把 Mathlib 已有的准逆或 Fredholm package 定理改名重发。
