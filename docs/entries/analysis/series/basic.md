---
id: analysis.series.basic
kind: theorem
state: verified
title: "数项级数基础"
premises: [analysis.sequence.cauchy, analysis.real.archimedean]
mathlib: ["HasSum", "Summable", "hasSum_geometric_of_norm_lt_one", "Real.not_summable_one_div_natCast", "Summable.of_norm", "summable_iff_cauchySeq_finset"]
provenance:
  source_type: textbook
  ref: "数学分析 II：数项级数基础"
---

# 内容

本批次建立数项级数的基础接口：

- 当 `|r|<1` 时，`∑ rⁿ = 1/(1-r)`；
- 调和级数 `∑ 1/n` 发散；
- 绝对收敛蕴含收敛；
- 级数可收敛当且仅当其有限集部分和构成 Cauchy 网。

这里的 `Summable`/`HasSum` 直接对应级数的收敛与和，Cauchy 准则使用 Mathlib 的有限集部分和过滤器形式。
