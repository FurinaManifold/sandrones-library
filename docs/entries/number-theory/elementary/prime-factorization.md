---
id: number-theory.elementary.prime-factorization
kind: theorem
state: verified
title: "算术基本定理：素因子分解的存在性与唯一性"
premises: ["number-theory.elementary.divisibility"]
mathlib: ["Nat.factorization", "Nat.prod_factorization_pow_eq_self", "Nat.eq_of_factorization_eq"]
provenance:
  source_type: book
  ref: "Hardy and Wright, An Introduction to the Theory of Numbers（算术基本定理）"
---

# 动机

算术基本定理说，每个正整数都能而且只能以一种方式写成素数幂的乘积。Mathlib 用有限支撑
函数 `n.factorization : ℕ →₀ ℕ` 记录每个素数的指数；本条目把这个数据结构包装成两条
教材式结论。

# 直觉

`factorization p` 是素数 `p` 在 `n` 中出现的次数。把所有 `p ^ factorization p` 相乘，
就应重构 `n`；反过来，如果两个非零自然数的所有指数逐点相同，它们就是同一个数。

# 陈述（自然语言）

非零自然数等于其素因子幂的乘积；两个非零自然数若每个素因子的指数均相同，则两数相等。

# 陈述（Lean 对照）

- `prime_factorization_reconstructs` 给出从 `Finsupp` 指数表回到原数的乘积等式。
- `eq_of_prime_factorization_eq` 给出素因子指数表在非零自然数上的单射性。

# 思维脉络（thinking trace）

存在性采用重构形式，避免额外引入“素数列表只差排列”的表述。唯一性采用逐点指数相等，
因此使用者不必先证明两个 `Finsupp` 整体相等。

# 自然语言 ↔ Lean 映射

- “有限个非零指数” ↔ `Finsupp`，即 `ℕ →₀ ℕ`。
- “所有素因子幂的乘积” ↔ `n.factorization.prod (fun p e ↦ p ^ e)`。
- “每个素数的指数相同” ↔ `∀ p, m.factorization p = n.factorization p`。
- 两个证明均用 `exact`，表示目标与引用定理的类型完全一致，无需改写。

# 依赖（人话版）

`Mathlib.Data.Nat.Factorization.Basic` 定义自然数的有限素因子指数表，并证明其重构性与
非零自然数上的单射性。本条目依赖前一条整除主线作为课程顺序，而 Lean 证明直接复用
Mathlib 已完成的唯一分解基础设施。

# 应用与陷阱

`0` 没有通常意义下的有限素因子分解，所以两条定理都显式排除 `0`。指数函数对非素数
也有值（通常为零），故逐点相等的量词写在全部自然数上是安全且方便的。
