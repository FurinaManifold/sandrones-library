---
id: number-theory.elementary.congruence
kind: theorem
state: verified
title: "同余与剩余环"
summary: 建立自然数同余与 ZMod 相等的桥，并证明同余对加法、乘法和乘方封闭
premises: ["number-theory.elementary.divisibility"]
mathlib: ["ZMod.natCast_eq_natCast_iff", "Nat.ModEq.add", "Nat.ModEq.mul", "Nat.ModEq.pow"]
provenance:
  source_type: book
  ref: "Hardy and Wright, An Introduction to the Theory of Numbers（同余）"
---

# 动机

同余把“除以同一模数所得余数相同”抽象成等价关系，是初等数论处理周期性信息的基本语言。
剩余环则把同余类变成可以直接加、乘的代数对象。

# 陈述

自然数 `a,b` 模 `n` 同余，当且仅当它们映入 `ZMod n` 后相等。同余关系保持加法、乘法
和任意自然数次幂。

# Lean 对照

- `modEq_iff_zmod_eq`：`a ≡ b [MOD n] ↔ (a : ZMod n) = b`；
- `modEq_add_mul_pow`：一次给出加法、乘法和乘方相容性。

# 思维脉络

映射 `ℕ → ZMod n` 把相差 `n` 的倍数的自然数识别为同一元素。由于该映射保持半环运算，
相等关系立即把加法、乘法及乘方的相容性传回同余语言。

# 陷阱

- 模数 `n = 0` 时，`Nat.ModEq 0 a b` 退化为普通相等；本条目的桥仍然成立。
- 同余可以逐项相加相乘，但消去公共因子通常需要该因子与模数互素。
