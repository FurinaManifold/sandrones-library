---
id: analysis.power-series.definition
kind: definition
state: verified
title: "实幂级数的定义与收敛点集"
premises: ["analysis.series.basic"]
mathlib: ["Summable.of_norm", "Summable.tendsto_sum_tsum_nat", "summable_of_ne_finset_zero"]
provenance:
  source_type: textbook
  ref: "数学分析 II：幂级数的定义与收敛点集"
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

# 公理依赖

核查得到依赖为命题外延、经典选择与商类型健全性。
