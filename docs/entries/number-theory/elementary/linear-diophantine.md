---
id: number-theory.elementary.linear-diophantine
kind: theorem
state: verified
title: "二元一次不定方程的 gcd 可解判据"
summary: 方程 ax+by=c 有整数解当且仅当 gcd(a,b) 整除 c，并由扩展 Euclid 系数构造解
premises: ["number-theory.elementary.divisibility"]
mathlib: ["Int.gcd_eq_gcd_ab", "Int.gcd_dvd_left", "Int.gcd_dvd_right"]
provenance:
  source_type: book
  ref: "Niven–Zuckerman–Montgomery, An Introduction to the Theory of Numbers, Ch 1"
---

# 动机

整数方程 `ax+by=c` 是最基本的不定方程。关键问题不是在有理数中解一次线性方程，
而是判断何时能同时让 `x,y` 为整数，并在可解时构造它们。

# 直觉

`gcd(a,b)` 同时整除 `a` 和 `b`，所以它必然整除任何线性组合 `ax+by`；这是可解的
必要条件。扩展 Euclid 算法给出 `aA+bB=gcd(a,b)`，若 `c=gcd(a,b)·k`，把系数同时
乘以 `k` 就得到 `a(Ak)+b(Bk)=c`，所以条件也充分。

# 陈述（自然语言）

- `a x+b y=gcd(a,b)·k` 总有显式整数解。
- `a x+b y=c` 有整数解，当且仅当 `gcd(a,b)∣c`。
- `a,b` 互素，当且仅当每个整数都是它们的整数线性组合。

# 陈述（Lean 对照）

`LinearDiophantineSolvable`、`linearDiophantine_of_gcd_mul`、
`linearDiophantine_iff_gcd_dvd`、`coprime_iff_linearDiophantine_all`。

# 思维脉络（thinking trace）

先把扩展 Euclid 的系数 `Int.gcdA`、`Int.gcdB` 乘上任意 `k`，得到充分性所需的构造
元件。主判据的正向只用 gcd 分别整除 `a,b`，反向把整除证书展开成 `c=gcd·k` 后调用
前一元件。最后取 `c=1`，得到互素与“表示所有整数”的等价。

# 自然语言 ↔ Lean 映射

- “有整数解” ↔ `LinearDiophantineSolvable a b c`。
- “扩展 Euclid 系数” ↔ `Int.gcdA a b`、`Int.gcdB a b`。
- “最大公因数” ↔ `Int.gcd a b`，其值为自然数，在线性组合中强制转换到 `ℤ`。

# 依赖（人话版）

依赖 gcd、Bézout 恒等式和整除的加法、乘法封闭性。实现层用
`Int.gcd_eq_gcd_ab` 给出可计算系数，并用 `Int.gcd_dvd_left/right` 证明必要性。

# 应用与陷阱

- `Int.gcd a b` 返回非负自然数，即使 `a,b` 为负；在线性组合中要写成整数强制转换。
- 判据只回答是否有解；所有解的参数化还需处理齐次方程。
- `a=b=0` 也被统一覆盖：此时 gcd 为 `0`，只有 `c=0` 可解。
