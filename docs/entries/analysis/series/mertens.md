---
id: analysis.series.mertens
kind: theorem
state: verified
title: "Mertens 级数乘积定理"
premises: ["analysis.series.cauchy-product-absolute", "analysis.series.conditional"]
mathlib: ["cauchy_product", "Metric.tendsto_atTop", "Finset.Nat.sum_antidiagonal_swap"]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

若 `Σ|aₙ|` 收敛，而 `b` 的自然顺序部分和趋于 `B`，则 Cauchy 乘积满足

\[
\sum_{n<N}\sum_{k=0}^{n}a_kb_{n-k}
\longrightarrow
\left(\sum_{n=0}^{\infty}a_n\right)B.
\]

`tendsto_sum_cauchyProduct_of_left_absolute` 给出左因子绝对收敛的形式；
`tendsto_sum_cauchyProduct_of_right_absolute` 通过反对角线交换给出右因子绝对收敛的形式。

这里刻意用自然顺序部分和的 `Tendsto` 表示普通收敛。Mathlib 的 `Summable` 是无条件可和；
若把条件收敛因子也写成 `Summable`，就会错误地把 Mertens 定理退化为双方绝对收敛。

# 证明思路

令 `A_N`、`B_N`、`C_N` 分别为两个原级数和 Cauchy 乘积的部分和。Mathlib 的直接
`cauchy_product` 估计证明 `A_N B_N-C_N→0`。另一方面 `A_N B_N` 趋于两极限之积，
两式相减即得 `C_N` 的极限。

# 公理依赖

核查得到依赖为命题外延、经典选择与商类型健全性。
