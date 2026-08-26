---
id: probability.moments.variance
family: probability.moments
variant: textbook
kind: definition
state: verified
title: 矩、方差与协方差
summary: 二阶矩条件下的方差协方差公式及扩展方差边界
premises: [probability.expectation.definition]
mathlib: [ProbabilityTheory.moment, ProbabilityTheory.variance, ProbabilityTheory.evariance, ProbabilityTheory.covariance]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 教材定义与正式承载

矩和中心矩是幂函数的期望；方差是二阶中心矩，协方差衡量两个实值随机变量的共同偏离。以上概念
直接使用 Mathlib 的 `moment`、`centralMoment`、`evariance`、`variance` 和 `covariance`。

# 二阶矩公式

在 `MemLp X 2 μ` 下，方差满足 `Var X = E[X²] - (E X)²`；两个 `L²` 随机变量的协方差满足
`Cov(X,Y)=E[XY]-E[X]E[Y]`。`L²` 条件同时保证公式中的各项有限且具有教材含义。

# 关键边界

`evariance` 取值于 `ℝ≥0∞`，能够诚实表示无限方差；普通 `variance` 是其 `toReal`，在不属于
`L²` 时反而取零。因此无 `L²` 假设的 `variance = 0` 不能解释成随机变量 a.e. 为常数。
