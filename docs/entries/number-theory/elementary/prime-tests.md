---
id: number-theory.elementary.prime-tests
kind: theorem
state: verified
title: "平方根试除、素数测试与合数证书"
summary: 用平方根以内的有限试除刻画素数，并为布尔测试的真、假结果给出可核验规格
premises: ["number-theory.elementary.prime-factorization"]
mathlib: ["Nat.prime_def_le_sqrt", "Nat.not_prime_iff_exists_dvd_lt"]
provenance:
  source_type: book
  ref: "Hardy–Wright, An Introduction to the Theory of Numbers, Ch 1"
---

# 动机

“素数可判定”不能只停留在 Lean 拥有某个 `Decidable` 实例。初等数论真正使用的是有限
算法及其证书：只需尝试不超过平方根的除数；测试失败时，应当能给出一个非平凡真因子。

# 直觉

若 `n=ab` 是合数，则 `a,b` 不可能都大于 `√n`，否则乘积会大于 `n`。所以若从 `2`
到 `√n` 都没有因子，就不会遗漏任何合数分解。反过来，找到 `2≤d<n` 且 `d∣n`，就是
一个无需信任测试实现也能核验的合数证书。

# 陈述（自然语言）

- `n` 为素数，当且仅当 `n≥2` 且平方根以内没有非平凡因子。
- `primeTest n = true` 当且仅当上述试除判据成立。
- 对 `n≥2`，`primeTest n = false` 当且仅当存在非平凡真因子。
- `97` 的测试结果为真；`221` 的测试结果为假，且 `13∣221`。

# 陈述（Lean 对照）

`PassesTrialDivision`、`primeTest`、`prime_iff_passesTrialDivision`、
`primeTest_eq_true_iff`、`primeTest_eq_false_iff`、`primeTest_97`、`primeTest_221`。

# 思维脉络（thinking trace）

先用课程语言定义 `PassesTrialDivision`，明确写出下界、平方根界和不可整除条件。
`prime_iff_passesTrialDivision` 把它桥接到 `Nat.Prime`。布尔函数只负责计算；两个规格
定理分别解释真结果和假结果。最后用 `97` 与 `221` 展示实际运行，其中后者同时保留因子证书。

# 自然语言 ↔ Lean 映射

- “`d` 整除 `n`” ↔ `d ∣ n`。
- “检查到平方根” ↔ `d ≤ n.sqrt`。
- “非平凡真因子” ↔ `d ∣ n ∧ 2 ≤ d ∧ d < n`。
- “布尔测试通过” ↔ `primeTest n = true`。

# 依赖（人话版）

依赖整除、素数和算术基本定理所提供的因子理论。实现层使用
`Nat.prime_def_le_sqrt` 的平方根判据，以及 `Nat.not_prime_iff_exists_dvd_lt` 的合数证书。

# 应用与陷阱

- `primeTest n = false` 对 `n=0,1` 也成立，但“存在非平凡真因子”的等价需要 `n≥2`。
- 布尔值是计算结果；把它变成可复用数学事实必须经过规格定理。
- 试除无需一直检查到 `n-1`，平方根以后出现的因子必与此前某个因子配对。
