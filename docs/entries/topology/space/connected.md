---
id: topology.space.connected
family: topology.space
variant: munkres
kind: theorem
state: verified
title: 连通集
summary: 连通集的连续像连通；闭区间连通；开区间连通；同胚保连通
premises: [topology.space.continuous]
mathlib: [IsConnected.image, isConnected_Icc, isPreconnected_Ioo, Homeomorph.isConnected_image]
provenance:
  source_type: book
  ref: Munkres, Topology, Ch 3（连通性）
---

# topology.space.connected

- **家族**: `topology.space`
- **变体**: munkres
- **状态**: verified
- **一句话**: 连通集 = 不能分解为两个不相交非空开集的并。

## 直觉

s 连通 ⟺ 不存在两个不相交非空开集 A、B 使 s = A ∪ B。连续像连通（连通性是被连续映射保持的）；
ℝ 的区间连通；同胚保连通。

## 陈述（教材记号）

`isConnected_image_of_continuous`：连通集的连续像连通。
`topo_isConnected_Icc`/`topo_isPreconnected_Ioo`：闭/开区间连通。
`homeomorph_isConnected_image`：同胚保连通（h '' s 连通 ⟺ s 连通）。

## 依赖（人话版）

前提：topology.space.continuous。mathlib 的 `IsConnected`/`IsPreconnected`，
`isConnected_Icc` 需 [ConditionallyCompleteLinearOrder] + [OrderTopology]（ℝ 满足）。

## 应用与陷阱

- 介值定理是"连通像"的直接推论：f:[a,b]→ℝ 连续，像连通 ⟹ 取遍 f(a)、f(b) 间所有值。
- `IsConnected.image` 需要 `ContinuousOn f s`。
