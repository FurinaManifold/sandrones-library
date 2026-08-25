---
id: functional-analysis.banach-series.absolute-summable
kind: theorem
state: staging
title: Banach 空间中绝对可和蕴含可和
premises: [topology.normed-space.banach]
mathlib: [Summable, HasSum, Summable.of_norm, norm_tsum_le_tsum_norm]
provenance: {source_type: book, ref: "Conway, A Course in Functional Analysis, Chapter I"}
---

# 动机

实数级数中“绝对收敛蕴含收敛”是基本判别法；在向量值级数中，对应结论依赖目标空间的
完备性，因而是 Banach 空间定义的首个核心应用。

# 教材定义与正式承载

教材中的向量级数 `∑ f n` 收敛，意为其有限部分和收敛；Mathlib 的 `Summable f` 和
`HasSum f x` 正好表达这一语义。绝对可和直接写成 `Summable (fun n ↦ ‖f n‖)`。这些量词和
语义完全一致，因此本库不另设 `VectorSeries` 或“绝对可和”包装谓词。

# 陈述（自然语言）

设 `E` 是 Banach 空间。若实数级数 `∑ ‖f n‖` 收敛，则向量级数 `∑ f n` 收敛；它的普通
部分和趋于其级数和，并且级数和的范数不超过各项范数之和。

# 陈述（Lean 对照）

对应 `summable_of_summable_norm`、`tendsto_partialSums_tsum_of_summable_norm` 和
`norm_tsum_le_tsum_norm_of_summable`。

# 思维脉络

范数级数收敛使任意尾段的范数和足够小，三角不等式进而使向量部分和成为 Cauchy 序列。
Banach 完备性给出其极限。Mathlib 已实现这一证明，本条复用它并显式展示教材最常使用的
部分和收敛与总和估计。

# 自然语言 ↔ Lean 映射

- Banach 空间：`[BanachSpace E]`，即底层 `[CompleteSpace E]`。
- 绝对可和：`Summable (fun n ↦ ‖f n‖)`。
- 向量级数可和：`Summable f`。
- 第 `N` 个部分和：`∑ n ∈ Finset.range N, f n`。
- 级数和：`∑' n, f n`。

# 依赖

依赖赋范空间的三角不等式和 `topology.normed-space.banach` 所解释的完备性。

# 应用与边界

完备性不可无故删除：非完备赋范空间中的绝对可和级数，其部分和极限可能只存在于完备化中。
本条只解释和导出核心结论，不全面复制 Mathlib 的重排、比较或无条件可和接口。
