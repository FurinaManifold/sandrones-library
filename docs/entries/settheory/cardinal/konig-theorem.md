---
id: settheory.cardinal.konig-theorem
kind: theorem
state: verified
title: "König 定理：逐坐标的严格不等式不能在和与积之间消失"
premises: ["settheory.cardinal.addition", "settheory.cardinal.multiplication"]
mathlib: ["Cardinal.sum_lt_prod", "Cardinal.lt_power_cof_ord"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 5: König's Theorem"}
---

# 定理在比较哪两类对象

给每个指标 `i` 两个基数 `κᵢ<λᵢ`。左边的基数和 `Σᵢ κᵢ` 表示：先选一个指标，再选该指标
下的一项。右边的基数积 `Πᵢ λᵢ` 表示：对每个指标都同时选一个值，也就是一个完整选择函数。

König 定理断言：

`Σᵢ κᵢ < Πᵢ λᵢ`。

右边不是普通有限乘法，而是依赖函数空间的大小；每个坐标都提供一种避开左边编码的余地。

# 对角线证明的核心

假设有人试图把右边所有选择函数都列入左边的不交并。左边每个元素带有一个来源指标 `i`，
因此可把名单按来源分组。第 `i` 组只有 `κᵢ` 项，却要覆盖第 `i` 坐标的 `λᵢ` 个可能值。
因为 `κᵢ<λᵢ`，总能在该坐标挑一个本组没有覆盖的值。

对每个 `i` 都这样挑选，得到一个函数 `g`。它在第 `i` 坐标上避开第 `i` 组的全部候选，所以
`g` 不属于任何一组，与“名单覆盖整个积”矛盾。这是 Cantor 对角线法的多坐标版本。

# Lean 陈述

```lean
theorem konig_theorem (κ λ : ι → Cardinal)
    (h : ∀ i, κ i < λ i) : Cardinal.sum κ < Cardinal.prod λ
```

形式化证明复用 `Cardinal.sum_lt_prod`。本条的数学内容在于上述逐坐标逃逸构造，而不只是一个
不等式改写。

# 为什么前提必须逐坐标严格

若某个位置只有 `κᵢ≤λᵢ` 而非严格小于，就可能找不到未被该组用过的坐标值，对角选择会在这里
失败。定理不是从总和与总积的粗略大小猜出来的；每个坐标的严格余量都是证明资源。

# 共尾性的关键推论

对无限基数 `κ`，König 定理推出

`κ < κ ^ cf(κ)`。

本库用 `cardinal_lt_power_cofinality` 记录它。直观上，若只用少于 `cf(κ)` 的规模试图控制所有
长度为 `cf(κ)` 的 `κ` 值序列，对角线总能构造出逃逸函数。

# 与 Cantor 定理的关系

Cantor 定理说 `κ<2^κ`；König 定理处理一族坐标，并能导出涉及共尾性的更精细结论。两者都靠
对角化，但前者逐点翻转成员资格，后者在每个坐标避开相应分组已经使用的值。

# 常见混淆

- `Cardinal.sum` 是带标签的不交并大小，`Cardinal.prod` 是所有选择函数的大小。
- 结论是严格小于，不只是“不等于”。
- 不要把基数版 König 定理与图论中的 König 定理混为一谈。
- 共尾性推论要求 `κ` 无限；有限基数不属于这里的使用范围。

