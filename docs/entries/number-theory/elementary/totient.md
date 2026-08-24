---
id: number-theory.elementary.totient
kind: theorem
state: verified
title: "Euler φ 函数与既约剩余类"
premises: ["number-theory.elementary.congruence"]
mathlib: ["ZMod.card_units_eq_totient"]
provenance:
  source_type: book
  ref: "Hardy and Wright, An Introduction to the Theory of Numbers（Euler φ 函数）"
---

# 动机

Euler φ 函数计数 `1,…,n` 中与 `n` 互素的数。剩余环观点下，这些数恰好对应可逆剩余类，
所以 φ 函数就是有限群 `(ZMod n)ˣ` 的阶。

# 直觉

一个剩余类存在乘法逆元，当且仅当它的代表元与模数互素。因而“数互素代表元”和“数环中
的单位”是同一批对象的两种描述。

# 陈述（自然语言）

非零模数 `n` 下，`ZMod n` 的单位群元素个数等于 `φ(n)`。

# 陈述（Lean 对照）

`reduced_residue_card (n) [NeZero n]` 证明
`Fintype.card (ZMod n)ˣ = n.totient`。

# 思维脉络（thinking trace）

选择单位群而不是手工定义既约剩余系，是为了让后续 Euler 定理直接使用有限群结构；此处
接口与 Mathlib 的计数定理完全一致，所以证明用 `exact`。

# 自然语言 ↔ Lean 映射

- `n.totient` 是 Euler φ 函数。
- `(ZMod n)ˣ` 是剩余环的单位群。
- `Fintype.card` 计算有限类型的元素个数。
- `[NeZero n]` 是由类型类系统提供的 `n ≠ 0` 假设。

# 依赖（人话版）

`Mathlib.Data.Nat.Totient` 同时提供 φ 函数及其与 `ZMod` 单位群的计数桥。

# 应用与陷阱

这里数的是单位而非 `ZMod n` 的全部元素；全部剩余类有 `n` 个，单位只有 `φ(n)` 个。
