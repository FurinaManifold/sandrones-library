---
id: settheory.ordinal.no-infinite-descent
kind: theorem
state: verified
title: "序数无穷下降不可能"
premises: ["settheory.ordinal.transfinite-induction"]
mathlib: ["Ordinal.lt_wf"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 2: Well-foundedness of Ordinals"}
---

# 动机
Goodstein 一类终止性证明把有限状态映射到序数，并证明每一步序数严格下降。

# 直觉
若能无限下降，其取值集合会有最小序数，但下一步还要更小，矛盾。

# 陈述（自然语言）
序数上的严格小于关系是良基关系。

# 陈述（Lean 对照）
`ordinal_lt_wellFounded : WellFounded ((· < ·) : Ordinal → Ordinal → Prop)`。

# 思维脉络（thinking trace）
直接暴露 mathlib 的序数良基定理，作为任何具体下降度量的统一终止接口。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| 良基 | `WellFounded r` |
| 严格序 | `(· < ·)` |

# 依赖（人话版）
良基性与超限归纳是同一原理的两种接口。

# 为什么不可能无限下降

假设有严格下降链 `α₀>α₁>α₂>⋯`。把链中出现的序数组成非空集合 `S`。良序性给出 `S` 的
最小元素 `αₙ`，但下一项 `αₙ₊₁<αₙ` 也属于 `S`，立即矛盾。因此严格下降过程必定停止。

这不意味着所有下降过程有一个统一的自然数步数上界。不同规则可能运行极久；良基性只排除真正
无限的下降链。

# 终止性证明模板

证明离散过程终止时，可给每个状态 `s` 指派序数度量 `μ(s)`，证明每次转移 `s→t` 都满足
`μ(t)<μ(s)`，再调用本条排除无限转移。Goodstein 定理的难点在于构造 `ε₀` 以下的度量并证明
换底减一使它严格下降；本条提供最后的统一终止接口。

# 应用与陷阱
本条只给终止原则；Goodstein 定理还需把每个状态编码到 ε₀ 以下并证明单步严格下降。
- 自然数值增长不妨碍序数度量下降；两者是不同的大小关系。
- 良基性证明终止，但通常不给出实用运行时间上界。
