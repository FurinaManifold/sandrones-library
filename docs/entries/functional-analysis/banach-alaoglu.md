---
id: functional-analysis.banach-alaoglu
kind: theorem
state: staging
title: Banach–Alaoglu 定理
premises: [functional-analysis.weak-star.definition]
mathlib: [WeakDual.isClosed_closedBall, WeakDual.isCompact_closedBall]
provenance: {source_type: book, ref: "Bühler–Salamon, Functional Analysis, Section 3.2"}
---

# 动机

无限维赋范空间中的闭单位球通常不在范数拓扑下紧致。连续对偶的闭单位球改用弱星拓扑后却总是
紧致；这是用拓扑方法抽取广义收敛子网的基本工具。

# 教材定义与正式承载

Mathlib 用 `WeakDual ℝ E` 承载连续对偶的弱星拓扑。它与 `StrongDual ℝ E` 是同一底层线性对象，
但拓扑不同。于是范数闭球作为弱星空间中的集合写成
`WeakDual.toStrongDual ⁻¹' Metric.closedBall f r`。本条直接复用
`WeakDual.isCompact_closedBall`，不建立新的弱星空间、球或紧性谓词。

# 陈述（自然语言）

连续对偶中的每个范数闭球，在弱星拓扑下是闭且紧的；特别地，对偶闭单位球弱星紧致。

# 陈述（Lean 对照）

闭性、任意闭球紧致和闭单位球紧致分别对应 `weakStar_isClosed_closedBall`、
`weakStar_isCompact_closedBall` 与 `weakStar_isCompact_unitBall`。

# 思维脉络

弱星拓扑只测试每个原空间向量上的取值。对偶范数球给出所有这些坐标的一致界，因而能嵌入相应
紧坐标区间的乘积；闭性再把它识别为该紧空间中的闭子集。Mathlib 已完成这条 Tychonoff 证明链，
本条负责固定教材集合与正式类型之间的对应。

# 自然语言 ↔ Lean 映射

- 弱星对偶：`WeakDual ℝ E`。
- 读取对偶范数：`WeakDual.toStrongDual`。
- 半径 `r` 的范数闭球：`Metric.closedBall f r`。
- 弱星紧致：上述闭球在 `WeakDual ℝ E` 中的原像满足 `IsCompact`。

# 应用与边界

本定理给出的是弱星紧致，不是对偶范数紧致，也不是原空间闭单位球的弱紧致。可分空间中的弱星
可度量化与序列紧致属于后续独立条目；“原空间自反当且仅当其闭单位球弱紧”还需要典范双对偶
嵌入与弱拓扑之间的桥，本条不提前声称该结论。
