---
id: topology.space.neighborhood
family: topology.space
variant: munkres
kind: theorem
state: verified
title: 邻域
summary: 开集是其中每点的邻域
premises: [topology.space.def]
mathlib: [IsOpen.mem_nhds, nhds]
provenance:
  source_type: book
  ref: Munkres, Topology, Ch 2（邻域）
---

# topology.space.neighborhood

- **家族**: `topology.space`
- **变体**: munkres
- **状态**: verified
- **一句话**: 开集是其中每点的邻域。

## 直觉

x 的邻域是"包含 x 的某个开集"的集合。开集本身是其中每点的邻域（`IsOpen.mem_nhds`）。
mathlib 用滤子 `nhds x`（邻域滤子）表达，与连续性的滤子语言衔接。

## 陈述（教材记号）

`topo_isOpen_mem_nhds`：s 开且 x ∈ s ⟹ s ∈ nhds x。

## 依赖（人话版）

前提：topology.space.def。mathlib 的 `nhds x : Filter X` 是邻域滤子，`IsOpen.mem_nhds hs hx` 给出开集入滤子。

## 应用与陷阱

- 邻域滤子 `nhds x` 是后续连续、收敛、聚点的统一语言。
