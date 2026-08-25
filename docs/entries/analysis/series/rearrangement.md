---
id: analysis.series.rearrangement
kind: theorem
state: verified
title: "绝对收敛级数的重排不变性"
premises: ["analysis.series.absolute"]
mathlib: ["Equiv.tsum_eq", "Equiv.summable_iff"]
provenance:
  source_type: book
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

绝对收敛级数在自然数指标的任意等价重排下，仍绝对收敛且无穷和不变。

- `absolute_reindex_tsum`
- `absolute_reindex_summable`
