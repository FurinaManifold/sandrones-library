---
id: real-analysis.measure.outer
family: real-analysis.measure
variant: tao
kind: theorem
state: verified
title: 外测度次可加性
summary: 外测度可数次可加：可数并的测度 ≤ 各测度之和
premises: [real-analysis.measure.def]
mathlib: [OuterMeasure, measure_iUnion_le]
provenance:
  source_type: book
  ref: Tao, An Introduction to Measure Theory, Ch 1（外测度）
---

# real-analysis.measure.outer

- **家族**: `real-analysis.measure`
- **变体**: tao
- **状态**: verified
- **一句话**: 外测度是定义在全体子集上的次可加函数（可数并 ≤ 和）。

## 直觉

外测度 m : Set X → [0,∞] 定义在全体子集上，满足单调 + 可数次可加（`measure_iUnion_le`）。
它比测度弱（测度需要可数可加且只在可测集上），是构造 Lebesgue 测度的第一步。

## 陈述（教材记号）

`meas_outer_measure_iUnion_le`：m(⋃ᵢ sᵢ) ≤ Σᵢ m(sᵢ)（可数次可加）。

## 依赖（人话版）

前提：real-analysis.measure.def。mathlib 的 `OuterMeasure`，`measure_iUnion_le` 次可加。

## 应用与陷阱

- 外测度对全体子集定义（不需可测）；用 Carathéodory 判据挑出可测集。
