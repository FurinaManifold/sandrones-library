---
id: topology.space.def
family: topology.space
variant: munkres
kind: theorem
state: verified
title: 拓扑空间与开闭集公理
summary: 开集公理（空/全集开、有限交开、任意并开）；闭集任意交闭/有限并闭；开⟺补闭
premises: []
mathlib: [IsOpen, IsClosed, isOpen_iUnion, isClosed_iInter, isOpen_compl_iff]
provenance:
  source_type: book
  ref: Munkres, Topology, Ch 2（拓扑空间）
---

# topology.space.def

- **家族**: `topology.space`
- **变体**: munkres
- **状态**: verified
- **一句话**: 拓扑是"指定哪些子集为开"的结构，满足三条公理。

## 直觉

拓扑空间 (X, τ) 指定一簇"开集"，满足：空集与全集开、有限交开、任意并开。闭集是开集的补。
mathlib 的 `TopologicalSpace X` typeclass + `IsOpen` 承载这一切。

## 陈述（教材记号）

`topo_isOpen_empty`/`topo_isOpen_univ`：∅、X 开。`topo_isOpen_inter`：有限交开。
`topo_isOpen_iUnion`：任意并开。`topo_isClosed_iInter`：闭集任意交闭。`topo_isClosed_union`：有限并闭。
`topo_isOpen_iff_isClosed_compl`：s 开 ⟺ sᶜ 闭。

## 依赖（人话版）

前提：无。mathlib 的 `IsOpen`/`IsClosed` 是谓词，`isOpen_iUnion`/`isClosed_iInter` 是公理对应的引理。

## 应用与陷阱

- 开集公理由 mathlib 自动保证，这里的引理是"教材公理"的显式复述。
- `topo_` 前缀避免与 mathlib 同名（isOpen_empty 等）。
