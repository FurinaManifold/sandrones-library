---
id: topology.space.continuous
family: topology.space
variant: munkres
kind: theorem
state: verified
title: 连续映射
summary: 连续⟺开集原像开；连续⟺处处点连续；连续保极限；恒等/常/复合连续
premises: [topology.space.def]
mathlib: [continuous_def, continuous_iff_continuousAt, Continuous.tendsto, Continuous.comp]
provenance:
  source_type: book
  ref: Munkres, Topology, Ch 2（连续函数）
---

# topology.space.continuous

- **家族**: `topology.space`
- **变体**: munkres
- **状态**: verified
- **一句话**: 连续 = 开集原像是开集 = 处处点连续 = 极限可穿过。

## 直觉

f 连续 ⟺ 每个开集的原像是开集（教材定义）。等价刻画：在每个点都连续、极限穿过
（x→x₀ ⟹ f(x)→f(x₀)）。恒等、常函数连续，连续复合连续。

## 陈述（教材记号）

`topo_continuous_iff_isOpen_preimage`：Continuous f ⟺ 开集原像开。
`topo_continuous_isOpen_preimage`：连续 ⟹ 开集原像开。
`topo_continuous_iff_continuousAt`：连续 ⟺ 处处点连续。
`topo_continuous_id`/`topo_continuous_const`/`topo_continuous_comp`：恒等/常/复合连续。
`topo_continuous_tendsto`：连续 ⟹ 极限穿过（滤子语言）。

## 依赖（人话版）

前提：topology.space.def。mathlib 的 `Continuous` 用开集原像定义（`continuous_def`），
`Continuous.tendsto` 连接滤子收敛。

## 应用与陷阱

- `Continuous` 是 Prop（非 typeclass），签名可直接出现。
- `continuous_iff_continuousAt` 是"点连续 ↔ 整体连续"的教材桥。
