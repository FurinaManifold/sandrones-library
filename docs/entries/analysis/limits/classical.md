---
id: analysis.limits.classical
kind: theorem
state: verified
title: "四个经典重要极限"
premises: [analysis.special-functions.basic, analysis.special-functions.log-tan-pow, analysis.func-limit.definition]
mathlib: ["HasDerivAt.tendsto_slope_zero", "Real.cos_two_mul_eq_one_sub", "Filter.Tendsto.comp", "Filter.Tendsto.pow"]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

本条目收录四个基础重要极限：`sin x / x → 1`、`(1 - cos x) / x^2 → 1/2`、
`(exp x - 1) / x → 1` 和 `log (1+x) / x → 1`。

证明统一使用导数给出的差商极限；余弦极限额外使用半角代换和二倍角恒等式。
