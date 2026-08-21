---
id: topology.separations
family: topology.separations
variant: munkres
kind: theorem
state: verified
title: 分离公理 T1/T2/正则
summary: T1单点闭；T2极限唯一；T2邻域分离；正则判据；T2⟹T1
premises: [topology.space.def]
mathlib: [T1Space, T2Space, RegularSpace, tendsto_nhds_unique, t2Space_iff_disjoint_nhds, regularSpace_iff]
provenance:
  source_type: book
  ref: Munkres, Topology, Ch 3（分离公理）
---

# topology.separations

- **家族**: `topology.separations`
- **变体**: munkres
- **状态**: verified
- **一句话**: 分离公理按"能否分离点/闭集"分层：T1、T2、正则、正规。

## 直觉

T1：单点集闭（点与点可分离）。T2（Hausdorff）：不同点有不相交邻域，收敛极限唯一。
正则：闭集与外部点可分离。正规：两个闭集可分离。层级：T2 ⟹ T1，正规 ⟹ T2。

## 陈述（教材记号）

`t1_singleton_closed`：T1 中 {x} 闭。`t2_tendsto_unique`：T2 中极限唯一。
`t2_iff_disjoint_nhds`：T2 ⟺ 不同点邻域不相交。
`regular_iff_closed_nhds`：正则判据。`t2_implies_t1`：T2 ⟹ T1。

## 依赖（人话版）

前提：topology.space.def。mathlib 的 `T1Space`/`T2Space`/`RegularSpace` 是 Prop；
`tendsto_nhds_unique` 是 T2 极限唯一，`t2Space_iff_disjoint_nhds` 是邻域刻画。

## 应用与陷阱

- T1/T2 是 typeclass（`[T2Space X]`），签名可直接用。
- 极限唯一性在 T2 中成立（非 Hausdorff 空间极限可能不唯一）。
