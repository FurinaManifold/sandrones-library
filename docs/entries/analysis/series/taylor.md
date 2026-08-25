---
id: analysis.series.taylor
kind: theorem
state: verified
title: "完整 Taylor 展开"
premises: ["analysis.mvt.taylor", "analysis.power-series.operations"]
mathlib: ["taylor_mean_remainder_lagrange_iteratedDeriv", "iteratedFDerivWithin_eq_iteratedFDeriv", "NormedSpace.expSeries_div_hasSum_exp", "Real.hasSum_sin", "Real.hasSum_cos", "Real.abs_iteratedDeriv_sin_le_one", "Real.abs_iteratedDeriv_cos_le_one"]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

本条目同时覆盖有限阶 Taylor 公式和无穷 Taylor 级数，而不是只列出低阶近似。

对任意函数 `f`、中心 `c` 和阶数 `n`，定义

`Pₙ(x)=Σ_{k=0}^n f⁽ᵏ⁾(c)(x-c)ᵏ/k!`。

若 `f` 具有连续的 `n+1` 阶导数，则存在位于 `c` 与 `x` 之间的 `ξ`，使

`f(x)=Pₙ(x)+f⁽ⁿ⁺¹⁾(ξ)(x-c)ⁿ⁺¹/(n+1)!`。

若闭区间上 `|f⁽ⁿ⁺¹⁾|≤M`，还得到统一截断误差界

`|f(x)-Pₙ(x)|≤M|x-c|ⁿ⁺¹/(n+1)!`。

对三个基本初等函数，文件给出在每个实数处成立的完整无穷展开：

- `exp x = Σ xⁿ/n!`；
- `cos x = Σ (-1)ⁿx²ⁿ/(2n)!`；
- `sin x = Σ (-1)ⁿx²ⁿ⁺¹/(2n+1)!`。

同时证明任意阶截断误差：正弦和余弦由 `|f⁽ⁿ⁺¹⁾|≤1` 控制，指数函数由
`exp |x|` 控制。指数函数另有任意展开中心的 Lagrange 精确余项公式。

# 证明思路

先用无序区间的唯一可微性，把 Mathlib 的区间内迭代导数转换为全局迭代导数，因而将
`taylorWithinEval` 对齐到教材中的有限和。Lagrange 余项随后直接给出精确公式；取绝对值并
使用区间上的导数界得到统一估计。

无穷展开使用指数级数以及实正弦、余弦级数的全局 `HasSum` 结果，并保留 `HasSum` 与
`tsum` 等式两种接口，方便后续极限、积分和特殊值计算调用。

# 公理依赖

核查得到依赖为命题外延、经典选择与商类型健全性。
