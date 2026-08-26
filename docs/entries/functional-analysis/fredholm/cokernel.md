---
id: functional-analysis.fredholm.cokernel
family: functional-analysis.fredholm
variant: identity-minus-compact-finite-cokernel
kind: theorem
state: verified
title: 恒等减紧算子的余核有限维
summary: 由闭值域零化子刻画和 Schauder 对偶紧性证明 I-K 的余核有限维
premises: [functional-analysis.fredholm.alternative, functional-analysis.compact-operator.dual, functional-analysis.closed-range]
mathlib: [Module.Dual, LinearMap.quotKerEquivRange, Submodule.Quotient, FiniteDimensional]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 问题与定义

对连续线性算子 `D : E → E`，余核是商空间 `E / range(D)`。它衡量值域离整个陪域还缺少多少个
独立方向。这里直接采用 Mathlib 的子空间商，不另造 cokernel 类型。

# 证明主线

若 `D` 的值域闭，则向量 `y` 在对偶算子核上给出的取值泛函为零，当且仅当 `y` 属于 `range(D)`。
因此 `E / range(D)` 嵌入对偶核的代数对偶。取 `D=I-K` 时，Schauder 定理说明 `K` 的对偶仍紧，
第一窗的有限维核结论于是作用于 `I-K'`；对偶核有限维，其代数对偶与上述余核也都有限维。

# Lean 对照与边界

`evaluationOnDualKernel` 是典范取值映射；`evaluationOnDualKernel_ker_eq_range` 给出闭值域下的核刻画；
`finiteDimensional_cokernel_identitySubCompact` 得到结论。证明依赖值域闭性和对偶紧性，不调用最终
Fredholm alternative，也没有由有限维核直接跳到有限维余核。

# 易混点

- 余核是陪域模掉值域，不是算子的核。
- 若没有闭值域，零化子只恢复值域闭包，不能使用这里的精确核等式。
- 有限维结论针对 `I-K`；它不是任意闭值域算子的结论。
