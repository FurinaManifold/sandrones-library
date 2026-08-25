---
id: functional-analysis.hilbert.unitary
kind: theorem
state: verified
title: Hilbert 空间之间的酉算子
premises: [functional-analysis.hilbert.adjoint, functional-analysis.hilbert.orthonormal-basis]
mathlib: [LinearIsometryEquiv, LinearIsometryEquiv.adjoint_eq_symm]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

酉算子是 Hilbert 空间中的刚性坐标变换：它既不改变长度，也不改变夹角，并且每个目标向量都有
唯一原像。因此同一几何对象可以在不同正交坐标系之间无损搬运。

# 教材定义与正式承载

两个实 Hilbert 空间之间的酉算子，是双射的线性等距映射。Mathlib 的
`LinearIsometryEquiv ℝ E F` 恰好把线性、范数保持和可逆性打包在一起；内积保持由实内积空间的
极化恒等式随之得到。本库直接使用该结构，不另造 `UnitaryOperator`。当始域和终域相同时，Mathlib
也有连续线性自同态代数中的 `unitary (E →L[ℝ] E)`；它与这里的等距等价有现成对应，但不是本条
陈述必须额外复制的第二套定义。

# 陈述（自然语言）

酉算子保持内积与范数，其伴随等于逆算子；两个酉算子的复合仍是酉算子，并按普通函数复合方式
作用于向量。

# 陈述（Lean 对照）

内积保持、范数保持、伴随等于逆与复合作用分别对应 `unitary_inner_map_map`、`unitary_norm_map`、
`unitary_adjoint_eq_inverse` 和 `unitary_trans_apply`。

# 思维脉络

`LinearIsometryEquiv` 已把等距与双射作为数据冻结。范数保持是其字段；实内积保持由范数和极化
恒等式恢复。把内积保持公式与伴随的唯一刻画比较，便得到 `u†=u⁻¹`。复合两个线性等距等价时，
线性、等距和双射分别在复合下保持。

# 自然语言 ↔ Lean 映射

- 酉算子：`u : E ≃ₗᵢ[ℝ] F`。
- 对应有界算子：`(u : E →L[ℝ] F)`。
- 逆酉算子：`u.symm : F ≃ₗᵢ[ℝ] E`。
- 伴随：`ContinuousLinearMap.adjoint (u : E →L[ℝ] F)`。
- 复合：`u.trans v : E ≃ₗᵢ[ℝ] G`。

# 依赖

依赖伴随的内积刻画，并使用正交规范基窗口所固定的 Hilbert 几何语言。后续 F6 有界谱理论可以
用酉等价表达坐标变换和算子共轭。

# 应用与边界

本条固定实 Hilbert 空间，所以更传统的名称是“正交算子”；为与后续复 Hilbert 谱理论统一，课程
沿用“酉算子”。复数域中 `LinearIsometryEquiv` 同样是正式承载。这里只讨论处处定义的有界双射，
不涉及部分等距、无界算子、投影值测度或谱定理。
