---
id: analysis.continuity.uniform
family: analysis.continuity
variant: ecnu
kind: theorem
state: verified
title: 一致连续
summary: 一致连续的 ε-δ 判据，且一致连续 ⟹ 连续
premises: []
mathlib: ["Metric.uniformContinuous_iff", "Metric.continuousAt_iff"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第二章 连续函数"
---

# analysis.continuity.uniform

- **家族**: `analysis.continuity`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 一致连续的 ε-δ 判据，且一致连续 ⟹ 连续

## 直觉

一致连续 = δ 不依赖点的连续；一致连续 ⟹ 连续（但反之不真，如 1/x）。

## 陈述（Lean 对照）

UniformContinuous f ⟺ ∀ ε>0 ∃ δ>0 ∀ x y, |x−y|<δ → |f x − f y|<ε

## 依赖（人话版）

mathlib: Metric.uniformContinuous_iff, Metric.continuousAt_iff

## 应用与陷阱

闭区间上连续 ⟹ 一致连续（Heine-Cantor）留待后续批次。
