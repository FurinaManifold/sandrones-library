---
id: probability.independence.events
family: probability.independence
variant: textbook
kind: definition
state: verified
title: 事件与σ代数的独立性
summary: 事件独立的概率乘法公式及其对称性
premises: [probability.space.definition]
mathlib: [ProbabilityTheory.IndepSet, ProbabilityTheory.Indep]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 教材定义与正式承载

可测事件 `A,B` 独立是指 `P(A∩B)=P(A)P(B)`；两个 σ-代数独立是指分别从其中选取事件时都
满足这一乘法公式。正式承载分别为 `IndepSet A B μ` 与 `Indep m₁ m₂ μ`。

# Lean 接口与版本说明

Mathlib 4.33 使用 `IndepSet` 表示两个事件的独立性。ROADMAP 中的早期名称 `IndepEvents`
已不对应当前公开 API，本库不为旧名称重造同义谓词。

# 基本性质

`independentEvents_iff` 给出教材乘法公式；`independentEvents_symm` 证明事件独立具有对称性。
事件本身仍由 `MeasurableSet` 承载。
