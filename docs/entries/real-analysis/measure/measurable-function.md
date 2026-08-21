---
id: real-analysis.measure.measurable-function
family: real-analysis.measure
variant: tao
kind: theorem
state: verified
title: 可测函数
summary: 可测函数：恒等/常函数/复合保持可测
premises: [real-analysis.measure.sigma-algebra]
mathlib: [Measurable, measurable_id, measurable_const, Measurable.comp]
provenance:
  source_type: book
  ref: Tao, An Introduction to Measure Theory, Ch 1（可测函数）
---

# real-analysis.measure.measurable-function

- **家族**: `real-analysis.measure`
- **变体**: tao
- **状态**: verified
- **一句话**: 可测函数 = 开集（可测集）原像可测的函数。

## 直觉

f 可测 ⟺ 每个可测集的原像可测。恒等、常函数可测；可测复合可测。
这是积分的定义域（只有可测函数能积分）。

## 陈述（教材记号）

`meas_measurable_id`：恒等可测。`meas_measurable_const`：常函数可测。
`meas_measurable_comp`：可测复合可测。

## 依赖（人话版）

前提：real-analysis.measure.sigma-algebra。mathlib 的 `Measurable f`。

## 应用与陷阱

- 可测性是积分的必要条件；a.e. 相等的函数积分相同。
