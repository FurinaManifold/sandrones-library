---
id: real-analysis.calculus.ftc-differentiate
family: real-analysis.calculus
variant: tao
kind: theorem
state: verified
title: 微积分基本定理（第一形式）
summary: FTC-1：f可积且在b连续 ⟹ 变上限积分在b可导，导数=f(b)
premises: [real-analysis.measure.lintegral]
mathlib: [intervalIntegral.integral_hasStrictDerivAt_right]
provenance:
  source_type: book
  ref: Tao, An Introduction to Measure Theory, Ch 3（微积分基本定理）
---

# real-analysis.calculus.ftc-differentiate

- **家族**: `real-analysis.calculus`
- **变体**: tao
- **状态**: verified
- **一句话**: 变上限积分可导，导数是被积函数。

## 直觉

FTC-1：F(u) = ∫ₐᵘ f 满足 F'(u) = f(u)（f 在 u 连续时）。
积分是"连续函数"的右逆。

## 陈述（教材记号）

`ftc_1_right`：f 在 [a,b] 可积且在 b 连续 ⟹
HasStrictDerivAt (u ↦ ∫ₐᵘ f) (f b) b。

## 依赖（人话版）

前提：real-analysis.measure.lintegral。mathlib 的 `integral_hasStrictDerivAt_right`。

## 应用与陷阱

- 这是"变上限积分函数"的分析性质，也是 FTC-2 的证明基础。
- 需要 f 在端点连续（FTCFilter 前提简化版）。
