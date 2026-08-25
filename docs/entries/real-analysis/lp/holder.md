---
id: real-analysis.lp.holder
family: real-analysis.lp
variant: generated
kind: theorem
state: verified
title: "Hölder 不等式"
premises: ["real-analysis.lp.basic", "real-analysis.measure.lintegral"]
mathlib: ["MeasureTheory.integral_mul_norm_le_Lp_mul_Lq", "MeasureTheory.integral_mul_le_Lp_mul_Lq_of_nonneg", "MeasureTheory.MemLp.integrable_mul"]
provenance: {source_type: book, ref: "folland-real-analysis-1999"}
---

# 陈述

若 `p,q` 为共轭指数，则

\[
\int \lVert f(x)\rVert\,\lVert g(x)\rVert\,d\mu(x)
\leq \lVert f\rVert_p\lVert g\rVert_q.
\]

因此 `f∈Lᵖ`、`g∈Lᑫ` 蕴含逐点乘积 `fg∈L¹`。非负实值函数可直接写成
`∫fg ≤ ‖f‖ₚ‖g‖q`，无需绝对值。

# 证明思路

先将两个函数分别除以各自的 `Lᵖ`、`Lᑫ` 大小做归一化。Young 不等式
`ab ≤ aᵖ/p + bᑫ/q` 对归一化函数逐点成立；积分后两项各为 `1/p` 与 `1/q`，其和为
一。最后乘回两个归一化因子。零范数与无穷值边界需要分别处理，Mathlib 的完整证明
已经覆盖这些分支。

# Lean 对照

- `holder_norm` 使用实数共轭关系 `Real.HolderConjugate`；
- `holder_nonneg` 在几乎处处非负条件下去掉范数；
- `holder_product_integrable` 使用 `ENNReal.HolderTriple p q 1`，直接表达
  `Lᵖ · Lᑫ ⊆ L¹`，并覆盖 `∞` 端点。

# 公理依赖

由公理审计脚本从 Lean 内核读取。
