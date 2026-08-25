---
id: settheory.cardinal.addition
kind: definition
state: verified
title: "基数加法：用不交并合并两批对象"
premises: ["settheory.cardinal.equinumerous"]
mathlib: ["Equiv.sumCongr"]
provenance: {source_type: book, ref: "jech-set-theory-2003"}
---

# 动机

把一批 `α` 对象和一批 `β` 对象合在一起时，普通并集会把重名元素合并，不能稳定表达“第一批的位置加第二批的位置”。基数加法需要一种保留来源的集合构造。

# 直觉

给两批对象贴上左右标签：第一批写成 `inl a`，第二批写成 `inr b`。即使原对象相同，标签也保证它们是不同位置。有限时这恢复通常的加法；无限时两份可数集的不交并仍可能与一份自然数等势。

# 陈述（自然语言）

`α` 与 `β` 的基数和由不交并 `Sum α β` 表示。若把 `α` 换成等势的 `α'`，所得不交并仍等势，说明该运算不依赖代表的具体名称。

# 陈述（Lean 对照）

```lean
def CardinalSum (α : Type u) (β : Type v) := Sum α β

theorem cardinalSum_respects_equinumerous
    (h : Equinumerous α α') :
    Equinumerous (CardinalSum α β) (CardinalSum α' β)
```

`CardinalSum` 是公开类型构造，`cardinalSum_respects_equinumerous` 是公开良定义性接口。`Equiv.sumCongr` 是 mathlib 的实现桥，用已有等价逐支构造和类型的等价。

# 思维脉络（thinking trace）

先从 `h` 取得 `e : α ≃ α'`。左支用 `e` 搬运，右支使用 `Equiv.refl β` 保持不动，再由 `Equiv.sumCongr` 合成为 `Sum α β ≃ Sum α' β`。这一证明验证的是“替换等势代表不改变结果”，不是计算某个特定无限和。

# 自然语言 ↔ Lean 映射

- “不交并” ↔ `Sum α β`。
- “来自第一批／第二批” ↔ `Sum.inl a`／`Sum.inr b`。
- “基数和” ↔ `CardinalSum α β` 的等势类大小。
- “逐支搬运双射” ↔ `Equiv.sumCongr e (Equiv.refl β)`，属于证明后端。

# 依赖（人话版）

依赖等势定义及 Lean 的和类型。良定义性证明复用 mathlib 的 `Equiv.sumCongr`；不需要已经构造抽象 `Cardinal` 对象，也不依赖选择公理或无限基数算术定理。

# 应用与陷阱

适合“从两批中任选一项”的计数；“两边各选一项”应使用乘法。不要把不交并写成可能重叠的普通并集。无限情形结果可能与一个加数等势，但这不表示定义丢掉了另一边。
