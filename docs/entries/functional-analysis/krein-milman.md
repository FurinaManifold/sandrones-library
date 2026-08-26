---
id: functional-analysis.krein-milman
family: functional-analysis.weak
variant: compact-convex-extreme-points
kind: theorem
state: verified
title: Krein--Milman 定理、face 与极点
summary: 局部凸 Hausdorff 实拓扑向量空间中的非空紧凸集等于其极点集合的闭凸包
premises: [functional-analysis.topological-vector-space.foundation, functional-analysis.hahn-banach.extension]
mathlib: [IsExtreme, Set.extremePoints, closedConvexHull, closure_convexHull_extremePoints]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

紧凸集虽然可能包含无限多个点，却由不能再作非平凡凸分解的极点生成。Krein--Milman 定理把这种
有限维凸几何直觉推广到局部凸拓扑向量空间：必须取极点的凸包再闭包，才能恢复整个紧凸集。

# 教材定义

Salamon Definition 3.5.1 规定：`F ⊆ K` 是 face，如果 `F` 非空、凸，并且 `K` 中一条开线段有
内点落入 `F` 时，两端点都属于 `F`。点 `x ∈ K` 是 extremal point，如果把 `x` 写成 `K` 中
两点的严格凸组合只能得到两个端点都等于 `x`。等价地，singleton `{x}` 满足 face 的极性条件。

# 正式承载

Mathlib `IsExtreme ℝ K F` 承载开线段的极性条件，`K.extremePoints ℝ` 承载极点集合。本库不建立
第二套 face 或 extreme point 谓词。需要注意，`IsExtreme` 本身允许空集且不要求 `F` 凸，因此
教材完整 face 正式写成 `F.Nonempty ∧ Convex ℝ F ∧ IsExtreme ℝ K F`，不能静默把两者混同。

# 展开与桥

`textbookFace_iff_nonempty_convex_isExtreme` 展开完整 face 量词，并同时给出开线段两个端点的归属。
`mem_extremePoints_iff_textbook` 是极点的双端点刻画；
`singleton_isExtreme_iff_mem_extremePoints` 连接 singleton extreme subset 与极点。Mathlib
`IsExtreme` 结构只存一个端点条件，另一个由开线段对称性推出，因此其极性部分与教材一致。

# 定理

Salamon Theorem 3.5.2 断言：实、局部凸、Hausdorff 拓扑向量空间中的紧凸集 `K` 满足
`closedConvexHull ℝ (K.extremePoints ℝ) = K`。若 `K` 非空，则极点集合非空。
Lean 中分别由 `closedConvexHull_extremePoints_eq` 与
`exists_extremePoint_of_nonempty_compact_convex` 组装。

# Lean 对照

局部凸、Hausdorff 与拓扑向量空间假设由 `LocallyConvexSpace ℝ E`、`T2Space E`、
`IsTopologicalAddGroup E` 和 `ContinuousSMul ℝ E` 承载。闭凸包直接使用 `closedConvexHull`；桥
`closedConvexHull_eq_closure_convexHull` 把它连接到 Mathlib 最终定理使用的
`closure (convexHull ...)` 表述。

# 证明思路

定义链证明只展开 `IsExtreme`，并用 `right_mem_of_mem_openSegment` 恢复第二端点。闭凸包等式直接
调用 Mathlib 已成熟的 `closure_convexHull_extremePoints`；极点存在性直接调用更强的
`IsCompact.extremePoints_nonempty`。本库没有重放 Zorn 引理与几何 Hahn--Banach 的五步证明。

# 边界

本条不声称 face 与 `IsExtreme` 无条件同义，不进入有限维 Minkowski--Carathéodory、Choquet 表示、
遍历测度的极点刻画或具体紧凸集的极点计算。Mathlib 的极点存在引理不要求凸性，但课程陈述保留
教材的非空紧凸环境。
