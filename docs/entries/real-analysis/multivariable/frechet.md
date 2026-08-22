---
id: real-analysis.multivariable.frechet
kind: theorem
state: verified
title: "Fréchet全微分与方向导数"
premises: ["topology.normed-space.def", "topology.normed-space.inequalities"]
mathlib: ["HasFDerivAt", "DifferentiableAt", "HasFDerivAt.comp", "HasFDerivAt.fderiv"]
provenance:
  source_type: book
  ref: "多元微积分：Fréchet导数与全微分"
---

# 动机

多元导数必须同时描述所有方向的一阶变化；连续线性映射正是全微分的无坐标形式。

# 直觉

在 `x` 附近把函数写成 `f(x+h)=f(x)+A(h)+o(‖h‖)`，其中唯一的 `A` 就是全微分。

# 陈述（自然语言）

全微分唯一，可微函数连续；恒等映射的全微分是恒等映射；复合函数全微分满足
`D(g∘f)(x)=Dg(f(x))∘Df(x)`，方向导数为 `Df(x)v`。

# 陈述（Lean 对照）

`TotalDerivative` 对应 `E →L[ℝ] F`，存在性由 `HasFDerivAt` 表达；
`DirectionalDerivative` 是 `fderiv ℝ f x v`。

# 思维脉络（thinking trace）

以 Fréchet 导数为唯一基础定义，链式法则和方向导数均由连续线性映射运算推出，
不先依赖坐标偏导。

# 自然语言 ↔ Lean 映射

- 全微分 ↔ `ContinuousLinearMap`；可微 ↔ `DifferentiableAt ℝ`；链式法则 ↔ `.comp`。

# 依赖（人话版）

依赖实赋范线性空间及范数诱导拓扑。

# 应用与陷阱

`fderiv` 在不可微点按约定取零，实际计算方向导数时应同时携带 `HasFDerivAt`。
