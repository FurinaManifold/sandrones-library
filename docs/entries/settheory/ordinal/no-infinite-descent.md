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

# 应用与陷阱
本条只给终止原则；Goodstein 定理还需把每个状态编码到 ε₀ 以下并证明单步严格下降。
