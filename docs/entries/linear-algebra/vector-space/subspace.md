---
id: linear-algebra.vector-space.subspace
family: linear-algebra.vector-space
variant: ecnu
kind: theorem
state: verified
title: 子空间
summary: 子空间=非空、对加法和数乘封闭的子集（自实现 IsSubspace）
premises: []
mathlib: []
provenance:
  source_type: book
  ref: "线性代数教材：子空间与生成"
---

# linear-algebra.vector-space.subspace

- **家族**: `linear-algebra.vector-space`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 子空间=非空、对加法和数乘封闭的子集（自实现 IsSubspace）

## 直觉

V 的非空子集 W，若对加法和数乘都封闭，则 W 是子空间（含 0）。

## 陈述（教材记号）

IsSubspace：非空 ∧ (u,v∈W→u+v∈W) ∧ (c·v∈W)

## 依赖（人话版）

前提：无；自实现，不依赖 mathlib 的 Submodule

## 应用与陷阱

核心封闭性。
