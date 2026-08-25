---
id: settheory.set.subset.definition
family: settheory.set.subset
variant: ecnu
kind: theorem
state: verified
title: 子集的逐元素刻画
summary: A ⊆ B 当且仅当 A 的每个元素都属于 B
premises: []
mathlib: []
provenance:
  source_type: book
  ref: "jech-set-theory-2003"
---

# 动机

“`A` 是 `B` 的子集”并不是说两个集合大小相近，也不要求 `B` 中存在 `A` 之外的元素。
它只表达一个逐元素条件：从任意证据 `x ∈ A`，都能得到证据 `x ∈ B`。这是后续所有
包含证明、集合相等证明和函数值域限制的基本语言。

# 陈述

对任意同一类型上的集合 `A`、`B`，

\[
A\subseteq B\quad\Longleftrightarrow\quad
\forall x,\;x\in A\Longrightarrow x\in B.
\]

# Lean 对照

```lean
theorem subset_iff_forall_mem {α : Type*} (A B : Set α) :
    A ⊆ B ↔ ∀ x : α, x ∈ A → x ∈ B
```

在 Lean 中，`A ⊆ B` 本身就定义为右侧的函数类型。因此证明是 `rfl`：这不是借用
某个外部定理，而是把记号展开后发现等价式两边完全相同。

# 推论与用法

- 要证明 `A ⊆ B`，使用 `intro x hx`，随后目标是 `x ∈ B`；
- 要使用 `h : A ⊆ B`，将它作用于 `hx : x ∈ A`，得到 `h hx : x ∈ B`；
- `subset_trans` 就是连续使用两次这种证据传递；
- `subset_antisymm` 把两个方向的逐元素蕴合并成集合外延相等。

# 容易混淆的边界

`A ⊆ B` 允许 `A = B`；真子集需要额外表达 `A ⊆ B ∧ A ≠ B`。此外，子集关系的
方向不能反用：由 `x ∈ B` 和 `A ⊆ B` 一般不能推出 `x ∈ A`。

# 公理依赖

无。证明只是定义反身性。
