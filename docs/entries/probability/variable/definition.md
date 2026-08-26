---
id: probability.variable.definition
family: probability.variable
variant: textbook
kind: definition
state: verified
title: 随机变量与可测性
summary: 随机变量作为样本空间到状态空间的可测函数
premises: [probability.space.definition, real-analysis.measure.measurable-function]
mathlib: [Measurable]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 动机

随机变量把每个样本结果变成一个可观察量。为了使“观测值落在某个集合中”的概率有定义，目标
可测集合的原像必须是样本空间中的事件。

# 教材定义与 Lean 承载

函数 `X : Ω → E` 是随机变量，当且仅当它可测。Mathlib 的 `Measurable X` 与这一语义完全
一致，因此直接作为正式承载，而不再包装一个只含函数和可测性证明的平行结构。

# 展开与基本性质

`randomVariable_iff_preimage` 给出原像刻画。常函数是随机变量；可测函数与随机变量复合仍是
随机变量。这是后续定义分布 `μ.map X` 的直接前置。

# 边界

本条目只讨论可测性，不默认随机变量可积，也不要求状态空间带线性、拓扑或度量结构。
