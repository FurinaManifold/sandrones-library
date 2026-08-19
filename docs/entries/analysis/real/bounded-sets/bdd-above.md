---
id: analysis.real.bounded-sets.bdd-above
family: analysis.real.bounded-sets
variant: ecnu
kind: theorem
state: verified
title: 有上界集的刻画
summary: BddAbove s ⟺ 存在上界 M
premises: []
mathlib: [BddAbove]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第二章（数列极限·预备）"
---

# 动机

"有界"是极限论的第一道门槛：收敛数列必有界（第三章），确界原理要求"非空有上界"。
先把"有上界"这个谓词钉死：它就是"存在一个数压住所有元素"。

# 直觉

把集合 s 想象成一堆点，`BddAbove s` 就是"能找到一块天花板 M，谁都不许超过它"。
天花板不要求是集合里的点——只要存在就行（可以是十分浪费的 M）。

# 陈述（自然语言）

集合 s ⊆ ℝ 有上界，当且仅当存在实数 M 使得对每个 x ∈ s 都有 x ≤ M。

# 陈述（Lean 对照）

```lean
theorem bdd_above_iff (s : Set ℝ) : BddAbove s ↔ ∃ M : ℝ, ∀ x ∈ s, x ≤ M := by
  rfl
```

| 人话 | Lean |
|---|---|
| s 有上界 | `BddAbove s` |
| 存在上界 M | `∃ M : ℝ, ∀ x ∈ s, x ≤ M` |

# 思维脉络（thinking trace）

1. **这是定义**：`BddAbove s` 在 mathlib 里就是 `∃ a, ∀ b ∈ s, b ≤ a`。
2. **所以逐字展开**：`rfl` 直接完成——叙述层与形式化层对"有上界"的理解完全一致。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 有上界 | `BddAbove` |
| 有下界（对称） | `BddBelow` |

# 依赖（人话版）

无库内依赖。

# 公理依赖（#print axioms）

```
bdd_above_iff 依赖: [propext, Classical.choice, Quot.sound]
```

**结构必需（无法削减）**：本证明就是 `rfl`（定义展开，证明体零公理）。
但类型里含 `ℝ` 的 `≤`（`BddAbove` 与右侧都用它），而 mathlib 4.33 的
`ℝ` 序实例定义体是经典构造的——已实测 `ℚ` 的同款 rfl 为零公理、`ℝ` 必带 choice。
这是结构底线，不是形式化噪声。

# 应用与陷阱

**应用**：
- 确界原理的前提（`analysis.real.sup`）。
- 单调有界收敛定理的前提（第三章）。
- "有界"在分析里常指"既有上界又有下界"：`BddAbove s ∧ BddBelow s`。

**陷阱**：
- 上界不要求属于集合（sup 与 max 的区别）。
- 空集：`BddAbove ∅` 是真（任意 M 都是空泛的上界）——别直觉当成假。