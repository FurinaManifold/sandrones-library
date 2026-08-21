---
id: linear-algebra.eigen.value
family: linear-algebra.eigen
variant: ecnu
kind: theorem
state: verified
title: 特征值
summary: μ 是特征值 ⟺ μ 的特征子空间非零
premises: []
mathlib: ["Module.End.hasEigenvalue_iff", "Module.End.eigenspace"]
provenance:
  source_type: book
  ref: "线性代数教材：特征值与特征向量"
---

# linear-algebra.eigen.value

- **家族**: `linear-algebra.eigen`
- **变体**: ecnu
- **状态**: verified
- **一句话**: μ 是特征值 ⟺ μ 的特征子空间非零

## 直觉

μ 是特征值 ⟺ 存在非零特征向量 ⟺ 特征子空间非零。

## 陈述（教材记号）

T.HasEigenvalue μ ↔ T.eigenspace μ ≠ ⊥

## 依赖（人话版）

前提：无；mathlib: Module.End.hasEigenvalue_iff

## 应用与陷阱

特征子空间=属于 μ 的所有特征向量加零向量。
