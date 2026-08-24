---
id: settheory.cardinal.cantor-bernstein
kind: theorem
state: verified
title: "Cantor–Bernstein 定理"
premises: ["settheory.cardinal.equinumerous", "settheory.cardinal.comparison"]
mathlib: ["Embedding.schroeder_bernstein", "Equiv.ofBijective"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 3: Cantor-Bernstein Theorem"}
---

# 动机

直接构造无限集合之间的双射往往困难，但构造单射比较容易。Cantor–Bernstein 允许把“两个方向
都放得进去”升级成“一一配对”，是基数比较中最常用的工具。

# 陈述（自然语言）

若存在单射 `f : α → β` 和单射 `g : β → α`，则存在双射 `α ≃ β`，所以两集合等势。

# 为什么不能简单说两个单射互为逆

`f`、`g` 完全可能彼此无关。复合 `g∘f` 只是 `α` 到自身的单射，并不保证为恒等映射；因此不能
把 `g` 直接当作 `f` 的逆。定理必须从二者重新挑选配对边。

# 图像化证明思路

把 `α`、`β` 的元素画成左右两列；从每个 `α` 点画一条 `f` 边到 `β`，从每个 `β` 点画一条
`g` 边回 `α`。由于两函数单射，每个点的入边至多一条。连通分量会成为双向无限链、环、单向链
或有限起始链。在不同类型的分量上选择正向 `f` 边或反向 `g` 边，就能让每个点恰好配对一次。

# 陈述（Lean 对照）

`cantor_bernstein hαβ hβα : Equinumerous α β`。

# 思维脉络

先从两个 `CardinalLE` 前提取出函数和单射证明。mathlib 的
`Embedding.schroeder_bernstein` 完成分量选择，返回一个双射函数；再用
`Equiv.ofBijective` 打包成本库 `Equinumerous` 所要求的等价。

# 一个典型用法

要证明开区间 `(0,1)` 与实数等势，可先给出 `(0,1)→ℝ` 的包含单射，再构造把 `ℝ` 压缩进
`(0,1)` 的单射，例如使用单调压缩函数。无需显式写出两者互逆，Cantor–Bernstein 自动补全。

# 应用与陷阱

- 必须有两个相反方向的单射；两个同方向单射没有帮助。
- 结论保证存在某个双射，不保证它等于输入的任一函数。
- 该定理不依赖先把所有集合良序化，是基数反对称性的核心。
