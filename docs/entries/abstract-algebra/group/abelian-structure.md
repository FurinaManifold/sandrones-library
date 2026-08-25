---
id: abstract-algebra.group.abelian-structure
kind: theorem
state: verified
title: "有限生成交换群结构定理"
summary: 自建有限生成群定义，并给出有限生成交换群结构定理与有限交换群的双向分类
premises: ["abstract-algebra.group.sylow"]
mathlib: ["Group.fg_iff", "CommGroup.equiv_free_prod_prod_multiplicative_zmod", "AddCommGroup.equiv_directSum_zmod_of_finite", "CommGroup.equiv_prod_multiplicative_zmod_of_finite"]
provenance:
  source_type: book
  ref: "dummit-foote-abstract-algebra-2004"
---

# 动机

有限生成交换群是能够完整分类的第一大类无限群。交换律允许把生成元之间的关系化为
整数线性关系；标准形最终把群拆成自由部分和有限挠部分。有限交换群正是自由部分消失的
情形。

# 定义

`IsFinitelyGeneratedGroup G` 表示存在有限集合 `S ⊆ G`，使
`generatedSubgroup S = ⊤`。这是本库自己的教材定义；Mathlib 的 `Group.FG` 只通过
`isFinitelyGeneratedGroup_iff_mathlib` 在证明内部使用。

# 陈述（自然语言）

每个有限生成交换群都同构于有限个无限循环群与有限个素数幂阶循环群的直积：

`G ≅ ℤ^r × ∏ᵢ ℤ/(pᵢ^{eᵢ})ℤ`。

若 `G` 有限，则自由秩 `r = 0`，从而 `G` 是有限多个素数幂阶循环群的直积。合并具有
互素阶的循环因子后，也可写成有限多个非平凡有限循环群的直积。本库还证明了反向：任何
这样的有限直积都是有限交换群。

# 陈述（Lean 对照）

- `IsFinitelyGeneratedGroup`：有限生成群定义；
- `finite_group_isFinitelyGenerated`：有限群必有限生成；
- `finitely_generated_abelian_structure`：一般结构定理；
- `finite_abelian_prime_power_structure`：有限交换群的初等因子形式；
- `finite_abelian_cyclic_structure`：有限循环因子存在形式；
- `finite_abelian_iff_cyclic_product`：有限性的双向分类。

# 自然语言 ↔ Lean 映射

- 无限循环群 `ℤ` ↔ `Multiplicative ℤ`；
- 阶为 `n` 的循环群 ↔ `Multiplicative (ZMod n)`；
- `r` 个副本的直积 ↔ `Fin r → Multiplicative ℤ`；
- 有限指标直积 ↔ `(i : ι) → Multiplicative (ZMod (n i))`；
- 群同构 ↔ `MulEquiv`，记号 `≃*`。

# 思维脉络

有限生成交换群可视为有限秩自由交换群的商。整数矩阵的 Smith 标准形把关系矩阵对角化，
零对角项产生自由部分，非零对角项产生有限循环因子；再把每个循环因子的阶作素因数分解，
即可得到素数幂初等因子形式。

# 陷阱

- 本条目的循环因子存在形式没有声明 `n₁ ∣ n₂ ∣ ⋯`，因此不包含不变量因子形式的唯一性。
- `e i = 0` 时 `ZMod (p i ^ e i)` 是平凡因子；删除平凡因子后的版本满足 `1 < n i`。
- 结构定理要求交换性；一般有限生成群不存在这种循环群直积分解。
