---
id: linear-algebra.maps.row-rank
family: linear-algebra
variant: ecnu
kind: theorem
state: verified
title: 行秩=列秩
summary: rank Aᵀ = rank A，即行秩等于列秩
premises: []
mathlib: ["Matrix.rank_transpose"]
provenance:
  source_type: book
  ref: "线性代数教材：行列式与秩"
---

# linear-algebra.maps.row-rank

- **家族**: `linear-algebra`
- **变体**: ecnu
- **状态**: verified
- **一句话**: rank Aᵀ = rank A，即行秩等于列秩

## 直觉

矩阵的秩不因转置改变：Aᵀ 的秩 = A 的秩，即行秩=列秩。

## 陈述（教材记号）

rank Aᵀ = rank A

## 依赖（人话版）

前提：无；mathlib: Matrix.rank_transpose

## 应用与陷阱

秩=行秩=列秩是教材定义秩的三种等价说法。
