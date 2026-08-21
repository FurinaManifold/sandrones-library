---
id: analysis.continuity.div
family: analysis.continuity
variant: ecnu
kind: theorem
state: verified
title: 连续函数之商
summary: 连续函数相除仍连续（分母处处非零）
premises: []
mathlib: ["Continuous.div"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第二章 连续函数"
---

# analysis.continuity.div

- **家族**: `analysis.continuity`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 连续函数相除仍连续（分母处处非零）

## 直觉

相除仍连续，前提是分母处处非零（否则在零点附近无定义）。

## 陈述（Lean 对照）

Continuous f → Continuous g → (∀ x, g x ≠ 0) → Continuous (f / g)

## 依赖（人话版）

mathlib: Continuous.div

## 应用与陷阱

除法的可倒性约束。
