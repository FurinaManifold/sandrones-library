---
id: analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy
family: analysis.completeness.equivalence-cycle
variant: generated
kind: theorem
state: verified
title: 聚点 ⟹ Cauchy 收敛
summary: 环第5道：Cauchy 有界；值域无限则聚点即极限（聚点→cluster→子列→Cauchy 拉平），有限则鸽笼常值子列
premises: ["analysis.completeness.accumulation-point"]
mathlib: ["cauchySeq_bdd", "Nat.exists_strictMono_subsequence", "tendsto_nhds_of_cauchySeq_of_subseq", "Set.Finite.biUnion", "accPt_principal_iff_clusterPt", "Set.Infinite.exists_gt"]
provenance:
  source_type: generated
  ref: "本库自建：实数完备性六大等价环"
---

# analysis.completeness.equivalence-cycle.accumulation-point-to-cauchy

- **家族**: `analysis.completeness.equivalence-cycle`
- **变体**: generated
- **状态**: verified
- **一句话**: 环第5道：Cauchy 有界；值域无限则聚点即极限（聚点→cluster→子列→Cauchy 拉平），有限则鸽笼常值子列

## 直觉

Cauchy 列必有界；值域无限则聚点定理给聚点，聚点即极限；值域有限则鸽笼给常值子列，Cauchy 再拉成整体收敛。

## 陈述（Lean 对照）

`(h : AccumulationPointProperty) : CauchyConvergenceProperty`；核心桥 `mapClusterPt_of_accPt_range`（聚点→cluster point→子列），辅以 `cauchySeq_tendsto_of_finite_range`（鸽笼）。

## 依赖（人话版）

**前提**：`analysis.completeness.accumulation-point`。
**mathlib**：`cauchySeq_bdd`、`Nat.exists_strictMono_subsequence`、`tendsto_nhds_of_cauchySeq_of_subseq`、`Set.Finite.biUnion`、`accPt_principal_iff_clusterPt`、`Set.Infinite.exists_gt`。

## 应用与陷阱

证明类别 C。三个小坑记在 §2.12：Set.mem_biUnion 构造、Set.Infinite.exists_gt 枚举、Infinite 与 ¬Finite 同义。
