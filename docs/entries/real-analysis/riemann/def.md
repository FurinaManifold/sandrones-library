---
id: real-analysis.riemann.def
family: real-analysis.riemann
variant: tao
kind: theorem
state: verified
title: 黎曼积分定义
summary: 达布分划/上下和/黎曼可积(上下和可任意逼近)/均匀分划
premises: [real-analysis.measure.lintegral, real-analysis.lebesgue-measure]
mathlib: [sSup, sInf, Finset.sum_range]
provenance:
  source_type: book
  ref: Tao, Analysis I, Ch 11（黎曼积分）
---

# real-analysis.riemann.def

- **家族**: `real-analysis.riemann`
- **变体**: tao
- **状态**: verified
- **一句话**: 黎曼积分用达布上下和定义，可积 = 上下和可任意逼近。

## 直觉

黎曼积分：分划 [a,b]（a=x₀<x₁<...<xₙ=b），达布下和 Σ(xᵢ₊₁−xᵢ)·inf f、上和 Σ(xᵢ₊₁−xᵢ)·sup f。
f 黎曼可积 ⟺ 上和与下和可任意接近（上积分=下积分）。
mathlib 没有此定义，全部自建（Playbook §4.1）。

## 陈述（教材记号）

`DarbouxPartition a b`：分划。`lowerSum`/`upperSum`：达布上下和。
`RiemannIntegrable f a b`：黎曼可积。`uniformPartition`：均匀分划（等分 [a,b]）。

## 依赖（人话版）

前提：real-analysis.measure.lintegral、lebesgue-measure。用 `sSup`/`sInf`（区间上下确界）、
`Finset.sum_range`（求和）。

## 应用与陷阱

- 上下和需要区间上 f 有界（连续函数自动有界）。
- 这是后续"连续 ⟹ 可积"、"数值=Lebesgue"、"Lebesgue 判据"的基础。
