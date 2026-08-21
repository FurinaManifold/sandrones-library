---
id: topology.metric.completion
family: topology.metric
variant: munkres
kind: theorem
state: verified
title: 完备化
summary: 完备化嵌入一致连续；T0 中嵌入单射
premises: [topology.metric.cauchy-complete]
mathlib: [UniformSpace.Completion, UniformSpace.Completion.uniformContinuous_coe, UniformSpace.Completion.coe_injective]
provenance:
  source_type: book
  ref: Munkres, Topology, Ch 2（完备化）
---

# topology.metric.completion

- **家族**: `topology.metric`
- **变体**: munkres
- **状态**: verified
- **一句话**: 完备化 = 把空间嵌入一个完备空间，且是"最小的"完备扩张。

## 直觉

任意度量空间 X 可嵌入完备空间 Completion X：嵌入一致连续、单射（T0 时），Completion X 完备。
这是把有理数扩张到实数的抽象版（analysis.real.construction-cauchy）。

## 陈述（教材记号）

`completion_coe_uniformContinuous`：嵌入 α → Completion α 一致连续。
`completion_coe_injective`：T0 中嵌入单射。

## 依赖（人话版）

前提：topology.metric.cauchy-complete。mathlib 的 `UniformSpace.Completion α` 是完备化空间，
`uniformContinuous_coe`/`coe_injective` 是嵌入性质，`instCompleteSpace` 是完备性实例（非 Prop）。

## 应用与陷阱

- Completion 的完备性、度量结构由 mathlib instance 提供（instance 非 Prop，不立条）。
- 完备化与实数构造（CauSeq）一脉相承。
