---
id: settheory.ordinal.order-type
kind: theorem
state: verified
title: "良序与序型"
premises: []
mathlib: ["Ordinal.type_eq", "Ordinal.type_nat_lt"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 2: Ordinal Numbers"}
---

# 动机
序数把彼此同构的良序视为同一个“排列形状”，从而可以比较不同集合上的良序。

# 直觉
序型忘掉元素叫什么，只保留先后关系；自然数通常序的序型记作 `ω`。

# 陈述（自然语言）
两个良序的序型相等，当且仅当二者序同构；自然数通常严格序的序型是 `ω`。

# 陈述（Lean 对照）
`orderType_classification` 同时给出 `Ordinal.type r = Ordinal.type s ↔ Nonempty (r ≃r s)` 与自然数序型公式。

# 思维脉络（thinking trace）
`Ordinal.type` 是良序按序同构取商后的对象，因此相等恰好由序同构刻画；自然数一式由标准构造直接计算。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| 序型 | `Ordinal.type r` |
| 序同构 | `r ≃r s` |
| 最小无限序数 | `Ordinal.omega0` |

# 依赖（人话版）
无库内前置条目。

# 应用与陷阱
序数比较的是良序结构，不等同于只比较底集基数。
