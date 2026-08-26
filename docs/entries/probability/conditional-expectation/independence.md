---
id: probability.conditional-expectation.independence
family: probability.conditional-expectation
variant: textbook
kind: theorem
state: verified
title: 独立时条件期望退化为期望
summary: 与条件信息独立的随机变量在条件化后仍只有常数期望
premises: [probability.conditional-expectation.definition, probability.independence.variables]
mathlib: [MeasureTheory.condExp_indep_eq, ProbabilityTheory.IndepFun]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 定理

若随机变量 `X` 所生成的 σ-代数与条件 σ-代数 `m` 独立，则

\[
  \mathbb E[X\mid m]=\mathbb E[X]\quad\text{a.e.}
\]

特别地，若随机变量 `X` 与 `Y` 独立，则给定 `Y` 的全部信息之后，`X` 的条件期望仍是常数
`E[X]`。独立性在这里准确表达“新信息没有改善对 `X` 的平均预测”。

# 证明思路

条件期望由条件 σ-代数可测集合上的积分刻画。对任意条件事件 `A`，独立性把 `X` 在 `A` 上的
积分分解为 `P(A)E[X]`，这恰好是常函数 `E[X]` 在 `A` 上的积分。由条件期望的 a.e. 唯一性即得
结论。随机变量版本把 `X`、`Y` 分别换成其生成 σ-代数后应用同一论证。

# Lean 对照

σ-代数版本直接复用 `MeasureTheory.condExp_indep_eq`。随机变量版本以
`ProbabilityTheory.IndepFun X Y μ` 作为 Pr1 独立性承载，并将条件信息写成
`MeasurableSpace.comap Y inferInstance`；`comap_measurable X` 给出 `X` 对自身生成信息的可测性。

# 边界

一般 Banach 空间值版本要求 `X` 对其生成 σ-代数强可测。由普通 `Measurable X` 推出这一点时，
值域采用第二可数 Borel 可测结构。随机变量版本置于概率测度下，从而自动满足条件 trim 的
σ-有限性。结论仍是 a.e. 等式；不可积时 Mathlib 的积分与条件期望都退化为零，本条目不把该
分支解释成有限期望存在。
