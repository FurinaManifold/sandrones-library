---
id: settheory.set.subset.antisymm
family: settheory.set.subset
variant: ecnu
kind: theorem
state: verified
title: 包含的反对称性
summary: A ⊆ B 且 B ⊆ A 蕴含 A = B
premises: [settheory.set.ext]
mathlib: [Set.Subset.antisymm]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第一章（预备知识）"
---

# 动机

证明两个集合相等，最常用的方法不是直接摆等式，而是**双向包含**：
先证 `A ⊆ B`，再证 `B ⊆ A`，于是 `A = B`。

这个方法之所以对，是因为 ⊆ 具有**反对称性**（antisymmetry）：互相包含的集合只能相等。
这一条把"外延性原理"（settheory.set.ext）翻译成了方便实用的话——
外延性说"元素相同则相等"，而"元素相同"拆成两个包含各管一半。

# 直觉

两个盒子互相装下对方：A 里的东西都在 B 里，B 里的东西都在 A 里——
它们不可能是两个不同的集合，只能装的是完全相同的一批东西。

这是"⊆ 是偏序"的最后一个关键性质（自反、传递、反对称三者齐了才是偏序）。

# 陈述（自然语言）

若 A ⊆ B 且 B ⊆ A，则 A = B。

# 陈述（Lean 对照）

```lean
theorem subset_antisymm {α : Type*} (A B : Set α)
    (hAB : A ⊆ B) (hBA : B ⊆ A) : A = B
```

| 人话 | Lean |
|---|---|
| 双向包含 | `hAB : A ⊆ B` 和 `hBA : B ⊆ A` |
| 相等 | `A = B` |

# 思维脉络（thinking trace）

1. **目标**：证 `A = B`。手里是两条包含。
2. **回忆外延性**（settheory.set.ext）：`A = B ⟺ ∀ x, x∈A ↔ x∈B`。
   所以只需证"任意 x 属于 A 当且仅当属于 B"。
3. **拆两半**：`x ∈ A → x ∈ B` 正是 `hAB`；`x ∈ B → x ∈ A` 正是 `hBA`。
4. **收尾**：两条包含各自喂进 iff 的两个方向，外延性收工。
   这就是"双向包含证相等"的全部原理——它只是外延性换了个说法。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 相等降到逐元素 | `apply (set_ext A B).2` |
| 一个方向一条包含 | `constructor` 后各 `exact hAB hxA` / `exact hBA hxB` |

# 依赖（人话版）

- `settheory.set.ext`：外延性——把"集合相等"变成"逐元素双向属于"。
  本条是它的直接推论（把双向属于再拆成两个单向包含）。

# 应用与陷阱

**应用**：
- 分析里几乎每一个"两个集合相等"的证明都是这个套路：区间等式、像原像等式、上/下确界的刻画。
- 有了它，"等于"就能用 ⊆ 表达，而 ⊆ 的证明（逐元素传证据）通常更直接。

**陷阱**：
- **漏一半**：只证了一个方向就声称相等——这是最常见的错误。`A ⊆ B` 永远不等于 `A = B`。
- **循环论证**：证明 `A = B` 时用了 `A = B` 本身。双向包含必须来自独立的推理。
