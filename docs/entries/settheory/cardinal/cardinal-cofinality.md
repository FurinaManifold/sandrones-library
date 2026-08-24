---
id: settheory.cardinal.cardinal-cofinality
kind: definition
state: verified
title: "基数共尾性：逼近一个基数至少需要多长"
premises: ["settheory.ordinal.cofinality"]
mathlib: ["Cardinal.ord", "Ordinal.cof_ord_le"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 5: Cofinality"}
---

# 动机

基数只回答“有多少元素”，却不能区分一个极限大小需要多少阶段才能逼近。共尾性补充这一信息：它测量越过每个较小阶段所需的最短索引长度。

# 直觉

自然数需要整条可数序列才能逼近，所以 `cf(ℵ₀)=ℵ₀`。巨大的 `ℵ_ω` 却可由 `ℵ₀<ℵ₁<…` 这条可数序列逼近，因此同样具有可数共尾性。共尾性描述“抵达方式的最短长度”，不是再次报告总大小。

# 陈述（自然语言）

一个基数本身没有指定顺序。先取代表它的最小序数，即初始序数，再取该序数的共尾性，定义为基数共尾性。对每个基数 `c`，其共尾性不超过 `c`。本条只公开该定义和上界；具体基数的等式需要额外定理。

# 陈述（Lean 对照）

```lean
noncomputable def CardinalCofinality (c : Cardinal) : Cardinal := c.ord.cof

theorem cardinalCofinality_le (c : Cardinal) :
    CardinalCofinality c ≤ c
```

`c.ord` 将基数换成其初始序数，`Ordinal.cof` 再计算序数共尾性。`noncomputable` 反映这一经典结构不是数值算法。

# 思维脉络（thinking trace）

要谈递增逼近，必须先恢复一个规范的良序代表；任取良序会引入不必要选择，因此使用最小代表 `c.ord`。随后复用序数共尾性。最后用 `Ordinal.cof_ord_le` 把序数侧的上界传回基数侧，从而得到 `cf(c)≤c`。

# 自然语言 ↔ Lean 映射

- 基数的初始序数 ↔ `c.ord`。
- 最短共尾长度 ↔ `c.ord.cof`。
- 基数共尾性 ↔ `CardinalCofinality c`，公开定义。
- 共尾性不超过自身 ↔ `cardinalCofinality_le c`，公开定理。
- `Ordinal.cof_ord_le` ↔ 上界证明的 mathlib 后端。

# 依赖（人话版）

需要先理解序数共尾性以及“基数由初始序数代表”。不需要先知道正则、奇异分类；相反，本条正是那组定义的依赖入口。

# 应用与陷阱

共尾性用于定义正则／奇异基数，并出现在 König 定理的幂指数推论中。给出一条可数共尾序列只得到 `cf(c)≤ℵ₀`，要证明等号还须排除有限方案。共尾序列也无需枚举所有元素，只需最终越过每个较小界。
