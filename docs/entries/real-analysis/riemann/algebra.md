---
id: real-analysis.riemann.algebra
kind: theorem
state: verified
title: "连续函数 Riemann 积分的代数与序性质"
premises: ["real-analysis.riemann.cont-integrable", "real-analysis.riemann.eq-lebesgue"]
mathlib: ["intervalIntegral.integral_add", "intervalIntegral.integral_sub", "intervalIntegral.integral_const_mul", "intervalIntegral.integral_nonneg", "intervalIntegral.integral_mono_on", "intervalIntegral.abs_integral_le_integral_abs", "intervalIntegral.integral_add_adjacent_intervals"]
provenance:
  source_type: book
  ref: "数学分析 II：Riemann 积分的基本性质"
---

# 内容

设 `a<b`。对闭区间 `[a,b]` 上连续的实函数，本条目证明教材中最基本的
Riemann 积分运算规则：常值函数公式、加减与数乘线性、非负性、单调性、
绝对值估计，以及相邻区间上的可加性。

# 证明思路

本库已经从 Darboux 上下和出发证明：连续函数的 `riemannIntegral` 等于同一区间
上的 Lebesgue 区间积分。因此每个证明都采用同一条透明的推理链：

1. 用连续函数 Riemann 可积定理处理可积性；
2. 用 `riemannIntegral_eq_interval` 把自建积分值改写成区间积分；
3. 在区间积分侧使用线性、序或区间可加定理；
4. 等式中的其余积分值同样经桥梁识别为 `riemannIntegral`。

这避免了重复证明已经由等值定理统一蕴含的 Darboux 和运算。

# Lean 对照

- `riemannIntegrable_const_lt`：常值函数可积；
- `riemannIntegral_const`：`∫ₐᵇ c = c(b-a)`；
- `riemannIntegral_add`、`riemannIntegral_sub`、`riemannIntegral_const_mul`：线性；
- `riemannIntegral_nonneg`、`riemannIntegral_mono`：序性质；
- `abs_riemannIntegral_le_riemannIntegral_abs`：`|∫f|≤∫|f|`；
- `riemannIntegral_add_adjacent`：`∫ₐᵇf+∫ᵦᶜf=∫ₐᶜf`。

# 依赖与边界

关键库内依赖是连续函数可积和两种积分值相等。Mathlib 没有提供这里的 Riemann
积分定义；列出的 `intervalIntegral` 接口只在等值桥梁之后承担计算。

本批次刻意陈述为 `a<b` 且函数连续。若要推广到任意有界 Riemann 可积函数，需先把
积分值等同定理从连续函数推广到 Lebesgue 判据给出的“有界且几乎处处连续”范围。

# 公理依赖

由注册审计脚本直接读取 Lean 的 `#print axioms` 结果。
