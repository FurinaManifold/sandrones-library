---
id: real-analysis.measure.lintegral
family: real-analysis.measure
variant: tao
kind: theorem
state: verified
title: 非负积分（lintegral）
summary: 常数函数积分=c·μ(X)；积分单调；∫f=0⟺f=0 a.e.
premises: [real-analysis.measure.def, real-analysis.measure.measurable-function]
mathlib: [lintegral_const, lintegral_mono, lintegral_eq_zero_iff]
provenance:
  source_type: book
  ref: Tao, An Introduction to Measure Theory, Ch 1（积分）
---

# real-analysis.measure.lintegral

- **家族**: `real-analysis.measure`
- **变体**: tao
- **状态**: verified
- **一句话**: 非负可测函数的积分（lintegral），先对非负函数定义。

## 直觉

lintegral（`∫⁻`）定义在非负可测函数 f : X → [0,∞] 上。常数积分 = c·μ(X)；
积分单调（f≤g ⟹ ∫f≤∫g）；∫f=0 ⟺ f 几乎处处为 0。这是 Lebesgue 积分的非负部分。

## 陈述（教材记号）

`meas_lintegral_const`：∫⁻c = c·μ(X)。`meas_lintegral_mono`：积分单调。
`meas_lintegral_eq_zero_iff`：∫⁻f=0 ⟺ f=0 a.e.。

## 依赖（人话版）

前提：real-analysis.measure.def、measurable-function。mathlib 的 `lintegral`（非负积分，值域 ℝ≥0∞）。

## 应用与陷阱

- lintegral 值域 ℝ≥0∞（含 ∞），是一般可积函数积分（integral）的前置。
- `∫⁻` 记号 = 非负积分；`=ᵐ[μ]` = 几乎处处相等。
