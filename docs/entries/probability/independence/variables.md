---
id: probability.independence.variables
family: probability.independence
variant: textbook
kind: definition
state: verified
title: 随机变量的独立性
summary: 独立随机变量的事件原像刻画、可测变换与乘积期望
premises: [probability.variable.definition, probability.independence.events, probability.expectation.definition]
mathlib: [ProbabilityTheory.IndepFun, ProbabilityTheory.iIndepFun]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 教材定义与正式承载

两个随机变量独立，是指它们生成的 σ-代数独立。Mathlib 的 `IndepFun X Y μ` 与该语义一致，
并用 `X ⟂ᵢ[μ] Y` 表示；一族随机变量的联合独立性由 `iIndepFun` 承载。

# 展开与稳定性

独立性等价于任意两个可测目标事件的原像满足概率乘法公式。分别施加可测函数不会破坏独立性，
因为新变量生成的 σ-代数不会比原变量更大。

# 期望应用与边界

两个独立且可积的实值随机变量，其乘积仍可积，且 `E[XY]=E[X]E[Y]`。显式可积条件避免把
Mathlib 对不可积 Bochner 积分取零的全定义约定误读为有限期望结论。
