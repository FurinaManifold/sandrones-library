---
id: linear-algebra.matrix.hermitian
family: linear-algebra.matrix
variant: textbook
kind: theorem
state: verified
title: Hermitian、斜 Hermitian 与正规矩阵
summary: 三类复矩阵的定义、Hermitian-斜Hermitian 分解与 Hermitian 矩阵的酉对角化
premises: [linear-algebra.matrix.orthogonal-unitary]
mathlib: ["Matrix.IsHermitian.spectral_theorem", "Matrix.IsHermitian.eigenvectorUnitary", "Matrix.conjTranspose_add", "Matrix.conjTranspose_sub"]
provenance:
  source_type: book
  ref: "horn-johnson-matrix-analysis-2013"
---

# linear-algebra.matrix.hermitian

## 动机

Hermitian 矩阵是实对称矩阵在复数域的推广，也是具有实特征值和正交特征向量系的
矩阵类。为了说清“哪些复矩阵可以酉对角化”，先定义 Hermitian、斜 Hermitian 与
正规矩阵，并建立它们之间的关系与标准分解。

## 直觉

Hermitian 与斜 Hermitian 分别要求共轭转置等于自身、等于自身的负；两者都满足与
自己的共轭转置可交换，因此都是正规矩阵。任意复方阵的“对称部分”和“反对称部分”
相加减半即可读出，所以每个复方阵都能写成 Hermitian 部分与斜 Hermitian 部分之和。
Hermitian 矩阵的谱定理则给出酉对角化，并保证对角元可取为实数。

## 陈述（教材记号）

设 `A` 为 `n×n` 复矩阵：

1. `IsNormalMatrix A` 表示 `AᴴA = AAᴴ`；`IsHermitianMatrix A` 表示 `Aᴴ=A`；
   `IsSkewHermitianMatrix A` 表示 `Aᴴ=-A`；
2. Hermitian 与斜 Hermitian 矩阵都正规；
3. `hermitianPart A = (A+Aᴴ)/2`、`skewHermitianPart A = (A-Aᴴ)/2` 分别确实是
   Hermitian、斜 Hermitian 矩阵，且 `hermitianPart A + skewHermitianPart A = A`；
4. 若 `A` Hermitian，则存在酉矩阵 `U` 与实向量 `μ`，使
   `A = U · diag(μ) · Uᴴ`，即特征值全为实数。

## 依赖（人话版）

依赖共轭转置、酉矩阵，以及有限维复内积空间上的 Hermitian 谱定理。库内前提为
`linear-algebra.matrix.orthogonal-unitary`；谱定理本身由 Mathlib 提供。

## 实现说明

三个谓词 `IsNormalMatrix`、`IsHermitianMatrix`、`IsSkewHermitianMatrix` 直接以
共轭转置 (`Aᴴ`) 定义。`hermitian_is_normal` 与 `skewHermitian_is_normal` 说明两类
矩阵正规；`hermitianPart_isHermitian`、`skewHermitianPart_isSkewHermitian` 与
`hermitian_add_skewHermitian` 给出标准分解。`hermitian_unitary_diagonalization`
从 `A.IsHermitian` 取 Mathlib 的 `eigenvectorUnitary` 与实特征值 `eigenvalues`，
用 `spectral_theorem` 组装出 `A = U * diagonal μ * Uᴴ`。

需要注意的边界：本模块只证明分解的存在（`A` 等于两部分之和），并未把分解的
唯一性单列为公开定理；因此这里也不把它当作公开结论。此外 `IsNormalMatrix` 本身
在本 Entry 只用于承接“Hermitian/斜 Hermitian 都正规”，一般正规矩阵的酉对角化
属于另一条已注册 Entry（`linear-algebra.matrix.normal`），不在本条目范围。
