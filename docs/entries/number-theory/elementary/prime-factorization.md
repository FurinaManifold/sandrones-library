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

算术基本定理说，每个正整数都能而且只能以一种方式写成素数幂的乘积。本库先把“`p` 出现
多少次”定义为满足 `p^k∣n` 的最大有界指数；Mathlib 的有限支撑函数 `n.factorization`
只作为高效数据结构和证明后端。

# 直觉

`factorization p` 是素数 `p` 在 `n` 中出现的次数。把所有 `p ^ factorization p` 相乘，
就应重构 `n`；反过来，如果两个非零自然数的所有指数逐点相同，它们就是同一个数。

# 陈述（自然语言）

非零自然数等于其素因子幂的乘积；两个非零自然数若每个素因子的指数均相同，则两数相等。

# 陈述（Lean 对照）

- `primeMultiplicity n p`：在 `k≤n` 中取满足 `p^k∣n` 的最大指数。
- `primeMultiplicity_eq_factorization`：对素数 `p` 与非零 `n`，教材定义等于
  `n.factorization p`。
- `primeMultiplicity_zero`：明确记录本库在 `n=0` 时取值为零的约定。
- `eq_of_primeMultiplicity_eq`：全部素数的教材重数相同即可推出两个非零自然数相等。
- `prime_factorization_reconstructs` 给出从 `Finsupp` 指数表回到原数的乘积等式。
- `eq_of_prime_factorization_eq` 给出素因子指数表在非零自然数上的单射性。

# 思维脉络（thinking trace）

有界最大值定义使指数语义可以直接展开为幂整除。桥定理利用素数幂整除判据证明它与
factorization 指数相同；唯一性再经此桥复用 Mathlib 的有限支撑重构。

# 自然语言 ↔ Lean 映射

- “最大幂次” ↔ `Nat.findGreatest (fun k ↦ p ^ k ∣ n) n`。
- “有限个非零指数” ↔ Mathlib 后端 `Finsupp`，即 `ℕ →₀ ℕ`。
- “所有素因子幂的乘积” ↔ `n.factorization.prod (fun p e ↦ p ^ e)`。
- “每个素数的指数相同” ↔ `∀ p, m.factorization p = n.factorization p`。
- 两个证明均用 `exact`，表示目标与引用定理的类型完全一致，无需改写。

# 依赖（人话版）

`Mathlib.Data.Nat.Factorization.Basic` 定义自然数的有限素因子指数表，并证明其重构性与
非零自然数上的单射性。本条目依赖前一条整除主线作为课程顺序，而 Lean 证明直接复用
Mathlib 已完成的唯一分解基础设施。

# 应用与陷阱

`0` 被每个正幂整除，若不加边界就没有有限最大指数。本库把搜索限制在 `k≤n`，从而约定
`primeMultiplicity 0 p = 0`；桥和唯一分解定理仍要求 `n≠0`。非素数底数不参与桥和唯一性
假设，不能把其返回值解释为素因子指数。
