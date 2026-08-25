---
id: analysis.multivariable.hessian-taylor
kind: theorem
state: verified
title: "Hessian与多元Taylor公式"
premises: ["analysis.multivariable.frechet", "analysis.multivariable.coordinates", "analysis.mvt.taylor-integral-remainder"]
mathlib: ["iteratedFDeriv", "ContDiffAt.isSymmSndFDerivAt", "map_add_eq_sum_add_integral_iteratedFDeriv"]
provenance:
  source_type: book
  ref: "spivak-calculus-manifolds-1965"
---

# 动机

Jacobian 只记录一阶线性近似；研究曲率、极值和高阶误差需要二阶及更高阶导数。
Hessian 把二阶导数写成教材熟悉的矩阵，而 Taylor 公式则定量描述有限阶近似的余项。

# 直觉

二阶 Fréchet 导数是一个双线性映射，在两组标准基向量上取值便得到 Hessian 的元素。
Taylor 展开则把多元函数限制到线段 `x+t y`，沿该线段应用一元微积分基本定理。

# 陈述（自然语言）

二阶连续可微的实值函数具有对称 Hessian。若函数沿 `x` 到 `x+y` 的线段处处
`N+1` 阶连续可微，则 `f(x+y)` 等于 `N` 阶 Taylor 多项式加积分型余项。

# 陈述（Lean 对照）

`hessian` 用 `iteratedFDeriv ℝ 2` 定义；`hessian_symmetric` 给出矩阵对称性。
`multivariableTaylorPolynomial` 收集有限和，`multivariable_taylor_integral_remainder`
给出任意阶公式，`multivariable_taylor_first_order` 给出其基本定理特例。

# 思维脉络（thinking trace）

先用 Mathlib 的二阶导数交换定理证明标准基上的值可交换。Taylor 部分不引入幂级数，
而是复用沿线段参数化后的积分余项公式，因此只需要有限阶光滑性。

# 自然语言 ↔ Lean 映射

- `k` 阶导数 ↔ `iteratedFDeriv ℝ k f x`。
- Hessian 对称 ↔ `Matrix.IsSymm`。
- `1/k!` ↔ `(Nat.factorial k : ℝ)⁻¹`。
- 线段 ↔ `x + t • y`，积分余项 ↔ `intervalIntegral`。

# 依赖（人话版）

依赖 Fréchet 导数、标准坐标 Jacobian 语言，以及先前的一元 Taylor 积分型余项。

# 应用与陷阱

Hessian 对称需要二阶可微性的正规条件，不能仅凭两个形式偏导的存在推出。公式中的
`N` 是 Taylor 多项式最高次数，因而余项使用 `N+1` 阶导数；这与把“展开到第几项”
按项数计数的约定不同。
