---
id: number-theory.elementary.infinite-primes
kind: theorem
state: verified
title: "Euclid 定理：素数有无穷多个"
summary: 用 n!+1 的素因子构造严格大于任意给定界的素数，并推出素数集合无限
premises: ["number-theory.elementary.prime-tests"]
mathlib: ["Nat.minFac_prime", "Nat.minFac_dvd", "Nat.Prime.dvd_factorial", "Set.infinite_of_not_bddAbove"]
provenance:
  source_type: book
  ref: "Euclid, Elements, Book IX, Proposition 20"
---

# 动机

素数不是一张可以列完的有限表。Euclid 的证明更强：给定任何界 `n`，都能从
`n!+1` 中抽取一个严格超过 `n` 的新素数。

# 直觉

取 `p` 为 `n!+1` 的最小素因子。若 `p≤n`，素数 `p` 会整除 `n!`；但它又整除
`n!+1`，因而整除两者之差 `1`，矛盾。所以 `p>n`。这把“不能列完素数”加强为
“任意界以外都有素数”。

# 陈述（自然语言）

- 对每个自然数 `n`，`n!+1` 有一个严格大于 `n` 的素因子。
- 自然数中的素数集合是无限集。

# 陈述（Lean 对照）

- `euclid_trialDivision_above`、`infinitely_many_trialDivision_primes`：课程主签名，使用
  `PassesTrialDivision` 陈述素性。
- `euclid_prime_above`、`infinitely_many_primes`：保留给既有调用者的 `Nat.Prime` 签名。

# 思维脉络（thinking trace）

底层证明先证明 `n!+1≠1`，因此其最小因子确实为 Mathlib 素数。再假设该素因子不超过 `n`，借助
素数整除阶乘的判据得到它整除 `n!`，由整除加法推出它整除 `1`。严格超界结论完成后，
经 `prime_iff_passesTrialDivision` 把证书拉回教材试除判据。若试除素数集合有上界，只需在这个
上界处再次应用教材构造便立即矛盾。

# 自然语言 ↔ Lean 映射

- `n!` ↔ `n.factorial`。
- “最小素因子” ↔ `(n.factorial + 1).minFac`。
- “集合没有上界” ↔ `¬ BddAbove {p : ℕ | PassesTrialDivision p}`。
- “试除素数集合无限” ↔ `Set.Infinite {p : ℕ | PassesTrialDivision p}`。

# 依赖（人话版）

使用最小素因子为素数且整除原数、素数整除阶乘当且仅当它不超过阶乘指标，以及
有限集合必有上界这一序理论事实。

# 应用与陷阱

- `n!+1` 自己未必是素数；证明只取它的某个素因子。
- 用阶乘而不是前若干素数的乘积，可直接保证每个 `p≤n` 都整除 `n!`。
- 本定理说明存在任意大的素数，不提供素数间隔的有效上界。
