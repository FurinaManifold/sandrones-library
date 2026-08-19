---
id: analysis.func-limit.congr
family: analysis.func-limit
variant: ecnu
kind: lemma
state: verified
title: 最终相等替换
summary: 去心邻域上 f=g 且 f→L，则 g→L
premises: []
mathlib: ["Filter.Tendsto.congr'"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第一章 函数极限"
---

# analysis.func-limit.congr

- **家族**: `analysis.func-limit`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 去心邻域上 f=g 且 f→L，则 g→L

## 直觉

在去心邻域上 f 与 g 处处相等，则它们的极限自动相同。

## 陈述（Lean 对照）

`(∀ᶠ x in 𝓝[≠] a, f x = g x) → Tendsto f (𝓝[≠] a) (𝓝 L) → Tendsto g (𝓝[≠] a) (𝓝 L)`

## 依赖（人话版）

mathlib: Filter.Tendsto.congr'

## 应用与陷阱

函数极限只关心靠近 a 的行为，单点（甚至某一段）的差异不影响极限。
