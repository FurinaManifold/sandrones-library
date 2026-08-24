---
id: settheory.ordinal.exponentiation
kind: theorem
state: verified
title: "序数幂的后继递推"
premises: ["settheory.ordinal.multiplication"]
mathlib: ["Ordinal.opow_succ"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 2: Ordinal Arithmetic"}
---

# 动机
序数幂通过对指数做超限递归定义，是 Cantor 正规形的核心运算。

# 直觉
指数每增加一个后继步，就在右侧再乘一个底数。

# 陈述（自然语言）
对任意序数 `a,b`，`a^(b+1)=a^b·a`。

# 陈述（Lean 对照）
`exponentiation_successor (a b)`。

# 思维脉络（thinking trace）
这是序数幂超限递归定义的后继方程。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| 序数幂 | `a ^ b` |
| 后继 | `Order.succ b` |

# 依赖（人话版）
后继递推右侧使用序数乘法。

# 应用与陷阱
乘法不交换，因此因子顺序不能颠倒。
