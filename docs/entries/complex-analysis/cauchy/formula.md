---
id: complex-analysis.cauchy.formula
kind: theorem
state: verified
title: "Cauchy 积分公式"
summary: 用正向边界圆周积分恢复闭圆盘内全纯函数在任意内点的值
premises: ["complex-analysis.holomorphic.definition"]
mathlib: ["DifferentiableOn.circleIntegral_sub_inv_smul", "circleIntegral"]
provenance:
  source_type: book
  ref: "Conway, Functions of One Complex Variable I（Cauchy 积分公式）"
---

# 定义

`∮ z in C(c, R), g z` 表示沿以 `c` 为圆心、`R` 为半径的正向圆周路径积分。
`ball c R` 是开圆盘，`closedBall c R` 包含边界。

# 动机

Cauchy 公式说明，全纯函数的内部值完全由边界值决定，它是导数公式、平均值性质和各种
刚性定理的出发点。

# 直觉

核 `1/(z-w)` 在 `w` 有一个单极点。圆周绕 `w` 一圈时，这个极点留下恰好
`2πi f(w)` 的贡献；其余全纯部分的闭路积分为零。

# 陈述（自然语言）

若 `f` 在整个闭圆盘的每一点附近全纯，且 `w` 严格位于开圆盘内，则
`∮ f(z)/(z-w) dz = 2πi f(w)`。

# 陈述（Lean 对照）

`cauchy_integral_formula (hf : HolomorphicOnTextbook f (Metric.closedBall c R))
(hw : w ∈ Metric.ball c R)`。

# 思维脉络（thinking trace）

先逐点用 `complexDifferentiableAtTextbook_iff_differentiableAt` 把教材全纯前提转成闭圆盘上的
`DifferentiableOn ℂ`。然后调用 Mathlib 的圆周 Cauchy 公式，最后只将标量作用改写为复数乘法。

# 自然语言 ↔ Lean 映射

- 闭圆盘 ↔ `Metric.closedBall c R`。
- 严格内点 ↔ `w ∈ Metric.ball c R`。
- 正向边界积分 ↔ `∮ z in C(c, R), ...`。
- “在闭圆盘附近全纯” ↔ `HolomorphicOnTextbook f (closedBall c R)`。

# 依赖（人话版）

依赖教材全纯定义与 Mathlib 可微性的桥，以及 Mathlib 已证明的圆周 Cauchy 积分公式。

# 应用与陷阱

- `w` 必须在开圆盘内，不能在边界上，否则积分核在路径上奇异。
- 前提覆盖闭圆盘而非仅开圆盘，因为圆周积分还需要边界值的连续性。
- 圆周取正向；反向参数化会使等式右边变号。
