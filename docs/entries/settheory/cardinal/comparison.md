---
id: settheory.cardinal.comparison
kind: definition
state: verified
title: "基数比较：用单射定义不大于"
premises: ["settheory.cardinal.equinumerous"]
mathlib: ["Function.Injective"]
provenance: {source_type: book, ref: "jech-set-theory-2003"}
---

# 动机

仅有“同样多”还不足以比较不同大小。要表达 `α` 不比 `β` 大，需要一种能把较小一方无冲突地放进较大一方、但不要求占满目标的关系。

# 直觉

单射 `α → β` 为每个 `α` 元素分配不同的 `β` 位置，因此 `β` 至少容得下 `α`。单向单射只给出一个不等式；两个方向的单射也不必互为逆，必须借助 Cantor–Bernstein 才能升级为等势。

# 陈述（自然语言）

称 `α` 的基数不大于 `β`，若存在从 `α` 到 `β` 的单射。这个关系自反且传递；若两个方向都
成立，Cantor–Bernstein 将它们合成为等势，因此它在“按等势识别类型”的意义下满足反对称性。

# 陈述（Lean 对照）

```lean
def CardinalLE (α β : Type*) : Prop :=
  ∃ f : α → β, Function.Injective f

theorem equinumerous_implies_both_le (h : Equinumerous α β) :
    CardinalLE α β ∧ CardinalLE β α

theorem cardinalLE_refl (α : Type*) : CardinalLE α α
theorem cardinalLE_trans (hαβ : CardinalLE α β) (hβγ : CardinalLE β γ) :
    CardinalLE α γ
theorem cardinalLE_antisymm (hαβ : CardinalLE α β) (hβα : CardinalLE β α) :
    Equinumerous α β
```

`CardinalLE` 是本库公开定义，`Function.Injective` 是实现其含义的 mathlib 谓词。三个新增定理已
公开比较闭环：恒等函数证明自反，单射复合证明传递，`cardinalLE_antisymm` 调用本库
`cantor_bernstein` 得到等势。这里的反对称结论是 `Equinumerous α β`，不是 Lean 类型相等。

# 思维脉络（thinking trace）

自反性选择恒等函数。传递性从单射 `f : α → β`、`g : β → γ` 构造复合 `g ∘ f`，并用
`hg.comp hf` 验证不会碰撞。等势推出双向比较时分别使用 `e.injective` 与
`e.symm.injective`。反对称闭环不把输入单射误当成互逆，而是调用 Cantor–Bernstein 重新构造
双射。

# 自然语言 ↔ Lean 映射

- `|α| ≤ |β|` ↔ `CardinalLE α β`。
- “把 `α` 嵌入 `β`” ↔ `∃ f : α → β, Function.Injective f`。
- “等势给出正反两个嵌入” ↔ `e.injective` 与 `e.symm.injective`。
- “任何大小不大于自身” ↔ `cardinalLE_refl`。
- “比较可以串接” ↔ `cardinalLE_trans` 与函数复合。
- “双向不大于推出同样大” ↔ `cardinalLE_antisymm`，结论为 `Equinumerous`。
- `Function.Injective` 是证明后端谓词；它不额外携带满射或逆函数。

# 依赖（人话版）

概念上依赖等势、基本函数论和 Cantor–Bernstein。自反与传递只用恒等函数及函数复合；反对称
闭环依赖下一条已经公开的 `cantor_bernstein`。这些证明不需要选择公理。

# 应用与陷阱

函数方向不能写反：`α → β` 的单射表达 `α` 不大于 `β`。不要把双向单射误解为两个现成函数
互逆，也不要把类型大小比较混同于具体子集包含。当前已经公开自反、传递和等势意义下的反对称
定理，但尚未把类型及等势商封装成 Lean 的 `Preorder` 或 `PartialOrder` 实例。
