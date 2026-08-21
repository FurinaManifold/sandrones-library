---
id: real-analysis.calculus.ftc
family: real-analysis.calculus
variant: tao
kind: theorem
state: verified
title: 微积分基本定理（第二形式）
summary: FTC-2：f在[a,b]可导且f'可积 ⟹ ∫ₐᵇf' = f(b)-f(a)
premises: [analysis.derivative.unique, real-analysis.measure.lintegral]
mathlib: [intervalIntegral.integral_eq_sub_of_hasDerivAt]
provenance:
  source_type: book
  ref: Tao, An Introduction to Measure Theory, Ch 3（微积分基本定理）
---

# real-analysis.calculus.ftc

- **家族**: `real-analysis.calculus`
- **变体**: tao
- **状态**: verified
- **一句话**: 导数的积分 = 端点函数值之差。

## 直觉

微积分基本定理第二形式：∫ₐᵇ f'(x) dx = f(b) - f(a)。
导数"逆运算"积分。在 Lebesgue 积分框架下，只需 f' 可积（比黎曼要求的条件弱）。

## 陈述（教材记号）

`ftc_2`：f 在 [a,b] 可导且 f' 可积 ⟹ ∫ y in a..b, f' y = f b - f a。

## 依赖（人话版）

前提：analysis.derivative.unique、real-analysis.measure.lintegral。mathlib 的
`intervalIntegral.integral_eq_sub_of_hasDerivAt`（区间积分版 FTC-2）。

## 应用与陷阱

- 记号 `[[a,b]]` = uIcc（闭区间），`∫ y in a..b` = 区间积分。
- FTC-2 + 分部积分（integral_deriv_mul_eq_sub）= 计算积分的两大工具。
