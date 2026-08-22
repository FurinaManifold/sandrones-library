---
id: analysis.series.absolute
kind: theorem
state: verified
title: "绝对收敛与尾和"
premises: ["analysis.series.basic", "analysis.series.tests"]
mathlib: ["Summable.abs", "Summable.tendsto_sum_tsum_nat"]
provenance:
  source_type: book
  ref: "数学分析 II：绝对收敛级数"
---

# 内容

本批次给出实数项级数的绝对收敛等价判据，并记录可和级数的有限部分和趋于无穷和。

- `summable_abs_iff`
- `partial_sum_tendsto_tsum`
