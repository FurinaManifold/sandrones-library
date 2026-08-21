---
id: analysis.continuity.mul
family: analysis.continuity
variant: ecnu
kind: theorem
state: verified
title: 连续函数之积
summary: 连续函数相乘仍连续
premises: []
mathlib: ["Continuous.mul"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第二章 连续函数"
---

# analysis.continuity.mul

- **家族**: `analysis.continuity`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 连续函数相乘仍连续

## 直觉

逐点相乘仍连续。

## 陈述（Lean 对照）

Continuous f → Continuous g → Continuous (f * g)

## 依赖（人话版）

mathlib: Continuous.mul

## 应用与陷阱


