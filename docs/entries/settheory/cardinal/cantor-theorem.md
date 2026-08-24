---
id: settheory.cardinal.cantor-theorem
kind: theorem
state: verified
title: "Cantor 定理：幂集严格更大"
premises: ["settheory.cardinal.comparison"]
mathlib: []
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 3: Cantor's Theorem"}
---

# 动机

幂集 `Set α` 收集 `α` 的全部子集。要证明无穷大小没有最大者，关键是说明任何试图用 `α` 编号其所有子集的名单都会遗漏一项。

# 直觉

给定名单 `f : α → Set α`，在第 `x` 个位置故意与第 `x` 项相反，构造 `D = {x | x ∉ f x}`。若 `D = f a`，检查 `a ∈ D` 就会得到 `a ∈ D ↔ a ∉ D`，因此 `D` 不可能出现在名单中。

# 陈述（自然语言）

对任意 `f : α → Set α`，`f` 都不是满射。另一方面，单元素映射 `x ↦ {x}` 把 `α` 单射进
`Set α`；若反方向也有单射，Cantor–Bernstein 会给出等势，与对角线结论矛盾。因此本库意义下
`CardinalLT α (Set α)`，即原类型严格小于其幂集。

# 陈述（Lean 对照）

```lean
def diagonalSet (f : α → Set α) : Set α := {x | x ∉ f x}
theorem cantor_no_surjection (f : α → Set α) : ¬ Function.Surjective f
theorem cantor_not_equinumerous (α : Type*) : ¬ Equinumerous α (Set α)
def CardinalLT (α β : Type*) : Prop := CardinalLE α β ∧ ¬ CardinalLE β α
theorem cardinalLE_powerSet (α : Type*) : CardinalLE α (Set α)
theorem not_cardinalLE_powerSet_reverse (α : Type*) : ¬ CardinalLE (Set α) α
theorem cantor_strictly_smaller_powerSet (α : Type*) : CardinalLT α (Set α)
```

`diagonalSet` 是公开对角对象，前两个定理给出无满射和不同势。`CardinalLT` 是本库公开的 `Prop`
定义：有正向单射且无反向单射。后三个定理依次建立正向嵌入、排除反向嵌入并组装严格比较；它们
尚未把 `CardinalLT` 注册成 mathlib 的序关系实例。

# 思维脉络（thinking trace）

先假设 `f` 满射，取 `a` 使 `f a = diagonalSet f`；对 `a` 是否属于对角集合分情况，两支展开
定义后都矛盾。随后用单元素集合构造 `α → Set α` 的单射。若存在反向单射，结合正向单射调用
本库 Cantor–Bernstein 得到等势，再与 `cantor_not_equinumerous` 冲突。最后把正向成立和反向
不成立打包成 `CardinalLT`。

# 自然语言 ↔ Lean 映射

- “所有子集” ↔ `Set α`。
- “对角集合” ↔ `diagonalSet f` 与成员条件 `x ∉ f x`。
- “名单覆盖所有子集” ↔ `Function.Surjective f`。
- “原类型与幂集不同势” ↔ `cantor_not_equinumerous α`。
- “单元素集合给出正向嵌入” ↔ `cardinalLE_powerSet α`。
- “反向嵌入不可能” ↔ `not_cardinalLE_powerSet_reverse α`。
- “幂集严格更大” ↔ `cantor_strictly_smaller_powerSet α : CardinalLT α (Set α)`。
- 分情况 tactic 只实现矛盾证明，不是新的数学公理。

# 依赖（人话版）

依赖等势、`CardinalLE`、Cantor–Bernstein，以及 Lean 的集合、单射和满射谓词。对角论证本身不
依赖选择公理；严格比较的反向排除复用本库 Cantor–Bernstein，而不是引用一个现成基数序定理。

# 应用与陷阱

该定理是不可数性和无穷层级的基础，也说明任何候选枚举都会产生专属于它的遗漏集合。`D` 依赖
给定的 `f`，不是预先固定的神秘集合；这也不是 Russell 悖论，因为构造始终限制在类型 `α` 内。
本条已经建立本库 `CardinalLT` 严格比较，但该对象只是命题定义，尚未封装为 Lean 的 `LT`、
`Preorder` 或 `PartialOrder` 实例，不能直接套用所有通用序论 API。
