---
id: probability.distribution.pushforward
family: probability.distribution
variant: textbook
kind: definition
state: verified
title: 随机变量的分布与推前测度
summary: 以推前测度正式承载随机变量的分布并给出事件公式
premises: [probability.variable.definition, real-analysis.measure.def]
mathlib: [Measure.map]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 动机

很多概率问题只关心随机变量取值的概率，而不关心底层样本如何实现。分布把样本空间上的概率
沿随机变量推到状态空间上。

# 教材定义与正式承载

若 `X : Ω → E` 可测，`X` 在 `μ` 下的分布就是推前测度 `μ.map X`。Mathlib 的
`Measure.map` 与教材推前测度完全一致，因此不再定义同义的 `distribution` 包装。

# 展开与使用者

对可测集合 `B ⊆ E`，`distribution_apply` 给出
`μ.map X B = μ (X ⁻¹' B)`。`distribution_isProbabilityMeasure` 证明概率测度的推前仍是
概率测度，因而分布可以继续作为后续期望与独立性定理的概率测度输入。

# 边界

推前公式要求 `X` 可测且 `B` 可测。Mathlib 对不可 a.e. 可测的函数把 `Measure.map` 定义为
零测度；本课程不把这种退化值称作随机变量的分布。
