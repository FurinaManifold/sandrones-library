---
id: linear-algebra.maps.matrix-rank
family: linear-algebra.maps
variant: ecnu
kind: theorem
state: verified
title: 矩阵的秩（列秩）
summary: 矩阵秩 = 列向量张成子空间的维数
premises: []
mathlib: ["Matrix.rank_eq_finrank_span_cols"]
provenance:
  source_type: book
  ref: "线性代数教材：线性映射、秩与秩-零度定理"
---

# linear-algebra.maps.matrix-rank

- **家族**: `linear-algebra.maps`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 矩阵秩 = 列向量张成子空间的维数

## 直觉

矩阵 A 的秩 = 其列向量张成的子空间维数。

## 陈述（教材记号）

A.rank = dim(span{列向量})

## 依赖（人话版）

前提：无；mathlib: Matrix.rank_eq_finrank_span_cols

## 应用与陷阱

列秩=行秩=秩是重要推论。
