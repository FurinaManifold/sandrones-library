---
id: topology.metric.cauchy-complete
family: topology.metric
variant: munkres
kind: theorem
state: verified
title: Cauchy 列与完备空间
summary: Cauchy ε-N 判据；完备空间中 Cauchy 列收敛
premises: [topology.space.def]
mathlib: [Metric.cauchySeq_iff, cauchySeq_tendsto_of_complete, CompleteSpace]
provenance:
  source_type: book
  ref: Munkres, Topology, Ch 2（完备性）
---

# topology.metric.cauchy-complete

- **家族**: `topology.metric`
- **变体**: munkres
- **状态**: verified
- **一句话**: Cauchy 列 = 项之间最终任意近；完备 = 每个 Cauchy 列收敛。

## 直觉

u 是 Cauchy 列 ⟺ ∀ε>0, ∃N, ∀m,n≥N, d(u m, u n)<ε（项自家人最终靠近，与极限无关）。
完备空间：每个 Cauchy 列都有极限（不必预先知道极限存在）。

## 陈述（教材记号）

`metric_cauchySeq_iff_eps_N`：Cauchy 的 ε-N 判据。
`metric_cauchySeq_tendsto_of_complete`：完备 ⟹ Cauchy 列收敛。

## 依赖（人话版）

前提：topology.space.def。mathlib 的 `CauchySeq`/`CompleteSpace`；`Metric.cauchySeq_iff` 是 ε-N 判据。

## 应用与陷阱

- ℝ、ℂ 完备；ℚ 不完备（这正是完备化/实数构造的动机，见 analysis.real.construction-cauchy）。
- Cauchy 列有界但不一定收敛（非完备空间）。
