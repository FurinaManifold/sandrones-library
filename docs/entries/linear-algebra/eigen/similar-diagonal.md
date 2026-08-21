---
id: linear-algebra.eigen.similar-diagonal
family: linear-algebra.eigen
variant: ecnu
kind: theorem
state: verified
title: 相似与对角化
summary: 可对角化记号（存在可逆 P 使 P⁻¹AP 为对角阵）；对角阵可对角化；可逆 ⟹ 左右逆
premises: [linear-algebra.eigen.charpoly]
mathlib: [Matrix.nonsing_inv_mul, Matrix.mul_nonsing_inv, Matrix.diagonal]
provenance:
  source_type: book
  ref: 线性代数教材：相似与对角化
---

# linear-algebra.eigen.similar-diagonal

- **家族**: `linear-algebra.eigen`
- **变体**: ecnu
- **状态**: verified
- **一句话**: A 可对角化 = 存在可逆 P 使 P⁻¹AP 为对角阵。

## 直觉

对角化就是"换个基"把线性变换写成对角阵：P 的列是对角化基（n 个线性无关特征向量），
P⁻¹AP 在新基下是对角的。对角阵本身已是对角化（取 P=单位阵）。

## 陈述（教材记号）

- `IsInvertible A`：det A ≠ 0（A 可逆）。
- `IsDiagonalizable A`：∃ d P, IsUnit P.det ∧ P⁻¹·A·P = diag(d)。
- 对角阵 diag(d) 可对角化；可逆阵有左右逆 A⁻¹·A = A·A⁻¹ = 1。

## 依赖（人话版）

premises: linear-algebra.eigen.charpoly；
mathlib: Matrix.nonsing_inv_mul, Matrix.mul_nonsing_inv（证明内部给可逆阵的左右逆）。

## 应用与陷阱

- "n 个线性无关特征向量 ⟺ 可对角化"与"相似保持特征多项式"是后续核心，mathlib 现成支持弱，
  留待专门批次（需 charmatrix 乘积分布与矩阵可逆桥接）。
- 教材"det A ≠ 0"在 mathlib 是 `IsUnit A.det`；可逆阵的逆用 A⁻¹（nonsing_inv）。
