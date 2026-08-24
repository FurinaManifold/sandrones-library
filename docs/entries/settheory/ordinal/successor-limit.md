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

# 两类非零序数

后继序数是“在某个良序末尾再添一个新点”。`succ a` 的最后一个点就在 `a` 之后，所以
`a<succ a`，且二者之间塞不进任何序数。如果 `a<b<succ a`，由 `b<succ a` 可推出
`b≤a`，与 `a<b` 矛盾。

极限序数则完全不同：它非零，但不是任何序数的后继，也就没有紧邻的前一个序数。`ω` 是第一个
例子。每个有限序数 `n` 都在 `ω` 之前，但给出任意 `n`，仍能找到 `n+1<ω`，所以不存在
“最大的有限序数”。

# 为什么这个分类重要

证明或定义序数对象时，零、后继、极限三种阶段使用不同逻辑：零阶段给初值，后继阶段读取上一值，
极限阶段汇总所有更小位置。超限递归、序数幂和正规函数的连续性都建立在这一分类上。

# 应用与陷阱
- mathlib 的 `IsSuccLimit` 表示“非零且在后继意义下为极限”。
- `ω` 是极限序数，但 `ω+1` 是后继序数；“无限”不等于“极限”。
- 后继序数可以有无限多个前驱，例如 `ω+1`，但它仍有直接前驱 `ω`。
