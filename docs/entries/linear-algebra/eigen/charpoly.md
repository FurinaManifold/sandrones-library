---
id: linear-algebra.eigen.charpoly
family: linear-algebra.eigen
variant: ecnu
kind: theorem
state: verified
title: 特征多项式
summary: 对角阵特征多项式=∏(X−dᵢ)；特征多项式首一
premises: []
mathlib: ["Matrix.charpoly_diagonal", "Matrix.charpoly_monic", "Matrix.charpoly"]
provenance:
  source_type: book
  ref: "线性代数教材：特征值与特征向量"
---

# linear-algebra.eigen.charpoly

- **家族**: `linear-algebra.eigen`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 对角阵特征多项式=∏(X−dᵢ)；特征多项式首一

## 直觉

det(λI−T) 的特征多项式；对角阵时=∏(X−dᵢ)，故对角元即特征值。

## 陈述（教材记号）

(diagonal d).charpoly = ∏ᵢ(X−dᵢ)；charpoly 首一

## 依赖（人话版）

前提：无；mathlib: Matrix.charpoly_diagonal, charpoly_monic

## 应用与陷阱

特征值是特征多项式的根（对角情形显式）。
