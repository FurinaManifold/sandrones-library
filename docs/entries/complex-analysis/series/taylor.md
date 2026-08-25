---
id: complex-analysis.series.taylor
kind: theorem
state: verified
title: "圆盘内 Taylor 展开与局部系数唯一性"
summary: 全纯函数在指定圆盘内等于以圆心为中心的导数系数 Taylor 级数，且局部幂级数系数唯一
premises: ["complex-analysis.holomorphic.definition", "complex-analysis.holomorphic.power-series", "complex-analysis.cauchy.derivatives"]
mathlib: ["Complex.hasSum_taylorSeries_on_ball", "HasFPowerSeriesAt.eq_formalMultilinearSeries", "FormalMultilinearSeries.ofScalars"]
provenance:
  source_type: book
  ref: "ahlfors-complex-analysis-1979"
---

# 动机

复分析中的核心结论是：圆盘上的全纯函数能在圆心展开为 Taylor 级数。本条目把本库的教材全纯定义、Cauchy 导数公式和幂级数接口连成一条明确的桥，并单独记录系数唯一性。

# 直觉

固定中心 `c` 后，第 `n` 个系数是 `f⁽ⁿ⁾(c)/n!`。只要 `f` 在整个开圆盘 `ball c R` 上全纯，这些项就在该圆盘的每一点求和到 `f`。Cauchy 公式还把同一个系数写成边界圆周积分；局部幂级数的唯一性保证不存在另一组不同系数表示同一函数。

# 陈述（自然语言）

若 `f` 在以 `c` 为中心、实半径 `R` 的开圆盘上符合 `HolomorphicOnTextbook`，则对每个 `z ∈ ball c R`，级数 `∑ₙ f⁽ⁿ⁾(c) (z-c)ⁿ / n!` 收敛且其和为 `f z`。这里保证的是整个给定圆盘内收敛，不声称 `R` 是精确或最大的收敛半径。若在正半径闭圆盘上全纯，则系数也等于相应 Cauchy 圆周积分除以 `2πi`。同一中心处表示同一函数的两组局部幂级数系数必然相同。

# 陈述（Lean 对照）

`taylorCoefficient` 定义导数除以阶乘的系数；`taylorExpansion` 使用本库 `complexPowerSeries`；`hasSum_taylorSeries_on_ball` 给出级数收敛；`taylorExpansion_eq_on_ball` 给出函数等式；`taylorCoefficient_eq_circleIntegral` 给出 Cauchy 系数公式；`powerSeriesCoefficients_unique` 给出局部系数唯一性。

# 思维脉络（thinking trace）

第一步使用开放集桥接定理，把 `HolomorphicOnTextbook f (ball c R)` 转成 Mathlib 的 `DifferentiableOn ℂ`，没有把 `AnalyticAt` 当成本库定义。第二步应用圆盘 Taylor 求和结论。第三步借助 `complexPowerSeries_eq_tsum` 接回本库幂级数接口。闭圆盘上的 Cauchy 高阶导数公式给出系数的积分表达。最后用一维形式多线性级数的唯一性比较任意两组局部系数。

# 自然语言 ↔ Lean 映射

“中心”对应参数 `c`；“给定收敛圆盘”对应 `Metric.ball c R`；“第 `n` 阶导数”对应 `iteratedDeriv n f c`；“除以 `n!`”对应 `(n.factorial : ℂ)⁻¹`；“级数收敛到”对应 `HasSum`；“在中心附近有幂级数表示”对应 `HasFPowerSeriesAt`；系数序列通过 `FormalMultilinearSeries.ofScalars ℂ a` 嵌入 Mathlib。

# 依赖（人话版）

本库 `Holomorphic` 提供教材定义到 Mathlib 可微性的显式桥；`PowerSeries` 提供 `complexPowerSeries` 及其显式 `tsum` 公式；`CauchyFormula` 提供高阶导数的圆周积分公式。Mathlib 的 `Complex.TaylorSeries` 完成圆盘内求和，`Analytic.Uniqueness` 完成局部幂级数系数唯一性。

# 应用与陷阱

开圆盘 Taylor 定理只要求在该开圆盘上全纯；圆周积分系数公式为了包含边界，使用闭圆盘上的更强前提和 `0 < R`。不要从结论反推 `R` 是最大收敛半径，函数可能延拓到更大圆盘。唯一性定理中的两组系数必须都表示同一个函数并使用同一个中心；仅在单个点取值相同远远不够。
