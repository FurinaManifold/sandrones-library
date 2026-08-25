---
id: complex-analysis.holomorphic.cauchy-riemann
kind: theorem
state: verified
title: "Cauchy–Riemann 方程：复可微的必要条件"
summary: 用实 Fréchet 导数沿 x、y 方向的四个实偏导定义 CR 方程，并由复可微推出 CR
premises: ["complex-analysis.holomorphic.definition"]
mathlib: ["differentiableAt_complex_iff_differentiableAt_real"]
provenance:
  source_type: book
  ref: "ahlfors-complex-analysis-1979"
---

# 动机

复可微比二元实可微严格得多：差商必须与复平面中的逼近方向无关。Cauchy–Riemann
方程正是比较水平和竖直方向后得到的兼容条件。

# 直觉

把 `f=u+iv` 看成从 `ℝ²` 到 `ℝ²` 的映射。实 Fréchet 导数 `L` 沿 `1` 的值给出
x 方向偏导，沿 `I` 的值给出 y 方向偏导。复线性要求 `L(I)=iL(1)`；比较实部和虚部
得到 `uₓ=vᵧ`、`uᵧ=-vₓ`。

# 陈述（自然语言）

- 定义 `uₓ,uᵧ,vₓ,vᵧ` 为实 Fréchet 导数沿 `1,I` 的分量。
- CR 方程等价于实导数满足 `L(I)=iL(1)`。
- 若 `f` 在 `z` 复可微，则它在该点实可微并满足 CR 方程。

# 陈述（Lean 对照）

`realPartPartialX`、`realPartPartialY`、`imaginaryPartPartialX`、
`imaginaryPartPartialY`、`SatisfiesCauchyRiemannAt`、
`cauchyRiemann_iff_realFDeriv_map_I`、`complexDifferentiableAt_cauchyRiemann`。

# 思维脉络（thinking trace）

先从 `fderiv ℝ f z` 抽取四个坐标分量，再把教材中的两条方程立为本库谓词。通过复数
外延性逐坐标证明这两式恰等价于 `L(I)=iL(1)`。最后把本库差商复可微定义桥接到复
Fréchet 可微性并限制标量到 `ℝ`，由复线性导数自动得到该等式和 CR 条件。

# 自然语言 ↔ Lean 映射

- x 方向 ↔ 复向量 `1`；y 方向 ↔ 复向量 `Complex.I`。
- `uₓ` ↔ `(fderiv ℝ f z 1).re`；`vᵧ` ↔ `(fderiv ℝ f z I).im`。
- “复可微” ↔ `ComplexDifferentiableAtTextbook f z`。
- “复线性” ↔ `fderiv ℝ f z I = I * fderiv ℝ f z 1`。

# 依赖（人话版）

依赖本库差商形式的点态复可微定义、实 Fréchet 导数和复数实虚部运算。Mathlib 的抽象
CR 判据仅作为“复可微与实导数复线性等价”的证明后端；公开 CR 定义是本库的坐标方程。

# 应用与陷阱

- `fderiv` 在不可微处有默认值，因此单独满足坐标等式不代表可微；必要性定理同时返回实可微。
- CR 方程是点态条件；区域上全纯需要每一点都复可微。
- 本条只证明必要性，带实可微前提的充分性在下一条目中给出。
