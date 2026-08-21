---
id: analysis.continuity.add
family: analysis.continuity
variant: ecnu
kind: theorem
state: verified
title: 连续函数之和
summary: 连续函数相加仍连续
premises: []
mathlib: ["Continuous.add"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第二章 连续函数"
---

# analysis.continuity.add

- **家族**: `analysis.continuity`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 连续函数相加仍连续

## 直觉

两个连续函数逐点相加仍连续：和的连续性来自加法在拓扑环上的连续性。

## 陈述（Lean 对照）

Continuous f → Continuous g → Continuous (f + g)

## 依赖（人话版）

mathlib: Continuous.add

## 应用与陷阱

同构的 mul/sub/div。
