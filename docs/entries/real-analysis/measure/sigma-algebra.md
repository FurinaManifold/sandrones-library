---
id: real-analysis.measure.sigma-algebra
family: real-analysis.measure
variant: tao
kind: theorem
state: verified
title: σ-代数公理
summary: 可测集族公理：空/全集可测、补可测、可数并可测、有限交并可测
premises: []
mathlib: [MeasurableSpace, MeasurableSet.empty, MeasurableSet.compl, MeasurableSet.iUnion, MeasurableSet.inter]
provenance:
  source_type: book
  ref: Tao, An Introduction to Measure Theory, Ch 1（σ-代数）
---

# real-analysis.measure.sigma-algebra

- **家族**: `real-analysis.measure`
- **变体**: tao
- **状态**: verified
- **一句话**: σ-代数 = 对补、可数并、有限交封闭的可测集族。

## 直觉

σ-代数 Σ 是 X 的可测子集族：∅、X 可测；补可测；可数并仍可测；有限交并可测。
这是测度的定义域。mathlib 的 `MeasurableSpace`/`MeasurableSet` 承载。

## 陈述（教材记号）

`meas_measurable_empty`/`meas_measurable_univ`：∅、X 可测。
`meas_measurable_compl`：补可测。`meas_measurable_iUnion`：可数并可测。
`meas_measurable_inter`/`meas_measurable_union`：有限交并可测。

## 依赖（人话版）

前提：无。mathlib 的 `MeasurableSet` 是谓词，公理由 `MeasurableSpace` typeclass 保证。

## 应用与陷阱

- 定理名加 `meas_` 前缀避免与 mathlib 同名（measurable_empty 等）。
- 可数并可测需要 `[Countable ι]`（σ-代数核心是可数运算封闭）。
