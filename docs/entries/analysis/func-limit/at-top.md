---
id: analysis.func-limit.at-top
family: analysis.func-limit
variant: ecnu
kind: theorem
state: verified
title: 无穷极限
summary: 自变量趋于无穷的极限（ε-N 判据）及函数在 a 处发散到正无穷
premises: []
mathlib: ["Metric.tendsto_atTop", "tendsto_pow_atTop_atTop_of_one_lt", "tendsto_atTop"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第一章 函数极限"
---

# analysis.func-limit.at-top

- **家族**: `analysis.func-limit`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 自变量趋于无穷的极限（ε-N 判据）及函数在 a 处发散到正无穷

## 直觉

自变量趋于无穷的极限（ε-N 判据）以及函数在 a 处发散到正无穷。

## 陈述（Lean 对照）

Tendsto f atTop (𝓝 L) ⟺ ∀ ε>0 ∃ M 最终 |f x − L|<ε；Tendsto f (𝓝[≠] a) atTop ⟺ ∀ M ∃ δ 最终 M ≤ f x

## 依赖（人话版）

mathlib: Metric.tendsto_atTop, tendsto_pow_atTop_atTop_of_one_lt

## 应用与陷阱

发散到无穷用 atTop 滤波器表达，r>1 时 rⁿ→∞ 是幂函数的发散性。
