---
id: number-theory.elementary.fermat-euler
kind: theorem
state: verified
title: "Euler 定理与 Fermat 小定理"
summary: 由互素剩余类的单位群阶推出 Euler 定理及 Fermat 小定理的两种形式
premises: ["number-theory.elementary.totient", "number-theory.elementary.congruence"]
mathlib: ["Nat.ModEq.pow_totient", "Nat.totient_prime", "Nat.modEq_zero_iff_dvd"]
provenance:
  source_type: book
  ref: "Hardy and Wright, An Introduction to the Theory of Numbers（Euler 与 Fermat 定理）"
---

# 动机

Euler 定理是有限群 Lagrange 定理在模算术中的基本应用；Fermat 小定理则是模数为素数时
的专门化，也是素数判定和公钥密码学的基础工具。

# 陈述

- 若 `a,n` 互素，则 `a^φ(n) ≡ 1 (mod n)`；
- 若素数 `p` 不整除 `a`，则 `a^(p-1) ≡ 1 (mod p)`；
- 对任意 `a`，都有 `a^p ≡ a (mod p)`。

# Lean 对照

对应 `euler_theorem`、`fermat_little_theorem_of_not_dvd` 和
`fermat_little_theorem`。

# 思维脉络

与 `n` 互素的剩余类属于有限单位群；对其应用群阶次幂等于单位元，得到 Euler 定理。
素数 `p` 满足 `φ(p)=p-1`。无条件形式再按 `p ∣ a` 与 `p ∤ a` 分情况处理。

# 陷阱

`a^(p-1) ≡ 1` 需要 `p ∤ a`；只有改写为 `a^p ≡ a` 后才能去掉该条件。
