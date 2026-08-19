---
id: analysis.func-limit.le
family: analysis.func-limit
variant: ecnu
kind: lemma
state: verified
title: 极限保序
summary: 去心邻域上 f≤g 且 f→L、g→M，则 L≤M
premises: []
mathlib: ["ge_of_tendsto"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第一章 函数极限"
---

# analysis.func-limit.le

- **家族**: `analysis.func-limit`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 去心邻域上 f≤g 且 f→L、g→M，则 L≤M

## 直觉

函数在附近被 g 压住且两个极限都存在，则极限也保持这个顺序。

## 陈述（Lean 对照）

`f≤g 最终 → f→L ∧ g→M → L≤M`

## 依赖（人话版）

mathlib: ge_of_tendsto

## 应用与陷阱

g−f → M−L 且 ≥0 最终，极限取不等式。
