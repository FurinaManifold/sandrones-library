---
id: analysis.continuity.intermediate-value
family: analysis.continuity
variant: ecnu
kind: theorem
state: verified
title: 介值定理
summary: 闭区间连续函数取遍两端之间的所有值
premises: []
mathlib: ["intermediate_value_Icc"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第二章 连续函数"
---

# analysis.continuity.intermediate-value

- **家族**: `analysis.continuity`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 闭区间连续函数取遍两端之间的所有值

## 直觉

闭区间上连续函数从 f a 走到 f b 时必经过两者之间的每一个值——函数图像不能‘跳过’任何高度。

## 陈述（Lean 对照）

intermediate_value_Icc hab hf : Icc (f a) (f b) ⊆ f '' Icc a b

## 依赖（人话版）

mathlib: intermediate_value_Icc

## 应用与陷阱

介值定理是连通性在实直线上的体现。
