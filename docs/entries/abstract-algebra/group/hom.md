---
id: abstract-algebra.group.hom
family: abstract-algebra.group
variant: rotman
kind: theorem
state: verified
title: 同态与同态基本定理
summary: 核/值域元素刻画；同态保单位元/乘法/逆；单射⟺核平凡；满射⟺值域全；同态基本定理 G/ker≅im
premises: [abstract-algebra.group.normal]
mathlib: [MonoidHom.mem_ker, MonoidHom.mem_range, MonoidHom.ker_eq_bot_iff, MonoidHom.range_eq_top, QuotientGroup.quotientKerEquivRange]
provenance:
  source_type: book
  ref: Rotman, An Introduction to the Theory of Groups, Ch 2（同态定理）
---

# abstract-algebra.group.hom

- **家族**: `abstract-algebra.group`
- **变体**: rotman
- **状态**: verified
- **一句话**: 同态核是正规子群；单射⟺核平凡；G/ker ≅ im。

## 直觉

群同态 f:G→N 的核 ker f = {x | f x = 1} 是正规子群。单射性由核决定：核只含单位元 ⟺ 单射。
同态基本定理（Noether 第一同构定理）：商掉核之后，G/ker f 与像 im f 完全同构。

## 陈述（教材记号）

`hom_mem_ker`：x ∈ ker f ⟺ f x = 1。`hom_mem_range`：y ∈ im f ⟺ ∃x, f x = y。
`hom_map_one/mul/inv`：f(1)=1、f(a·b)=f a·f b、f(a⁻¹)=(f a)⁻¹。
`hom_injective_iff_ker_bot`：ker f = ⊥ ⟺ f 单射。
`hom_surjective_iff_range_top`：im f = ⊤ ⟺ f 满射。
`first_isomorphism_theorem`：G/ker f ≃* im f（同态基本定理）。

## 依赖（人话版）

前提：abstract-algebra.group.normal（ker 正规）。mathlib 的 `MonoidHom` 是群同态，
`MonoidHom.mem_ker/mem_range/ker_eq_bot_iff/range_eq_top` 是基本性质，
`QuotientGroup.quotientKerEquivRange` 正是同态基本定理的显式同构。

## 应用与陷阱

- 同态基本定理在 mathlib 是 `quotientKerEquivRange : G ⧸ ker φ ≃* range φ`，直接可用。
- `f.ker = ⊥` 中的 `⊥` 是平凡子群（与 Set 的 {1} 需区分）。
