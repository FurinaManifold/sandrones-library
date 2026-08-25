---
id: analysis.series.cauchy-product-absolute
kind: theorem
state: verified
title: "绝对收敛级数的 Cauchy 乘积"
premises: ["analysis.series.absolute", "analysis.series.cauchy-product-definition"]
mathlib: ["summable_norm_sum_mul_range_of_summable_norm", "hasSum_sum_range_mul_of_summable_norm"]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

设 `a` 与 `b` 都绝对收敛，并令

\[
c_n=\sum_{k=0}^{n}a_kb_{n-k}.
\]

`cauchyProduct_summable_absolute` 证明 `Σ|cₙ|` 收敛；
`hasSum_cauchyProduct_of_absolute` 进一步证明

\[
\sum_{n=0}^{\infty}c_n=
\left(\sum_{n=0}^{\infty}a_n\right)
\left(\sum_{n=0}^{\infty}b_n\right).
\]

`tsum_cauchyProduct_of_absolute` 是同一结论的 `tsum` 等式接口，供幂级数乘法直接使用。

# 公理依赖

核查得到依赖为命题外延、经典选择与商类型健全性。
