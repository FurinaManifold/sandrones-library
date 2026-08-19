---
id: analysis.func-limit.sub
family: analysis.func-limit
variant: ecnu
kind: lemma
state: verified
title: 函数极限减法
summary: lim(f−g) = lim f − lim g
premises: []
mathlib: ["Filter.Tendsto.sub"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第一章 函数极限"
---

# analysis.func-limit.sub

- **家族**: `analysis.func-limit`
- **变体**: ecnu
- **状态**: verified
- **一句话**: lim(f−g) = lim f − lim g

## 直觉

差、负号、平移极限，都由极限的减法统一处理。

## 陈述（Lean 对照）

`hf.sub hg`

## 依赖（人话版）

mathlib: Filter.Tendsto.sub

## 应用与陷阱

减法在拓扑群里的连续性质。
