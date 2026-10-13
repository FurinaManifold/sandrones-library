---
id: analysis.complex.fundamental-theorem-algebra
kind: theorem
state: verified
title: 代数学基本定理
premises: []
mathlib: [Complex.exists_root, IsAlgClosed.of_exists_root, IsAlgClosed.splits, Polynomial.Splits.eq_prod_roots]
provenance:
  source_type: book
  ref: ahlfors-complex-analysis-1979
---

# 代数学基本定理

## 定理

每个次数大于零的复系数多项式至少有一个复根。等价地，复数域是代数闭域；进一步，
每个复系数多项式都能完全分解为首项系数与若干一次因子 `X-z` 的乘积，根按重数计数。

## 证明路线

Mathlib 采用复分析中的经典 Liouville 路线：若非常数多项式 `p` 无根，则 `1/p` 是
全纯函数；多项式在无穷远处的模趋于无穷，因此 `1/p` 在无穷远处趋于零并且全局
有界。Liouville 定理迫使 `1/p` 为常数，与 `p` 非常数矛盾。

本库依次封装为：

1. `fundamental_theorem_of_algebra`：非常数复多项式存在复根；
2. `complex_is_algebraically_closed`：显式由上一条构造 `IsAlgClosed ℂ`；
3. `complex_polynomial_splits`：所有复多项式完全分裂；
4. `complex_polynomial_eq_leadingCoeff_mul_prod_roots`：写出全部一次因子的乘积。

## Jordan 标准型应用

`LinearAlgebra/JordanSimilarity.lean` 单向依赖本文件，并用
`complex_is_algebraically_closed` 得到：每个复方阵都相似于由有限个 Jordan 块组成的
标准矩阵。对应结论是 `complex_matrix_is_similar_to_jordan`。
