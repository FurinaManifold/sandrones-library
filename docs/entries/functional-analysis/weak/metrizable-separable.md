---
id: functional-analysis.weak.metrizable-separable
kind: theorem
state: verified
title: 可分空间对偶球的弱星可度量化与序列抽取
premises: [functional-analysis.banach-alaoglu, functional-analysis.weak-star.definition]
mathlib: [WeakDual.metrizable_of_isCompact, WeakDual.isSeqCompact_closedBall]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

一般紧致性只保证网或滤子的收敛子网，未必能用序列描述。原空间可分时，对偶球上的弱星拓扑
可度量化，于是 Banach–Alaoglu 的紧致性可以转化为熟悉的收敛子列结论。

# 教材定义与正式承载

弱星空间仍由 `WeakDual ℝ E` 承载。可分性使用 `TopologicalSpace.SeparableSpace E`；紧子集的
可度量化直接使用 `WeakDual.metrizable_of_isCompact`，闭球的序列紧致直接使用
`WeakDual.isSeqCompact_closedBall`。本条不选择或固定一条本地度量。

# 陈述（自然语言）

若实赋范空间可分，则其弱星对偶的每个紧子集可度量化；连续对偶的每个范数闭球弱星序列紧。
特别地，闭单位球中的任意序列都有一个弱星收敛子列，且极限仍属于闭单位球。

# 陈述（Lean 对照）

紧子集可度量化、闭球序列紧与闭单位球序列抽取分别对应
`weakStar_metrizable_of_isCompact`、`weakStar_isSeqCompact_closedBall` 和
`exists_weakStar_convergent_subsequence_of_norm_le_one`。

# 思维脉络

可分原空间提供可数稠密向量族，它们的求值函数分离弱星对偶中的点；紧空间上，可数连续分离族
导出可度量化。Banach–Alaoglu 已给出对偶闭球弱星紧致，所以在该可度量空间中得到序列紧致，
再把 `IsSeqCompact` 展开即可抽取严格递增的子列指标。

# 自然语言 ↔ Lean 映射

- 原空间可分：`TopologicalSpace.SeparableSpace E`。
- 弱星紧子集：`K : Set (WeakDual ℝ E)` 与 `IsCompact K`。
- 对偶范数闭球：`WeakDual.toStrongDual ⁻¹' Metric.closedBall f r`。
- 收敛子列：严格递增 `φ : ℕ → ℕ` 与弱星空间中的 `Tendsto`。

# 应用与边界

可度量化只断言紧子集的子类型具有某个兼容度量，不声称整个弱星对偶可度量化，也不把弱星拓扑
等同于范数拓扑。若原空间不可分，本条的序列结论不能由 Banach–Alaoglu 单独推出。
