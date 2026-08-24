---
id: settheory.ordinal.addition
kind: theorem
state: verified
title: "序数加法不交换"
premises: []
mathlib: ["Ordinal.add_omega0", "Order.lt_succ"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 2: Ordinal Arithmetic"}
---

# 动机
序数运算描述良序的拼接，其左右方向有本质区别。

# 直觉
把一个点放在自然数列前面仍是 `ω`；放在后面则得到严格更大的 `ω+1`。

# 陈述（自然语言）
`1+ω=ω` 而 `ω+1≠ω`，所以序数加法不交换。

# 陈述（Lean 对照）
`addition_not_commutative` 给出上述两个公式的合取。

# 思维脉络（thinking trace）
第一式由有限序数吸收到右侧极限序数；第二式由 `ω < succ ω` 排除相等。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| ω | `Ordinal.omega0` |
| 后继 | `Order.succ` / `+ 1` |

# 依赖（人话版）
无库内前置条目。

# 应用与陷阱
不可把自然数加法的交换律自动迁移到序数。
