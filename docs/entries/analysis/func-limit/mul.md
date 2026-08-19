---
id: analysis.func-limit.mul
family: analysis.func-limit
variant: ecnu
kind: lemma
state: verified
title: 函数极限乘法
summary: lim(f·g) = lim f · lim g
premises: []
mathlib: ["Filter.Tendsto.mul"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第一章 函数极限"
---

# analysis.func-limit.mul

- **家族**: `analysis.func-limit`
- **变体**: ecnu
- **状态**: verified
- **一句话**: lim(f·g) = lim f · lim g

## 直觉

积的极限等于极限的积。

## 陈述（Lean 对照）

`hf.mul hg`

## 依赖（人话版）

mathlib: Filter.Tendsto.mul

## 应用与陷阱

乘法在拓扑环里连续。
