---
id: settheory.ordinal.transfinite-induction
kind: theorem
state: verified
title: "超限归纳"
premises: ["settheory.ordinal.order-type"]
mathlib: ["WellFoundedLT.induction"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 2: Transfinite Induction"}
---

# 动机
普通自然数归纳只处理后继；序数还含极限阶段，需要一次使用全部更小序数的结论。

# 直觉
若反例存在，序数良序性会给出最小反例；它的所有前驱都成立，与归纳步矛盾。

# 陈述（自然语言）
若对每个序数 `α`，从性质对所有 `β<α` 成立可推出其对 `α` 成立，则性质对所有序数成立。

# 陈述（Lean 对照）
`transfinite_induction {P} (step) : ∀ α, P α`。

# 思维脉络（thinking trace）
把序数严格序的良基归纳原则直接应用于任意 `α`。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| 所有更小序数 | `∀ β < α, P β` |
| 良基归纳 | `WellFoundedLT.induction` |

# 依赖（人话版）
序数来自良序的序型，因此其严格序是良基的。

# 应用与陷阱
极限序数没有“前一个”序数，不能只写自然数式的后继归纳。
