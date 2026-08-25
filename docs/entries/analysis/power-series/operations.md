---
id: analysis.power-series.operations
kind: theorem
state: verified
title: "幂级数的逐项代数、求导与积分"
premises: ["analysis.power-series.radius", "analysis.series.cauchy-product-absolute"]
mathlib: ["Summable.tsum_add", "hasDerivAt_tsum_of_isPreconnected", "Summable.of_norm_bounded", "Summable.sum_add_tsum_nat_add"]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

本条目给出幂级数的四类基本运算接口。

- 逐项加法：在两个原级数都绝对收敛的点，系数 `aₙ+bₙ` 所定义的和值等于两和值之和。
- 逐项乘法：乘积系数取 Cauchy 卷积，乘积级数的和值等于两和值之积。
- 逐项求导：若在开区间 `|y-c|<R` 上存在一个可和控制列，逐项支配全部单项导数，
  则和函数可导，导数系数为 `(n+1)aₙ₊₁`。
- 逐项积分：系数取 `0,a₀,a₁/2,a₂/3,…`，在原级数各项受到可和列一致控制时，
  新幂级数的导数就是原幂级数，因而给出中心处取零的原函数。

后两条把教材中“在收敛区间的任意内闭子区间上一致收敛”的关键条件显式写成
Weierstrass 控制列。这样接口既能直接用于由收敛半径得到的控制，也不会把端点行为误混入
开区间结论。

# 证明思路

加法使用两个绝对可和级数的 `tsum` 可加性。乘法把幂级数的 Cauchy 系数与两个加权项列
的 Cauchy 乘积对齐，再使用绝对收敛乘积定理。

求导时，把每个单项看作开球上的可导函数列。可和控制列给出导数级数的一致控制，原级数
在中心处只有常数项非零，因此满足一个基点收敛条件。光滑函数列定理随后允许交换求导与
无穷求和。最后删去为零的第零项，并将下标从 `n+1` 平移回 `n`。积分结论通过证明
`derivativeCoeffs (integralCoeffs a)=a` 化归为同一个求导定理。

# 公理依赖

核查得到依赖为命题外延、经典选择与商类型健全性。
