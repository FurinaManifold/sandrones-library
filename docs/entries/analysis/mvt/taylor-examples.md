---
id: analysis.mvt.taylor-examples
kind: theorem
state: verified
title: "初等函数的有限阶 Taylor 展开"
premises: [analysis.mvt.taylor, analysis.special-functions.basic]
mathlib: ["taylor_mean_remainder_lagrange_iteratedDeriv", "taylor_within_apply", "iteratedDerivWithin_zero"]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

本条目给出三个不依赖级数的有限阶展开实例：`exp x = 1 + exp c * x`、
`sin x = x - sin c * x^2 / 2`、`cos x = 1 - cos c * x^2 / 2`。

其中 `c ∈ uIoo 0 x`，且 `x ≠ 0`。证明使用有限阶 Taylor–Lagrange 余项和函数的有限阶导数性质。
