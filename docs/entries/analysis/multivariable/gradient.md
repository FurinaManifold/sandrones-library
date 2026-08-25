---
id: analysis.multivariable.gradient
kind: theorem
state: verified
title: "梯度与方向导数"
premises: ["analysis.multivariable.frechet"]
mathlib: ["HasGradientAt", "HasGradientAt.hasFDerivAt", "HasGradientAt.fderiv_apply"]
provenance:
  source_type: book
  ref: "spivak-calculus-manifolds-1965"
---

# 动机

实值函数的全微分是线性泛函；内积把它表示成唯一向量，即梯度。

# 直觉

梯度是函数增长最快方向的信息载体，任意方向的一阶变化是梯度在该方向的投影。

# 陈述（自然语言）

若 `grad` 是 `f` 在 `x` 的梯度，则 `Df(x)v=⟪grad,v⟫`，因而方向导数同样等于该内积。

# 陈述（Lean 对照）

`HasGradientAt f grad x` 通过 `InnerProductSpace.toDual` 转成 `HasFDerivAt`；
`directionalDerivative_eq_inner_gradient` 给出方向导数公式。

# 思维脉络（thinking trace）

使用 Riesz 表示将连续线性泛函转为向量，再把全微分作用于方向 `v`。

# 自然语言 ↔ Lean 映射

- 梯度 ↔ `HasGradientAt`；内积 ↔ `inner ℝ grad v`。

# 依赖（人话版）

依赖 Fréchet 全微分，并要求定义域是完备实内积空间。

# 应用与陷阱

梯度依赖内积，而 Fréchet 导数只依赖赋范线性结构；二者不可混为同一概念。
