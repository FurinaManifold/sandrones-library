---
id: settheory.cardinal.equinumerous
kind: definition
state: verified
title: "等势：用双射比较集合大小"
premises: []
mathlib: ["Equiv"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 3: Cardinal Numbers"}
---

# 动机

有限集合可以数完元素再比较个数，无限集合却没有“数到最后”这一步。我们需要一种不依赖枚举终点、同时适用于有限与无限对象的大小相等概念；逐一配对正好满足这一要求。

# 直觉

若 `α` 的每个元素都与 `β` 的唯一元素配对，而且 `β` 中没有遗漏，那么两边同样多。自然数与偶数可由 `n ↦ 2n` 配对，说明无限集合可能与自己的真子集等势；等势比较的是数量，不保留代数、拓扑或次序结构。

# 陈述（自然语言）

类型 `α` 与 `β` 等势，当且仅当二者之间存在双射。等价地，存在函数 `f : α → β`，它既单射又满射。

# 陈述（Lean 对照）

```lean
def Equinumerous (α β : Type*) : Prop := Nonempty (α ≃ β)

theorem equinumerous_iff_exists_bijective {α β : Type*} :
    Equinumerous α β ↔ ∃ f : α → β, Function.Bijective f
```

`Equinumerous` 是本条公开结构；`Equiv` 是 mathlib 中携带正向函数、逆函数及互逆证明的双射数据。定理是两种常用表述之间的公开转换接口。

# 思维脉络（thinking trace）

正向从 `e : α ≃ β` 取出函数 `e`，其 `e.bijective` 已同时给出单射与满射。反向从普通函数及 `Function.Bijective f` 出发，由 `Equiv.ofBijective` 构造逆映射并打包为 `α ≃ β`，最后用 `Nonempty` 隐去具体选择，只保留“存在双射”。

# 自然语言 ↔ Lean 映射

- “`α` 与 `β` 等势” ↔ `Equinumerous α β`。
- “一一对应” ↔ `α ≃ β`，并由 `Nonempty` 表达其存在性。
- “单射且满射” ↔ `Function.Bijective f`。
- “由双射函数构造等价” ↔ `Equiv.ofBijective`，它是证明后端，不是本条另定义的大小概念。

# 依赖（人话版）

数学上只依赖函数、单射、满射和双射的基本概念。Lean 实现依赖 mathlib 的 `Equiv` 与 `Function.Bijective`；不需要选择公理、良序定理或任何后续的基数比较关系。

# 应用与陷阱

等势是后续 `CardinalLE`、Cantor–Bernstein 和基数算术“与代表无关”的基础。任意函数不能证明等势，必须验证双射；真子集也不必严格更小。`Nonempty (α ≃ β)` 只断言某个双射存在，不承诺一个规范或唯一的配对。
