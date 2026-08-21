---
id: topology.metric.uniform
family: topology.metric
variant: munkres
kind: theorem
state: verified
title: 一致连续
summary: 一致连续 ε-δ 判据；一致连续⟹连续；恒等一致连续
premises: [topology.space.continuous]
mathlib: [Metric.uniformContinuous_iff, UniformContinuous.continuous, uniformContinuous_id]
provenance:
  source_type: book
  ref: Munkres, Topology, Ch 2（一致连续）
---

# topology.metric.uniform

- **家族**: `topology.metric`
- **变体**: munkres
- **状态**: verified
- **一句话**: 一致连续 = δ 不依赖于点（全局 ε-δ）。

## 直觉

f 一致连续 ⟺ ∀ε>0, ∃δ>0, ∀a b, d(a,b)<δ ⟹ d(f a, f b)<ε。与普通连续不同，δ 对全体点统一。
一致连续 ⟹ 连续（连续允许 δ 随点变）。

## 陈述（教材记号）

`metric_uniformContinuous_iff_eps_delta`：一致连续 ε-δ 判据。
`metric_uniformContinuous_of_continuous`：一致连续 ⟹ 连续。
`metric_uniformContinuous_id`：恒等映射一致连续。

## 依赖（人话版）

前提：topology.space.continuous。mathlib 的 `UniformContinuous f`（一致连续），`Metric.uniformContinuous_iff` 给 ε-δ。

## 应用与陷阱

- 分析线 Continuity 的 `uniform` 条目已用过 ε-δ；这里立为度量空间条目。
- 一致连续是度量空间特有的（一般拓扑无此概念）。
