---
id: number-theory.elementary.chinese-remainder
kind: theorem
state: verified
title: "中国剩余定理"
summary: 互素模数下联立同余方程有解，并给出 ZMod(mn) 与 ZMod(m)×ZMod(n) 的环同构
premises: ["number-theory.elementary.congruence"]
mathlib: ["Nat.chineseRemainder", "ZMod.chineseRemainder"]
provenance:
  source_type: book
  ref: "Hardy and Wright, An Introduction to the Theory of Numbers（中国剩余定理）"
---

# 动机

互素模数携带彼此独立的余数信息。中国剩余定理说明，分别指定模 `m` 与模 `n` 的余数，
等价于指定模 `mn` 的一个余数类。

# 陈述

若 `m,n` 互素，则任意 `a,b` 都存在自然数 `x`，同时满足
`x ≡ a (mod m)` 与 `x ≡ b (mod n)`。更强地，剩余环 `ZMod (m*n)` 与
`ZMod m × ZMod n` 环同构。

# Lean 对照

- `chinese_remainder_exists`：联立同余方程的存在形式；
- `chineseRemainderEquiv`：环同构形式。

# 思维脉络

Bézout 等式给出 `um + vn = 1`。由此构造分别在一个模数下为一、另一个模数下为零的
两个幂等系数，再对给定余数作线性组合即可得到共同解；核与基数计算把该构造提升为环同构。

# 陷阱

互素条件不可删除；否则两条同余式只有在余数对最大公因数相容时才可能同时有解。
