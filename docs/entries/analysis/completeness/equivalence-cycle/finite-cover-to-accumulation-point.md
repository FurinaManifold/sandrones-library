---
id: analysis.completeness.equivalence-cycle.finite-cover-to-accumulation-point
family: analysis.completeness.equivalence-cycle
variant: generated
kind: theorem
state: verified
title: 有限覆盖 ⟹ 聚点
summary: 环第4道：反证无聚点则每点有邻域只含 s 单点，有限子覆盖使 s 有限矛盾
premises: ["analysis.completeness.finite-cover"]
mathlib: ["accPt_iff_nhds", "Metric.mem_nhds_iff", "Metric.mem_ball_self", "Finset.finite_toSet", "Set.Infinite.not_finite"]
provenance:
  source_type: generated
  ref: "本库自建：实数完备性六大等价环"
---

# analysis.completeness.equivalence-cycle.finite-cover-to-accumulation-point

- **家族**: `analysis.completeness.equivalence-cycle`
- **变体**: generated
- **状态**: verified
- **一句话**: 环第4道：反证无聚点则每点有邻域只含 s 单点，有限子覆盖使 s 有限矛盾

## 直觉

反证无聚点：每点 x 有一个开邻域只与 s 交于（至多）x 自己。
  这些邻域盖住包 s 的闭区间，有限覆盖抽出的有限片里 s 至多有限个点，与 s 无限矛盾。

## 陈述（Lean 对照）

`(h : FiniteCoverProperty) : AccumulationPointProperty`；`not_accPt_iff_exists_nhds` 把‘非聚点’译成‘有邻域只含 {x}’，FC 抽有限片，`Set.Finite` 收尾。

## 依赖（人话版）

**前提**：`analysis.completeness.finite-cover`。
**mathlib**：`accPt_iff_nhds`、`Metric.mem_nhds_iff`、`Metric.mem_ball_self`、`Finset.finite_toSet`、`Set.Infinite.not_finite`。

## 应用与陷阱

证明类别 B。用纯 open-ball 覆盖而非 ⋃ 记法，避免 bigUnion 绑架（§2.11）。
