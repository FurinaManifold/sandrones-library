---
id: linear-algebra.matrix.normal
family: linear-algebra.matrix
variant: textbook
kind: theorem
state: verified
title: 正规矩阵的酉谱定理
summary: 一般复正规矩阵可被酉矩阵对角化
premises: ["linear-algebra.matrix.orthogonal-unitary", "linear-algebra.matrix.hermitian"]
mathlib: ["Matrix.IsHermitian.spectral_theorem", "Matrix.IsHermitian.eigenvectorUnitary", "Matrix.conjTranspose_add", "Matrix.conjTranspose_sub"]
provenance:
  source_type: book
  ref: "horn-johnson-matrix-analysis-2013"
---

# 动机

正规矩阵是能够被酉矩阵对角化的正确类别，它把实对称／Hermitian 矩阵的谱定理推广到一般复方阵。

# 直觉

任意复方阵都能唯一分成 Hermitian 部分与斜 Hermitian 部分。若矩阵正规，这两部分可交换，
因而可同时对角化；把两个实／复特征值合并，就得到原矩阵的酉对角化。

# 陈述（自然语言）

设 `A` 是复方阵。若 `A` 正规（`Aᴴ A = A Aᴴ`），则存在酉矩阵 `U` 与对角元向量 `eig`，
使得 `A = U · diag(eig) · Uᴴ`。

# 陈述（Lean 对照）

对应 `normal_unitary_diagonalization {A : Matrix n n ℂ} (hA : IsNormalMatrix A) :
∃ (U : Matrix n n ℂ) (eig : n → ℂ), IsUnitaryMatrix U ∧ A = U * Matrix.diagonal eig * Uᴴ`。

# 思维脉络（thinking trace）

先把正规矩阵分解为两个可交换的 Hermitian 矩阵（`hermitianPart` 与 `-i • skewHermitianPart`），
再对可交换 Hermitian 对构造共同特征向量组成的正交归一基；最后把换基矩阵识别为酉矩阵，
并将两块的对角数据合并。私有引理 `commuting_hermitian_joint_orthonormalBasis` 与
`commuting_hermitian_simultaneously_diagonalizable` 承担该步骤。

# 依赖（人话版）

依赖 Hermitian／斜 Hermitian 定义与分解（`linear-algebra.matrix.hermitian`）、酉矩阵
（`linear-algebra.matrix.orthogonal-unitary`）以及有限维 Hermitian 谱定理。

# 应用与陷阱

一般正规矩阵的特征值不必为实数（只有 Hermitian 情形才是实数）。证明中联合特征空间
原本由无限类型 `ℂ × ℂ` 编号，构造有限维正交基前必须先把指标缩到实际出现的有限谱。
本文件的 `lean_file` 为 `LinearAlgebra/NormalSpectral.lean`；三类矩阵的定义与
Hermitian 酉对角化归 `linear-algebra.matrix.hermitian`（`NormalMatrix.lean`）。
