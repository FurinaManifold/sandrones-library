---
id: settheory.set.operations.complement-inter
family: settheory.set.operations
variant: ecnu
kind: theorem
state: verified
title: 德摩根律（交的补集）
summary: (A∩B)ᶜ = Aᶜ∪Bᶜ
premises: []
mathlib: [Set.compl_inter]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第一章（预备知识）"
---

# 动机

与 complement-union 配套的另一半德摩根律。两者合起来是"取补"的完整代数规则，
在证明"有限并/交"与"补"互换时缺一不可。

# 直觉

x 不在 A∩B，就是"不(同时属于 A 和 B)"——即 x 不属于 A **或**不属于 B。
取补时 ∩ 变成 ∪。左边的每一边各带一个补号。

# 陈述（自然语言）

对任意集合 A、B：不属于 A∩B 的元素，恰好就是不属于 A 或不属于 B 的元素。

# 陈述（Lean 对照）

```lean
theorem complement_inter {α : Type*} (A B : Set α) : (A ∩ B)ᶜ = Aᶜ ∪ Bᶜ
```

# 思维脉络（thinking trace）

1. **翻译**：`x ∈ (A∩B)ᶜ ⟺ ¬(x∈A ∧ x∈B)`。
2. **命题层 De Morgan**：`¬(P∧Q) ⟺ ¬P ∨ ¬Q`。
3. **翻译回集合**：`Aᶜ ∪ Bᶜ`。
4. **形式化**：直接 `rw [Set.compl_inter]`。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 德摩根（交的版本） | `Set.compl_inter` |

# 依赖（人话版）

无库内依赖。

# 公理依赖（#print axioms）

```
complement_inter 依赖: [propext, Classical.choice, Quot.sound]
```

**Classical.choice 是数学上必需的，不是形式化噪声**：这一半德摩根的正向方向
`¬(P∧Q) → ¬P ∨ ¬Q` 在直觉主义逻辑里**不可证**——它等价于对 P 的排中律
（经典逻辑教科书定理）。已实测：唯一能证它的路径（`by_cases`/`Classical.em`）
都依赖 `Classical.choice`。它与 complement-union 的不对称
（一个零 Choice、一个必须 Choice）正是"直觉主义德摩根半边失效"的形式化证据，
教科书（经典逻辑）看不到这个区别。

# 应用与陷阱

**应用**：
- 构造"同时避开两个集合"的补集的论证。
- 与 complement-union 成对记忆："取补翻转 ∪/∩，各归各"，可类推到有限与任意并交。

**陷阱**：
- **方向陷阱**：`(A∩B)ᶜ = Aᶜ∪Bᶜ`，别误写成 `Aᶜ∩Bᶜ`（那是并的补集）。
- **任意交/并的推广**：对任意索引族有 `(⋂ᵢ Aᵢ)ᶜ = ⋃ᵢ Aᵢᶜ`——无限情形仍是"翻转+各补各"，只是更强版本，别在有限习惯上出错。