---
id: real-analysis.measure.caratheodory
family: real-analysis.measure
variant: tao
kind: theorem
state: verified
title: Carathéodory 定理
summary: Carathéodory 判据：可测 ⟺ ∀t, m(t)=m(t∩s)+m(t\\s)；可测集构成 σ-代数
premises: [real-analysis.measure.outer]
mathlib: [OuterMeasure.caratheodory, isCaratheodory_iff]
provenance:
  source_type: book
  ref: Tao, An Introduction to Measure Theory, Ch 1（Carathéodory）
---

# real-analysis.measure.caratheodory

- **家族**: `real-analysis.measure`
- **变体**: tao
- **状态**: verified
- **一句话**: Carathéodory 判据挑出可测集，它们构成 σ-代数且外测度在其上可数可加。

## 直觉

外测度 m 下，s 是 Carathéodory 可测的 ⟺ 对一切 t，m(t) = m(t∩s) + m(t\s)
（s 把任意集"无损失地"切成两块）。全体可测集构成 σ-代数（`m.caratheodory`），
外测度限制在其上成为测度——这就是 Lebesgue 测度的构造。

## 陈述（教材记号）

`meas_caratheodory_iff`：Carathéodory 判据。
（可测集构成 σ-代数由 `OuterMeasure.caratheodory m : MeasurableSpace X` 直接提供。）

## 依赖（人话版）

前提：real-analysis.measure.outer。mathlib 的 `OuterMeasure.caratheodory` 是可测空间，
`isCaratheodory_iff` 是判据。

## 应用与陷阱

- 判据是 `=` 不是 `≤`（mathlib 版本）。
- 这是 Lebesgue 测度（volume）、Cantor 集理论的地基。
