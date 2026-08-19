---
id: settheory.set.subset.trans
family: settheory.set.subset
variant: ecnu
kind: theorem
state: verified
title: 包含的传递性
summary: A ⊆ B 且 B ⊆ C 蕴含 A ⊆ C
premises: []
mathlib: [Set.Subset.trans]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第一章（预备知识）"
---

# 动机

集合包含（子集）是分析里最常见的集合关系：`A ⊆ B` 表示"A 的每个元素都在 B 里"。
它看起来平淡，却是数学里最常用的三段论引擎之一——"x 属于 A，所以 x 属于 B；
又因 B ⊆ C，所以 x 属于 C"。这一串推理能成立，靠的就是传递性。

# 直觉

包含是一条"能一直延伸的链"：把 A 装进 B，把 B 装进 C，A 自然就装进了 C。
传递性保证"⊆"是一种**序**（在集合族上定义了一个偏序），
从而 `A = B` 可以像实数一样用"双向 ≤"来证明（见 antisymm 条目）。

# 陈述（自然语言）

若 A ⊆ B 且 B ⊆ C，则 A ⊆ C。

# 陈述（Lean 对照）

```lean
theorem subset_trans {α : Type*} {A B C : Set α}
    (hAB : A ⊆ B) (hBC : B ⊆ C) : A ⊆ C
```

| 人话 | Lean |
|---|---|
| A 是 B 的子集 | `A ⊆ B`（即 `∀ x, x ∈ A → x ∈ B`） |
| 传递结论 | `hBC (hAB hxA)`：先过 A→B，再过 B→C |

# 思维脉络（thinking trace）

1. **展开目标**：`A ⊆ C` = `∀ x, x ∈ A → x ∈ C`。固定 x，假设 `x ∈ A`。
2. **顺藤摸瓜**：`x ∈ A` 且 `hAB : A ⊆ B` ⇒ `x ∈ B`；再且 `hBC : B ⊆ C` ⇒ `x ∈ C`。
3. **翻译成 Lean**：`hAB hxA` 就是把"函数" `hAB`（把 `x∈A` 变成 `x∈B`）作用在 `hxA` 上。
   子集证明的本质就是"按包含关系传证据"。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 任取 x ∈ A | `intro x hxA` |
| 由包含把证据传给下一步 | `hAB hxA`（作用一个蕴含） |

# 依赖（人话版）

无库内依赖（只有 ⊆ 的定义）。

# 应用与陷阱

**应用**：
- 证明包含链：`A ⊆ B ⊆ C` 一步到位。
- 与 antisymm 配合，形成"双向包含证相等"的标准套路——分析里遍地都是。

**陷阱**：
- **方向陷阱**：⊆ 只能"顺方向"传。`hAB hxC` 是错误的（x∈C 不能推出 x∈B）。
- **思维陷阱**：别把包含当"相等"用。`A ⊆ B` 只保证一边，除非还有 `B ⊆ A`。
