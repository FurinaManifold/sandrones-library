---
id: number-theory.elementary.pell-composition
family: number-theory.elementary
variant: brahmagupta
kind: definition
state: verified
title: Pell 解的 Brahmagupta 合成
summary: 两个同参数 Pell 解按显式坐标公式合成后仍是解
premises: [number-theory.elementary.pell-equation]
mathlib: []
provenance:
  source_type: book
  ref: "Ireland--Rosen, A Classical Introduction to Modern Number Theory, Section 17.5"
---

# 公式

若 `a=(x₁,y₁)`、`b=(x₂,y₂)`，定义

- 新的第一坐标为 `x₁x₂ + d y₁y₂`；
- 新的第二坐标为 `x₁y₂ + y₁x₂`。

# 为什么仍是解

直接展开可得

`X² - dY² = (x₁²-dy₁²)(x₂²-dy₂²) = 1·1 = 1`。

Lean 证明使用 `ring` 核验这个多项式恒等式，再代入两个输入解的方程。这个证明展示了合成律的
初等来源，不依赖 Mathlib 的打包群运算。
