---
id: analysis.series.tests
kind: theorem
state: verified
title: "数项级数判别法"
premises: ["analysis.series.basic"]
mathlib: ["summable_of_isBigO_nat", "summable_of_ratio_test_tendsto_lt_one", "not_summable_of_ratio_test_tendsto_gt_one", "Antitone.cauchySeq_alternating_series_of_tendsto_zero"]
provenance:
  source_type: book
  ref: "数学分析 II：数项级数判别法"
---

# 内容

本批次建立比较、比值和交错级数三个教材层判别法接口。比较判别法使用渐近上界；比值判别法同时给出收敛和发散方向；交错级数给出部分和的 Cauchy 性。

根值判别法尚未转正，保留在后续 roadmap 中单独 formalize。

# 对应定理

- `summable_of_isBigO_nat`
- `summable_of_ratio_test`
- `not_summable_of_ratio_test`
- `alternating_series_cauchy`
