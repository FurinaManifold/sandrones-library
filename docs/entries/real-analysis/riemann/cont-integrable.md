---
id: real-analysis.riemann.cont-integrable
family: real-analysis.riemann
variant: tao
kind: theorem
state: verified
title: 连续函数黎曼可积
summary: 闭区间连续函数黎曼可积（一致连续+均匀分划+振荡界完全自证）
premises: [real-analysis.riemann.def, analysis.continuity.uniform-compact, analysis.continuity.uniform]
mathlib: [continuousOn_compact_uniformContinuousOn, Metric.uniformContinuousOn_iff, Finset.sum_le_sum]
provenance:
  source_type: book
  ref: Tao, Analysis I, Ch 11（黎曼可积性）
---

# real-analysis.riemann.cont-integrable

- **家族**: `real-analysis.riemann`
- **变体**: tao
- **状态**: verified
- **一句话**: 闭区间上连续的函数黎曼可积。

## 直觉

f 在 [a,b] 连续 ⟹ 一致连续（analysis.continuity.uniform-compact）。对 ε 取 δ，
均匀分划使步长 < δ，则每个子区间上振荡 ≤ 2ε'（C2），上下和差 ≤ 2ε'·(b-a) < ε。
完整证明自建（mathlib 无此定理）。

## 陈述（教材记号）

`continuous_on_riemannIntegrable_lt`：a < b 且 f 在 [a,b] 连续 ⟹ RiemannIntegrable f a b。

## 依赖（人话版）

前提：riemann.def（达布分划/上下和）、analysis.continuity.uniform-compact（紧集连续⟹一致连续）、
uniform（一致连续 ε-δ）。证明用均匀分划 + 区间宽度引理 + 振荡界 + 求和。

## 应用与陷阱

- 这是"连续 ⟹ 可积"的教材定理，也是数值=Lebesgue（eq-lebesgue）的前提。
- 退化区间 [a,a] 无 Darboux 分划（严格增矛盾），主定理限定 a < b。
- 证明要点：一致连续给 δ；均匀分划步长 < δ；每子区间振荡 ≤ 2ε'；求和 ≤ 2ε'·(b-a)。
