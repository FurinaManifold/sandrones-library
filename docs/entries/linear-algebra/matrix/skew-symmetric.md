---
id: linear-algebra.matrix.skew-symmetric
kind: theorem
state: verified
title: "反对称矩阵"
premises: ["linear-algebra.matrix.symmetric"]
mathlib: ["Matrix.transpose_neg", "Matrix.transpose_sub"]
provenance:
  source_type: book
  ref: "线性代数教材：反对称矩阵与标准分解"
---

# 动机

反对称矩阵描述旋转的无穷小生成元，并与对称矩阵共同给出所有方阵的标准分解。

# 直觉

沿主对角线翻折后，每个元素恰好变号；对角元因此必须满足 `aᵢᵢ=-aᵢᵢ`。

# 陈述（自然语言）

方阵反对称当且仅当 `Aᵀ=-A`，等价于 `aᵢⱼ=-aⱼᵢ`。特征零域上其对角元为零，
且任意方阵唯一自然地写成对称部分 `(A+Aᵀ)/2` 与反对称部分 `(A-Aᵀ)/2` 之和。

# 陈述（Lean 对照）

`IsSkewSymmetric` 是教材谓词；`diagonal_eq_zero` 给出对角元结论；
`skewSymmetricPart` 和 `symmetricPart_add_skewSymmetricPart` 给出标准分解。

# 思维脉络（thinking trace）

逐元素判据来自转置定义。对角元结论使用 `2aᵢᵢ=0`；标准分解则展开两个部分后
消去转置项。

# 自然语言 ↔ Lean 映射

- 反对称 ↔ `IsSkewSymmetric A`。
- 反对称部分 `(A-Aᵀ)/2` ↔ `skewSymmetricPart A`。

# 依赖（人话版）

依赖对称矩阵条目以及域上的加减、除以二。

# 应用与陷阱

“对角元为零”和二分解需要 `2≠0`；本条目用 `CharZero` 明确排除特征二。
