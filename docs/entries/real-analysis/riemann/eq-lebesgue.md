---
id: real-analysis.riemann.eq-lebesgue
family: real-analysis.riemann
variant: tao
kind: theorem
state: verified
title: 黎曼积分值 = Lebesgue 区间积分
summary: 连续函数黎曼积分值(下积分上确界) = Lebesgue 区间积分（达布和=阶梯积分+夹逼，全自证）
premises: [real-analysis.riemann.def, real-analysis.riemann.cont-integrable, real-analysis.measure.lintegral, analysis.continuity.uniform-compact]
mathlib: [integral_indicator, integral_mono, integrableOn_const, lintegral]
provenance:
  source_type: book
  ref: "folland-real-analysis-1999"
---

# real-analysis.riemann.eq-lebesgue

- **家族**: `real-analysis.riemann`
- **变体**: tao
- **状态**: verified
- **一句话**: 连续函数上，黎曼积分值 = Lebesgue 区间积分。

## 直觉

对闭区间连续函数 f，黎曼积分（达布下和上确界）与 Lebesgue 区间积分相等。
核心：达布和 = 阶梯函数的 Lebesgue 积分（indicator 组合），上下阶梯函数夹逼 f，
积分保序 + 上下和差任意小（连续⟹可积）⟹ 相等。完全自证（mathlib 无此定理）。

## 陈述（教材记号）

`riemannIntegral_eq_interval`：a < b 且 f 在 [a,b] 连续 ⟹
riemannIntegral f a b = ∫ x in Ioc a b, f x（黎曼值 = Lebesgue 区间积分）。

## 依赖（人话版）

前提：riemann.def（达布分划/上下和/积分值）、cont-integrable（连续⟹可积）、
measure.lintegral（Lebesgue 积分）、analysis.continuity.uniform-compact（一致连续）。
证明链：达布和 = 阶梯积分 → 下和 ≤ ∫ ≤ 上和 → riemannIntegral = ∫。

## 应用与陷阱

- 这是"两种积分数值相等"，证明黎曼积分是 Lebesgue 积分的特例（连续情形）。
- 证明要点：阶梯函数（indicator 常数和）的 Lebesgue 积分 = 达布和；上下夹逼 + 可积性。
- 退化区间 [a,a] 无 Darboux 分划，主定理限 a < b。

## Lean 声明集合

本 Entry 在 `SandronesLibrary/RealAnalysis/Riemann.lean` 中确切包含 26 个声明
（`> **Entry**: real-analysis.riemann.eq-lebesgue` 标记自 `integral_indicator_const_Ioc`
起至主定理 `riemannIntegral_eq_interval` 止，是“达布和 = 阶梯积分 + 上下夹逼”的证明后端）：

- 指标/阶梯积分原子引理：`integral_indicator_const_Ioc`、`integral_sum_indicator_Ioc`、
  `restricted_integral_const_Ioc`、`step_indicator_identity`、`lower_sum_le_interval`、
  `continuous_indicator_integrable`。
- 分划组合引理：`partition_cover`、`step_eval_at`、`fin_strict_mono_le`、`partition_disjoint`、
  `mono_x_le`、`mono_x_le_le`、`partition_point_mem`、`partition_subinterval_sub`。
- 下和方向：`step_le_f_pointwise`、`step_le_f_upper`、`step_integral_eq_lowerSum`、
  `darboux_lower_le_interval`、`riemannIntegral_le_interval`。
- 上和方向：`f_le_step_sup_pointwise`、`step_ge_f_upper`、`indicator_f_le_indicator_uP`、
  `step_sup_integral_eq_upperSum`、`darboux_upper_ge_interval`、
  `interval_le_sSup_lowerSum_add`。
- 主定理：`riemannIntegral_eq_interval`。
