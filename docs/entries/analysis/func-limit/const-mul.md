---
id: analysis.func-limit.const-mul
family: analysis.func-limit
variant: ecnu
kind: lemma
state: verified
title: 常数数乘
summary: lim(c·f) = c·lim f
premises: []
mathlib: ["Filter.Tendsto.const_mul"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第一章 函数极限"
---

# analysis.func-limit.const-mul

- **家族**: `analysis.func-limit`
- **变体**: ecnu
- **状态**: verified
- **一句话**: lim(c·f) = c·lim f

## 直觉

常数乘进极限：c 倍函数的效果等于把极限放大 c 倍。

## 陈述（Lean 对照）

`hf.const_mul c`

## 依赖（人话版）

mathlib: Filter.Tendsto.const_mul

## 应用与陷阱

乘法的一个特例（另一侧取常数函数）。
