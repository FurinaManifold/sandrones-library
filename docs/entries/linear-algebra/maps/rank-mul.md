---
id: linear-algebra.maps.rank-mul
family: linear-algebra.maps
variant: ecnu
kind: theorem
state: verified
title: 矩阵乘法秩的界
summary: rank(AB) ≤ min rank A rank B
premises: []
mathlib: ["Matrix.rank_mul_le"]
provenance:
  source_type: book
  ref: "线性代数教材：线性映射、秩与秩-零度定理"
---

# linear-algebra.maps.rank-mul

- **家族**: `linear-algebra.maps`
- **变体**: ecnu
- **状态**: verified
- **一句话**: rank(AB) ≤ min rank A rank B

## 直觉

rank(AB) ≤ min(rank A, rank B)：乘法不会增大秩。

## 陈述（教材记号）

(A*B).rank ≤ min A.rank B.rank

## 依赖（人话版）

前提：无；mathlib: Matrix.rank_mul_le

## 应用与陷阱

齐次线性方程组 AX=0 解空间维数的来源。
