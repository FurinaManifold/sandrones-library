---
id: topology.compact.def
family: topology.compact
variant: munkres
kind: theorem
state: verified
title: 紧致性（有限覆盖）
summary: 有限子覆盖抽取；连续像紧；紧集有限并；单点集紧
premises: [topology.space.def]
mathlib: [IsCompact.elim_finite_subcover, IsCompact.image, IsCompact.union, isCompact_singleton]
provenance:
  source_type: book
  ref: Munkres, Topology, Ch 3（紧致性）
---

# topology.compact.def

- **家族**: `topology.compact`
- **变体**: munkres
- **状态**: verified
- **一句话**: 紧集 = 每个开覆盖都有有限子覆盖。

## 直觉

s 紧 ⟺ 对 s 的任意开覆盖 {Uᵢ}，都能挑出有限个仍覆盖 s。这是紧致性的工作定义。
核心性质：连续像紧（`IsCompact.image`）、有限并紧、单点紧。

## 陈述（教材记号）

`compact_elim_finite_subcover`：紧集开覆盖存在有限子覆盖。
`compact_image_of_continuous`：紧集连续像紧。`compact_union`：紧集有限并紧。
`compact_singleton`：单点集紧。

## 依赖（人话版）

前提：topology.space.def。mathlib 的 `IsCompact s` 用有限覆盖定义（`isCompact_iff_finite_subcover`），
`elim_finite_subcover` 是核心工具。

## 应用与陷阱

- 紧致性的原始定义（有限覆盖）在 mathlib 已内建，`elim_finite_subcover` 是常用入口。
- 连续像紧 + 闭区间紧 ⟹ 最值定理（与 analysis.continuity.max-min 呼应）。
