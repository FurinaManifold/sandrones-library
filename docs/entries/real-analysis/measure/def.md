---
id: real-analysis.measure.def
family: real-analysis.measure
variant: tao
kind: theorem
state: verified
title: 测度公理
summary: 测度公理：空集零测/可数可加/单调性/有限可加
premises: [real-analysis.measure.sigma-algebra]
mathlib: [measure_empty, measure_sUnion, measure_mono, measure_union]
provenance:
  source_type: book
  ref: Tao, An Introduction to Measure Theory, Ch 1（测度）
---

# real-analysis.measure.def

- **家族**: `real-analysis.measure`
- **变体**: tao
- **状态**: verified
- **一句话**: 测度 = 满足空集零测 + 可数可加的非负集函数。

## 直觉

测度 μ : Σ → [0,∞] 满足：μ(∅)=0；可数个两两不交可测集的并的测度 = 测度和（可数可加）。
推论：单调性（s⊆t ⟹ μs≤μt）、有限可加。mathlib 的 `Measure` typeclass 承载。

## 陈述（教材记号）

`meas_measure_empty`：μ(∅)=0。`meas_measure_sUnion`：可数可加。
`meas_measure_mono`：单调。`meas_measure_union`：有限可加。

## 依赖（人话版）

前提：real-analysis.measure.sigma-algebra。mathlib 的 `Measure X`（带 MeasurableSpace）、
`measure_sUnion`（可数可加，值在 ℝ≥0∞）。

## 应用与陷阱

- 测度值域是 `ℝ≥0∞`（ENNReal），允许 ∞（如 ℝ 的 Lebesgue 测度）。
- 可数可加需要两两不交（`S.Pairwise Disjoint`）+ 可测前提。
