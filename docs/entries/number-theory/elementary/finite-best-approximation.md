---
id: number-theory.elementary.finite-best-approximation
family: number-theory.elementary
variant: finite-candidates
kind: theorem
state: verified
title: 有限候选集中的最佳逼近存在
summary: 每个非空有限有理数候选集都有绝对误差最小者
premises: []
mathlib: [Finset.exists_min_image]
provenance:
  source_type: derivation
  ref: "有限线性序集取最小值"
---

# 陈述与证明思想

对非空有限集 `s : Finset ℚ`，存在 `q ∈ s`，使每个 `r ∈ s` 都满足
`|ξ-q| ≤ |ξ-r|`。把误差函数映到实数线性序，有限集必能选出像的最小值；Lean 中由
`Finset.exists_min_image` 完成这一有限选择。

# 作用

本条是构造分母受限最佳逼近的有限化接口：实际应用先给出一个有限候选集，再在其中取最优者。
它本身不声称候选集已包含“所有分母不超过某界的有理数”；后者还需要对分子作有界化论证。
