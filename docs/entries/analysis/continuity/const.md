---
id: analysis.continuity.const
family: analysis.continuity
variant: ecnu
kind: theorem
state: verified
title: 常函数连续
summary: 恒等于常数的函数连续
premises: []
mathlib: ["continuous_const"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第二章 连续函数"
---

# analysis.continuity.const

- **家族**: `analysis.continuity`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 恒等于常数的函数连续

## 直觉

一个不动的值无论自变量怎么变，函数值不变，自然连续。

## 陈述（Lean 对照）

Continuous fun _ : ℝ => c = continuous_const

## 依赖（人话版）

mathlib: continuous_const

## 应用与陷阱

零负担，后续运算打底。
