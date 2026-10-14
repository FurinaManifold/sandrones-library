---
id: examples.settheory.set-operations
kind: example
state: verified
title: 有限集上的并、交、差、补与 De Morgan 逐元素计算例
summary: 在有限全集 Fin 5 上取 A={1,2,3}、B={3,4}、C={2,4}，逐元素算出并、交、差、补、交对并分配律与德摩根律两侧，并给出 A∪B=A∪C 推不出 B=C 的精确反例与差集不可交换的辨析
premises: [settheory.set.ext, settheory.set.subset.definition, settheory.set.operations.inter-distrib, settheory.set.operations.complement-union, settheory.set.operations.complement-inter, settheory.set.operations.diff-inter-complement]
mathlib: [Set.ext, Set.mem_insert_iff, Set.mem_singleton_iff, Set.mem_inter_iff, Set.mem_sdiff, Set.mem_compl_iff, Set.union_insert, Set.union_singleton, Set.insert_eq_of_mem, Fin.reduceEq]
provenance:
  source_type: book
  ref: "jech-set-theory-2003"
---

# 动机

理论条目 `settheory.set.ext`、`settheory.set.operations.*` 与 `settheory.set.subset.definition`
把集合语言建立为“外延性 + 逐元素刻画 + 若干恒等式”。这些恒等式本身是抽象的：读者能看到
`(A ∪ B)ᶜ = Aᶜ ∩ Bᶜ`，却不容易确认“补集到底在哪个全集里取”“并集相等为什么不能消去”。

本 Entry 把全部运算落到一个能手工核对的小对象上：有限全集 `Fin 5 = {0,1,2,3,4}` 中的三个
命名集合 `A = {1,2,3}`、`B = {3,4}`、`C = {2,4}`。每条结论都是把两侧逐元素算成显式集合
字面量后相接，而不是引用一般定理改名。

# 直觉

- 有限集上一切集合运算都可以退化成“查表”：`x ∈ A ∪ B` 只需分别检查 `x ∈ A`、`x ∈ B`。
  本 Entry 的每个集合等式都先 `ext x` 降到元素层，再对 `Fin 5` 的五个元素逐一求值。
- 德摩根律在有限集上就是“补集表格的两种算法”：先并后补，与先补后交，得到同一张表。
- 补集必须相对于一个全集才有意义。本 Entry 的补集都在 `Fin 5` 中取（`U = univ`），
  `Aᶜ = U \ A` 这条桥把这个约定写死。
- `A ∪ B = A ∪ C` 只记录 `A` 之外的部分：`B` 与 `C` 的差别（`3` 对 `2`）都落在 `A` 内，
  被 `A` 吸收，所以并集看不出差别。这就是消去律失败的全部机制。

# 陈述（自然语言）

在有限全集 `U = {0,1,2,3,4}` 中取 `A = {1,2,3}`、`B = {3,4}`、`C = {2,4}`：

1. 并：`A ∪ B = {1,2,3,4}`，`B ∪ C = {2,3,4}`，`A ∪ C = {1,2,3,4}`；
2. 交：`A ∩ B = {3}`，`A ∩ C = {2}`；
3. 差：`A \ B = {1,2}`，`B \ A = {4}`，`C \ A = {4}`；
4. 补：`Aᶜ = {0,4}`，`Bᶜ = {0,1,2}`，且 `Aᶜ = U \ A`；
5. 分配律：`A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C) = {2,3}`；
6. 德摩根律：`(A ∪ B)ᶜ = Aᶜ ∩ Bᶜ = {0}`，`(A ∩ B)ᶜ = Aᶜ ∪ Bᶜ = {0,1,2,4}`；
7. 差集公式：`A \ B = A ∩ Bᶜ = {1,2}`；
8. 子集：`A ⊆ {1,2,3,4}` 成立。

反例（逐条写清前件与后件）：

- **反例 1（并集不能左消去）**：取 `A = {1,2,3}`、`B = {3,4}`、`C = {2,4}`，
  **前件** `A ∪ B = A ∪ C` 成立（两侧都等于 `{1,2,3,4}`），
  **后件** `B = C` 不成立（见证 `3 ∈ B` 而 `3 ∉ C`）。
  一般否定命题：在 `Fin 5` 上 `¬ ∀ A B C, A ∪ B = A ∪ C → B = C`。
  机制：`B \ A = C \ A = {4}`——差别被 `A` 吸收。
- **反例 2（差集不可交换）**：`A \ B = {1,2}` 而 `B \ A = {4}`，两者不相等；
  见证 `1 ∈ A \ B` 而 `1 ∉ B \ A`。
- **辨析（子集方向）**：`B ⊄ A`，见证 `4 ∈ B` 而 `4 ∉ A`（即 `not_subset_B_A`）。

# 陈述（Lean 对照）

