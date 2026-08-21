---
id: real-analysis.measure.monotone-convergence
family: real-analysis.measure
variant: tao
kind: theorem
state: verified
title: 单调收敛定理
summary: MCT：非负可测单调序列 ∫⁻(⨆fₙ)=⨆∫⁻fₙ
premises: [real-analysis.measure.lintegral]
mathlib: [lintegral_iSup]
provenance:
  source_type: book
  ref: Tao, An Introduction to Measure Theory, Ch 1（单调收敛）
---

# real-analysis.measure.monotone-convergence

- **家族**: `real-analysis.measure`
- **变体**: tao
- **状态**: verified
- **一句话**: 非负可测单调递增序列的积分 = 极限的积分。

## 直觉

若 0 ≤ f1 ≤ f2 ≤ ... 且逐点可测，则 ∫⁻(sup fₙ) = sup ∫⁻fₙ。
积分与上确界可交换——这是 Lebesgue 积分优于黎曼积分的关键性质（黎曼积分不满足）。

## 陈述（教材记号）

`meas_lintegral_iSup`：∫⁻a (⨆ₙ fₙ a) = ⨆ₙ ∫⁻a fₙ a（fₙ 可测单调）。

## 依赖（人话版）

前提：real-analysis.measure.lintegral。mathlib 的 lintegral_iSup。

## 应用与陷阱

MCT 只需单调，不需一致收敛；黎曼积分没有对应定理。
