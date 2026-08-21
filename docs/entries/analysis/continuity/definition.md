---
id: analysis.continuity.definition
family: analysis.continuity
variant: ecnu
kind: theorem
state: verified
title: 连续性定义
summary: 连续函数与连续函数的区间限制（ContinuousOn）
premises: []
mathlib: ["Continuous", "ContinuousOn", "continuous_iff_continuousAt"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第二章 连续函数"
---

# analysis.continuity.definition

- **家族**: `analysis.continuity`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 连续函数与连续函数的区间限制（ContinuousOn）

## 直觉

连续 = 微小的输入扰动只引起微小的输出变化；在区间上连续（ContinuousOn）则是限制到该区间仍连续。

## 陈述（Lean 对照）

Continuous f ⟺ ∀ x, ContinuousAt f x；`continuousOn_Icc` 把全域连续限制到闭区间。

## 依赖（人话版）

mathlib: Continuous, ContinuousOn

## 应用与陷阱

限制用 ContinuousOn.restrict（已弃用，用 domRestrict）。
