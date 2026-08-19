---
id: analysis.func-limit.unique
family: analysis.func-limit
variant: ecnu
kind: lemma
state: verified
title: 函数极限唯一
summary: 同一天趋近方向下（去心邻域）两个极限必相等
premises: []
mathlib: ["tendsto_nhds_unique"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第一章 函数极限"
---

# analysis.func-limit.unique

- **家族**: `analysis.func-limit`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 同一天趋近方向下（去心邻域）两个极限必相等

## 直觉

同一个函数同一个方向下不能同时是两个极限：极限是唯一的。

## 陈述（Lean 对照）

`Tendsto f (𝓝[≠] a) (𝓝 L) → Tendsto f (𝓝[≠] a) (𝓝 M) → L = M`

## 依赖（人话版）

mathlib: tendsto_nhds_unique

## 应用与陷阱

依赖 ℝ 是 Hausdorff（T2）空间。
