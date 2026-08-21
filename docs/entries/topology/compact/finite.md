---
id: topology.compact.finite
family: topology.compact
variant: munkres
kind: theorem
state: verified
title: 紧 Hausdorff 的闭紧性
summary: T2 中紧集闭；T2 中紧集交仍紧
premises: [topology.compact.def, topology.separations]
mathlib: [IsCompact.isClosed, IsCompact.inter]
provenance:
  source_type: book
  ref: Munkres, Topology, Ch 3（紧致性与 Hausdorff）
---

# topology.compact.finite

- **家族**: `topology.compact`
- **变体**: munkres
- **状态**: verified
- **一句话**: Hausdorff 空间中紧集必闭；两个紧集之交仍紧。

## 直觉

在 Hausdorff（T2）空间中，紧集是闭集（`IsCompact.isClosed`）。这使紧集兼具"有限性"
（有限覆盖）与"闭性"。紧集之交仍紧（`IsCompact.inter`，T2 前提）。

## 陈述（教材记号）

`compact_isClosed_of_t2`：T2 中紧集闭。`compact_inter_of_t2`：T2 中紧集交仍紧。

## 依赖（人话版）

前提：topology.compact.def（紧致性）、topology.separations（T2）。mathlib 的
`IsCompact.isClosed`/`IsCompact.inter` 都要求 `[T2Space X]`。

## 应用与陷阱

- 紧集闭在非 Hausdorff 空间不成立——T2 前提是本质的。
- 推论：紧 Hausdorff 空间中"紧 ⟺ 闭"（配合反方向需额外条件）。
