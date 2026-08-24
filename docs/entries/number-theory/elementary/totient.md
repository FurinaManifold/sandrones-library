---
id: number-theory.elementary.totient
kind: theorem
state: verified
title: "Euler φ 函数"
summary: Euler φ 函数等于模 n 剩余环中的可逆剩余类数
premises: ["number-theory.elementary.chinese-remainder"]
mathlib: ["ZMod.card_units_eq_totient"]
provenance:
  source_type: book
  ref: "Hardy and Wright, An Introduction to the Theory of Numbers（Euler φ 函数）"
---

# 动机

`φ(n)` 计数 `1,…,n` 中与 `n` 互素的数。代数上，这些数恰好代表剩余环 `ZMod n`
中的可逆元素，因此 `φ(n)` 是有限单位群的阶。

# 陈述与 Lean 对照

`reduced_residue_card` 证明在 `n ≠ 0` 时：
`Fintype.card (ZMod n)ˣ = n.totient`。

# 思维脉络

一个模 `n` 剩余类可逆，当且仅当其代表元与 `n` 互素。于是既约剩余系与 `ZMod n` 的
单位群逐一对应，计数即得结论。

# 陷阱

`ZMod 0` 是整数环而不是有限剩余环，所以基数公式需要 `n ≠ 0`。
