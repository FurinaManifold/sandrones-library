---
id: analysis.multivariable.coordinates
kind: theorem
state: verified
title: "坐标偏导与Jacobian矩阵"
premises: ["analysis.multivariable.frechet"]
mathlib: ["LinearMap.pi_apply_eq_sum_univ", "Matrix.mulVec", "Matrix.mul_apply", "Pi.single"]
provenance:
  source_type: book
  ref: "spivak-calculus-manifolds-1965"
---

# 动机

Fréchet 导数是最稳定的无坐标定义，但教材中的计算通常用偏导数和 Jacobian 矩阵。
本条目给出两种语言的精确对应，使后续反函数定理、换元公式和向量分析可以使用标准
矩阵记法而不重新定义可微性。

# 直觉

把全微分 `Df(x)` 依次作用于标准基向量 `eⱼ`，所得向量就是 Jacobian 的第 `j` 列。
因此一般方向 `v` 上的线性变化等于各列按坐标 `vⱼ` 加权，也就是矩阵乘法 `Jf(x)v`。

# 陈述（自然语言）

偏导向量等于全微分作用于标准基向量；全微分在标准坐标下由 Jacobian 矩阵表示；
恒等映射的 Jacobian 是单位矩阵，并且 `J(g∘f)(x)=Jg(f(x))Jf(x)`。

# 陈述（Lean 对照）

`partialDerivative f x j` 定义为 `DirectionalDerivative f x (Pi.single j 1)`；
`jacobian f x i j` 取该向量的第 `i` 个分量。矩阵作用和链式法则分别由
`totalDerivative_apply_eq_jacobian_mulVec`、`jacobian_chain` 表达。

# 思维脉络（thinking trace）

先用有限维函数空间的标准基分解任意向量，再利用全微分的线性性逐项作用，得到
矩阵—向量公式。Jacobian 链式法则随后直接来自 Fréchet 链式法则，无需逐坐标重证。

# 自然语言 ↔ Lean 映射

- 标准基向量 ↔ `Pi.single j 1`。
- Jacobian 乘向量 ↔ `Matrix.mulVec`，记号为 `J *ᵥ v`。
- 两个 Jacobian 的复合 ↔ `Matrix.mul`。

# 依赖（人话版）

依赖 Fréchet 全微分、方向导数与全微分链式法则。

# 应用与陷阱

本库采用“输出分量为行、输入坐标为列”的约定，因此复合时矩阵次序是
`Jg(f(x)) * Jf(x)`。`fderiv` 在不可微点取零，实际公式应携带 `HasFDerivAt`。
