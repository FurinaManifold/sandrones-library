---
id: topology.compact.tychonoff
family: topology.compact
variant: munkres
kind: theorem
state: verified
title: Tychonoff 定理
summary: 任意族紧集的积紧；Set.pi 版；紧空间的积是紧空间
premises: [topology.compact.def]
mathlib: [isCompact_pi_infinite, isCompact_univ_pi, Pi.compactSpace]
provenance:
  source_type: book
  ref: Munkres, Topology, Ch 5（Tychonoff 定理）
---

# topology.compact.tychonoff

- **家族**: `topology.compact`
- **变体**: munkres
- **状态**: verified
- **一句话**: 任意多个紧空间的积仍是紧空间。

## 直觉

Tychonoff 定理：一族紧空间 {Xᵢ} 的积空间 ∏Xᵢ 紧。与有限情形不同，**无限积**也保持紧致性。
这是拓扑学最深刻的定理之一（等价于选择公理），是嵌入定理、紧群论的基石。

## 陈述（教材记号）

`tychonoff`：∀i, IsCompact (s i) ⟹ IsCompact {x | ∀i, x i ∈ s i}。
`tychonoff_pi`：Set.pi 版（∏ᵢ sᵢ 紧）。`compact_space_pi`：各因子紧 ⟹ 积空间紧（CompactSpace）。

## 依赖（人话版）

前提：topology.compact.def。mathlib 的 `isCompact_pi_infinite`/`isCompact_univ_pi` 是 Tychonoff 定理，
`Pi.compactSpace` 是紧凑型积空间实例。

## 应用与陷阱

- Tychonoff 定理等价于选择公理（依赖 Zorn/AC）。
- `Set.pi Set.univ s` 是积集的写法；无限积的紧致性是 Tychonoff 的独到之处。
