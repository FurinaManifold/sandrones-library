---
id: settheory.ordinal.multiplication
kind: theorem
state: verified
title: "序数乘法不交换"
premises: ["settheory.ordinal.addition"]
mathlib: ["Ordinal.natCast_mul_omega0", "Ordinal.mul_two"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 2: Ordinal Arithmetic"}
---

# 动机
序数乘法是按右因子排列多个左因子副本，也保留方向性。

# 直觉
依次排列 `ω` 个二点块仍像自然数列；两个连续的 `ω` 块则比 `ω` 更长。

# 陈述（自然语言）
`2·ω=ω` 而 `ω·2≠ω`，所以序数乘法不交换。

# 陈述（Lean 对照）
`multiplication_not_commutative` 给出两式。

# 思维脉络（thinking trace）
用有限正序数左乘 `ω` 的吸收律证明第一式；展开 `ω·2=ω+ω` 并用右侧正加数得到严格增长。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| 序数乘法 | `a * b` |
| 两倍 | `Ordinal.mul_two` |

# 依赖（人话版）
使用序数加法及其方向性。

# 应用与陷阱
序数乘法满足结合律和左分配律，但通常不交换。
