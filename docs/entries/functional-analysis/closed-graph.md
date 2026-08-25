---
id: functional-analysis.closed-graph
kind: theorem
state: staging
title: Banach 闭图定理
premises: [functional-analysis.open-mapping]
mathlib: [LinearMap.graph, LinearMap.continuous_of_isClosed_graph, ContinuousLinearMap.ofIsClosedGraph]
provenance: {source_type: book, ref: "Conway, A Course in Functional Analysis, Chapter II"}
---

# 动机

直接验证线性映射连续有时很困难，而验证“输入和输出同时收敛时极限关系不丢失”往往更自然。闭图
定理把这种图像的闭性转化为连续性，是分析中识别有界算子的核心工具。

# 教材定义与正式承载

线性映射 `T : E →ₗ[ℝ] F` 的图是所有 `(x,T x)` 组成的线性子空间，Mathlib 直接写作
`T.graph : Submodule ℝ (E × F)`。闭图条件是 `IsClosed (T.graph : Set (E × F))`。这与教材定义
完全一致，因此不建立“闭图线性映射”包装结构。

# 陈述（自然语言）

设 `E,F` 是 Banach 空间。若线性映射 `T : E → F` 的图在乘积空间中闭，则 `T` 连续，因而可打包
成取值相同的连续线性映射。等价的实用判据是：只要 `xₙ→x` 且 `Txₙ→y` 总能推出 `y=Tx`，就可
断定 `T` 连续。

# 陈述（Lean 对照）

对应 `linearMap_continuous_of_isClosed_graph`、`exists_continuousLinearMap_of_isClosed_graph` 和
`linearMap_continuous_of_sequential_closed_graph`。

# 思维脉络

闭图本身是乘积 Banach 空间的闭子空间，因而也是 Banach 空间。图到定义域的第一坐标投影是连续
线性双射；开映射／有界逆思想说明其逆连续。再与第二坐标投影复合，就得到原线性映射的连续性。
在度量空间中，闭集可由序列极限刻画，于是得到序列版本。

# 自然语言 ↔ Lean 映射

- 线性映射：`T : E →ₗ[ℝ] F`。
- 图：`T.graph : Submodule ℝ (E × F)`。
- 闭图：`IsClosed (T.graph : Set (E × F))`。
- 连续性：`Continuous T`。
- 序列复合：`T ∘ u`；收敛仍用 `Tendsto ... atTop (nhds ...)`。

# 依赖

依赖 F1 的 Banach 空间与连续线性映射，以及本批开映射定理背后的有界逆机制。

# 应用与边界

本条讨论处处定义的线性映射。无界算子通常只在稠密子空间上定义，其闭性、可闭性和图范数属于
高级泛函分析，不由本条的 `LinearMap` 接口覆盖。
