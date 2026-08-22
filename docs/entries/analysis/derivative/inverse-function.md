---
id: analysis.derivative.inverse-function
kind: theorem
state: verified
title: "反函数求导"
premises: [analysis.derivative.chain-rule, analysis.continuity.inverse]
mathlib: ["HasDerivAt.comp", "HasDerivAt.congr_of_eventuallyEq", "HasDerivAt.unique"]
provenance:
  source_type: textbook
  ref: "数学分析中的反函数求导定理"
---

# 内容

若 `f` 在 `x` 可导、`g` 在 `f x` 可导，且 `g(f y)=y` 在 `x` 的邻域内成立，同时 `f' x ≠ 0`，则
`g' (f x) = 1 / f' x`。证明直接对局部恒等关系使用链式法则和导数唯一性。
