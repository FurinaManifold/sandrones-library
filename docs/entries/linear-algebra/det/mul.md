---
id: linear-algebra.det.mul
family: linear-algebra.det
variant: ecnu
kind: theorem
state: verified
title: 积的行列式
summary: det(AB)=det A·det B
premises: []
mathlib: ["Matrix.det_mul"]
provenance:
  source_type: book
  ref: "线性代数教材：行列式"
---

# linear-algebra.det.mul

- **家族**: `linear-algebra.det`
- **变体**: ecnu
- **状态**: verified
- **一句话**: det(AB)=det A·det B

## 直觉

行列式是乘法同态：两个方阵乘积的行列式等于各自行列式之积。

## 陈述（教材记号）

det(A·B)=det A·det B

## 依赖（人话版）

前提：无；mathlib: Matrix.det_mul

## 应用与陷阱

核心乘法性质。
