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

对任意 `f : α → Set α`，`f` 都不是满射；所以 `α` 不与 `Set α` 等势。本条已形式化“无满射”和“不同势”，但尚未通过本库 `CardinalLE` 公开完整的严格比较接口。

# 陈述（Lean 对照）

```lean
def diagonalSet (f : α → Set α) : Set α := {x | x ∉ f x}
theorem cantor_no_surjection (f : α → Set α) : ¬ Function.Surjective f
theorem cantor_not_equinumerous (α : Type*) : ¬ Equinumerous α (Set α)
```

`diagonalSet` 是公开的对角对象，两个定理分别公开强结论“无满射”和推论“不同势”。集合外延与经典命题推理是证明工具；当前源码没有名为严格小于的公开结构。

# 思维脉络（thinking trace）

假设 `f` 满射，则可取 `a` 使 `f a = diagonalSet f`。对命题 `a ∈ diagonalSet f` 分情况，展开定义后两支都矛盾。若再假设等势，从 `α ≃ Set α` 的正向函数得到满射，与前一定理冲突，从而排除等势。

# 自然语言 ↔ Lean 映射

- “所有子集” ↔ `Set α`。
- “对角集合” ↔ `diagonalSet f` 与成员条件 `x ∉ f x`。
- “名单覆盖所有子集” ↔ `Function.Surjective f`。
- “原类型与幂集不同势” ↔ `cantor_not_equinumerous α`。
- 分情况 tactic 只实现矛盾证明，不是新的数学公理。

# 依赖（人话版）

依赖等势概念以及 Lean 的集合与函数满射定义。对角论证不依赖选择公理。标题沿用教材中的“严格更大”读法，但本批可稳定依赖的 Lean 结论仅是无满射与不同势；`CardinalLE α (Set α)` 及反向不成立的成套严格序接口仍待补齐。

# 应用与陷阱

该定理是不可数性和无穷层级的基础，也说明任何候选枚举都会产生专属于它的遗漏集合。`D` 依赖给定的 `f`，不是预先固定的神秘集合；这也不是 Russell 悖论，因为构造始终限制在类型 `α` 内。不要把“不同势”单独写成已经完成本库严格基数序。
