---
id: analysis.series.abel-cauchy-product
kind: theorem
state: verified
title: "Abel 的 Cauchy 乘积定理"
premises: ["analysis.series.mertens"]
mathlib: ["Real.tendsto_tsum_powerSeries_nhdsWithin_lt", "summable_powerSeries_of_norm_lt_one", "tendsto_nhds_unique"]
provenance:
  source_type: textbook
  ref: "数学分析 II：Abel 的级数乘积定理"
---

# 内容

设 `Σaₙ=A`、`Σbₙ=B` 都按自然顺序收敛，并设它们的 Cauchy 乘积

\[
c_n=\sum_{k=0}^{n}a_kb_{n-k}
\]

也按自然顺序收敛到 `C`。则

\[
C=AB.
\]

与 Mertens 定理不同，这里不要求任一原级数绝对收敛，但必须额外假设乘积级数本身收敛。

# 证明思路

当 `|x|<1` 时，`Σaₙxⁿ` 与 `Σbₙxⁿ` 都绝对收敛，因此绝对收敛 Cauchy 乘积公式给出

\[
\sum c_nx^n=\left(\sum a_nx^n\right)\left(\sum b_nx^n\right).
\]

令 `x→1⁻`。Abel 极限定理说明等式两侧分别趋于 `C` 与 `AB`，极限唯一性遂给出结论。
代码中的 `cauchyProduct_mul_pow` 负责指数卷积恒等式，`tsum_cauchyProduct_mul_pow`
负责单位圆内的绝对收敛乘法。

# 公理依赖

核查得到依赖为命题外延、经典选择与商类型健全性。
