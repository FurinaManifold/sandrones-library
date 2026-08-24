---
id: settheory.cardinal.beth-hierarchy
kind: definition
state: verified
title: "Beth 层级：反复取幂集产生的无穷"
premises: ["settheory.cardinal.exponentiation", "settheory.cardinal.aleph-hierarchy"]
mathlib: ["Cardinal.beth", "Cardinal.beth_zero", "Cardinal.beth_succ"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 5: Beth Numbers"}
---

# 动机

Aleph 层级按大小枚举全部无限基数，却不告诉我们怎样构造下一层。幂集是一种明确且永远增大的构造。Beth 层级从 `ℵ₀` 出发反复取幂集，用来追踪这条特定的增长路线。

# 直觉

`ℶ₀=ℵ₀`，`ℶ₁=2^ℵ₀` 是自然数所有子集的数量，`ℶ₂=2^ℶ₁`。在极限下标 `λ`，没有可供“再取一次幂集”的直接前项，所以取所有较早层的上确界。Aleph 像完整尺寸表，Beth 则像一台每步按下“取幂集”按钮的机器。

# 陈述（自然语言）

定义 `BethLevel(α)=ℶ_α`。零层是 `ℵ₀`；后继层是二的上一层次幂，也就是上一层集合的幂集基数。本条公开验证零层与后继递推。Cantor 定理说明每个后继步骤严格增长，但该严格性不是本条新登记的 Lean 结论。

# 陈述（Lean 对照）

```lean
noncomputable def BethLevel (o : Ordinal) : Cardinal := Cardinal.beth o

theorem bethLevel_zero_and_successor (o : Ordinal) :
    BethLevel 0 = Cardinal.aleph0 ∧
      BethLevel (Order.succ o) = 2 ^ BethLevel o
```

这里的 `^` 是基数幂：函数空间的基数。底数 `2` 表示二元素类型；从 `X` 到二元素类型的函数与 `X` 的子集一一对应。

# 思维脉络（thinking trace）

先把幂集大小译成基数幂 `2^κ`，由此得到后继规则。再注意超限递归不能只写自然数循环：极限下标必须汇总此前全部阶段。Lean 采用 `Cardinal.beth` 保存完整超限定义，本库的公开定理检验教材最常直接使用的两个计算规则。

# 自然语言 ↔ Lean 映射

- 第 `o` 个 Beth 数 ↔ `BethLevel o`，公开定义。
- 起点 `ℶ₀=ℵ₀` ↔ 合取结论第一项。
- 取幂集 ↔ `2 ^ BethLevel o`，基数函数空间。
- 后继下标 ↔ `Order.succ o`。
- `Cardinal.beth_zero`、`Cardinal.beth_succ` ↔ 证明后端。

# 依赖（人话版）

需要理解基数幂来自函数空间，以及子集可由二值特征函数编码。形式化实现依赖 mathlib 的 Beth 超限递归和前一条 Aleph 起点；不依赖 CH。

# 应用与陷阱

`ℶ₁` 是连续统大小，CH 问它是否等于 `ℵ₁`。不要把 Beth 当成全部无限基数的枚举；它只是幂集迭代形成的子序列。也不要在 `ℶ_ω` 处机械套后继公式：极限层不是某个有限层“再取一次幂集”。
