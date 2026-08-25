---
id: analysis.power-series.definition
kind: definition
state: verified
title: "实幂级数的定义与收敛点集"
premises: ["analysis.series.basic"]
mathlib: ["Summable.of_norm", "Summable.tendsto_sum_tsum_nat", "summable_of_ne_finset_zero"]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

系数为 `aₙ`、中心为 `c` 的实幂级数在点 `x` 处写作

\[
\sum_{n=0}^{\infty}a_n(x-c)^n.
\]

本条目定义：

- 单项 `term a c x n`；
- 前 `N` 项部分和 `partialSum a c x N`；
- 自然顺序和 `HasSumAt` 与收敛谓词 `ConvergesAt`；
- 绝对收敛谓词 `AbsolutelyConvergesAt`；
- 收敛点集与绝对收敛点集；
- 绝对收敛区域上的 `tsum` 和函数 `sum`。

普通收敛刻意用自然顺序部分和表示，以便幂级数端点允许条件收敛；绝对收敛才使用
Mathlib 的 `Summable`。此外证明任意幂级数在中心绝对收敛，且中心处的和等于常数项 `a₀`。

# 与一般级数定义层的一致性

固定 `a,c,x` 后，幂级数只是一般项列 `term a c x : ℕ → ℝ`。三条具名桥逐层说明：

- `hasSumAt_iff_seriesHasSum`：幂级数自然部分和与 `SeriesHasSum` 定义完全相同；
- `convergesAt_iff_seriesConvergent`：两边都是存在某个自然部分和极限；
- `absolutelyConvergesAt_iff_seriesAbsolutelyConvergent`：通过一般级数已经验收的
  `seriesAbsolutelyConvergent_iff_summable_abs` 桥接当前 `Summable` 实现。

`absolutelyConvergesAt_imp_convergesAt` 现在真实经过一般级数教材定理
`seriesConvergent_of_seriesAbsolutelyConvergent`。这说明幂级数不是另起一套不相容的收敛概念。

# 边界

普通 `HasSumAt`／`ConvergesAt` 仍允许端点条件收敛，不能无条件改写为 Mathlib `HasSum`／
`Summable`。只有绝对收敛一侧才使用无条件求和后端；本窗不全面替换既有幂级数 API。

# 公理依赖

核查得到依赖为命题外延、经典选择与商类型健全性。
