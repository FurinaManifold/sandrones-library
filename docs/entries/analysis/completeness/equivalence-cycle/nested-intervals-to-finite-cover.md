---
id: analysis.completeness.equivalence-cycle.nested-intervals-to-finite-cover
family: analysis.completeness.equivalence-cycle
variant: generated
kind: theorem
state: verified
title: 闭区间套 ⟹ 有限覆盖
summary: 环第3道：二分反证（halfbiseq），闭区间套给公共点，被单个开集连同小区间包住矛盾
premises: ["analysis.completeness.nested-intervals"]
mathlib: ["monotone_nat_of_le_succ", "antitone_nat_of_succ_le", "Metric.isOpen_iff", "tendsto_pow_atTop_nhds_zero_of_norm_lt_one"]
provenance:
  source_type: generated
  ref: "本库自建：实数完备性六大等价环"
---

# analysis.completeness.equivalence-cycle.nested-intervals-to-finite-cover

- **家族**: `analysis.completeness.equivalence-cycle`
- **变体**: generated
- **状态**: verified
- **一句话**: 环第3道：二分反证（halfbiseq），闭区间套给公共点，被单个开集连同小区间包住矛盾

## 直觉

反证若 [a,b] 无有限子覆盖，则每层二分后必有一半仍无有限子覆盖 → 得嵌套闭区间套；
  闭区间套给公共点 x，x 被某个开集 Uᵢ 连同长度趋于 0 的 [lₙ,rₙ] 整个包住 → 单元素有限子覆盖，矛盾。

## 陈述（Lean 对照）

`(h : NestedIntervalsProperty) : FiniteCoverProperty`；`halfbiseq` 二分 + 8 个辅助引理。

## 依赖（人话版）

**前提**：`analysis.completeness.nested-intervals`。
**mathlib**：`monotone_nat_of_le_succ`、`antitone_nat_of_succ_le`、`Metric.isOpen_iff`、`tendsto_pow_atTop_nhds_zero_of_norm_lt_one`。

## 应用与陷阱

证明类别 C。大小坑集中在 Playbook §3.12-3.15：⋃ bigUnion 绑架、if/dif 展开、No goals 直接删行、Type* universe。
