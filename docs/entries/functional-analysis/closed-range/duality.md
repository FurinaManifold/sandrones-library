---
id: functional-analysis.closed-range.duality
kind: theorem
state: verified
title: 原算子与对偶算子的闭值域等价
summary: 原算子与对偶算子的值域范数闭性等价，并统一给出四项闭值域刻画
premises: [functional-analysis.closed-range.double-annihilator, functional-analysis.weak-star.banach-dieudonne]
mathlib: [ContinuousLinearMap.exists_preimage_norm_le, IsCompact.image, StrongDual.polarSubmodule]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

闭值域定理不只刻画原算子的值域：它还说明原算子和对偶算子的值域是否范数闭完全同步。
这一对称形式把零化子刻画、对偶值域闭性和共同零点恢复统一在同一条等价链中。

# 教材概念与正式承载

原算子为 `T : E →L[ℝ] F`，对偶算子沿用 `dualOperator T`。两侧闭性分别使用
`IsClosed (Set.range T)` 与 `IsClosed ((dualOperator T).range : Set (StrongDual ℝ E))`；
没有另设“闭值域算子”谓词或平行对偶空间接口。

# 陈述（自然语言）

在实 Banach 空间之间，连续线性算子的值域范数闭，当且仅当其对偶算子的值域范数闭。
这也等价于对偶值域等于原核的连续零化子，并等价于原值域是对偶核中所有函数的共同零点。

# 陈述（Lean 对照）

范数闭性的对称形式是 `isClosed_range_iff_dualOperator_range_isClosed`；共同零点形式是
`isClosed_range_iff_forall_mem_range_iff_dualOperator_ker`；三项伴随原闭性合并为
`closedRange_four_way`。

# 证明思路

困难方向从对偶值域范数闭出发。开映射定理为对偶值域单位截面提供统一有界原像，
所以其弱星像是弱星紧球连续像与弱星单位球的交，因而弱星闭。Banach--Dieudonné 判据
再将这一局部闭性提升为整个对偶值域的弱星闭性。若某个消去原核的函数不在对偶值域，
弱星分离给出一个向量；在该向量的算子像上取范数化函数便产生矛盾。

# 自然语言 ↔ Lean 映射

- 对偶值域单位截面：`dualUnitSlice (dualOperator T).range`。
- 范数对偶到弱星对偶：`weakStarImage`、`WeakDual.toStrongDual`。
- 统一有界原像：`ContinuousLinearMap.exists_preimage_norm_le`。
- 原核的零化子：`StrongDual.polarSubmodule ℝ T.ker`。

# 应用与边界

本条完成的是实 Banach 空间上连续线性算子的闭值域等价，不涉及复数标量推广，
也不推出 Fredholm 备择、Fredholm 指数稳定性或紧扰动结论。证明中的弱星拓扑只用于桥接，
最终对称陈述两侧均是范数拓扑下的闭性。

# Mathlib 对接说明

Mathlib 提供开映射的受控原像、弱星闭球紧性和对偶/弱对偶的基础接口，但没有直接提供本条
闭值域对称定理。本库只组合这些后端并沿用既有 `dualOperator` 教材命名，不复制 Mathlib 接口。
