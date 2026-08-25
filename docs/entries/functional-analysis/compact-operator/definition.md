---
id: functional-analysis.compact-operator.definition
family: functional-analysis.compact-operator
variant: textbook-unit-ball
kind: definition
state: verified
title: 紧算子与单位球像刻画
summary: 用单位球像相对紧刻画紧算子，并给出零算子、有限维情形和恒等算子判据
premises: [functional-analysis.operator.space]
mathlib: [IsCompactOperator, isCompactOperator_iff_isCompact_closure_image_ball, compactOperator]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

紧算子把有界向量族送到具有收敛子网的相对紧集合，是有限维线性代数在无限维空间中的重要替代。
它仍是普通有界线性算子，只额外满足像集紧性条件。

# 教材定义与正式承载

Mathlib 用谓词 `IsCompactOperator T` 表达紧性，并用 `compactOperator` 收集连续线性映射空间中的
所有紧算子。本库不建立 `CompactOperator` 包装类型。对赋范空间，教材中“单位球像相对紧”精确
对应 `closure (T '' Metric.ball 0 1)` 紧致。

# 陈述（自然语言）

连续线性映射紧，当且仅当开单位球像的闭包紧。零算子紧；定义域或值域有限维的连续线性映射紧；
恒等算子紧当且仅当空间有限维。

# 陈述（Lean 对照）

这些结论依次对应 `compactOperator_iff_isCompact_closure_image_unitBall`、
`zero_isCompactOperator`、`isCompactOperator_of_finiteDimensional_domain`、
`isCompactOperator_of_finiteDimensional_codomain` 与
`identity_isCompactOperator_iff_finiteDimensional`。

# 思维脉络

紧性的 Mathlib 原始定义使用“某个零邻域的像包含在紧集中”，它与单位球像相对紧等价。有限维
空间局部紧，因此以有限维空间为定义域或值域时可直接用局部紧性得到紧算子。恒等算子的结论说明
无限维闭单位球不会在范数拓扑下紧致。

# 自然语言 ↔ Lean 映射

- 有界线性算子：`E →L[ℝ] F`。
- 紧性：`IsCompactOperator T`。
- 相对紧：集合的 `closure` 满足 `IsCompact`。
- 紧算子子模：`compactOperator`。

# 应用与边界

这里的紧致性在值域的范数拓扑中讨论，与弱紧致或弱星紧致不同。本条不进入 Fredholm 理论，也
不声称所有无限维算子都非紧；有限秩算子和许多积分算子是典型紧算子。
