---
id: functional-analysis.subspace.quotient
kind: theorem
state: verified
title: 闭线性子空间与商 Banach 空间
premises: [topology.normed-space.banach]
mathlib: [Submodule, IsClosed, Submodule.Quotient, QuotientAddGroup.norm_mk, Submodule.Quotient.completeSpace]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

把一个线性子空间中的向量视为零，就得到商向量空间。泛函分析还要求商上的距离能分辨不同陪集，
并希望原空间完备时商空间仍然完备；这正是对子空间增加闭性条件的原因。

# 教材定义与正式承载

教材的线性子空间直接由 Mathlib `Submodule ℝ E` 承载，闭性写作
`IsClosed (S : Set E)`，商空间写作 `E ⧸ S`。陪集 `x + S` 的商范数定义为 `x` 到 `S` 的距离，
即 `infDist x S`。这些接口与教材的对象、等价关系和量词一致，因此不另造“闭子空间”结构、商集
或商范数。

# 陈述（自然语言）

向量 `x` 所在陪集的范数等于 `x` 到子空间的距离，因而不超过 `‖x‖`。一般情况下该范数为零当且
仅当 `x` 属于子空间的闭包；当子空间闭时，这等价于 `x ∈ S`，所以商半范数成为真正的范数。若
原空间还是 Banach 空间，则商空间完备。

# 陈述（Lean 对照）

对应 `quotientNorm_eq_infDist`、`quotientNorm_eq_zero_iff_mem_closure`、
`quotientNorm_eq_zero_iff_mem`、`quotientMap_norm_le` 和 `closedSubspace_quotient_complete`。

# 思维脉络

距离公式把商范数的抽象定义还原成最佳代表元问题。到集合距离为零只保证点落在闭包中，因此非闭
子空间会产生非零陪集但范数为零。闭性恰好排除这一退化。完备性则通过为商空间中的 Cauchy 序列
选择逐步足够短的代表元，把问题提升回原 Banach 空间。

# 自然语言 ↔ Lean 映射

- 线性子空间：`S : Submodule ℝ E`。
- 闭线性子空间：`S` 连同 `hS : IsClosed (S : Set E)`。
- 商空间：`E ⧸ S`，即 `Submodule.Quotient S`。
- 商映射：`Submodule.Quotient.mk`。
- 商范数：商上的标准 `‖·‖`；代表元公式为 `Metric.infDist x S`。

# 依赖

依赖 `topology.normed-space.banach` 的赋范与完备语义，以及点集拓扑中的闭包和闭集。

# 应用与边界

闭性只负责让商范数非退化；Mathlib 在更一般的非闭情形仍提供半范数商及其完备性接口。本条聚焦
教材所称的商 Banach 空间，不展开商映射的通用提升、补空间或同构定理接口。
