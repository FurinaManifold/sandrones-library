---
id: abstract-algebra.poly.irreducible
family: abstract-algebra.poly
variant: rotman
kind: theorem
state: verified
title: 不可约与带余除法
summary: 不可约判据(p=ab⟹a或b单位)；X-a不可约；X不可约；次数1不可约；带余除法整除判据；余式次数小于除式
premises: [abstract-algebra.poly.def]
mathlib: [Irreducible.isUnit_or_isUnit, Polynomial.irreducible_X_sub_C, Polynomial.irreducible_X, Polynomial.irreducible_of_degree_eq_one, Polynomial.modByMonic_eq_zero_iff_dvd, Polynomial.degree_modByMonic_lt]
provenance:
  source_type: book
  ref: Rotman, Advanced Modern Algebra, Ch 2（不可约/欧几里得）
---

# abstract-algebra.poly.irreducible

- **家族**: `abstract-algebra.poly`
- **变体**: rotman
- **状态**: verified
- **一句话**: 不可约 = 不能分解为两个非单位之积；一次因式必不可约。

## 直觉

p 不可约 ⟺ p 非单位且 p=ab ⟹ a 或 b 是单位。X−a 与 X 都不可约；域上次数 1 的多项式不可约。
域上多项式环是欧几里得环：有带余除法，余式次数严格小于除式，整除 ⟺ 余式为 0。

## 陈述（教材记号）

`irreducible_mul_iff`：不可约的教材判据（p=ab ⟹ a 或 b 单位）。
`irreducible_X_sub_C`：X−a 不可约。`irreducible_X`：X 不可约。
`irreducible_of_degree_eq_one`：次数 1 不可约（域上）。
`modByMonic_eq_zero_iff_dvd`：带余除法整除判据。`degree_modByMonic_lt`：余式次数 < 除式次数。

## 依赖（人话版）

前提：abstract-algebra.poly.def。mathlib 的 `Irreducible p` 是 Prop，`isUnit_or_isUnit` 是其分解判据；
`Polynomial.irreducible_X_sub_C`/`irreducible_X`/`irreducible_of_degree_eq_one` 是具体不可约结论；
`modByMonic`/`divByMonic` 是首一除法的带余除法。

## 应用与陷阱

- 带余除法 `p %ₘ q`（modByMonic）只对首一多项式 q 良好定义（`q.Monic` 前提）。
- "域上多项式环欧几里得"是 `Polynomial.instEuclideanDomain` 实例（instance 非 Prop，不立条）。
