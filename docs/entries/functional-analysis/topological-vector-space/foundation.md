---
id: functional-analysis.topological-vector-space.foundation
kind: definition
state: verified
title: 拓扑向量空间基础
premises: []
mathlib: [IsTopologicalAddGroup, Module, ContinuousSMul, Homeomorph.addLeft]
provenance: {source_type: book, ref: buehler-salamon-functional-analysis-2018}
---

# 动机

弱拓扑与弱星拓扑首先是向量空间上的拓扑：向量加法、取负和标量乘法必须与拓扑相容。
把这层结构讲清楚，才能区分“仅有拓扑和线性结构”与真正的拓扑向量空间。

# 教材定义与正式承载

实拓扑向量空间是实向量空间 `Module ℝ E`，其加法群拓扑由 `IsTopologicalAddGroup E` 承载，
标量乘法的联合连续性由 `ContinuousSMul ℝ E` 承载。Mathlib 将这些正交职责拆成 typeclass，
而不建立单一的 `TopologicalVectorSpace` 包装结构；本库沿用这一组合。

# 陈述（自然语言）

向量加法、取负和标量乘法连续。对任意固定向量作平移是自同胚，所以任意点附近的拓扑问题可以
等价地平移到零向量附近。

# 陈述（Lean 对照）

三项连续性分别对应 `topologicalVectorSpace_add_continuous`、
`topologicalVectorSpace_neg_continuous`、`topologicalVectorSpace_smul_continuous`；平移自同胚
对应 `topologicalVectorSpace_translation`。

# 思维脉络

`IsTopologicalAddGroup` 同时提供加法和取负的连续性。`ContinuousSMul` 要求 `(a, x) ↦ a • x`
联合连续，强于只固定一个变量时的连续。连续加法和连续取负使 `x ↦ a + x` 与
`x ↦ -a + x` 互为连续逆，从而得到平移自同胚。

# 自然语言 ↔ Lean 映射

- 拓扑加法群：`IsTopologicalAddGroup E`。
- 实向量空间：`Module ℝ E`。
- 联合连续数乘：`ContinuousSMul ℝ E`。
- 固定向量平移：`Homeomorph.addLeft a`。

# 应用与边界

赋范空间自动具有上述结构，但一般拓扑向量空间不必来自范数。本条只固定最基础的结构接口，
不把局部凸性、弱拓扑或弱星拓扑塞入定义；这些性质由后续条目分别挂靠。
