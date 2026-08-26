---
id: probability.expectation.definition
family: probability.expectation
variant: textbook
kind: definition
state: verified
title: 期望与可积性
summary: 以Bochner积分承载期望并说明有限期望的L1条件
premises: [probability.variable.definition, real-analysis.measure.dominated-convergence]
mathlib: [MeasureTheory.integral, MeasureTheory.Integrable, MeasureTheory.MemLp]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 动机与定义

期望是随机变量相对于概率测度的积分。正式承载直接使用 Bochner 积分 `∫ ω, X ω ∂μ`，有限
期望由 `Integrable X μ` 表示；它等价于 `X` 属于 `L¹`。

# 基本性质

可积随机变量的期望保持加法，也保持 a.e. 次序。概率测度下常随机变量的期望等于该常数。

# Lean 边界

Bochner 积分允许 Banach 空间值随机变量；单调性在本条目中只用于实值变量。Mathlib 把不可积
函数的 Bochner 积分约定为零，所以教材线性定理显式携带可积性，不能从裸积分符号推断有限期望。
