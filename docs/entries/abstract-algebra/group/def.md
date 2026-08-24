---
id: abstract-algebra.group.def
family: abstract-algebra.group
variant: rotman
kind: theorem
state: verified
title: 子群判定与基本性质
summary: 群公理直接推论、整数幂；子群判定；生成子群的泛性质、同态像及子群格
premises: []
mathlib: [mul_left_cancel, mul_right_cancel, mul_inv_rev, zpow_add, zpow_neg, Subgroup, Subgroup.closure, Subgroup.closure_le, Subgroup.closure_union, Subgroup.zpowers_eq_closure, MonoidHom.map_closure]
provenance:
  source_type: book
  ref: Rotman, An Introduction to the Theory of Groups, Ch 2（子群判定）
---

# abstract-algebra.group.def

- **家族**: `abstract-algebra.group`
- **变体**: rotman（Rotman《群论导引》）
- **状态**: verified
- **一句话**: 子群既可由封闭性判定，也可看作一组生成元所生成的最小封闭集合。

## 直觉

群公理首先保证单位元与逆元唯一、左右消去律成立，并使方程 `ax=b`、`xa=b` 各有唯一解。
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

`subgroup_of_closed S h1 hmul hinv`：S 含单位元、对乘法与取逆封闭 ⟹ 存在子群 H 恰以 S 为元素集。
`subgroup_one_mem H`：1 ∈ H。`subgroup_ext`：元素集相同的子群相等。
`subgroup_bot_eq_singleton`：平凡子群 = {1}。`subgroup_top_eq_univ`：全子群 = G。

`generatedSubgroup S`：S 生成的子群。`subset_generatedSubgroup`：S ⊆ ⟨S⟩。
`generatedSubgroup_le_iff`：⟨S⟩ ≤ H ↔ S ⊆ H。`generatedSubgroup_mono`：生成操作保包含。
`generatedSubgroup_coe`：子群的底层集合重新生成自身。
`generatedSubgroup_union`：⟨S ∪ T⟩ = ⟨S⟩ ⊔ ⟨T⟩。
`mem_subgroup_inf_iff` 与 `mem_subgroup_iInf_iff`：有限交和任意交的成员刻画。
`subgroup_sup_le_iff`、`subgroup_le_inf_iff`：上下确界的序刻画。
`generatedSubgroup_singleton_eq_zpowers`：单元素生成子群就是整数幂子群。
`map_generatedSubgroup`：同态像与生成子群可交换。

## 依赖（人话版）

前提：无。证明内部用 mathlib 的 `Subgroup.mk`（从 Set + 封闭性构造子群）、`Subgroup.ext`
（外延性）以及 `Subgroup.closure`。这里的 closure 是代数闭包，不是拓扑闭包：它取包含 S 的
所有子群之交。

## 应用与陷阱

- 子群判定是最常用判据：验证封闭性即可，不需重证结合律（群已给）。
- 非交换群中 `(ab)⁻¹` 必须反序写成 `b⁻¹a⁻¹`；整数幂只对同一底数使用指数加法。
- 要证明由 S 生成的子群落在 H 中，不应展开生成元素的“单词”表示；直接用最小性判据。
- `S ∪ T` 通常不是子群；正确对象是 `generatedSubgroup (S ∪ T)`，即子群格的 `⊔`。
- `Subgroup` 元素投影到 G 用 `↑`，子群内乘法 = 群内乘法（`Subgroup.coe_mul`）。
