---
id: functional-analysis.compact-operator.dual
family: functional-analysis.operator
variant: schauder-dual-compactness
kind: theorem
state: verified
title: 紧算子的对偶仍紧
summary: Banach 空间之间紧算子的 Banach 对偶算子仍是紧算子
premises: [functional-analysis.dual-operator.definition, functional-analysis.compact-operator.definition, functional-analysis.banach-alaoglu]
mathlib: [IsCompactOperator, WeakDual.isCompact_closedBall, ContinuousLinearMap.precomp]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 教材命题

Salamon Theorem 4.2.10(iii) 断言 Banach 空间之间的有界算子 `K` 紧，当且仅当对偶算子 `K*` 紧。
本条交付 Fredholm 第一开发窗所需的正向方向：`K` 紧推出 `K*` 紧。

# 正式承载

紧性直接使用 Mathlib `IsCompactOperator`，对偶算子使用本库对
`ContinuousLinearMap.precomp ℝ` 的教材名 `dualOperator`。Mathlib 当前没有现成的 Schauder
对偶紧性声明，因此本库只补这一缺失的组装定理，不建立紧算子或对偶算子的第二套定义。

# 证明

在弱星对偶单位球上使用 `WeakDual.isCompact_closedBall`。原算子闭单位球像的闭包紧，故对任意
`ε>0` 有有限 `ε/8` 网。有限个网点上的弱星求值控制，结合单位球中两个泛函之差的范数至多为
`2`，推出对偶算子像在算子范数中小于 `3ε/4`。因此弱星紧球在对偶算子下的像范数紧，再由
紧算子的闭单位球像刻画得到 `K*` 紧。

# Lean 对照

公开定理 `dualOperator_isCompactOperator` 对应上述正向方向。弱星球上的连续性提升保持为私有
技术引理，避免把证明后端误当课程接口。

# 边界

本条不另行证明逆向 `K*` 紧推出 `K` 紧；该方向需要双对偶典范嵌入。它也不推出余核有限维、
Fredholm 指数零或最终备择，并且不调用 Mathlib 的最终 FredholmAlternative package。
