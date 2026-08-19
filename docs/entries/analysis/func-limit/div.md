---
id: analysis.func-limit.div
family: analysis.func-limit
variant: ecnu
kind: lemma
state: verified
title: 函数极限除法
summary: lim(f/g) = lim f / lim g（分母极限非零）
premises: []
mathlib: ["Filter.Tendsto.div"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第一章 函数极限"
---

# analysis.func-limit.div

- **家族**: `analysis.func-limit`
- **变体**: ecnu
- **状态**: verified
- **一句话**: lim(f/g) = lim f / lim g（分母极限非零）

## 直觉

商的极限等于极限的商，前提是分母极限不为零（保证可倒）。

## 陈述（Lean 对照）

`hf.div hg hM`（需 M ≠ 0）

## 依赖（人话版）

mathlib: Filter.Tendsto.div

## 应用与陷阱

除法比乘法多一个分母非零前提。
