---
id: topology.compact.closed-bdd
family: topology.compact
variant: munkres
kind: theorem
state: verified
title: 闭区间紧
summary: ℝ 上闭区间 [a,b] 紧（Heine-Borel 基础）
premises: [topology.space.def]
mathlib: [isCompact_Icc]
provenance:
  source_type: book
  ref: Munkres, Topology, Ch 3（紧致性）
---

# topology.compact.closed-bdd

- **家族**: `topology.compact`
- **变体**: munkres
- **状态**: verified
- **一句话**: 闭区间 [a,b] 在 ℝ 上是紧集。

## 直觉

ℝ 上闭区间 [a,b] 是紧集（Heine-Borel 的一维情形）。这是"闭区间套/有限覆盖"在分析中
反复使用的紧致性来源，也是最值定理、一致连续性的基础。

## 陈述（教材记号）

`compact_Icc {a b : ℝ} : IsCompact (Set.Icc a b)`。

## 依赖（人话版）

前提：topology.space.def。mathlib 的 `isCompact_Icc`（`CompactIccSpace` 实例）。

## 应用与陷阱

- 紧致性 + 连续像紧 ⟹ 最值定理（分析线已用）。
- 开区间 (a,b) 不紧（无界/缺端点），这是紧与非紧的经典对比。
