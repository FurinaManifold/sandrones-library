---
id: analysis.func-limit.add
family: analysis.func-limit
variant: ecnu
kind: lemma
state: verified
title: 函数极限加法
summary: lim(f+g) = lim f + lim g
premises: []
mathlib: ["Filter.Tendsto.add"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第一章 函数极限"
---

# analysis.func-limit.add

- **家族**: `analysis.func-limit`
- **变体**: ecnu
- **状态**: verified
- **一句话**: lim(f+g) = lim f + lim g

## 直觉

和的极限等于极限的和。

## 陈述（Lean 对照）

`hf.add hg`（Filter.Tendsto.add）

## 依赖（人话版）

mathlib: Filter.Tendsto.add

## 应用与陷阱

四则运算的加法half。
