---
id: abstract-algebra.group.def
family: abstract-algebra.group
variant: rotman
kind: theorem
state: verified
title: 群公理、子群与生成子群
summary: 本库逐项定义群公理、交换群、子群集合及生成子群集合，并建立 Mathlib 承载桥
premises: []
mathlib: [Group, Subgroup, Subgroup.closure, Subgroup.closure_le, mul_left_cancel, mul_inv_rev, zpow_add]
provenance:
  source_type: book
  ref: "dummit-foote-abstract-algebra-2004"
---

# abstract-algebra.group.def

- **家族**: `abstract-algebra.group`
- **变体**: rotman（Rotman《群论导引》）
- **状态**: verified
- **一句话**: 群公理由结合律、单位律和逆元律组成；子群是对这些运算封闭的子集。

## 直觉

本库不把 `[Group G]` 或 `Subgroup G` 当作教材定义。`GroupAxioms G` 逐条列出结合律、
左右单位律与左右逆元律；`CommutativeGroupAxioms G` 再加入交换律。`SubgroupSet H`
要求集合含单位元并对乘法、逆封闭。

群公理保证单位元与逆元唯一、左右消去律成立，并使方程 `ax=b`、`xa=b` 各有唯一解。
整数幂把自然数次重复乘法扩展到负指数，并保持指数加法与乘法法则。

群 G 的子集 H 要成为一个子群，只需验证三条：单位元在 H 中、H 对乘法封闭、H 对取逆封闭。
这三条保证 H 内乘法仍是群运算。反过来，从任意集合 S 出发，把所有必须由乘法和取逆
产生的元素补进去，就得到生成子群 `⟨S⟩`。它不是某个任意选择，而是包含 S 的最小子群：
`⟨S⟩ ≤ H ↔ S ⊆ H`。因此子群天然组成一个格，交对应下确界，并集生成的子群对应上确界。

## 陈述（教材记号）

`left_identity_unique`、`right_identity_unique`：单位元唯一。
`left_inverse_unique`、`right_inverse_unique`：逆元唯一。
`group_mul_left_cancel`、`group_mul_right_cancel`：左右消去律。
`solve_mul_left_iff`、`solve_mul_right_iff`：群中一次方程的唯一解。
`inverse_mul_reverse`：乘积取逆反序。
`zpow_zero_basic`、`zpow_one_basic`、`zpow_add_basic`、`zpow_neg_basic`、`zpow_mul_basic`：整数幂法则。

`GroupAxioms`、`CommutativeGroupAxioms`、`SubgroupSet`：本库教材定义。
`group_has_groupAxioms`、`subgroupSet_iff_exists_subgroup`：到 Mathlib 承载层的桥。
`generatedSubgroupSet`：所有包含 `S` 的子群集合之交。
`generatedSubgroupSet_is_subgroup`、`subset_generatedSubgroupSet`、
`generatedSubgroupSet_least`：封闭性、包含性和最小性。
`generatedSubgroupSet_eq_mathlib_closure`：与 Mathlib 闭包的正确性桥。

`subgroup_of_closed S h1 hmul hinv`：旧打包接口，供尚未迁移的定理兼容使用。
`subgroup_one_mem H`：1 ∈ H。`subgroup_ext`：元素集相同的子群相等。
`subgroup_bot_eq_singleton`：平凡子群 = {1}。`subgroup_top_eq_univ`：全子群 = G。

`generatedSubgroup S`：Mathlib 打包承载，不再是本库定义。`subset_generatedSubgroup`：S ⊆ ⟨S⟩。
`generatedSubgroup_le_iff`：⟨S⟩ ≤ H ↔ S ⊆ H。`generatedSubgroup_mono`：生成操作保包含。
`generatedSubgroup_coe`：子群的底层集合重新生成自身。
`generatedSubgroup_union`：⟨S ∪ T⟩ = ⟨S⟩ ⊔ ⟨T⟩。
`mem_subgroup_inf_iff` 与 `mem_subgroup_iInf_iff`：有限交和任意交的成员刻画。
`subgroup_sup_le_iff`、`subgroup_le_inf_iff`：上下确界的序刻画。
`generatedSubgroup_singleton_eq_zpowers`：单元素生成子群就是整数幂子群。
`map_generatedSubgroup`：同态像与生成子群可交换。

## 依赖（人话版）

前提：无。定义层只使用 `1`、乘法、逆运算与集合。Mathlib `Group`、`Subgroup` 和
`Subgroup.closure` 只在桥接及旧兼容接口中作为实现承载。这里的 closure 是代数闭包，
不是拓扑闭包。

## 应用与陷阱

- 子群判定是最常用判据：验证封闭性即可，不需重证结合律（群已给）。
- 非交换群中 `(ab)⁻¹` 必须反序写成 `b⁻¹a⁻¹`；整数幂只对同一底数使用指数加法。
- 要证明由 S 生成的子群落在 H 中，不应展开生成元素的“单词”表示；直接用最小性判据。
- `S ∪ T` 通常不是子群；正确对象是 `generatedSubgroup (S ∪ T)`，即子群格的 `⊔`。
- 新定理应优先使用 `SubgroupSet` 与 `generatedSubgroupSet`；需要调用 Mathlib 时再通过桥打包。
