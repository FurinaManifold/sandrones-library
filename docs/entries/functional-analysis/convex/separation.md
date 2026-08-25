---
id: functional-analysis.convex.separation
kind: theorem
state: verified
title: 凸集的 Hahn–Banach 分离定理
premises: [functional-analysis.hahn-banach.extension, functional-analysis.hahn-banach.norming-functional]
mathlib: [Convex, gauge, separate_convex_open_set, geometric_hahn_banach_closed_point]
provenance: {source_type: book, ref: "Bühler–Salamon, Functional Analysis, Section 2.3.3"}
---

# 动机

线性泛函把向量空间投影到实直线。如果两个凸集不相交，希望找到一个投影，使一个集合落在某个
阈值左边，另一个落在右边；阈值的原像就是分隔它们的超平面。这把几何不交性转化成可计算的
线性不等式。

# 教材定义与正式承载

凸集直接使用 Mathlib 的 `Convex ℝ s`：任意两点间的线段仍在集合内。分离泛函直接使用连续对偶
`StrongDual ℝ E`。若 `s` 是包含零的吸收凸集，其 Minkowski 泛函 `gauge s x` 衡量把 `s` 放大到
首次包含 `x` 所需的尺度；凸性给出次可加性，正缩放给出正齐次性，因此上一条 Hahn–Banach 支配
延拓可以产生分离泛函。本库直接使用 Mathlib 的 `gauge` 和几何分离链，不另造凸集、半空间或
Minkowski 泛函定义。

# 陈述（自然语言）

包含零的开凸集和集合外一点可由取值 `1` 的连续线性泛函严格分离。两个不交开凸集可被同一水平
严格分到两侧。闭凸集和外点也可严格分离；因此闭凸集恰是所有包含它的闭半空间之交。

# 陈述（Lean 对照）

四种形式分别对应 `separate_open_convex_neighborhood`、`separate_disjoint_open_convex`、
`separate_closed_convex_point` 和 `closedConvex_eq_iInter_halfSpaces`。

# 思维脉络

先平移问题，使零落在一个开凸集合中，并让待分离点位于集合外。Minkowski 泛函在集合内严格小于
一，在外点处至少为一。把外点张成的一维子空间上的坐标泛函用 Hahn–Banach 延拓，同时保持受
Minkowski 泛函支配，便得到所需连续线性泛函。两个集合的情形应用于差集 `s-t`；闭集情形先用
局部凸空间中的不交凸邻域拉开正距离，再应用开集分离。最后逐个分离所有外点得到半空间交刻画。

# 自然语言 ↔ Lean 映射

- 凸集：`Convex ℝ s`。
- 开集、闭集：`IsOpen s`、`IsClosed s`。
- 不交：`Disjoint s t`。
- 分离泛函：`f : StrongDual ℝ E`。
- Minkowski 泛函：`gauge s x`，作为 Mathlib 几何 Hahn–Banach 的证明后端。
- 闭半空间交：`iInter_halfSpaces_eq`。

# 依赖

依赖 Hahn–Banach 的支配延拓和范数化泛函出口。下一条子空间零化子会把闭凸集分离专门化到线性
子空间；F4 的弱拓扑课程也将使用连续对偶决定的半空间。

# 应用与边界

本条工作在实赋范空间；范数拓扑自动提供所需的局部凸结构。开集分离与闭集分离的严格程度不同，
源码分别保留准确前提。没有声称两个任意闭凸集总能严格分离：通常还需要一侧紧致、正距离或其他
条件。这里也不讨论复泛函的实部版本。
