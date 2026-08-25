---
id: linear-algebra.matrix.symmetric
kind: theorem
state: verified
title: "对称矩阵"
premises: []
mathlib: ["Matrix.IsSymm", "Matrix.IsSymm.ext_iff", "Matrix.transpose_add"]
provenance:
  source_type: book
  ref: "horn-johnson-matrix-analysis-2013"
---

# 动机

对称矩阵是二次型、实谱定理和多元函数 Hessian 的共同语言，需要在线性代数层先行定义。

# 直觉

沿主对角线翻折矩阵后不变；因此位置 `(i,j)` 与 `(j,i)` 的元素总是相等。

# 陈述（自然语言）

方阵对称当且仅当其转置等于自身，也等价于所有元素满足 `aᵢⱼ=aⱼᵢ`。对称矩阵
对加法封闭，任意方阵的 `(A+Aᵀ)/2` 是对称矩阵。

# 陈述（Lean 对照）

教材谓词为 `IsSymmetric A`；`isSymmetric_iff_mathlib` 将它连接到
`Matrix.IsSymm`，`symmetricPart` 定义标准对称部分。

# 思维脉络（thinking trace）

由函数外延性把矩阵等式化为逐元素等式；转置与加法、数乘相容，直接给出封闭性。

# 自然语言 ↔ Lean 映射

- 转置 ↔ `A.transpose`；对称 ↔ `IsSymmetric A`。
- 对称部分 `(A+Aᵀ)/2` ↔ `symmetricPart A`。

# 依赖（人话版）

只依赖方阵、转置、矩阵加法和标量乘法。

# 应用与陷阱

这里是普通转置而非复矩阵的共轭转置；复内积空间中的对应概念是 Hermitian 矩阵。
