---
id: settheory.ordinal.successor-limit
kind: theorem
state: verified
title: "后继序数与极限序数"
premises: ["settheory.ordinal.order-type"]
mathlib: ["Order.lt_succ", "Order.lt_succ_iff", "Ordinal.isSuccLimit_omega0"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 2: Successor and Limit Ordinals"}
---

# 动机
超限论证必须区分有直接前驱的后继阶段与没有直接前驱的极限阶段。

# 直觉
`succ α` 是紧挨着 `α` 的下一序数；`ω` 汇集全部有限序数，没有最大有限前驱。

# 陈述（自然语言）
`α<succ α`，两者之间没有序数，并且 `ω` 是非零极限序数。

# 陈述（Lean 对照）
`successor_and_limit (a)`。

# 思维脉络（thinking trace）
由 `b<succ a ↔ b≤a` 排除中间序数；`ω` 的极限性使用标准定理。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| 非零极限序数 | `IsSuccLimit α` |
| 后继 | `Order.succ α` |

# 依赖（人话版）
依赖 `ω` 作为自然数序型的入口。

# 应用与陷阱
mathlib 的 `IsSuccLimit` 表示“非零且在后继意义下为极限”。
