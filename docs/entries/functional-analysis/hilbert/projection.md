---
id: functional-analysis.hilbert.projection
kind: theorem
state: staging
title: Hilbert 空间的闭子空间正交投影
premises: [linear-algebra.inner-product, topology.normed-space.banach, functional-analysis.subspace.quotient]
mathlib: [Submodule.HasOrthogonalProjection, Submodule.starProjection, Submodule.starProjection_minimal]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

有限维欧氏空间中，把向量投影到子空间是解最小距离问题的基本工具。Hilbert 空间的完备性使同一
结论在无限维闭子空间中仍成立，并产生正交分解、Riesz 表示和谱理论的基础接口。

# 教材定义与正式承载

Hilbert 空间由实内积结构 `InnerProductSpace ℝ E` 与完备性 `BanachSpace E` 共同承载。闭线性
子空间仍写作 `S : Submodule ℝ E` 加 `IsClosed (S : Set E)`。Mathlib 的
`S.starProjection : E →L[ℝ] E` 正是把向量映到 `S` 中最近点的正交投影；不再建立本地投影定义。

# 陈述（自然语言）

Hilbert 空间的每个闭线性子空间 `S` 都存在正交投影。对任意 `x`，投影 `P_Sx` 属于 `S`，余项
`x-P_Sx` 属于正交补 `S⊥`，而且 `P_Sx` 在 `S` 中使距离 `‖x-y‖` 达到最小。

# 陈述（Lean 对照）

对应 `closedSubspace_hasOrthogonalProjection`、`closedSubspace_starProjection_mem`、
`closedSubspace_sub_starProjection_mem_orthogonal` 和 `closedSubspace_starProjection_minimal`。

# 思维脉络

在闭子空间中取趋近距离下确界的点列。平行四边形恒等式说明它是 Cauchy 序列；闭性和 Hilbert
完备性给出子空间中的极限。沿任意子空间方向作实参数扰动，最小性迫使余项与每个子空间向量内积
为零。反过来，勾股恒等式说明满足该正交条件的点就是唯一最近点。

# 自然语言 ↔ Lean 映射

- Hilbert 空间：`[InnerProductSpace ℝ E] [BanachSpace E]`。
- 闭线性子空间：`S : Submodule ℝ E` 与 `hS : IsClosed (S : Set E)`。
- 正交投影：`S.starProjection x`。
- 正交补：`Sᗮ`。
- 最近距离：`⨅ y : S, ‖x-y‖`。

# 依赖

依赖线性代数的内积与正交概念、F1 的 Banach 完备性和闭子空间接口。

# 应用与边界

闭性保证子空间本身完备；对非闭子空间，距离下确界可能无法在子空间内达到。本条专注线性子空间
投影，闭凸集的一般最近点定理只作为 Mathlib 构造后端，不在此扩展完整凸分析接口。
