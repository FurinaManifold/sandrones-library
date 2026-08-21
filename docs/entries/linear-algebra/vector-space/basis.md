---
id: linear-algebra.vector-space.basis
family: linear-algebra.vector-space
variant: ecnu
kind: theorem
state: verified
title: 基与维数
summary: 基的元素个数等于维数
premises: []
mathlib: ["Module.finrank_eq_card_basis"]
provenance:
  source_type: book
  ref: "华东师大/线性代数教材：向量空间与维数"
---

# linear-algebra.vector-space.basis

- **家族**: `linear-algebra.vector-space`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 基的元素个数等于维数

## 直觉

一组基的张成就是整个空间且线性无关；基的元素个数=维数。

## 陈述（教材记号）

若 h 是 V 的基（Module.Basis ι K V），则 dim V = |ι|

## 依赖（人话版）

前提：无；mathlib: Module.finrank_eq_card_basis

## 应用与陷阱

dim K (K^I)=|I| 即标准基结论。
