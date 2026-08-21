---
id: abstract-algebra.group.coset
family: abstract-algebra.group
variant: rotman
kind: theorem
state: verified
title: 陪集与 Lagrange 定理
summary: 左陪集 aH 元素刻画与相等判据；自身在陪集；单位元陪集；陪集与子群等势；Lagrange |H|·[G:H]=|G|
premises: [abstract-algebra.group.def]
mathlib: [mem_leftCoset_iff, leftCoset_eq_iff, Subgroup.leftCosetEquivSubgroup, Subgroup.card_mul_index, Subgroup.index_eq_card]
provenance:
  source_type: book
  ref: Rotman, An Introduction to the Theory of Groups, Ch 2（Lagrange）
---

# abstract-algebra.group.coset

- **家族**: `abstract-algebra.group`
- **变体**: rotman
- **状态**: verified
- **一句话**: 陪集是子群的平移；Lagrange：|H|·[G:H]=|G|。

## 直觉

左陪集 aH = { a·h | h ∈ H } 是子群 H 按 a 平移。关键事实：
- x ∈ aH ⟺ a⁻¹·x ∈ H（把 x 移回看是否落 H）
- aH = bH ⟺ b⁻¹·a ∈ H（两个陪集重合当且仅当"代表差"落 H）
- 每个陪集与 H 等势（平移是一一对应），所以有限群 G 被 H 的陪集等分，|G| = |H|·[G:H]

## 陈述（教材记号）

`left_coset_mem_iff`：x ∈ aH ⟺ a⁻¹·x ∈ H。
`left_coset_eq_iff`：aH = bH ⟺ b⁻¹·a ∈ H。
`left_coset_mem_self`：a ∈ aH。`one_left_coset`：1H = H。
`left_coset_card_eq`：|aH| = |H|。`lagrange`：|H|·[G:H] = |G|。

## 依赖（人话版）

前提：abstract-algebra.group.def。mathlib 用 pointwise smul `a • (H : Set G)` 表示 aH，
`mem_leftCoset_iff`/`leftCoset_eq_iff` 是 Set 层陪集引理，`Subgroup.leftCosetEquivSubgroup` 给陪集与
子群的显式一一对应（等势），`Subgroup.card_mul_index` 正是 Lagrange。

## 应用与陷阱

- mathlib 的 `leftCoset_eq_iff` 方向是 `a⁻¹*b`，与教材 `b⁻¹*a` 相反，需 `.symm`/换参。
- `[G:H]` = `H.index`，由 `Subgroup.index_eq_card` 知道它等于陪集数 |G/H|。
