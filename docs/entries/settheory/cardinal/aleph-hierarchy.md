---
id: settheory.cardinal.aleph-hierarchy
kind: definition
state: verified
title: "Aleph 层级：依次编号所有无限基数"
premises: ["settheory.cardinal.finite-set"]
mathlib: ["Cardinal.aleph", "Cardinal.aleph_zero", "Cardinal.succ_aleph"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 5: Alephs"}
---

# 为什么无穷还要编号

Cantor 定理已经说明不存在“最大的集合大小”：给定任何集合，幂集都更大。因此“无限”不是一个
单独的大小，而是许多不同基数组成的层级。Aleph 记号的任务，是按从小到大的顺序为所有无限
基数编号。

# 定义图景

`ℵ₀` 是最小的无限基数，也就是自然数的大小。`ℵ₁` 是严格大于 `ℵ₀` 的最小基数；继续下去，
`ℵ₂` 是 `ℵ₁` 之后的下一个基数。一般地：

- 起点：`ℵ_0 = ℵ₀`；
- 后继：`ℵ_(α+1)` 是严格大于 `ℵ_α` 的最小基数；
- 极限：若 `λ` 没有直接前驱，则 `ℵ_λ` 是所有 `ℵ_α`（`α<λ`）的上确界。

这三句不是普通自然数递推，而是沿全部序数进行的超限递归。

# Lean 接口

```lean
noncomputable def AlephLevel (o : Ordinal) : Cardinal := Cardinal.aleph o
```

`alephLevel_zero_and_successor` 验证起点及后继规则。这里 `Order.succ` 作用在基数上，表示“下一个
严格更大的基数”，不是给集合随便添一个元素。对无限基数而言，集合加一个元素通常不改变大小。

# ℵ₀ 与 ℵ₁

自然数、整数、有理数都具有大小 `ℵ₀`。所有可数序数组成的集合具有大小 `ℵ₁`；因此 `ℵ₁`
是第一个不可数基数。它不是“自然数再加一项”，而是越过全部可数集合大小后的下一档。

# 极限下标的例子

`ℵ_ω` 位于 `ℵ₀,ℵ₁,ℵ₂,…` 全部有限编号层级之上，并且是它们的上确界。它没有紧邻的前一项：
无论选择某个有限 `n`，后面仍有 `ℵ_(n+1)`。这也是后续奇异基数的第一个典型例子。

# 与 Beth 层级的区别

Aleph 层级按顺序列出所有无限基数，不说明相邻两层怎样由集合运算构造。Beth 层级则每一步明确
取幂集。`ℶ₁` 究竟等于 `ℵ₁` 还是跳过若干 aleph，是连续统假设研究的问题。

# 常见混淆

- `ℵ₀` 是基数，`ω` 是最小无限序数；二者分别忘记和保留次序结构。
- 下标可以是任意序数，不限于自然数。
- “后继基数”不是“基数加一”；无限基数加一仍等于自身。

