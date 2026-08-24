---
id: settheory.cardinal.comparison
kind: definition
state: verified
title: "基数比较：用单射定义不大于"
premises: ["settheory.cardinal.equinumerous"]
mathlib: ["Function.Injective"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 3: Comparing Cardinals"}
---

# 动机

仅有“同样多”还不足以比较不同大小。要表达 `α` 不比 `β` 大，需要一种能把较小一方无冲突地放进较大一方、但不要求占满目标的关系。

# 直觉

单射 `α → β` 为每个 `α` 元素分配不同的 `β` 位置，因此 `β` 至少容得下 `α`。单向单射只给出一个不等式；两个方向的单射也不必互为逆，必须借助 Cantor–Bernstein 才能升级为等势。

# 陈述（自然语言）

称 `α` 的基数不大于 `β`，若存在从 `α` 到 `β` 的单射。若 `α` 与 `β` 等势，则正向双射及其逆都单射，所以得到双向比较。

# 陈述（Lean 对照）

```lean
def CardinalLE (α β : Type*) : Prop :=
  ∃ f : α → β, Function.Injective f

theorem equinumerous_implies_both_le (h : Equinumerous α β) :
    CardinalLE α β ∧ CardinalLE β α
```

`CardinalLE` 是本库公开定义，`Function.Injective` 是实现其含义的 mathlib 谓词。当前公开配套定理只登记“等势推出双向比较”；自反、传递以及由 Cantor–Bernstein 得到的反对称闭环不在本条已登记接口中。

# 思维脉络（thinking trace）

展开 `Equinumerous` 得到 `e : α ≃ β`。正向用 `e.injective` 作为 `CardinalLE α β` 的见证，反向用 `e.symm.injective` 作为 `CardinalLE β α` 的见证。反方向“两个比较推出等势”由下一条 `cantor_bernstein` 单独处理，避免误把输入函数当成彼此的逆。

# 自然语言 ↔ Lean 映射

- `|α| ≤ |β|` ↔ `CardinalLE α β`。
- “把 `α` 嵌入 `β`” ↔ `∃ f : α → β, Function.Injective f`。
- “等势给出正反两个嵌入” ↔ `e.injective` 与 `e.symm.injective`。
- `Function.Injective` 是证明后端谓词；它不额外携带满射或逆函数。

# 依赖（人话版）

概念上依赖前一条等势定义和基本函数论。Lean 中只需 `Function.Injective` 与 `Equiv` 的单射性质；不依赖选择公理。完整的反对称解释依赖后续 Cantor–Bernstein 定理。

# 应用与陷阱

函数方向不能写反：`α → β` 的单射表达 `α` 不大于 `β`。不要把双向单射误解为两个现成函数互逆，也不要把类型大小比较混同于某个具体子集的包含。当前条目是比较关系的基础入口，并未单独公开预序或偏序的全部定律。
