---
id: analysis.multivariable.implicit-function
kind: theorem
state: verified
title: "多元隐函数定理"
premises: ["analysis.multivariable.inverse-function"]
mathlib: ["ContDiffAt.implicitFunction", "ContDiffAt.hasStrictFDerivAt_implicitFunction"]
provenance:
  source_type: book
  ref: "spivak-calculus-manifolds-1965"
---

# 动机

许多曲线和曲面由方程而非显式函数给出；隐函数定理说明何时能局部解出部分变量。

# 直觉

若方程对 `y` 的线性响应可逆，就可以用 `y` 的变化抵消 `x` 引起的函数值变化。

# 陈述（自然语言）

若 `f(x,y)` 为 `C¹` 且 `D₂f` 可逆，则存在通过基点的局部 `C¹` 函数 `y=ψ(x)`，
满足原方程，且 `Dψ=-(D₂f)⁻¹D₁f`。

# 陈述（Lean 对照）

偏导通过 `fderiv` 分别复合 `ContinuousLinearMap.inl/inr` 得到；局部性使用
`∀ᶠ x in nhds u.1` 表达。

# 思维脉络（thinking trace）

把 `(x,y) ↦ (x,f(x,y))` 交给反函数定理，其局部逆的第二分量就是隐函数。

# 自然语言 ↔ Lean 映射

- `D₁f` ↔ `fderiv ℝ f u ∘L inl`；`D₂f` ↔ `fderiv ℝ f u ∘L inr`。

# 依赖（人话版）

依赖多元反函数定理和乘积空间的连续线性映射分解。

# 应用与陷阱

需要被解变量方向的偏全微分可逆；仅有总导数非零一般不足以指定解出哪组变量。
