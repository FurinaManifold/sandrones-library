---
id: settheory.set.operations.complement-union
family: settheory.set.operations
variant: ecnu
kind: theorem
state: verified
title: 德摩根律（并的补集）
summary: (A∪B)ᶜ = Aᶜ∩Bᶜ
premises: []
mathlib: [Set.compl_union]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第一章（预备知识）"
---

# 动机

集合代数里的"翻译工具"：当你想知道"哪些元素不在 A∪B 里"，德摩根律把它变成
两个补集的交集，往往更好处理（比如证明"补集的交集仍是开集"这类拓扑论断）。

# 直觉

x 不在 A∪B，就是说 x 既不属于 A **又**不属于 B。而"不属于"正是补集。
所以"∪ 的补" = "补的 ∩"。这就是德摩根：取补号时，∪ 变 ∩，∩ 变 ∪。

# 陈述（自然语言）

对任意集合 A、B：不属于 A∪B 的元素，恰好就是同时不属于 A 且不属于 B 的元素。

# 陈述（Lean 对照）

```lean
theorem complement_union {α : Type*} (A B : Set α) : (A ∪ B)ᶜ = Aᶜ ∩ Bᶜ
```

| 人话 | Lean |
|---|---|
| A 的补集 | `Aᶜ`（`Set.compl A`） |
| 并 | `A ∪ B` |
| 交 | `A ∩ B` |

# 思维脉络（thinking trace）

1. **翻译成元素层**：`x ∈ (A∪B)ᶜ ⟺ x ∉ A∪B ⟺ ¬(x∈A ∨ x∈B)`。
2. **命题逻辑**：`¬(P∨Q) ⟺ ¬P ∧ ¬Q`（De Morgan 在命题层的投影）。这正是命题形式。
3. **翻译回集合层**：`¬P ∧ ¬Q` = 两个补集的交集。
4. **形式化**：这是教科书矩阵式的 4 行真值表验证；mathlib 的 `Set.compl_union`
   已打包，直接 `rw`。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 补集运算 | `Set.compl`，记号 `ᶜ` |
| 德摩根（集合层） | `Set.compl_union` |

# 依赖（人话版）

无库内依赖。

# 公理依赖（#print axioms）

```
complement_union 依赖: [propext, Quot.sound]
```

**零 Classical.choice**：本条目最初借 mathlib 的 `Set.compl_union` 证明时携带
`Classical.choice`（数学上不必要的噪声）。已改写为 ext + 逐元素纯构造性证明：
`¬(P∨Q) = ¬P ∧ ¬Q` 在直觉主义逻辑里对称可证，全程只用 Or/And 消解。
这恰好示范了"德摩根律之一不需要选择公理"——教科书同样不提，但这次是 Lean 证实不需要。

# 应用与陷阱

**应用**：
- 拓扑/测度里"补集与开闭集"的论证。
- 与 `diff-inter-complement`、`complement-inter` 组合形成集合代数工具箱。

**陷阱**：
- **方向陷阱**：取补翻转连接词——`(A∪B)ᶜ = Aᶜ∩Bᶜ`，别写成 `Aᶜ∪Bᶜ`（那是对交取补）。
- 补集是**相对全集**的概念：必须清楚"全集"（宇宙 α）是什么，否则 `ᶜ` 无意义。