---
id: linear-algebra.vector-space.dimension
family: linear-algebra.vector-space
variant: ecnu
kind: theorem
state: verified
title: 维数
summary: dim V=0 当且仅当 V 是平凡空间；dim 与秩（基数）在有限维一致
premises: []
mathlib: ["Module.finrank_eq_rank", "Module.finrank_zero_iff"]
provenance:
  source_type: book
  ref: "线性代数教材：向量空间、基与维数"
---

# linear-algebra.vector-space.dimension

- **家族**: `linear-algebra.vector-space`
- **变体**: ecnu
- **状态**: verified
- **一句话**: dim V=0 当且仅当 V 是平凡空间；dim 与秩（基数）在有限维一致

## 直觉

dim V = 0 ⟺ V 只有零向量（平凡空间）；有限维时 dim 与秩（基数）一致。

## 陈述（教材记号）

dim V = 0 ↔ Subsingleton V；finrank 与 rank 一致

## 依赖（人话版）

前提：无；mathlib: Module.finrank_zero_iff, Module.finrank_eq_rank

## 应用与陷阱

零维是平凡空间；非平凡空间 dim≥1。
