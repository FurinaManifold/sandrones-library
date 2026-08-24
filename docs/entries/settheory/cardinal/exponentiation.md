---
id: settheory.cardinal.exponentiation
kind: definition
state: verified
title: "基数幂：计算所有函数的数量"
premises: ["settheory.cardinal.equinumerous"]
mathlib: ["Equiv.arrowCongr"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 3: Cardinal Arithmetic"}
---

# 动机

若每个位置都有若干可选值，一个完整方案必须告诉我们每个位置选了什么。把有限算术中的 `m^n` 推广到任意集合时，所有这类方案正是函数空间。

# 直觉

`|α|^|β|` 把 `β` 看作位置、`α` 看作每个位置的可选值，因此对应函数 `β → α`。从空类型出发只有一个空函数，所以零次幂为一；`β → Bool` 则记录对每个位置的是非选择，与 `β` 的子集密切对应。

# 陈述（自然语言）

底数类型 `α`、指数类型 `β` 的基数幂，由所有函数 `β → α` 组成的类型表示。把底数替换成等势类型时，逐点搬运输出会给出等势的函数空间。

# 陈述（Lean 对照）

```lean
def CardinalPower (α : Type u) (β : Type v) := β → α

theorem cardinalPower_respects_equinumerous
    (h : Equinumerous α α') :
    Equinumerous (CardinalPower α β) (CardinalPower α' β)
```

`CardinalPower` 是公开构造，良定义性定理是公开接口。`Equiv.arrowCongr` 是 mathlib 的实现桥：定义域用恒等等价，值域用给定等价，从而产生函数空间等价。

# 思维脉络（thinking trace）

由 `h` 取得 `e : α ≃ α'`。对 `f : β → α` 定义新函数 `b ↦ e (f b)`，逆向逐点应用 `e.symm`。`Equiv.arrowCongr (Equiv.refl β) e` 封装这两个方向及函数外延所需的互逆证明。

# 自然语言 ↔ Lean 映射

- `|α|^|β|` ↔ 函数空间 `β → α` 的大小。
- “一个完整赋值” ↔ `f : β → α`。
- “逐点替换可选值” ↔ 对函数输出应用 `e`。
- `Equiv.arrowCongr` 是证明后端；`Equiv.refl β` 表示位置集合不变。

# 依赖（人话版）

依赖等势和函数类型，良定义性复用 mathlib 的函数空间等价。它不依赖 Cantor 定理；幂集与二值函数空间的具体等价也不是本条当前公开定理。

# 应用与陷阱

用于字符串、无限序列、特征函数和全部选择模式的计数。箭头方向容易写反：`|α|^|β|` 对应 `β → α`。这里计入所有函数，不要求单射或满射；基数幂与保留次序递归定义的序数幂也不能混同。
