---
id: analysis.continuity.comp
family: analysis.continuity
variant: ecnu
kind: theorem
state: verified
title: 复合连续
summary: 连续函数复合仍连续（点连续与全域连续两版）
premises: []
mathlib: ["Continuous.comp", "ContinuousAt.comp"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第二章 连续函数"
---

# analysis.continuity.comp

- **家族**: `analysis.continuity`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 连续函数复合仍连续（点连续与全域连续两版）

## 直觉

连续函数复合仍连续；点连续版本是链式法则的拓扑先声。

## 陈述（Lean 对照）

Continuous g → Continuous f → Continuous (g ∘ f)

## 依赖（人话版）

mathlib: Continuous.comp, ContinuousAt.comp

## 应用与陷阱

点连续版本是反函数/链式的基础。
