---
id: real-analysis.riemann.eq-lebesgue-general
kind: theorem
state: verified
title: "任意 Riemann 可积函数的积分值桥梁"
premises: ["real-analysis.riemann.def", "real-analysis.riemann.lebesgue-criterion"]
mathlib: ["Measure.integrableOn_of_bounded", "integral_indicator", "integral_mono", "csInf_le", "le_csSup"]
provenance:
  source_type: book
  ref: "Lebesgue criterion and the equivalence of Riemann and Lebesgue integrals"
---

# 内容

设 `a<b`，函数 `f` 在闭区间 `[a,b]` 上有界，并且其 Darboux 上下和之差能够
任意小。本条目证明，本库以所有 Darboux 下和的上确界定义的 `riemannIntegral`
等于 Mathlib 在半开区间 `Ioc a b` 上给出的 Lebesgue 积分。

这把原来仅适用于连续函数的积分值桥梁推广到了全部标准 Riemann 可积函数。库中
早期的 `RiemannIntegrable` 只编码上下和逼近条件，因此定理使用同时记录有界性的
`RiemannIntegrableWithBound`，这正是当前库的标准教材接口。

# 证明思路

证明先处理一个容易被连续情形掩盖的技术点：一般 Riemann 可积函数未必处处连续，
所以不能直接调用连续函数的 Lebesgue 可积性。Lebesgue 判据说明它在闭区间上几乎
处处连续。把所有不连续点装入一个可测零测集 `N` 后，`f` 在 `Icc a b \ N` 上连续，
因而在该集合的限制测度下几乎强可测。删去零测集不改变限制测度，再结合区间有限
测度和 `f` 的全局界，即得 `f` 在 `Ioc a b` 上 Lebesgue 可积。

随后固定任意 Darboux 分划：

1. 在每个小区间上取 `f` 的下确界，组成下阶梯函数 `sP`；
2. 在每个小区间上取 `f` 的上确界，组成上阶梯函数 `uP`；
3. 有界性保证这些上下确界合法，并逐点得到 `sP ≤ f ≤ uP`；
4. 阶梯函数积分公式给出 `∫sP = lowerSum f P` 和 `∫uP = upperSum f P`；
5. 积分保序得到 `lowerSum f P ≤ ∫f ≤ upperSum f P`。

对左侧所有下和取上确界得到 `riemannIntegral ≤ ∫f`。反方向选取上下和间隙小于
任意正数 `ε` 的分划，再利用上述夹逼，最后令 `ε` 任意小即可。

# Lean 对照

主定理为
`riemannIntegral_eq_interval_of_riemannIntegrableWithBound`。其前提
`RiemannIntegrableWithBound f a b` 同时提供闭区间有界性和 Darboux 可积性。

文件中的三个证明层次分别对应：

- `integrableOn_Ioc_of_riemannIntegrableWithBound`：由 Lebesgue 判据推出 Lebesgue 可积；
- `lowerSum_le_integral_of_riemannIntegrableWithBound`：任意下和不超过区间积分；
- `integral_le_upperSum_of_riemannIntegrableWithBound`：区间积分不超过任意上和。

# 边界与用途

- 主定理仍要求 `a<b`，因为本库的 Darboux 分划要求严格递增，退化区间没有这种分划。
- 结论覆盖跳跃函数等不连续但 Riemann 可积的函数，不再要求处处连续。
- 后续可用这座桥把一般 Riemann 可积函数的线性、序性质和区间可加性转到 Lebesgue
  积分侧证明，而不必重复展开 Darboux 和。

# 公理依赖

由注册审计脚本从主定理的 `#print axioms` 输出更新。
