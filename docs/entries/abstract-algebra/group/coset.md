---
id: abstract-algebra.group.coset
family: abstract-algebra.group
variant: rotman
kind: theorem
state: verified
title: 陪集与 Lagrange 定理
summary: 左右陪集的成员与相等判据；陪集相交即相等并形成分割；Lagrange 及子群阶、元素阶整除推论
premises: [abstract-algebra.group.def]
mathlib: [mem_leftCoset_iff, leftCoset_eq_iff, mem_rightCoset_iff, rightCoset_eq_iff, Subgroup.leftCosetEquivSubgroup, Subgroup.card_mul_index, orderOf_dvd_card, pow_card_eq_one]
provenance:
  source_type: book
  ref: Rotman, An Introduction to the Theory of Groups, Ch 2（Lagrange）
---

# abstract-algebra.group.coset

- **家族**: `abstract-algebra.group`
- **变体**: rotman
- **状态**: verified
- **一句话**: 左右陪集是子群的平移并把群分割成等大的块；Lagrange 是这一分割的计数结果。

## 直觉

左陪集 aH = { a·h | h ∈ H } 是子群 H 按 a 平移。关键事实：
- x ∈ aH ⟺ a⁻¹·x ∈ H（把 x 移回看是否落 H）
- aH = bH ⟺ b⁻¹·a ∈ H（两个陪集重合当且仅当"代表差"落 H）
- 每个陪集与 H 等势（平移是一一对应），所以有限群 G 被 H 的陪集等分，|G| = |H|·[G:H]

右陪集 Ha 有镜像判据 `x ∈ Ha ↔ xa⁻¹ ∈ H`。在非交换群中，左陪集与右陪集一般不同。
两个同侧陪集一旦相交就完全相等，否则互不相交，所以陪集确实构成 G 的分割。

## 陈述（教材记号）

`left_coset_mem_iff`：x ∈ aH ⟺ a⁻¹·x ∈ H。
`left_coset_eq_iff`：aH = bH ⟺ b⁻¹·a ∈ H。
`left_coset_mem_self`：a ∈ aH。`one_left_coset`：1H = H。
`left_coset_card_eq`：|aH| = |H|。`lagrange`：|H|·[G:H] = |G|。
`right_coset_mem_iff`、`right_coset_eq_iff`、`right_coset_mem_self`：右陪集的对应性质。
`left_coset_inter_nonempty_iff_eq`：两个左陪集相交当且仅当相等。
`left_cosets_eq_or_disjoint`：任意两个左陪集相等或不交。
`subgroup_card_dvd_group_card`：|H| 整除 |G|。
`element_order_dvd_group_order`：有限群中 `ord(x) ∣ |G|`。
`pow_group_order_eq_one`：有限群中 `x^|G| = 1`。

## 依赖（人话版）

前提：abstract-algebra.group.def。mathlib 用 pointwise smul `a • (H : Set G)` 表示 aH，
`mem_leftCoset_iff`/`leftCoset_eq_iff` 是 Set 层陪集引理，`Subgroup.leftCosetEquivSubgroup` 给陪集与
子群的显式一一对应（等势），`Subgroup.card_mul_index` 正是 Lagrange。

## 应用与陷阱

- mathlib 的 `leftCoset_eq_iff` 方向是 `a⁻¹*b`，与教材 `b⁻¹*a` 相反，需 `.symm`/换参。
- mathlib 用 `MulOpposite.op a • H` 表示右陪集 `Ha`，以区分左右点乘作用。
- “陪集不相等”可以立即强化为“不相交”，证明计数公式时应使用这个分割性质。
- `[G:H]` = `H.index`，由 `Subgroup.index_eq_card` 知道它等于陪集数 |G/H|。
