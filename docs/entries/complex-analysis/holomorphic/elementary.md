---
id: complex-analysis.holomorphic.elementary
kind: theorem
state: verified
title: "复指数、复三角函数与局部对数分支的全纯性"
summary: 证明复指数、复正弦和复余弦是整函数，并在通过非零基点的射线补集上构造局部对数分支
premises: ["complex-analysis.holomorphic.definition"]
mathlib: ["Complex.differentiable_exp", "Complex.hasDerivAt_exp", "Complex.differentiable_sin", "Complex.hasDerivAt_sin", "Complex.differentiable_cos", "Complex.hasDerivAt_cos", "Complex.slitPlane", "Complex.isOpen_slitPlane", "Complex.differentiableAt_log", "Complex.exp_log", "Complex.exp_add"]
provenance:
  source_type: book
  ref: "ahlfors-complex-analysis-1979"
---

# 动机

复指数和复三角函数是全纯函数的基本例子。复对数不能在 `ℂ \ {0}` 上选取全局单值分支，
但在切去一条从零出发的射线后可以构造局部全纯右逆。

# 直觉

标准 `log` 在 slit plane 上全纯。映射 `z ↦ z/a` 把通过 `a` 的相应切线域送入
slit plane；再加上 `log a` 使指数还原为 `(z/a)·a=z`。

# 陈述（自然语言）

- 局部对数域定义为 `localLogDomain a = {z | z/a ∈ Complex.slitPlane}`；局部分支定义为
  `localLogAt a z = log (z/a) + log a`，即把标准 slit-plane 分支旋转并缩放到基点 `a` 附近。
- `exp`、`sin`、`cos` 在整个复平面上全纯，导数分别为 `exp z`、`cos z`、`-sin z`。
- `localLogDomain a` 是开集；当 `a ≠ 0` 时它包含 `a`。
- `localLogAt a` 在该域上全纯，且当 `a ≠ 0` 时满足 `exp (localLogAt a z)=z`。

# 陈述（Lean 对照）

`localLogDomain`、`localLogAt`、`exp_holomorphic`、`exp_hasDerivAt`、
`sin_holomorphic`、`sin_hasDerivAt`、
`cos_holomorphic`、`cos_hasDerivAt`、`isOpen_localLogDomain`、
`mem_localLogDomain_center`、`localLog_holomorphicOn`、`exp_localLogAt`。

# 思维脉络（thinking trace）

对三个整函数，先用 `holomorphicOnTextbook_iff_forall_differentiableAt` 把教材接口转成逐点
Mathlib 可微性，再应用现成导数定理。对局部对数，用连续映射 `z ↦ z/a` 的开集原像
证明定义域开；全纯性由 `log` 与该线性分式的复合得到。最后用 `exp_add` 和两次
`exp_log` 验证右逆恒等式。

# 自然语言 ↔ Lean 映射

- “整函数” ↔ `HolomorphicOnTextbook f Set.univ`。
- “去掉一条射线” ↔ `Complex.slitPlane` 及其在 `z ↦ z/a` 下的原像。
- “局部对数分支” ↔ `localLogAt a` 与 `exp_localLogAt`。
- “复合后仍全纯” ↔ `DifferentiableAt.comp`。

# 依赖（人话版）

依赖本库教材全纯定义与 Mathlib 逐点复可微性的桥。后端使用 Mathlib 对复指数、复正弦、
复余弦和标准复对数分支已证明的导数定理，以及 slit plane 的开性。

# 应用与陷阱

- `localLogAt a` 只是选定切线后的局部分支，不是 `ℂ \ {0}` 上的全局对数。
- `a ≠ 0` 对“定义域包含基点”和右逆公式都是必要的；定义域开性本身不需要此假设。
- 不同基点给出的分支在重叠域上可能相差 `2πi` 的整数倍。
- `Complex.log` 在切线上的总函数值不能用来推断该点的全纯性。
