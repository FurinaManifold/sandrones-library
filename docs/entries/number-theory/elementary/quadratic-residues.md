---
id: number-theory.elementary.quadratic-residues
kind: theorem
state: verified
title: "二次剩余、Legendre/Jacobi 符号与 Gauss 引理"
summary: 从平方同余定义出发，建立 Legendre 分类、Euler 判别、Gauss 奇偶判别与 Jacobi 合数模接口
premises: ["number-theory.elementary.congruence", "number-theory.elementary.fermat-euler"]
mathlib: ["isSquare_iff_exists_sq", "legendreSym.eq_one_iff", "legendreSym.eq_neg_one_iff", "ZMod.euler_criterion", "ZMod.gauss_lemma", "neg_one_pow_eq_one_iff_even", "neg_one_pow_eq_neg_one_iff_odd", "jacobiSym.legendreSym.to_jacobiSym", "jacobiSym.mul_left", "jacobiSym.eq_one_or_neg_one", "jacobiSym.at_two", "χ₈"]
provenance:
  source_type: book
  ref: "Ireland & Rosen, A Classical Introduction to Modern Number Theory, Chapters 5-6"
---

# 定义

`IsQuadraticResidue n a` 表示存在 `x : ZMod n` 使 `x ^ 2 = a`。这一定义包含零；
`IsQuadraticNonresidue n a` 则额外要求 `a` 的剩余类非零，从而与 Legendre 符号的
`-1` 取值精确对应。

`gaussUpperHalfCount p a` 统计 `1 ≤ x ≤ p/2` 中，`a*x` 的模 `p` 标准代表元落在
上半区的个数。这是 Gauss 引理中决定符号的可计算量。

# 动机

直接搜索方程 `x² ≡ a (mod p)` 在大素数下并不方便。Legendre 符号将“是否有解”
压缩为 `0, 1, -1` 三个值；Euler 判别法把它化为一次模幂运算，Gauss 引理则把它
化为有限集合的奇偶性。Jacobi 符号进一步把这套乘法计算推广到合数分母。

# 直觉

将非零剩余类两两相反地配成 `x` 与 `-x`，平方映射正好把每对压到同一个二次剩余，
所以非零类中一半是剩余、一半是非剩余。Gauss 引理跟踪乘以 `a` 后有多少代表元需要
取负才能回到对称的下半区；每取一次负就贡献一个 `-1`，因而只有次数的奇偶性会保留下来。

# 陈述（自然语言）

- 零是二次剩余；二次剩余对乘法封闭。
- 对非零模 `p` 类，Legendre 符号为 `1` 当且仅当它是平方，为 `-1` 当且仅当它不是平方。
- Euler 判别法给出 `a^(p/2)=1` 的幂判据。
- Gauss 引理给出 `legendreSym p a = (-1)^N`，因而剩余恰对应 `N` 偶，非剩余恰对应 `N` 奇。
- 素数分母下 Jacobi 符号就是 Legendre 符号；互素整数的平方具有 Jacobi 符号 `1`。
- 逆命题在合数模下失败：`J(2|15)=1`，但 `2` 不是模 `15` 的平方。

# 陈述（Lean 对照）

`IsQuadraticResidue`、`IsQuadraticNonresidue`、`quadraticResidue_mul`、
`legendre_eq_one_iff_quadraticResidue`、
`legendre_eq_neg_one_iff_quadraticNonresidue`、
`quadraticResidue_iff_eulerCriterion`、`gaussUpperHalfCount`、
`legendre_eq_neg_one_pow_gaussUpperHalfCount`、
`quadraticResidue_iff_gaussUpperHalfCount_even`、
`quadraticNonresidue_iff_gaussUpperHalfCount_odd`、`jacobi_prime_denominator`、
`jacobi_square_of_coprime`、`jacobi_one_not_sufficient_for_quadraticResidue`。

# 思维脉络（thinking trace）

1. 先用存在见证元定义二次剩余，并直接用见证 `x*y` 证明乘法封闭。
2. 经 `quadraticResidue_iff_isSquare` 进入有限域底层，得到 Legendre 的 `1/-1` 分类和 Euler 判据。
3. 只把 Mathlib 的 Gauss 主引理作为深层入口；“剩余当且仅当计数为偶”由前述
   Legendre 分类和 `(-1)^N` 的奇偶性在本库中组装。
4. Jacobi 部分先连接素数分母，再用分子乘法性推出平方结论。
5. 最后用 `at_two` 计算 `J(2|15)`，并穷举 `ZMod 15` 的元素排除平方解。

# 自然语言 ↔ Lean 映射

- “存在 `x` 使 `x² ≡ a`” ↔ `∃ x : ZMod n, x ^ 2 = a`。
- “`p` 不整除 `a`” ↔ `(a : ZMod p) ≠ 0`。
- “越过半程的个数” ↔ `gaussUpperHalfCount p a`。
- “个数为偶/奇” ↔ `Even (...)` / `Odd (...)`。
- `rw` 用于把目标沿已证等价链逐段改写；`rcases` 拆出平方见证或 `±1` 分支。
- `fin_cases` 穷举有限类型 `ZMod 15`；每个分支仍由内核检查的 `decide` 关闭。

# 依赖（人话版）

依赖前置的同余、`ZMod` 剩余类环、素数模下的有限域结构和 Euler/Fermat 幂同余理论。
Mathlib 的 `IsSquare`、Legendre/Jacobi 符号和 Gauss 引理是验证过的底层实现；本条目负责将它们
组织成“定义 → 分类 → 幂判据 → 奇偶判据 → 合数警示”的课程链。

# 应用与陷阱

- Legendre 的 `1` 分类必须假设剩余类非零；零的符号是 `0`，但零仍是平方。
- Gauss 引理的计数区间是 `Ico 1 (p / 2).succ`，即自然数中的 `1 ≤ x ≤ p/2`。
- Jacobi 符号为 `-1` 可以证明非平方，但为 `1` 在合数分母下不能反推平方。
- `Fact p.Prime` 是 Mathlib 为类型类接口携带“`p` 为素数”的方式，不是新的数学假设。
