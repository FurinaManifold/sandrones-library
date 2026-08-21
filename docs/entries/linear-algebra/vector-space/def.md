---
id: linear-algebra.vector-space.def
family: linear-algebra.vector-space
variant: ecnu
kind: theorem
state: verified
title: 向量空间定义
summary: 向量空间=加法群配数乘；数域 K 作为自身向量空间维数 1，dim Kⁿ=n
premises: []
mathlib: ["Module.finrank_self", "Module.finrank_pi"]
provenance:
  source_type: book
  ref: "华东师大/线性代数教材：向量空间与维数"
---

# linear-algebra.vector-space.def

- **家族**: `linear-algebra.vector-space`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 向量空间=加法群配数乘；数域 K 作为自身向量空间维数 1，dim Kⁿ=n

## 直觉

向量空间就是带加法和数乘的集合，两条运算满足教材的公理；数域 K 自身是一维向量空间。

## 陈述（教材记号）

K 作为自身向量空间 dim K K = 1；dim K (K^I) = |I|

## 依赖（人话版）

前提：无；实现注记：形式化用 Module.finrank（K 上有限维），此处仅为教材记号 dim 的别名

## 应用与陷阱

dim 是 noncomputable（维数依赖选择）。
