---
id: analysis.special-functions.basic
kind: theorem
state: verified
title: "初等特殊函数基础性质"
premises: [analysis.continuity.definition, analysis.derivative.const]
mathlib: ["Real.exp_pos", "Real.exp_add", "Real.continuous_exp", "Real.hasDerivAt_exp", "Real.continuous_sin", "Real.continuous_cos", "Real.hasDerivAt_sin", "Real.hasDerivAt_cos"]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

本批次建立指数函数与三角函数的教材层接口：指数函数的正值、加法公式、连续性和导数，以及正弦/余弦函数的连续性和导数。

核心结论包括：

- `0 < exp x`；
- `exp (x + y) = exp x * exp y`；
- `(exp x)' = exp x`；
- `(sin x)' = cos x`；
- `(cos x)' = -sin x`。

正式实现位于 `Analysis/SpecialFunctions.lean`。这些结果是后续重要极限、反函数求导和特殊函数 Riemann 积分例子的前置。
