---
id: probability.inequalities.basic
family: probability.inequalities
variant: textbook
kind: theorem
state: verified
title: Markov、Chebyshev与Jensen不等式
summary: 三个基本概率不等式及其可测性、矩与可积性边界
premises: [probability.expectation.definition, probability.moments.variance]
mathlib: [MeasureTheory.meas_ge_le_lintegral_div, ProbabilityTheory.meas_ge_le_variance_div_sq, ConvexOn.map_integral_le]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# Markov 不等式

对非负 a.e. 可测函数 `X : Ω → ℝ≥0∞` 和非零有限阈值 `a`，超水平集的测度不超过
`(∫⁻X)/a`。使用扩展非负实数避免额外假设期望有限；右端可以是无穷。

# Chebyshev 不等式

若实值随机变量属于 `L²` 且 `c>0`，则它偏离期望至少 `c` 的概率不超过
`Var(X)/c²`。`L²` 条件保证普通实方差没有落入非有限矩时的退化零值。

# Jensen 不等式

概率测度下，若 `g` 在闭凸集 `s` 上凸且连续，`X` a.e. 落在 `s` 中，并且 `X` 与
`g∘X` 都可积，则 `g(E[X]) ≤ E[g(X)]`。仅有 `X∈L¹` 并不能自动保证凸复合可积。

# 正式承载与边界

三个证明分别直接复用 Mathlib 的 `meas_ge_le_lintegral_div`、
`meas_ge_le_variance_div_sq` 和 `ConvexOn.map_integral_le`，不另造不等式定义，也不把
`ℝ≥0∞` 概率静默强制转成实数。
