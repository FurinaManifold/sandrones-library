---
id: linear-algebra.maps.rank-nullity
family: linear-algebra.maps
variant: ecnu
kind: theorem
state: verified
title: 秩-零度定理
summary: rank f + nullity f = dim V
premises: ["linear-algebra.vector-space.dimension"]
mathlib: ["LinearMap.finrank_range_add_finrank_ker"]
provenance:
  source_type: book
  ref: "线性代数教材：线性映射、秩与秩-零度定理"
---

# linear-algebra.maps.rank-nullity

- **家族**: `linear-algebra.maps`
- **变体**: ecnu
- **状态**: verified
- **一句话**: rank f + nullity f = dim V

## 直觉

线性映射 f:V→W 的像维数（秩）加核维数（零度）等于定义域维数。像把 V 压得越扁，核就越大。

## 陈述（教材记号）

rank f + nullity f = dim V，其中 rank f=dim(im f)、nullity f=dim(ker f)

## 依赖（人话版）

前提：线性代数.vector-space.dimension；mathlib: LinearMap.finrank_range_add_finrank_ker

## 应用与陷阱

最核心的线性代数定理之一，直接推出解空间维数公式。
