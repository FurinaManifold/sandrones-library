---
id: linear-algebra.eigen.diagonalization
family: linear-algebra.eigen
variant: textbook
kind: theorem
state: verified
title: 特征基、重数与最小多项式
summary: 对角化的特征基判据、重数不等式、Cayley-Hamilton 定理与最小多项式
premises: [linear-algebra.coordinates.change-basis, linear-algebra.eigen.charpoly]
mathlib: ["LinearMap.finrank_eigenspace_le", "LinearMap.aeval_self_charpoly", "LinearMap.minpoly_dvd_charpoly"]
provenance:
  source_type: textbook
  ref: "本科线性代数：线性算子的对角化与多项式理论"
---

# linear-algebra.eigen.diagonalization

## 陈述（教材记号）

- 一组基是算子的特征基，当且仅当算子在该基下的矩阵是对角矩阵。
- 特征值的几何重数不超过它的代数重数。
- 特征多项式代入算子自身得到零算子（Cayley–Hamilton）。
- 最小多项式湮灭算子、整除特征多项式，并整除任意湮灭该算子的多项式。

## 实现说明

特征基继续使用本库的 `IsBasis` 表述。几何重数由教材集合形式的特征子空间维数定义；
底层广义模结构仅用于证明，不进入公开定理签名。
