---
id: analysis.completeness.nested-intervals
family: analysis.completeness
variant: generated
kind: theorem
state: verified
title: 闭区间套定理
summary: 嵌套闭区间 [aₙ,bₙ]（aₙ 增、bₙ 减、aₙ≤bₙ）之交非空；长度趋于 0 时交为单点
premises: ["analysis.sequence.monotone-convergence", "analysis.real.sup"]
mathlib: ["Real.isLUB_sSup", "IsLUB"]
provenance:
  source_type: generated
  ref: "Rudin, Principles of Mathematical Analysis, Thm 2.38"
---

# analysis.completeness.nested-intervals

- **家族**: `analysis.completeness`
- **变体**: generated
- **状态**: verified
- **一句话**: 嵌套闭区间 [aₙ,bₙ]（aₙ 增、bₙ 减、aₙ≤bₙ）之交非空；长度趋于 0 时交为单点

## 直觉

aₙ 与 bₙ 像两个相向而行的巡游队伍：aₙ 只进不退、bₙ 只退不进，且永远 aₙ ≤ bₙ，它们必然在某处碰头。
  结合确界原理：x = sSup {aₙ} 同时压住每个下界序列项（下界）并被每个上界序列项压住（上界）。

## 陈述（Lean 对照）

`∃ x : ℝ, ∀ n, x ∈ Set.Icc (a n) (b n)`；`hshr` 版本进一步得 `∃! x`（交为单点）。

## 依赖（人话版）

**前提**：`analysis.sequence.monotone-convergence`（思想同源）、`analysis.real.sup`。
**mathlib**：`Real.isLUB_sSup`（确界存在即最小上界）、`IsLUB`。

## 应用与陷阱

两个不相交方向的不等号需要分开处理（k ≤ n 或 n ≤ k 分情况，靠 aₙ 单调 / bₙ 反单调接力）。
