---
id: linear-algebra.matrix.normal
kind: theorem
state: verified
title: "正规、Hermitian与斜Hermitian矩阵"
premises: ["linear-algebra.matrix.orthogonal-unitary", "linear-algebra.spectral-quadratic"]
mathlib: ["Matrix.IsHermitian.spectral_theorem", "Matrix.IsHermitian.eigenvectorUnitary", "Matrix.conjTranspose_add", "Matrix.conjTranspose_sub"]
provenance:
  source_type: book
  ref: "horn-johnson-matrix-analysis-2013"
---

# 动机

Hermitian 矩阵是实对称矩阵的复数推广，正规矩阵则是能够酉对角化的正确类别。

# 直觉

Hermitian 与斜 Hermitian 分别满足 `Aᴴ=A`、`Aᴴ=-A`；一般复方阵可分解成这两部分。

# 陈述（自然语言）

Hermitian 和斜 Hermitian 矩阵均正规。任意复方阵等于其 Hermitian 部分与斜
Hermitian 部分之和。Hermitian 矩阵存在酉对角化，且对角元均为实数；一般复正规
矩阵也存在酉对角化。

# 陈述（Lean 对照）

对应 `IsNormalMatrix`、`IsHermitianMatrix`、`IsSkewHermitianMatrix`、
`hermitian_add_skewHermitian`、`hermitian_unitary_diagonalization` 与
`normal_unitary_diagonalization`。

# 思维脉络（thinking trace）

前两类蕴含正规性由定义代换得到；标准分解通过共轭转置的加减法规则验证。
Hermitian 酉对角化调用有限维复内积空间的矩阵谱定理。一般正规矩阵分解为两个
可交换 Hermitian 矩阵；证明把联合特征空间指标缩到两个有限谱上，收集共同特征向量
形成正交归一基，再将换基矩阵识别为酉矩阵。

# 自然语言 ↔ Lean 映射

- Hermitian 部分 ↔ `hermitianPart`；斜 Hermitian 部分 ↔ `skewHermitianPart`。
- 酉对角化 ↔ `A = U * diagonal μ * Uᴴ`。

# 依赖（人话版）

依赖共轭转置、酉矩阵和有限维 Hermitian 谱定理。

# 应用与陷阱

Hermitian 矩阵的特征值为实数，一般正规矩阵的特征值则不必为实数。联合特征空间
原本由无限类型 `ℂ × ℂ` 编号，构造有限维正交基前必须先缩到实际出现的有限谱。
