---
id: analysis.func-limit.comp
family: analysis.func-limit
variant: ecnu
kind: theorem
state: verified
title: 复合函数极限
summary: f(x)→L 且 g 在 L 连续，则 g(f(x))→g(L)（极限与连续函数换序）
premises: ["analysis.func-limit.definition"]
mathlib: ["ContinuousAt.tendsto", "Filter.Tendsto.comp"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版：函数极限与连续函数"
---

# analysis.func-limit.comp

- **家族**: `analysis.func-limit`
- **变体**: ecnu
- **状态**: verified
- **一句话**: f(x)→L 且 g 在 L 连续，则 g(f(x))→g(L)（极限与连续函数换序）

## 直觉

极限可以穿过连续函数：f 趋于 L，g 在 L 连续，则 g∘f 趋于 g(L)。换序的合法性由 g 的连续性保证。

## 陈述（教材记号）

f→L 于 a（去心），g 在 L 连续 ⟹ g∘f → g(L) 于 a

## 依赖（人话版）

前提：函数极限定义；mathlib: ContinuousAt.tendsto, Filter.Tendsto.comp

## 应用与陷阱

连续性版本归结原理；连续性版本的换序依据。
