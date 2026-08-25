---
id: analysis.series.root-test
kind: theorem
state: verified
title: "数项级数根值判别法"
premises: ["analysis.series.tests"]
mathlib: ["Real.rpow_le_rpow", "Real.rpow_inv_natCast_pow", "Summable.of_norm_bounded_eventually_nat", "tendsto_order"]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

设实数项级数的通项为 `fₙ`。本条目给出根值判别法的两个常用版本。

- 最终上界版：若存在 `0≤r<1`，使充分大的正整数 `n` 都满足
  `|fₙ|^(1/n)≤r`，则 `Σfₙ` 收敛。
- 极限版：若 `|fₙ|^(1/n)→l` 且 `l<1`，则 `Σfₙ` 收敛。

极限版不要求预先假设 `l≥0`。证明在 `max(l,0)` 与 `1` 之间选取非负比较数，避开
第零项中的 `1/n`，再化归到最终上界版。

# 证明思路

从 `|fₙ|^(1/n)≤r` 出发，两边取实数 `n` 次幂。利用 `n>0` 及实幂接口得到
`|fₙ|≤rⁿ`，于是通项最终被收敛几何级数支配。有限个被排除的初始项不影响可和性。

若只知道根值极限 `l<1`，取 `r=(max(l,0)+1)/2`。此时 `0≤r<1` 且 `l<r`；极限的
序关系刻画保证根值最终小于 `r`，故可调用上一版本。

# 公理依赖

核查得到依赖为命题外延、经典选择与商类型健全性。
