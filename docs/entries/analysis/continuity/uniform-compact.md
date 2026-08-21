---
id: analysis.continuity.uniform-compact
family: analysis.continuity
variant: ecnu
kind: theorem
state: verified
title: 紧集上连续 ⟹ 一致连续
summary: 紧集s上连续的函数在s上一致连续（Lebesgue数引理法：有限子覆盖+最小δ）
premises: [analysis.continuity.uniform, analysis.continuity.definition]
mathlib: [Metric.uniformContinuousOn_iff, Metric.continuousOn_iff, IsCompact.elim_finite_subcover, Finset.min']
provenance:
  source_type: book
  ref: 华东师大《数学分析》第五版（一致连续）
---

# analysis.continuity.uniform-compact

- **家族**: `analysis.continuity`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 紧性把逐点连续提升为一致连续。

## 直觉

f 在紧集 s 上连续，则对每个 ε 每点 x 有局部 δx。Lebesgue 数引理：
有限子覆盖 {ball x (δx/2)} 的最小 δ 同时适用于所有点——于是 δ 不依赖点，即一致连续。
证明完全自建（mathlib 无此定理）。

## 陈述（教材记号）

`continuousOn_compact_uniformContinuousOn`：s 紧 + s 非空 + f 在 s 上连续 ⟹ UniformContinuousOn f s。

## 依赖（人话版）

前提：analysis.continuity.uniform（一致连续 ε-δ 定义）、definition。证明用
`Metric.uniformContinuousOn_iff`（目标）、`Metric.continuousOn_iff`（每点 δ）、
`IsCompact.elim_finite_subcover`（有限覆盖）、`Finset.min'`（最小 δ）。

## 应用与陷阱

- 这是黎曼积分"连续 ⟹ 可积"的前提（上下和差被一致连续控制）。
- 经典证明（Lebesgue 数引理）：每点 δx 减半取覆盖，有限子覆盖取最小 δ。
