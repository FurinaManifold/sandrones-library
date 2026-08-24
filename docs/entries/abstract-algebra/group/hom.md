---
id: abstract-algebra.group.hom
family: abstract-algebra.group
variant: rotman
kind: theorem
state: verified
title: 同态与同态基本定理
summary: 同态的恒等与复合、子群像和逆像、核像判据、双射升级、显式第一同构定理及同构不变量
premises: [abstract-algebra.group.normal]
mathlib: [MonoidHom.comp, Subgroup.map, Subgroup.comap, MonoidHom.range_comp, MonoidHom.ker_eq_bot_iff, MonoidHom.range_eq_top, MulEquiv.ofBijective, QuotientGroup.quotientKerEquivRange, MulEquiv.orderOf_eq, Nat.card_congr]
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

群同态可复合，并把子群送到子群、把目标子群拉回源群。核是单位元子群的逆像，像是全群
的同态像。单射性由核决定，满射性由像决定；双射同态就是群同构。

第一同构定理不是单纯的存在性：它给出规范映射 `x ker f ↦ f(x)`。该映射把因 f 无法
区分而应视为相同的元素恰好商掉。同构进一步保持元素阶和群的基数。

## 陈述（教材记号）

`hom_mem_ker`：x ∈ ker f ⟺ f x = 1。`hom_mem_range`：y ∈ im f ⟺ ∃x, f x = y。
`hom_id_apply`、`hom_comp_apply`：恒等同态和复合同态。
`hom_mem_comap`、`hom_mem_map`：子群逆像与像的成员刻画。
`hom_ker_comp`、`hom_range_comp`：复合的核与像。
`hom_map_one/mul/inv`：f(1)=1、f(a·b)=f a·f b、f(a⁻¹)=(f a)⁻¹。
`hom_injective_iff_ker_bot`：ker f = ⊥ ⟺ f 单射。
`hom_surjective_iff_range_top`：im f = ⊤ ⟺ f 满射。
`homEquivOfBijective`：双射同态升级为同构。
`firstIsomorphism` 与 `firstIsomorphism_apply_mk`：规范同构及 `x ker f ↦ f(x)` 计算公式。
`first_isomorphism_theorem`：第一同构定理的存在性包装。
`mulEquiv_preserves_order`、`mulEquiv_preserves_card`：同构保持元素阶与群阶。

## 依赖（人话版）

前提：abstract-algebra.group.normal（ker 正规）。mathlib 的 `MonoidHom` 是群同态，
`MonoidHom.mem_ker/mem_range/ker_eq_bot_iff/range_eq_top` 是基本性质，
`QuotientGroup.quotientKerEquivRange` 正是同态基本定理的显式同构。

## 应用与陷阱

- 同态基本定理在 mathlib 是 `quotientKerEquivRange : G ⧸ ker φ ≃* range φ`，直接可用。
- `f.ker = ⊥` 中的 `⊥` 是平凡子群（与 Set 的 {1} 需区分）。
- `Subgroup.map f H` 是 H 的像；`Subgroup.comap f K` 是 K 的逆像，方向不要写反。
- 第一同构定理的右端是子类型 `f.range`，其元素同时携带目标群元素及属于像的证明。
