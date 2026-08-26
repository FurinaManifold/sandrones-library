---
id: probability.space.definition
family: probability.space
variant: textbook
kind: definition
state: verified
title: 概率空间与事件
summary: 概率测度的归一化条件、事件及其基本运算
premises: [real-analysis.measure.def]
mathlib: [IsProbabilityMeasure, MeasurableSet]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 动机

概率论把不确定结果组成样本空间，并把能够赋予概率的子集称为事件。测度论已经提供可测空间与
测度；概率空间只增加总质量为一的归一化条件。

# 教材定义与 Lean 承载

在可测空间 `Ω` 上取测度 `μ`。条件 `μ Ω = 1` 由 `IsProbabilityMeasure μ` 正式承载；事件
直接由 `MeasurableSet A` 承载。本库不复制概率空间或事件结构，因为这些接口与教材语义一致。

# 基本性质

空集、补集、有限交和有限并保持可测。概率测度满足 `μ univ = 1`、`μ A ≤ 1`，并对可测事件
满足 `μ Aᶜ = 1 - μ A`。

# 边界

概率值使用扩展非负实数 `ℝ≥0∞`；后续在需要普通实数概率时再显式使用 `Measure.real`。本条目
不引入随机变量、分布或独立性。
