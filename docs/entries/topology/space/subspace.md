---
id: topology.space.subspace
family: topology.space
variant: munkres
kind: theorem
state: verified
title: 子空间与积拓扑
summary: 子空间嵌入连续；限制连续；投影连续；子空间开集刻画（诱导拓扑）
premises: [topology.space.continuous]
mathlib: [continuous_subtype_val, ContinuousOn.restrict, continuous_fst, continuous_snd, isOpen_induced_iff]
provenance:
  source_type: book
  ref: Munkres, Topology, Ch 2（子空间/积拓扑）
---

# topology.space.subspace

- **家族**: `topology.space`
- **变体**: munkres
- **状态**: verified
- **一句话**: 子空间拓扑 = 诱导拓扑；积拓扑使投影连续。

## 直觉

子空间 s ⊆ X 的拓扑是诱导拓扑：U ⊆ s 开 ⟺ ∃ V ⊆ X 开，U = V ∩ s（`isOpen_induced_iff`）。
嵌入映射连续；连续函数的限制仍连续；积空间投影连续。

## 陈述（教材记号）

`topo_continuous_subtype_val`：子空间嵌入连续。`topo_continuous_restrict`：限制连续。
`topo_continuous_fst`/`topo_continuous_snd`：投影连续。
`topo_isOpen_subtype_iff`：子空间开集 = 原空间开集与 s 的交。

## 依赖（人话版）

前提：topology.space.continuous。mathlib 用 `Subtype` 表达子空间，`isOpen_induced_iff` 是诱导拓扑开集刻画。

## 应用与陷阱

- 连续函数的"限制到子空间"用 `ContinuousOn.restrict`/`domRestrict`。
- 商拓扑用 `isOpen_coinduced`（对偶），积拓扑是"投影连续的最弱拓扑"。
