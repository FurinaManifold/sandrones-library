---
id: linear-algebra.eigen.spectrum
family: linear-algebra.eigen
variant: ecnu
kind: theorem
state: verified
title: 谱
summary: 特征值属于线性变换的谱
premises: []
mathlib: ["Module.End.HasEigenvalue.mem_spectrum", "spectrum"]
provenance:
  source_type: book
  ref: "线性代数教材：特征值与特征向量"
---

# linear-algebra.eigen.spectrum

- **家族**: `linear-algebra.eigen`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 特征值属于线性变换的谱

## 直觉

特征值的集合就是谱。

## 陈述（教材记号）

特征值 μ ⟹ μ ∈ spectrum(T)

## 依赖（人话版）

前提：无；mathlib: Module.End.HasEigenvalue.mem_spectrum

## 应用与陷阱

谱=特征值集合的抽象名字。
