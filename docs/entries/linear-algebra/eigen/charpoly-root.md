---
id: linear-algebra.eigen.charpoly-root
family: linear-algebra.eigen
variant: ecnu
kind: theorem
state: verified
title: 特征值是特征多项式的根
summary: μ 是方阵 A 的特征值 ⟺ μ 是 A 的特征多项式 charpoly 的根
premises: [linear-algebra.eigen.charpoly, linear-algebra.eigen.value]
mathlib: [Module.End.hasEigenvalue_iff_isRoot_charpoly, Matrix.charpoly_toLin']
provenance:
  source_type: book
  ref: 线性代数教材：特征多项式
---

# linear-algebra.eigen.charpoly-root

- **家族**: `linear-algebra.eigen`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 特征值 = 特征多项式的根。

## 直觉

特征多项式 charpoly(X)=det(X·1−A)，μ 是根 ⟺ det(μ·1−A)=0 ⟺ μ·1−A 奇异
⟺ 存在非零 x 使 (μ·1−A)x=0 ⟺ A x=μ·x，即 μ 是特征值。

## 陈述（教材记号）

`MatrixHasEigenvalue A μ`（∃x≠0, A·x=μ·x）⟺ `A.charpoly.IsRoot μ`。

## 依赖（人话版）

premises: linear-algebra.eigen.charpoly（特征多项式）、linear-algebra.eigen.value（特征值）；
mathlib: Module.End.hasEigenvalue_iff_isRoot_charpoly、Matrix.charpoly_toLin'（矩阵与线性变换 charpoly 一致）。

## 应用与陷阱

- 这是"特征多项式根个数判断特征值个数"的基础，也是对 角化理论的前提。
- 矩阵特征值经 `A.toLin'`（矩阵的线性变换表示）桥接到 mathlib 的 `Module.End.HasEigenvalue`；
  桥接（charpoly 一致）在证明内部完成，签名只见教材记号。
