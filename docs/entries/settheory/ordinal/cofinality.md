---
id: settheory.ordinal.cofinality
kind: definition
state: verified
title: "序数的共尾数"
premises: ["settheory.ordinal.successor-limit", "settheory.ordinal.supremum"]
mathlib: ["Order.cof", "Ordinal.cof_toType", "Ordinal.cof_zero", "Ordinal.cof_add_one", "Ordinal.cof_omega0"]
provenance: {source_type: book, ref: "jech-set-theory-2003"}
---

# 动机
共尾数衡量至少需要多大的集合才能在一个良序中共尾，是研究极限阶段复杂度的尺度。

# 直觉
后继序数只需末端一个点便共尾；自然数序列自身在 `ω` 中共尾，因此其共尾数是 `ℵ₀`。

# 陈述（自然语言）
定义 `ordinalCofinality a := Order.cof a.ToType`，即在序数的规范良序载体上取最小
共尾子集的基数。零、任意后继序数、`ω` 的共尾数分别是零、一、`ℵ₀`。

# 陈述（Lean 对照）
```lean
def ordinalCofinality (a : Ordinal) : Cardinal := Order.cof a.ToType
```

`basic_cofinalities (a)` 使用该定义给出三个基本计算公式。

# 思维脉络（thinking trace）
先在 `a.ToType` 上使用一般线性序的 `Order.cof` 建立公开定义，再用私有桥
`ordinalCofinality_eq_mathlib` 验证它等于 mathlib 的 `a.cof`。三个基本计算只在桥后复用
mathlib 定理，公开陈述不直接出现 `Ordinal.cof`。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| 序数 `a` 的规范良序载体 | `a.ToType` |
| 本库序数共尾数 | `ordinalCofinality a` |
| 可数无限基数 | `Cardinal.aleph0` |

# 依赖（人话版）
后继/极限分类解释三例差异；上确界接口解释共尾族如何逼近极限。

# 什么叫共尾

在线性序 `L` 中，子集 `S` 共尾是说：无论给出多靠后的 `x`，总能在 `S` 里找到 `s` 使
`x≤s`。因此 `S` 一直延伸到整个次序的末端，没有被某个界截住。

共尾数不是“共尾子集的数量”，而是共尾子集可能具有的最小基数。它回答：至少需要多少个代表点，
才能从下方逼近整个序数？

# 三个基本计算

- 零序数中空集已经共尾，所以共尾数为 `0`。
- 后继序数 `succ a` 只取最后一个点就能支配所有前驱，所以共尾数为 `1`。
- `ω` 有可数共尾集；另一方面任何有限子集都有最大元素，无法越过所有自然数，所以其共尾数
  恰为 `ℵ₀`。

# 为什么使用规范载体

序数是良序的同构类，不应假装它天然带有某一套具体元素。本库选择规范代表 `a.ToType`，在上面取
一般线性序的 `Order.cof`。序同构保持共尾数，因此规范代表的选择不改变数学结果。

# 应用与陷阱
共尾数是基数而非序数；`ordinalCofinality a` 的结果类型是 `Cardinal`。原生 `a.cof`
只允许出现在私有验证桥中。
- 后继序数即使非常大，共尾数仍为 `1`；共尾数不等于序数本身大小。
- 证明 `cof(ω)=ℵ₀` 不能只展示一个可数共尾集，还必须排除有限共尾集。
