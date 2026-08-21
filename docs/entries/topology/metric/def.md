---
id: topology.metric.def
family: topology.metric
variant: munkres
kind: theorem
state: verified
title: 度量空间与开球
summary: 度量公理（对称/三角/自反/零距/非负）；开球成员刻画/开集/自含/单调
premises: [topology.space.def]
mathlib: [dist_comm, dist_triangle, dist_self, dist_eq_zero, Metric.mem_ball, Metric.isOpen_ball]
provenance:
  source_type: book
  ref: Munkres, Topology, Ch 2（度量空间）
---

# topology.metric.def

- **家族**: `topology.metric`
- **变体**: munkres
- **状态**: verified
- **一句话**: 度量空间 = 带距离函数的空间；开球生成度量拓扑。

## 直觉

度量空间 (X,d) 满足距离公理：对称、三角不等式、自反（d(x,x)=0）、零距判等（d(x,y)=0 ⟺ x=y）。
开球 B(x,ε) = {y | d(y,x) < ε} 是开集，全体开球生成度量拓扑。

## 陈述（教材记号）

`metric_dist_comm`：d(x,y)=d(y,x)。`metric_dist_triangle`：三角不等式。
`metric_dist_self`：d(x,x)=0。`metric_dist_eq_zero_iff`：d(x,y)=0 ⟺ x=y。`metric_dist_nonneg`：d ≥ 0。
`metric_mem_ball_iff`：y∈B(x,ε) ⟺ d(y,x)<ε。`metric_isOpen_ball`：开球开。
`metric_mem_ball_self`：x∈B(x,ε)。`metric_ball_subset_ball`：球单调。

## 依赖（人话版）

前提：topology.space.def。mathlib 的 `MetricSpace`/`PseudoMetricSpace` typeclass 承载距离，
`Metric.ball` 开球，`dist_*` 是距离公理引理。

## 应用与陷阱

- 定理名加 `metric_` 前缀避免与 mathlib 同名（dist_comm 等）。
- 度量公理由 mathlib 内建，这里的引理是教材公理显式复述。
