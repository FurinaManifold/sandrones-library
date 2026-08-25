---
id: functional-analysis.operator.bounded-iff
kind: theorem
state: verified
title: 线性算子有界与连续等价
premises: [functional-analysis.operator.continuous-linear-map]
mathlib: [LinearMap.mkContinuous, ContinuousLinearMap.le_opNorm]
provenance: {source_type: book, ref: "Conway, A Course in Functional Analysis, Chapter I"}
---

# 动机

全局范数估计适合计算，连续性适合极限论证。线性结构使两种条件等价。

# 直觉

有全局界时，输入趋近零会迫使输出趋近零；反过来，连续线性映射的算子范数给出统一放大倍数。

# 陈述（自然语言）

实赋范空间之间的线性映射连续，当且仅当存在非负实数 `C`，使所有 `x` 都满足
`‖Tx‖≤C‖x‖`。

# 陈述（Lean 对照）

`linearMap_continuous_iff_exists_bound` 直接在 `LinearMap`、`Continuous` 和显式量词之间给出
双向等价；没有引入重复的“有界算子”谓词。

# 思维脉络

正向把连续证明与线性映射临时打包成 `ContinuousLinearMap`，取其范数作为界；反向由显式界调用
`LinearMap.mkContinuous`。打包对象在正向证明中是语义一致的正式承载。

# 自然语言 ↔ Lean 映射

- 线性映射：`T : E →ₗ[ℝ] F`。
- 连续：`Continuous T`。
- 有界：`∃ C, 0 ≤ C ∧ ∀ x, ‖T x‖ ≤ C * ‖x‖`。

# 依赖

依赖上一条对 `ContinuousLinearMap` 的教材解释和全局界刻画。

# 应用与边界

这里的“有界”不是说整个值域集合有界，而是输出范数被输入范数线性控制。没有必要为这个等价条件
再建立本库包装谓词。
