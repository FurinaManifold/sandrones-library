---
id: analysis.func-limit.heine
family: analysis.func-limit
variant: ecnu
kind: theorem
state: verified
title: Heine 归结原理
summary: 函数极限 ⟺ 沿所有去心收敛序列的极限（归结原则）
premises: ["analysis.func-limit.definition"]
mathlib: ["Filter.Tendsto.comp", "Metric.tendsto_atTop", "tendsto_one_div_atTop_nhds_zero_nat"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第一章 函数极限（含 Heine 归结原理）"
---

# analysis.func-limit.heine

- **家族**: `analysis.func-limit`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 函数极限 ⟺ 沿所有去心收敛序列的极限（归结原则）

## 直觉

函数极限可以换成“沿每条去心收敛的序列”来检验。序列语言与 δ 语言等价。

## 陈述（Lean 对照）

`Tendsto f (𝓝[≠] a) (𝓝 L) ⟺ ∀ u, u→a ∧ u≠a → f∘u → L`

## 依赖（人话版）

mathlib: Filter.Tendsto.comp, Metric.tendsto_atTop, tendsto_one_div_atTop_nhds_zero_nat

## 应用与陷阱

反向方向是构造性反证：假设不趋于 L 取 ε₀，每次取 δ=1/(n+1) 挑一个坏点 xₙ 组成反例序列。
