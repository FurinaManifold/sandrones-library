---
id: real-analysis.measure.fatou
family: real-analysis.measure
variant: tao
kind: theorem
state: verified
title: Fatou 引理
summary: ∫⁻(liminf f) ≤ liminf ∫⁻f（非负可测函数）
premises: [real-analysis.measure.lintegral]
mathlib: [lintegral_liminf_le]
provenance:
  source_type: book
  ref: Tao, An Introduction to Measure Theory, Ch 1（Fatou）
---

# real-analysis.measure.fatou

- **家族**: `real-analysis.measure`
- **变体**: tao
- **状态**: verified
- **一句话**: liminf 的积分 ≤ liminf 的积分（不等式方向）。

## 直觉

非负可测函数族：∫⁻(liminf fₙ) ≤ liminf ∫⁻fₙ。
这是控制收敛定理证明的核心不等式。

## 陈述（教材记号）

`meas_lintegral_liminf_le`：∫⁻(liminfₙ fₙ) ≤ liminfₙ ∫⁻fₙ。

## 依赖（人话版）

前提：real-analysis.measure.lintegral。mathlib 的 lintegral_liminf_le。

## 应用与陷阱

不等式方向是 ≤（不是 =）；配合 MCT 可用于证明 DCT。
