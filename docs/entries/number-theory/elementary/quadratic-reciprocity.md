---
id: number-theory.elementary.quadratic-reciprocity
kind: theorem
state: verified
title: "Legendre/Jacobi 二次互反律"
summary: 由互反律乘积式推导等式式、模 4 特化、平方剩余互换及奇合数 Jacobi 版本
premises: ["number-theory.elementary.quadratic-residues"]
mathlib: ["legendreSym.quadratic_reciprocity", "legendreSym.sq_one", "prime_ne_zero", "neg_one_pow_div_two_of_one_mod_four", "neg_one_pow_div_two_of_three_mod_four", "legendreSym.eq_zero_iff", "jacobiSym.quadratic_reciprocity"]
provenance:
  source_type: book
  ref: "Ireland & Rosen, A Classical Introduction to Modern Number Theory, Chapter 6"
---

# 定义

本条目沿用前条的 `IsQuadraticResidue`、`IsQuadraticNonresidue`、`legendreSym` 和 `jacobiSym`。
“二次互反律”指交换 Legendre 或 Jacobi 符号的分子与分母时，两边只相差一个由
参数模 `4` 类别决定的符号。

# 动机

直接判定“`q` 是否为模 `p` 的平方”可能很费时。二次互反律允许交换两个奇素数，
并且只需根据它们模 `4` 的剩余决定是否加负号。配合 `2` 和 `-1` 的补充律，
这会把大数的剩余判定递归化简。Jacobi 版则把同一算法推广到奇合数。

# 直觉

两个奇素数中，只有当两者都模 `4` 余 `3` 时，`(p-1)/2` 和 `(q-1)/2` 才同时为奇数，
互反律的符号才是 `-1`。其他情况指数为偶，交换前后不变号。Jacobi 符号是各素因子处
Legendre 符号的乘积，所以每对素因子的变号汇总后，仍得到同一个模 `4` 规律。

# 陈述（自然语言）

对不同奇素数 `p,q`，有

`(p/q)(q/p) = (-1)^((p/2)(q/2))`。

因此：

- 若至少一个素数模 `4` 余 `1`，交换它们时 Legendre 符号不变。
- 若两者均模 `4` 余 `3`，交换时符号变号。
- 前两条等价地描述了“`q` 模 `p` 是否为二次剩余”与反向问题的关系。
- 对任意奇自然数 `a,b`，Jacobi 符号满足完全相同的符号规律。

# 陈述（Lean 对照）

`legendre_quadratic_reciprocity_product`、`legendre_quadratic_reciprocity`、
`legendre_reciprocity_one_mod_four`、`legendre_reciprocity_three_mod_four`、
`quadraticResidue_reciprocity_one_mod_four`、
`quadraticResidue_reciprocity_three_mod_four`、`jacobi_quadratic_reciprocity`、
`jacobi_reciprocity_one_mod_four`、`jacobi_reciprocity_three_mod_four`。

# 思维脉络（thinking trace）

1. 将 Mathlib 经 Gauss 和有限域理论证明的 Legendre 乘积式作为唯一素数主入口。
2. 为得到教材常用的等式形式，在乘积式两边乘上 `(q/p)`；由于 `p ≠ q`，
   该 Legendre 符号非零，其平方为 `1`，因而可消去。
3. 将 `p % 4 = 1` 或 `3` 代入符号指数，推出不变号与变号两个分支。
4. 通过前一 Entry 的 Legendre `1/-1` 分类，把符号等式翻译成“剩余/非剩余”。
5. 对 Jacobi 符号引入一般奇数互反律，再独立从一般式化简出两个模 `4` 课程接口。

# 自然语言 ↔ Lean 映射

- “`p,q` 是素数” ↔ `[Fact p.Prime] [Fact q.Prime]`。
- “奇素数” ↔ 素数事实加 `p ≠ 2`。
- “不同素数的剩余类非零” ↔ `prime_ne_zero`。
- `calc` 把“乘上一、把一改成符号平方、重结合、代入乘积式”四步显式写出。
- `by_cases hpq : p = q` 分开符号为零的对角情形与可用互反律的不同素数情形。
- `rw [pow_mul, ...]` 先把乘积指数改成幂的幂，再分别用模 `4` 条件化简两层。

# 依赖（人话版）

直接依赖前一条中的二次剩余定义、Legendre 的剩余/非剩余分类和非零符号平方为一。
深层数学输入是 Mathlib 已证的 Legendre 乘积式与 Jacobi 一般奇数互反律；本条目再推导
教材常用的等式形式、模 `4` 分支和平方剩余语句。

# 应用与陷阱

- 乘积式要求 `p ≠ q`；当 `p=q` 时 Legendre 符号为零，不能使用“平方为一”消去。
- `p % 4 = 1` 或 `3` 自动排除 `p=2`，但 Lean 中仍需在分支内显式建立这个事实。
- 二次剩余版在使用 `legendre_eq_one_iff_quadraticResidue` 前，必须由
  `prime_ne_zero` 建立分子在另一素数模下非零。
- Jacobi 互反律只要求参数为奇数，不要求它们互素或为素数。
