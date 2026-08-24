---
id: settheory.cardinal.comparison
kind: definition
state: verified
title: "基数比较：用单射定义不大于"
premises: ["settheory.cardinal.equinumerous"]
mathlib: ["Function.Injective"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 3: Comparing Cardinals"}
---

# 定义

称 `α` 的基数不大于 `β`，若存在从 `α` 到 `β` 的单射：

```lean
def CardinalLE (α β : Type*) : Prop :=
  ∃ f : α → β, Function.Injective f
```

# 把较小集合放进较大集合

单射给 `α` 中每个元素安排一个互不冲突的 `β` 位置，因此可把 `α` 看成嵌入 `β`。它不要求
占满 `β`，所以适合表达“不大于”而不是“相等”。

例如包含映射给出偶数集合单射进自然数；反过来 `n↦2n` 又给自然数单射进偶数。单看任意一个
方向只能得到一个不等式，两个方向合起来还需要 Cantor–Bernstein 才能推出等势。

# 为什么不用满射定义

在选择公理充足的经典环境中，“`β` 满射到 `α`”常可表达 `|α|≤|β|`，但它在空集和选择问题上
需要额外小心。单射定义直接表达把较小集合无碰撞地放入较大集合，是最稳定的基础接口。

# 陈述（自然语言）

若 `α` 与 `β` 等势，则存在两个方向的单射，因此 `α≤β` 且 `β≤α`。

# 陈述（Lean 对照）

`equinumerous_implies_both_le h` 从一个等价映射及其逆映射提取双向单射。

# 思维脉络

双射 `e : α ≃ β` 的正向函数是单射；逆等价 `e.symm : β ≃ α` 同样单射。因此等势自然蕴含
双向比较。反方向不直接拼接两个函数，而由下一条 Cantor–Bernstein 完成。

# 自然语言 ↔ Lean 映射

- `|α|≤|β|` ↔ `CardinalLE α β`。
- 把 `α` 嵌入 `β` ↔ `∃ f : α → β, Injective f`。
- 双向比较 ↔ `CardinalLE α β ∧ CardinalLE β α`。

# 应用与陷阱

- 单射方向不能写反：`α→β` 的单射表示 `α` 不大于 `β`。
- 双向单射不意味着两个给定单射互为逆；必须重新构造一个双射。
- 本条比较的是类型大小，而不是某个具体子集包含关系。
