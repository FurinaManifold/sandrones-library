---
id: analysis.completeness.equivalence-cycle.cauchy-to-sup
family: analysis.completeness.equivalence-cycle
variant: generated
kind: theorem
state: verified
title: Cauchy ⟹ 确界
summary: 环第6道：二分逼近上确界（bisect_upper），两端 Cauchy 同极限 x，x 是 s 的上确界（唯一用阿基米德的一环）
premises: ["analysis.sequence.cauchy"]
mathlib: ["ge_of_tendsto", "tendsto_nhds_unique", "tendsto_pow_atTop_nhds_zero_of_norm_lt_one", "mem_upperBounds", "Set.Finite.biUnion"]
provenance:
  source_type: generated
  ref: "本库自建：实数完备性六大等价环"
---

# analysis.completeness.equivalence-cycle.cauchy-to-sup

- **家族**: `analysis.completeness.equivalence-cycle`
- **变体**: generated
- **状态**: verified
- **一句话**: 环第6道：二分逼近上确界（bisect_upper），两端 Cauchy 同极限 x，x 是 s 的上确界（唯一用阿基米德的一环）

## 直觉

非空有上界的 s，取 x₀ ∈ s、上界 M；反复取中点二分 [x₀, M]，保持‘右端是上界、左端不是上界’；
  两端皆 Cauchy（区间直径 → 0）收敛到同一极限 x，x 正是 s 的上确界。

## 陈述（Lean 对照）

`(h : CauchyConvergenceProperty) : SupProperty`；`bisect_upper` 二分 + 不变量引理 + `IsLUB` 两件套（上界性 + 最小性）。

## 依赖（人话版）

**前提**：`analysis.sequence.cauchy`。
**mathlib**：`ge_of_tendsto`、`tendsto_nhds_unique`、`tendsto_pow_atTop_nhds_zero_of_norm_lt_one`、`mem_upperBounds`、`Set.Finite.biUnion`。

## 应用与陷阱

证明类别 C。唯一显式用到阿基米德原理（1/2ⁿ → 0）的一环，圆了‘确界原理不依赖阿基米德，Cauchy 反推才需要’。
