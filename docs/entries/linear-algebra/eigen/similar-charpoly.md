---
id: linear-algebra.eigen.similar-charpoly
family: linear-algebra.eigen
variant: ecnu
kind: theorem
state: verified
title: 相似保持行列式/特征多项式
summary: 若 P⁻¹AP=D（P 可逆），则对每个 c，det(c·1−A)=det(c·1−D)
premises: [linear-algebra.eigen.similar-diagonal]
mathlib: [Matrix.det_mul, Matrix.det_nonsing_inv, Matrix.nonsing_inv_mul, Matrix.mul_smul, Matrix.smul_mul]
provenance:
  source_type: book
  ref: 线性代数教材：相似矩阵与特征多项式
---

# linear-algebra.eigen.similar-charpoly

- **家族**: `linear-algebra.eigen`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 相似矩阵的行列式 det(c·1−A) 逐点相同，即特征多项式相似不变。

## 直觉

P⁻¹AP 是 A 在换基 P 下的表示。det(c·1−A) 反映"c 偏离特征值多少"，
换基不改变这一偏离量：det(P⁻¹(c·1−A)P) = det(c·1−A)，因为 det 乘性且
det P⁻¹·det P = 1，而 c·1 是标量矩阵（与任何矩阵交换）。

## 陈述（教材记号）

`P⁻¹·A·P = D` 且 P 可逆 ⟹ 对每个标量 c，det(c·1−A) = det(c·1−D)。

（即相似保持特征多项式 charpoly，取 c 为多项式变量 X 即得。）

## 依赖（人话版）

premises: linear-algebra.eigen.similar-diagonal（可逆与对角化记号）；
mathlib: Matrix.det_mul（det 乘性）、Matrix.det_nonsing_inv（逆的行列式）、
Matrix.nonsing_inv_mul（可逆 ⟹ 左右逆）、Matrix.mul_smul/smul_mul（标量矩阵交换）。

## 应用与陷阱

- 证明只用**数矩阵**的 det 乘性与可逆阵左右逆，**不引入多项式矩阵**（charmatrix）
  或环同态——项始终是域中元素，不失去域性质。
- 关键代数恒等式：P⁻¹·(c·1−A)·P = c·1 − P⁻¹·A·P（c·1 与 P 交换）。
