---
id: analysis.constants.e-irrational
kind: theorem
state: verified
title: "自然常数 e 的无理性"
premises: ["analysis.constants.e-definition", "analysis.series.taylor"]
mathlib: ["Real.exp_bound", "Real.sum_le_exp_of_nonneg", "Nat.factorial_dvd_factorial", "Nat.dvd_factorial", "Rat.cast_def"]
provenance:
  source_type: book
  ref: "数学分析 I：e 的无理性经典阶乘级数证明"
---

# 内容

自然常数 `e = exp 1` 不等于任何有理数。证明只使用指数级数的有限截断与
显式尾项估计，不依赖更强的超越性定理。

# 证明思路

反设 `e=q∈ℚ`，令 `n=q.den>0`，并记

`Sₙ=Σ_{k=0}^n 1/k!`。

由于每个 `k!`（`k≤n`）都整除 `n!`，所以 `n!Sₙ` 是整数；又因为 `n`
是 `q` 的分母，`n!q=n!e` 也是整数。因此

`N=n!(e-Sₙ)`

是整数。指数级数的下一项严格为正，故 `N>0`。另一方面，Mathlib 的指数
尾项估计给出

`e-Sₙ ≤ (n+2)/((n+1)!(n+1))`，

乘以 `n!` 后得到 `N≤(n+2)/(n+1)²<1`。不存在严格位于 `0` 与 `1`
之间的整数，矛盾。

# Lean 对照

- `factorial_mul_partial_sum_is_int`：`n!Sₙ` 为整数；
- `factorial_mul_rational_is_int`：`q.den!·q` 为整数；
- `exp_one_partial_sum_lt`：有限截断严格小于 `exp 1`；
- `factorial_mul_exp_one_sub_partial_sum_lt_one`：缩放后的尾项小于一；
- `e_irrational`：将四个局部事实组装成整数区间矛盾。

# 依赖与公理

库内依赖为 `e` 的定义接口；分析估计来自 `Real.exp_bound` 与
`Real.sum_le_exp_of_nonneg`，算术整除来自阶乘引理。公理依赖由注册审计结果记录。

# 陷阱

仅证明 `2<e<3` 或给出固定精度的小数估计不能排除分母任意大的有理数；关键是
根据假设中的分母选择阶乘公分母，并同时获得随该分母变化的尾项界。