```lean
abbrev U : Set (Fin 5) := Set.univ
abbrev A : Set (Fin 5) := {1, 2, 3}
abbrev B : Set (Fin 5) := {3, 4}
abbrev C : Set (Fin 5) := {2, 4}

theorem union_A_B : A ∪ B = ({1, 2, 3, 4} : Set (Fin 5))
theorem inter_A_B : A ∩ B = ({3} : Set (Fin 5))
theorem diff_A_B  : A \ B  = ({1, 2} : Set (Fin 5))
theorem compl_A   : Aᶜ     = ({0, 4} : Set (Fin 5))
theorem compl_A_eq_diff_U : Aᶜ = U \ A

theorem inter_distrib_instance : A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C)
theorem de_morgan_union : (A ∪ B)ᶜ = Aᶜ ∩ Bᶜ
theorem de_morgan_inter : (A ∩ B)ᶜ = Aᶜ ∪ Bᶜ
theorem diff_eq_inter_compl : A \ B = A ∩ Bᶜ

theorem union_eq_but_ne : ∃ A B C : Set (Fin 5), A ∪ B = A ∪ C ∧ B ≠ C
theorem union_right_cancel_not_valid :
    ¬ (∀ A B C : Set (Fin 5), A ∪ B = A ∪ C → B = C)
theorem diff_not_comm : A \ B ≠ B \ A
```

# 思维脉络

1. **先命名对象**：`U/A/B/C` 用 `abbrev` 而不是 `def`。这不是风格问题：`def` 对
   typeclass 搜索不可见，`decide` 合成不出 `Decidable (x ∈ A)`；改成 `abbrev` 后
   元素层判断才能直接交给决策过程。
2. **集合等式先降维**：`ext x`（外延性，理论条目 `settheory.set.ext`）把集合等式变成
   `x ∈ 左边 ↔ x ∈ 右边`；`fin_cases x` 枚举 `Fin 5` 的五个元素；`simp [A, B]`
   在每一支上把成员条件求值成真/假。这是本 Entry 所有计算例的统一套路。
3. **不要用 `decide` 判集合等式**：`Set.decidableEq` 是经典实例，`decide` 归约会卡在
   `Classical.choice` 上（实测报 “did not reduce to isTrue or isFalse”）。
   `decide` 只用在元素层结论上（`zero_notMem_A` 等）。
4. **恒等式靠“两侧都算出来”**：`de_morgan_union` 不是引用 `Set.compl_union`，而是
   `(A ∪ B)ᶜ = {0}` 与 `Aᶜ ∩ Bᶜ = {0}` 两条计算相接；分配律、差集公式同理。
5. **反例给足见证**：`B_ne_C` 用 `3 ∈ B`、`3 ∉ C` 具体元素否掉相等；
   `union_right_cancel_not_valid` 再把具体反例提升为对全称命题的否定。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 有限全集 `U = {0,1,2,3,4}` | `U : Set (Fin 5) := Set.univ` |
| 集合字面量 `{1,2,3}` | `({1, 2, 3} : Set (Fin 5))` |
| 属于 / 不属于 | `x ∈ A` / `x ∉ A` |
| 并、交、差、补 | `A ∪ B`、`A ∩ B`、`A \ B`、`Aᶜ` |
| 子集 | `A ⊆ B`（逐元素刻画，`settheory.set.subset.definition`） |
| “逐元素求值” | `ext x` + `fin_cases x <;> simp [A, B]` |
| 元素层的真/假计算 | `decide` |
| 集合等式（不能用 `decide`） | `Set.decidableEq` 走 `Classical.choice`，归约卡死 |

# 依赖（人话版）

- `settheory.set.ext`：所有集合等式的降维入口（`ext x`）。
- `settheory.set.subset.definition`：`subset_A_1234` 与 `not_subset_B_A` 使用的逐元素刻画。
- `settheory.set.operations.inter-distrib`：`inter_distrib_instance` 的抽象原型。
- `settheory.set.operations.complement-union`：`de_morgan_union` 的抽象原型。
- `settheory.set.operations.complement-inter`：`de_morgan_inter` 的抽象原型。
- `settheory.set.operations.diff-inter-complement`：`diff_eq_inter_compl` 的抽象原型。
- Mathlib 角色：`Set.ext` 是外延性的正式承载；`Set.mem_insert_iff`、`Set.mem_singleton_iff`、
  `Set.mem_inter_iff`、`Set.mem_sdiff`、`Set.mem_compl_iff`、`Set.union_insert`、
  `Set.union_singleton`、`Set.insert_eq_of_mem`、`Fin.reduceEq` 只在 `simp` 里充当
  **私有证明后端**（成员条件的展开与化简），不是本 Entry 的公开概念。

# 应用与陷阱

- **应用**：有限样本空间上的事件运算、容斥原理、有限集的计数与概率计算，都以此处
  的逐元素计算为最基础模型；`Aᶜ = U \ A` 提醒后续所有补集运算都要先固定全集。
- **陷阱 1（消去律）**：`A ∪ B = A ∪ C` **不能**推出 `B = C`（反例 1）；
  要消去必须补上“差别都在 `A` 之外”的条件，本 Entry 用 `diff_B_A_eq_diff_C_A`
  把这个机制显式算了出来。
- **陷阱 2（交换律）**：差集不可交换（反例 2）；并、交可交换，差不行。
- **陷阱 3（补集的全集）**：`Aᶜ` 在 Lean 中是相对于整个类型 `Fin 5` 的补集。
  若把类型换成 `ℕ`，`Aᶜ` 会变成无限集——本 Entry 特意选 `Fin 5` 并在文档中写死这一点。
- **陷阱 4（`decide` 的边界）**：元素层 `decide` 可行，集合等式 `decide` 不可行；
  后者要走 `ext` + 枚举。
