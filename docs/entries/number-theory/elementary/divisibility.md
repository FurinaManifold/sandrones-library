---
id: number-theory.elementary.divisibility
kind: theorem
state: verified
title: "带余除法、最大公因数与 Bézout 等式"
premises: []
mathlib: ["Nat.mod_add_div", "Nat.mod_lt", "Nat.dvd_gcd_iff", "Nat.gcd_eq_gcd_ab", "Int.gcd_dvd_iff", "Nat.Prime.dvd_mul", "Nat.exists_prime_and_dvd"]
provenance:
  source_type: book
  ref: "hardy-wright-number-theory-2008"
---

# 动机

整除理论的核心不是孤立地计算商和余数，而是把三种描述连接起来：Euclidean 除法给出
算法，最大公因数汇总共同的整除信息，Bézout 等式则把最大公因数写成整数线性组合。
这条链直接导出互素判别和 Euclid 引理。

# 直觉

- `m = qn + r, 0 ≤ r < n` 说明不断取余会下降，因此 Euclidean 算法终止。
- `d ∣ gcd(m,n) ↔ d ∣ m ∧ d ∣ n` 表明 `gcd` 确实代表全部公因子。
- Bézout 等式需要整数系数，因为减法在 Euclidean 算法的回代中不可避免。
- 当 `gcd(m,n)=1` 时，Bézout 等式恰好成为 `ma+nb=1`。

# 陈述（自然语言）

本条目证明带余除法、最大公因数的整除刻画、Bézout 等式、互素的整数线性组合判别、
Euclid 引理，以及每个大于一的自然数都有素因子。

# 陈述（Lean 对照）

- `euclidean_division`：显式产生商 `m / n` 与余数 `m % n`。
- `dvd_gcd_iff`：一个数整除最大公因数当且仅当它整除两个输入。
- `bezout_identity`：隐藏具体系数算法，只公开两个整数系数的存在性。
- `coprime_iff_exists_int_linear_combination`：互素与线性组合等于一等价。
- `prime_dvd_mul_iff`：素数整除乘积的二择一结论。
- `exists_prime_dvd_of_one_lt`：大于一的自然数存在素因子。

# 思维脉络（thinking trace）

带余除法直接选取 Mathlib 已定义的商和余数。Bézout 正向使用扩展 Euclidean 算法算出的
`gcdA`、`gcdB`，但不把这两个实现细节放进定理陈述。互素判别的反向先由给定线性组合
推出整数最大公因数整除 `1`，再回到自然数中得到最大公因数等于 `1`。

# 自然语言 ↔ Lean 映射

- “取商和余数” ↔ `refine ⟨m / n, m % n, ...⟩`。
- “余数小于除数” ↔ `Nat.mod_lt m hn`。
- “交换加法和乘法的书写顺序” ↔ `simpa [mul_comm, add_comm]`。
- “取出存在的系数” ↔ `obtain ⟨a, b, hab⟩ := ...`。
- “把存在量和假设拆开” ↔ `rintro ⟨a, b, hab⟩`。
- “按等价命题改写目标” ↔ `rw [Nat.coprime_iff_gcd_eq_one]`。

# 依赖（人话版）

`Mathlib.Data.Int.GCD` 提供扩展 Euclidean 算法和整数最大公因数；
`Mathlib.Data.Nat.GCD.Prime` 提供自然数最大公因数、互素及素数整除乘积的基础接口。

# 应用与陷阱

自然数版本的 Bézout 等式不能把两个系数都限制为自然数。`n = 0` 时“余数小于 `n`”
也不成立，所以带余除法显式要求 `0 < n`。
