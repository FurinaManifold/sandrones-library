---
id: linear-algebra.vector-space.independent
family: linear-algebra.vector-space
variant: ecnu
kind: theorem
state: verified
title: 线性无关
summary: 任何线性无关向量组至多有 dim V 个向量
premises: []
mathlib: ["LinearIndependent.fintype_card_le_finrank"]
provenance:
  source_type: book
  ref: "华东师大/线性代数教材：向量空间与维数"
---

# linear-algebra.vector-space.independent

- **家族**: `linear-algebra.vector-space`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 任何线性无关向量组至多有 dim V 个向量

## 直觉

线性无关向量组不能超过空间维数：n 个线性无关向量需要空间至少 n 维。

## 陈述（教材记号）

任何 LinearIndependent 组 v:ι→V 满足 Fintype.card ι ≤ dim V

## 依赖（人话版）

前提：无；mathlib: LinearIndependent.fintype_card_le_finrank

## 应用与陷阱

这是维数意义的根源：维数=最大无关组长度。
