---
id: real-analysis.lp.chebyshev
kind: theorem
state: verified
title: "Chebyshev 不等式"
premises: ["real-analysis.lp.basic"]
mathlib: ["MeasureTheory.mul_meas_ge_le_pow_eLpNorm'"]
provenance: {source_type: book, ref: "folland-real-analysis-1999"}
---

# 动机

一个函数的 `Lᵖ` 大小不仅给出整体积分信息，还应控制函数取得大值的区域有多大。
Chebyshev–Markov 不等式连接“平均大小”和“超水平集测度”，随后用于依测度收敛、
尾部估计以及概率论中的 Markov 不等式。

# 直觉

在集合 `{x | ε ≤ ‖f x‖}` 上逐点有 `εᵖ ≤ ‖f x‖ᵖ`。积分后，左边就是 `εᵖ`
乘该集合的测度，右边不超过函数的整个 `p` 次幂积分。

# 陈述

设 `0 < p < ∞`，`f` 几乎处处强可测。对任意阈值 `ε : ℝ≥0∞`，

\[
\varepsilon^p\mu\{x:\varepsilon\leq\lVert f(x)\rVert\}\leq\lVert f\rVert_p^p.
\]

`chebyshev_markov` 用 `hp0 : p ≠ 0`、`hp_top : p ≠ ∞` 表达有限正指数，以
`eLpNorm` 保留可能为无穷的半范数。乘法型陈述允许 `ε=0`，无需除法型版本的额外
非零阈值和无穷值边界条件。

# Lean 对照与依赖

- 超水平集 ↔ `{x | ε ≤ ‖f x‖ₑ}`；
- `Lᵖ` 大小 ↔ `eLpNorm f p μ`；
- 可测性 ↔ `AEStronglyMeasurable f μ`。

Mathlib 的 `mul_meas_ge_le_pow_eLpNorm'` 已封装逐点估计、指标函数积分和扩展实数
幂的边界情形。本条目只依赖 `Lᵖ` 基础，不要求预先证明 `f ∈ Lᵖ`。

# 应用与陷阱

这里估计的是范数超水平集，不是带符号函数的集合 `{f≥ε}`。若改写为带 `ε⁻ᵖ` 的
除法型公式，必须额外处理 `ε=0`。
