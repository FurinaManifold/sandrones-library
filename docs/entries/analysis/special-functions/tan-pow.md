---
id: analysis.special-functions.tan-pow
kind: theorem
state: verified
title: 反余弦连续性与反三角导数
summary: 反余弦在实轴连续，并给出反正弦和反余弦避开端点时的导数公式
premises: [analysis.special-functions.log-tan-pow]
mathlib: [Real.continuous_arccos, Real.hasDerivAt_arcsin, Real.hasDerivAt_arccos]
provenance: {source_type: textbook, ref: "ecnu-mathematical-analysis-5"}
---

# 动机

已有初等函数批次需要稳定的反余弦连续性和反三角导数接口。

# 直觉

Mathlib 把反余弦延拓为实轴上的连续总函数；反正弦和反余弦在避开端点时可微。

# 陈述（自然语言）

反余弦函数连续；当 `x ≠ ±1` 时，反正弦和反余弦具有标准平方根分母导数公式。

# 陈述（Lean 对照）

公开接口是 `continuous_arccos`、`hasDerivAt_arcsin` 和 `hasDerivAt_arccos`。

# 思维脉络（thinking trace）

本库把 Mathlib 连续性和点态导数定理整理成课程命名空间下的接口。

# 自然语言 ↔ Lean 映射

“反余弦连续”对应 `Real.continuous_arccos`；端点条件对应两个 `x ≠ ±1` 前提。

# 依赖（人话版）

依赖上一条合并的 log/tan/pow 接口；Mathlib 提供连续性和导数证明后端。

# 应用与陷阱

连续性适用于 Mathlib 总函数；两个导数公式都必须排除端点 `±1`。
