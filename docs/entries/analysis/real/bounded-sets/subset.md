---
id: analysis.real.bounded-sets.subset
family: analysis.real.bounded-sets
variant: ecnu
kind: theorem
state: verified
title: 子集继承有界性
summary: s⊆t 且 t 有上界 ⟹ s 有上界
premises: [analysis.real.bounded-sets.bdd-above]
mathlib: [BddAbove.mono]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第二章（数列极限·预备）"
---

# 动机

"子集不会比母集更有界"——这条简单继承性质在分析里反复出现：
区间收缩、截断集合、把某范围限制在更小区间时的界自动保留。

# 直觉

天花板对 t 有效，s 是 t 的一部分，自然也不会超过同一块天花板。
"更大的集合有界 ⇒ 更小的集合有界"。

# 陈述（自然语言）

若 s ⊆ t 且 t 有上界，则 s 也有上界。

# 陈述（Lean 对照）

```lean
theorem bdd_above_subset {s t : Set ℝ} (hst : s ⊆ t) (ht : BddAbove t) : BddAbove s := by
  exact BddAbove.mono hst ht
```

# 思维脉络（thinking trace）

1. **展开目标**：要 ∃M，∀x∈s, x≤M。
2. **借用 t 的天花板**：ht 给出 M 使 ∀y∈t, y≤M。对任意 x∈s，由 hst 得 x∈t，故 x≤M。
3. **形式化**：`BddAbove.mono` 正是这一步，参数顺序（包含、母集有界）传入即可。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 继承 | `BddAbove.mono hst ht` |

# 依赖（人话版）

- `analysis.real.bounded-sets.bdd-above`：本条目使用"有上界"的概念（思维路径承托）。

# 公理依赖（#print axioms）

```
bdd_above_subset 依赖: [propext, Classical.choice, Quot.sound]
```

**结构必需（无法削减）**：类型含 `ℝ` 的序结构（`≤`），mathlib 4.33 的 `ℝ` 序实例
定义体经典构造，凡涉 `ℝ ≤` 的命题必带 choice（对照实验：`ℚ`/`ℕ` 同款为零公理）。
证明本身只是 `BddAbove.mono` 的定义展开。

# 应用与陷阱

**应用**：
- 收敛数列有界（值域的子集位于某个区间）。
- 有界集的有限并仍有界（逐步用继承）。

**陷阱**：
- **方向**：只从大到小方向成立（t 大→s 小）。反向"子集有界 ⇒ 母集有界"不成立
  （如 s=[0,1]⊆ℝ）。别用反了。
- 对称地，`BddBelow.mono` 对下界同样成立。