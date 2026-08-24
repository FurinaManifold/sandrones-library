---
id: settheory.cardinal.multiplication
kind: definition
state: verified
title: "基数乘法：用笛卡尔积记录成对选择"
premises: ["settheory.cardinal.equinumerous"]
mathlib: ["Equiv.prodCongr"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 3: Cardinal Arithmetic"}
---

# 动机

当一次结果需要从 `α` 和 `β` 各选一项时，结果应同时记录两个坐标。基数乘法把有限计数中的乘法原理推广到任意类型，而不要求元素本身带有数值乘法。

# 直觉

所有选择写成有序对 `(a,b)`，组成笛卡尔积 `α × β`。若一边为空便无法配对；若一边只有一个元素，积与另一边等势。无限网格 `ℕ × ℕ` 仍可沿对角线枚举，显示无限乘法可能等于某个因子。

# 陈述（自然语言）

`α` 与 `β` 的基数积由 `α × β` 表示。将任一因子替换为等势类型，不改变积的等势类；当前公开定理登记了替换第一因子的情形。

# 陈述（Lean 对照）

```lean
def CardinalProduct (α : Type u) (β : Type v) := α × β

theorem cardinalProduct_respects_equinumerous
    (h : Equinumerous α α') :
    Equinumerous (CardinalProduct α β) (CardinalProduct α' β)
```

`CardinalProduct` 是本库公开定义，良定义性定理是公开接口。`Equiv.prodCongr` 是 mathlib 实现桥，负责把两个坐标上的等价组合为积类型等价。

# 思维脉络（thinking trace）

由 `h` 取出 `e : α ≃ α'`，在第一坐标应用 `e`，第二坐标使用恒等等价。`Equiv.prodCongr e (Equiv.refl β)` 同时给出正向、逆向及互逆证明，于是积类型等势。证明只关心坐标搬运，不调用数值乘法。

# 自然语言 ↔ Lean 映射

- “笛卡尔积” ↔ `α × β`。
- “同时各选一个” ↔ 元素 `(a,b)`。
- “基数积” ↔ `CardinalProduct α β` 的大小。
- “逐坐标搬运” ↔ `Equiv.prodCongr e (Equiv.refl β)`，属于证明后端。

# 依赖（人话版）

依赖等势定义和 Lean 的积类型。mathlib 的 `Equiv.prodCongr` 提供组合等价；本条不依赖乘法交换律、选择公理或关于无限基数乘积的化简定理。

# 应用与陷阱

用于成对选择、网格和多坐标状态空间的计数。有序对的两个位置角色不同，不能换成无序二元集合。`α × β` 与 `β × α` 不是定义相等；交换律需要另构造交换坐标的双射。
