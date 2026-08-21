---
id: real-analysis.measure.dominated-convergence
family: real-analysis.measure
variant: tao
kind: theorem
state: verified
title: 控制收敛定理
summary: DCT：Fₙ被可积bound控制且Fₙ→f a.e. ⟹ ∫Fₙ→∫f
premises: [real-analysis.measure.lintegral]
mathlib: [tendsto_lintegral_of_dominated_convergence]
provenance:
  source_type: book
  ref: Tao, An Introduction to Measure Theory, Ch 1（控制收敛）
---

# real-analysis.measure.dominated-convergence

- **家族**: `real-analysis.measure`
- **变体**: tao
- **状态**: verified
- **一句话**: 被可积函数控制的逐点收敛可以穿过积分。

## 直觉

若 |Fₙ| ≤ bound（可积）且 Fₙ → f a.e.，则 ∫Fₙ → ∫f。
控制条件保证质量不流失，极限可穿过积分。

## 陈述（教材记号）

`meas_tendsto_lintegral_of_dominated`：bound 可积、Fₙ≤bound a.e.、Fₙ→f a.e. ⟹ ∫Fₙ→∫f。

## 依赖（人话版）

前提：real-analysis.measure.lintegral。mathlib 的 tendsto_lintegral_of_dominated_convergence。

## 应用与陷阱

需要控制函数可积（∫bound≠∞）；DCT 是实分析最常用的极限交换定理。
