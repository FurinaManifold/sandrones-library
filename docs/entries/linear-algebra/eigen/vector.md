---
id: linear-algebra.eigen.vector
family: linear-algebra.eigen
variant: ecnu
kind: theorem
state: verified
title: 特征向量
summary: x≠0 且 T(x)=μ·x，则 x 是 T 的属于 μ 的特征向量
premises: []
mathlib: ["Module.End.HasEigenvector", "Module.End.HasEigenvector.apply_eq_smul"]
provenance:
  source_type: book
  ref: "线性代数教材：特征值与特征向量"
---

# linear-algebra.eigen.vector

- **家族**: `linear-algebra.eigen`
- **变体**: ecnu
- **状态**: verified
- **一句话**: x≠0 且 T(x)=μ·x，则 x 是 T 的属于 μ 的特征向量

## 直觉

非零向量 x 被线性变换 T 拉伸 μ 倍（方向不变），称 x 为属于 μ 的特征向量。

## 陈述（教材记号）

x≠0 ∧ T(x)=μ·x ⟹ x 是特征向量（HasEigenvector）

## 依赖（人话版）

前提：无；mathlib: Module.End.HasEigenvector

## 应用与陷阱

特征向量方向不变是核心直觉。
