---
id: topology.space.homeo
family: topology.space
variant: munkres
kind: theorem
state: verified
title: 同胚
summary: 同胚双向连续且双射；同胚保开集；同胚复合
premises: [topology.space.continuous]
mathlib: [Homeomorph, Homeomorph.continuous, Homeomorph.bijective, Homeomorph.isOpen_image]
provenance:
  source_type: book
  ref: Munkres, Topology, Ch 2（同胚）
---

# topology.space.homeo

- **家族**: `topology.space`
- **变体**: munkres
- **状态**: verified
- **一句话**: 同胚 = 双向连续的双射，是拓扑空间的"同构"。

## 直觉

同胚 h : X ≃ₜ Y 是双射，且 h 与 h⁻¹ 都连续。同胚保持拓扑性质（开集、连通等）。
mathlib 的 `Homeomorph X Y` 承载。

## 陈述（教材记号）

`homeomorph_continuous`：同胚连续。`homeomorph_invFun_continuous`：同胚的逆连续。
`homeomorph_bijective`：同胚是双射。`homeomorph_isOpen_image`：同胚保开集（h '' s 开 ⟺ s 开）。

## 依赖（人话版）

前提：topology.space.continuous。mathlib 的 `Homeomorph` 是 `X ≃ₜ Y`，`isOpen_image` 给开集保持。

## 应用与陷阱

- "同胚保持拓扑性质"是拓扑学核心思想：连通/紧致/分离性在同胚下不变。
- 同胚复合 `h₁.trans h₂` 返回新同胚（构造操作，非 Prop，不立条）。
