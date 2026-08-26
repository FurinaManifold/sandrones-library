---
id: functional-analysis.banach-algebra.foundation
family: functional-analysis.spectrum
variant: complex-unital-and-unitization
kind: definition
state: verified
title: 复 Banach 代数基础
summary: 复 Banach 代数的 Mathlib 挂靠、单位化与 Neumann 级数求逆
premises: [functional-analysis.operator-space]
mathlib: [NormedRing, NormedAlgebra, CompleteSpace, Unitization, Units.oneSub]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 定义挂靠

复 Banach 代数不是本库新建的结构。Mathlib 用同一类型上的 `NormedRing`、`NormedAlgebra ℂ A` 与
`CompleteSpace A` 共同表达“完备复赋范代数”；本课程讨论的幺代数还使用 `NormOneClass A`，明确
单位元范数为一。`NormedRing` 已包含 `‖ab‖ ≤ ‖a‖‖b‖`，因此无需另造乘法连续性字段。

这组 typeclass 是一个概念的分层承载，不意味着要定义新的 `BanachAlgebra` carrier。后续谱、预解
集和谱半径均直接作用于这个 Mathlib 代数。

# 单位化

非幺复 Banach 代数使用 Mathlib `Unitization ℂ B`。在 `RegularNormedAlgebra ℂ B` 的标准兼容性
假设下，单位化带 `NormedRing`、`NormedAlgebra ℂ` 和 `CompleteSpace` 实例；典范嵌入
`B → Unitization ℂ B` 是等距映射，所以原空间的范数和完备结构没有被悄悄替换。

# Neumann 级数

若 `‖a‖<1`，完备性与次乘性保证 `∑ₙ aⁿ` 收敛。Mathlib 的
`hasSum_geom_series_inverse` 将其和识别为环论逆元 `Ring.inverse (1-a)`，而
`isUnit_one_sub_of_norm_lt_one` 说明 `1-a` 确实可逆。这正是教材中开映射式谱论计算的基本局部工具。

有界算子 `E →L[ℂ] E` 已经拥有上述复 Banach 代数实例；因此同一 Neumann 级数结论直接给出
`‖T‖<1 → I-T` 可逆，不需要把连续线性映射重新包装成另一种算子代数。

# Lean 对照

- `banachAlgebra_norm_mul_le`：乘法次乘性；
- `banachAlgebra_hasSum_geometric_inverse`、`banachAlgebra_one_sub_isUnit`：Neumann 级数与可逆性；
- `complexUnitization_complete`、`complexUnitization_inclusion_isometry`：单位化的完备性和等距嵌入；
- `operator_hasSum_geometric_inverse`、`operator_one_sub_isUnit`：有界算子代数实例。

# 边界

本条只讲清 Banach 代数定义承载、单位化与几何级数求逆，不把谱、预解集、谱半径或谱非空紧致
混入 foundation。F6.2 在本 handoff 后按 Main 协议自动开放，F6.3 以后仍服从原冻结门。
