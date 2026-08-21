---
id: analysis.continuity.max-min
family: analysis.continuity
variant: ecnu
kind: theorem
state: verified
title: 最值定理
summary: 闭区间连续函数取到最大值与最小值
premises: []
mathlib: ["IsCompact.image_of_continuousOn", "IsCompact.exists_isGreatest", "IsCompact.exists_isLeast", "CompactIccSpace.isCompact_Icc"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第二章 连续函数"
---

# analysis.continuity.max-min

- **家族**: `analysis.continuity`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 闭区间连续函数取到最大值与最小值

## 直觉

闭区间上连续函数必取到最大值与最小值：紧集连续像仍紧，紧集含其上确界。

## 陈述（Lean 对照）

exists_isGreatest_on_Icc / exists_isLeast_on_Icc

## 依赖（人话版）

mathlib: IsCompact.image_of_continuousOn, IsCompact.exists_isGreatest/isLeast, CompactIccSpace.isCompact_Icc

## 应用与陷阱

注意 IsCompact.image 要全域 Continuous，这里用 image_of_continuousOn（ContinuousOn 版）。
