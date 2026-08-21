---
id: analysis.continuity.identity
family: analysis.continuity
variant: ecnu
kind: theorem
state: verified
title: 恒等函数连续
summary: 恒等映射连续
premises: []
mathlib: ["continuous_id"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第二章 连续函数"
---

# analysis.continuity.identity

- **家族**: `analysis.continuity`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 恒等映射连续

## 直觉

x 去哪儿 x 就到哪儿，自己连续。

## 陈述（Lean 对照）

Continuous (id : ℝ → ℝ) = continuous_id

## 依赖（人话版）

mathlib: continuous_id

## 应用与陷阱


