---
id: real-analysis.measure.product-measure
family: real-analysis.measure.product-measure
variant: generated
kind: theorem
state: verified
title: "乘积测度与矩形测度"
premises: ["real-analysis.measure.def"]
mathlib: ["MeasureTheory.Measure.prod_prod"]
provenance: {source_type: book, ref: "实分析：乘积测度"}
---

# 陈述与动机

给定 `(α, μ)` 与 `(β, ν)`，乘积测度 `μ.prod ν` 是乘积空间 `α × β` 上的测度，并满足

\[
(\mu\times\nu)(s\times t)=\mu(s)\nu(t).
\]

该矩形公式是二维测度的基本校准条件；后续 Tonelli/Fubini 定理把一般函数的积分还原
为沿两个坐标方向的迭代积分。

# Lean 对照与证明

`rectangle_measure` 使用 `Measure.prod` 和集合直积 `s ×ˢ t`。假设 `[SFinite ν]` 是
Mathlib 构造乘积积分所需的标准条件。底层 `Measure.prod_prod` 已从乘积测度构造证明
矩形公式，本条目固定教材层接口。值得注意的是，底层结论对任意集合 `s,t` 成立，
无需额外给出可测性。

# 公理依赖

由公理审计脚本读取 Lean 内核结果。
