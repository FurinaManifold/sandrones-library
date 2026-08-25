---
id: analysis.constants.nth-root-irrational
kind: theorem
state: verified
title: "非完全幂整数的 n 次根无理性"
premises: [analysis.real.archimedean, analysis.real.construction-cauchy]
mathlib: ["irrational_nrt_of_notint_nrt"]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

若 `n > 0`，实数 `x` 满足
\[
x^n=m\qquad(m\in\mathbb Z),
\]
且不存在整数 `z` 使得 `z^n=m`，则 `x` 是无理数。

证明采用反证法：若 `x` 为整数，则它本身就给出 `m` 的整数 `n` 次方表示，与非完全幂假设矛盾。
该接口可直接用于 `√2` 等具体无理性结论。
