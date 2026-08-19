---
id: analysis.func-limit.definition
family: analysis.func-limit
variant: ecnu
kind: theorem
state: verified
title: 函数极限定义（ε-δ 判据）
summary: 函数 f 在 a 的去心邻域上趋于 L ⟺ 对每个 ε>0 存 δ>0 使 x 靠近 a 且 x≠a 时 |f x − L| < ε
premises: []
mathlib: ["Metric.tendsto_nhds", "Metric.mem_nhdsWithin_iff"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第一章 函数极限"
---

# analysis.func-limit.definition

- **家族**: `analysis.func-limit`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 函数 f 在 a 的去心邻域上趋于 L ⟺ 对每个 ε>0 存 δ>0 使 x 靠近 a 且 x≠a 时 |f x − L| < ε

## 直觉

函数在 a 的去心邻域上趋于 L：对每个误差 ε 都能找到一个半径 δ 使足够靠近 a 的非 a 点全落在 L 的 ε 邻域里。这是极限的“机动半径”定义。

## 陈述（Lean 对照）

`Tendsto f (𝓝[≠] a) (𝓝 L) ⟺ ∀ ε>0, ∃ δ>0, ∀ x, |x−a|<δ → x≠a → |f x − L| < ε`

## 依赖（人话版）

mathlib: Metric.tendsto_nhds、Metric.mem_nhdsWithin_iff

## 应用与陷阱

定义去心邻域 𝓝[≠] a 是整条第四章的主语言。helper 引理 eventually_nhds_within_iff_delta 把“最终成立”换成 δ 判据。
