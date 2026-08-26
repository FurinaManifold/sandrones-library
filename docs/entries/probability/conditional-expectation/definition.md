---
id: probability.conditional-expectation.definition
family: probability.conditional-expectation
variant: textbook
kind: definition
state: verified
title: 条件期望的定义与刻画
summary: 以子σ代数可测性和集合积分恒等式刻画Banach空间值条件期望
premises: [probability.expectation.definition]
mathlib: [MeasureTheory.condExp, MeasureTheory.setIntegral_condExp]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 教材语义

设 `m₀` 是样本空间的环境 σ-代数，`m ≤ m₀` 表示我们当前掌握的信息。可积随机变量 `X` 关于
`m` 的条件期望，是一个 `m`-可测的可积函数，并且对每个 `m`-可测集合 `A` 都满足

\[
  \int_A \mathbb E[X\mid m],d\mu=\int_A X,d\mu.
\]

上述两个性质在几乎处处相等意义下唯一确定条件期望。形式化中允许 `X` 取值于实 Banach 空间，
所以实值和复值随机变量只是这一构造的特例。

# 正式承载

本库直接使用 `MeasureTheory.condExp` 和记号 `μ[X | m]`，不另建
`ConditionalExpectation` 结构或存在谓词。正常教材分支需要：

- `hm : m ≤ m₀`；
- `SigmaFinite (μ.trim hm)`；
- `Integrable X μ`；
- 值域为完备的实赋范向量空间。

在这些条件下，`stronglyMeasurable_condExp`、`integrable_condExp` 和
`setIntegral_condExp` 分别给出可测代表、可积性和集合积分刻画；
`ae_eq_condExp_of_forall_setIntegral_eq` 给出相应的 a.e. 唯一性。

# 基本性质

全空间取 `A=Ω` 得到全期望公式
`E[E[X|m]]=E[X]`。若 `X` 已经关于 `m` a.e. 强可测，则
`E[X|m]=X` a.e.；概率测度下常随机变量的条件期望仍等于该常数。这些结论是后续塔式性质、
独立性退化和鞅定义的共同入口。

# Lean 边界

Mathlib 把 `condExp` 定义成总函数。若 `m ≰ m₀`、trim 后的测度不是 σ-有限，或 `X` 不可积，
它退化为零。因此裸表达式 `μ[X | m]` 的存在不能被解读成教材条件全部自动成立；本条目的积分
定理显式保留正常分支的三个条件。类似地，“自身可测函数保持不变”使用 a.e. 等式，不把
`L¹` 对象错误升级为逐点相等。
