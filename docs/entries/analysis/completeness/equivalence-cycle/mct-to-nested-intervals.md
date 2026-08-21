---
id: analysis.completeness.equivalence-cycle.mct-to-nested-intervals
family: analysis.completeness.equivalence-cycle
variant: generated
kind: theorem
state: verified
title: 单调收敛 ⟹ 闭区间套
summary: 环第2道：从单调收敛定理推出闭区间套定理（aₙ 与 -bₙ 分头收敛 + 中点裁决）
premises: ["analysis.sequence.monotone-convergence"]
mathlib: ["Metric.tendsto_atTop", "abs_lt", "Filter.Tendsto.neg"]
provenance:
  source_type: generated
  ref: "本库自建：实数完备性六大等价环"
---

# analysis.completeness.equivalence-cycle.mct-to-nested-intervals

- **家族**: `analysis.completeness.equivalence-cycle`
- **变体**: generated
- **状态**: verified
- **一句话**: 环第2道：从单调收敛定理推出闭区间套定理（aₙ 与 -bₙ 分头收敛 + 中点裁决）

## 直觉

aₙ 单调递增且被 b₀ 挡住 → 收敛到 x；-bₙ 单调递增且被 -a₀ 挡住 → 收敛到 -y。
  对区间长度做中点裁决证 x ≤ -y，于是 x 落进每个 [aₙ, bₙ]。

## 陈述（Lean 对照）

`(h : MonotoneConvergenceProperty) : NestedIntervalsProperty`；辅助引理 `monotone_le_limit` / `antitone_limit_le` 用反证 ε 论证。

## 依赖（人话版）

**前提**：`analysis.sequence.monotone-convergence`。
**mathlib**：`Metric.tendsto_atTop`、`abs_lt`、`Filter.Tendsto.neg`。

## 应用与陷阱

关键落点 x ≤ -y 只做一次‘中间点裁决 ((x+y)/2)’；其余交给单调性（Playbook §5.2 记录了这个手法）。
