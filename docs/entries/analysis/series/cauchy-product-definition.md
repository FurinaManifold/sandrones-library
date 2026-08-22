---
id: analysis.series.cauchy-product-definition
kind: definition
state: verified
title: "Cauchy 乘积的定义与有限三角恒等式"
premises: ["analysis.series.basic"]
mathlib: ["Finset.Nat.sum_antidiagonal_eq_sum_range_succ", "Finset.sum_range_diag_flip"]
provenance:
  source_type: textbook
  ref: "数学分析 II：级数的 Cauchy 乘积"
---

# 内容

两个实数项级数 `a` 与 `b` 的 Cauchy 乘积系数定义为

\[
c_n=\sum_{k=0}^{n}a_kb_{n-k}.
\]

`cauchyProduct_eq_antidiagonal` 说明这正是沿 `i+j=n` 的有限反对角线求和。
`sum_cauchyProduct_eq_triangle` 进一步给出前 `N` 个乘积系数的教材恒等式

\[
\sum_{n<N}c_n=\sum_{i<N}a_i\sum_{j<N-i}b_j,
\]

即对有限三角区域 `i+j<N` 求和。它是证明绝对收敛乘积与 Mertens 定理的代数基础。

# 公理依赖

有限和由 Mathlib 的 `Finset` 实现；核查得到依赖为命题外延、经典选择与商类型健全性。
