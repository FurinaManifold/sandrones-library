---
id: settheory.set.operations.diff-inter-complement
family: settheory.set.operations
variant: ecnu
kind: theorem
state: verified
title: 差集与补集
summary: A∖B = A∩Bᶜ
premises: []
mathlib: [Set.sdiff_eq]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第一章（预备知识）"
---

# 动机

差集 `A∖B`（属于 A 但不属于 B）在分析里极常见（`ℝ∖{0}`、`A∖A'`）。
把它写成交集与补集的语言，就可以复用已建立的交/补全部代数规则。

# 直觉

"从 A 里拿掉 B 的部分" = "A 里那些同时在 B 之外的成员"。逐字翻译：
`A∖B = A ∩ Bᶜ`。

# 陈述（自然语言）

对任意集合 A、B：x ∈ A∖B 当且仅当 x ∈ A 且 x ∉ B。

# 陈述（Lean 对照）

```lean
theorem diff_inter_complement {α : Type*} (A B : Set α) : A \ B = A ∩ Bᶜ
```

| 人话 | Lean |
|---|---|
| 差集 | `A \ B`（注意是反斜杠） |
| 补集 | `Bᶜ` |

# 思维脉络（thinking trace）

1. **定义拆开**：`x ∈ A∖B ⟺ x∈A ∧ x∉B`。
2. **补集代入**：`x∉B ⟺ x∈Bᶜ`。
3. **合并**：交集定义正是"同时属于两者"。
4. **形式化**：mathlib 把差集**定义**成 `s \ t = s ∩ tᶜ`（现名 `Set.sdiff_eq`，
   `Set.diff_eq` 已弃用），`exact` 即可——这不是"算出来的"，而是"写出来的定义"。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 差集即交集补 | `Set.sdiff_eq` |

# 依赖（人话版）

无库内依赖。

# 公理依赖（#print axioms）

验证后此节自动核对；因是定义恒等式本身，通常为构造性（可能与 `propext` 相关）。

# 应用与陷阱

**应用**：
- 一切"去掉坏点"的论证：`ℝ∖{0}`、可去间断、删点邻域。
- 与占位：真子集 `A ⊊ B` ⇔ `A⊆B ∧ B∖A ≠ ∅` 论证的基础。

**陷阱**：
- **记号陷阱**：`\` 别与逻辑减法混淆；`A \ B` 无"顺序可交换"。
- **相对补 vs 绝对补**：`Bᶜ` 是相对全集 α 的补，`A∩Bᶜ` 是"留在 A 内"的局部化，两者不是一回事。