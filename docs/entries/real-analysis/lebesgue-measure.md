---
id: real-analysis.lebesgue-measure
family: real-analysis.measure
variant: tao
kind: theorem
state: verified
title: Lebesgue 测度
summary: ℝ 上 Lebesgue 测度 volume：区间长度 b-a；区间 Lebesgue 可测
premises: [real-analysis.measure.sigma-algebra, real-analysis.measure.caratheodory]
mathlib: [Real.volume_Icc, Real.volume_Ioo, measurableSet_Icc, measurableSet_Ioo]
provenance:
  source_type: book
  ref: Tao, An Introduction to Measure Theory, Ch 1（Lebesgue 测度）
---

# real-analysis.lebesgue-measure

- **家族**: `real-analysis.measure`
- **变体**: tao
- **状态**: verified
- **一句话**: ℝ 上的 Lebesgue 测度把区间长度推广到可测集。

## 直觉

ℝ 上 Lebesgue 测度 `volume`：闭/开区间测度 = 长度（b-a）；区间 Lebesgue 可测。
它由外测度 + Carathéodory 构造（R1.3），是测度积分（lintegral/integral）的定义基础。

## 陈述（教材记号）

`meas_volume_Icc`：volume [a,b] = b-a。`meas_volume_Ioo`：volume (a,b) = b-a。
`meas_measurable_Icc`/`meas_measurable_Ioo`：区间可测。

## 依赖（人话版）

前提：real-analysis.measure.sigma-algebra、caratheodory。mathlib 的 `volume`（MeasureSpace 的规范测度）、
`Real.volume_Icc`。

## 应用与陷阱

- `volume` 值域 ℝ≥0∞（用 `ENNReal.ofReal (b-a)` 表达 b-a）。
- 测度积分 `∫⁻`/`∫` 默认用 volume（Lebesgue 积分）。
