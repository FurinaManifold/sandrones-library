---
id: probability.conditional-expectation.tower
family: probability.conditional-expectation
variant: textbook
kind: theorem
state: verified
title: 条件期望的塔式性质
summary: 沿嵌套σ代数重复条件化等于直接向较粗信息条件化
premises: [probability.conditional-expectation.definition]
mathlib: [MeasureTheory.condExp_condExp_of_le]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 定理

设 `m₁ ≤ m₂ ≤ m₀`。对 Banach 空间值随机变量 `X`，有

\[
  \mathbb E[\mathbb E[X\mid m_2]\mid m_1]
  =\mathbb E[X\mid m_1]
  \quad\text{a.e.}
\]

较大的 σ-代数 `m₂` 含有更多信息；已经把 `X` 压缩为 `m₂` 所能观察的部分后，再忘掉信息直到
只剩 `m₁`，与一开始就只保留 `m₁` 信息没有区别。

# 证明思路

内层条件期望可积且关于 `m₂` 可测。对任意 `m₁`-可测集合 `A`，由 `m₁ ≤ m₂` 可知 `A` 也
`m₂`-可测；两次使用条件期望的集合积分刻画，嵌套条件期望和直接条件期望在 `A` 上具有相同积分。
条件期望的 a.e. 唯一性遂给出结论。

# Lean 对照与边界

正式证明复用 `MeasureTheory.condExp_condExp_of_le`。只需假设外层给出的
`μ.trim hm₂` σ-有限；Mathlib 的证明会在较粗 trim 不是 σ-有限或 `X` 不可积时按 `condExp` 的
零退化约定分支处理。结论必须保持为 a.e. 等式，不能提升成逐点函数相等。
