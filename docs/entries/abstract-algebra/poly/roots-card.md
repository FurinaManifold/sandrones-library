---
id: abstract-algebra.poly.roots-card
family: abstract-algebra.poly
variant: rotman
kind: theorem
state: verified
title: 根的个数不超过次数
summary: 根属于根集⟺是根；乘积的根=根的析取；非零n次多项式至多n个根
premises: [abstract-algebra.poly.def]
mathlib: [Polynomial.mem_roots, Polynomial.root_mul, Polynomial.card_roots]
provenance:
  source_type: book
  ref: Rotman, Advanced Modern Algebra, Ch 2（根与次数）
---

# abstract-algebra.poly.roots-card

- **家族**: `abstract-algebra.poly`
- **变体**: rotman
- **状态**: verified
- **一句话**: n 次多项式至多有 n 个根。

## 直觉

非零 n 次多项式 p 至多有 n 个根（含重数计，`p.roots.card`）。这是域上多项式的核心性质：
每个根对应一个一次因式 X−a，且这些因式两两互素，总次数不能超过 n。

## 陈述（教材记号）

`mem_roots_iff_isRoot`：a ∈ p.roots ⟺ a 是根。
`root_mul_iff`：(p·q).IsRoot a ⟺ p.IsRoot a 或 q.IsRoot a。
`card_roots_le_degree`：p.roots.card ≤ p.degree（根个数 ≤ 次数）。

## 依赖（人话版）

前提：abstract-algebra.poly.def。mathlib 的 `p.roots : Multiset R` 是根 multiset；
`Polynomial.mem_roots`、`root_mul`、`card_roots` 是核心。

## 应用与陷阱

- `card_roots` 返回 `(card : WithBot ℕ) ≤ p.degree`（degree 是 WithBot）。
- 推论：两个 n 次多项式在 n+1 个点相等则相同（多项式相等判据的经典应用）。
