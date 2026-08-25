---
id: functional-analysis.compact-operator.composition
kind: theorem
state: staging
title: 紧算子的理想性质与范数极限
premises: [functional-analysis.compact-operator.definition]
mathlib: [IsCompactOperator.comp_clm, IsCompactOperator.clm_comp, isCompactOperator_of_tendsto]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

紧算子之所以构成算子理想，是因为在它的任一侧复合有界线性映射仍保持紧性。紧算子对算子范数
极限封闭，使有限秩逼近能够产生新的紧算子。

# 教材定义与正式承载

复合仍使用连续线性映射的 `∘L`。紧性继续使用 `IsCompactOperator`；加法与标量乘法在 Mathlib 的
`compactOperator` 子模中已经封装。范数极限就是连续线性映射空间自身拓扑中的 `Tendsto`。

# 陈述（自然语言）

紧算子与任意连续线性映射在左侧或右侧复合后仍紧；两个紧算子的和仍紧。若目标空间完备，紧算子
序列按算子范数收敛，则其极限仍是紧算子。

# 陈述（Lean 对照）

左右复合、加法和范数极限分别对应 `IsCompactOperator.comp_right`、
`IsCompactOperator.comp_left`、`IsCompactOperator.add_clm` 与
`isCompactOperator_of_operatorNorm_tendsto`。

# 思维脉络

预复合连续映射把零邻域拉回零邻域；后复合连续映射把紧集送到紧集。因此两侧复合都保持紧性。
目标完备时，相对紧性可用全有界性刻画，而全有界性在算子范数极限下保持，得到闭性。

# 自然语言 ↔ Lean 映射

- 算子复合：`S ∘L T`。
- 紧算子谓词：`IsCompactOperator`。
- 算子范数收敛：`Tendsto T atTop (nhds S)`。
- 目标完备：`CompleteSpace F`。

# 应用与边界

范数极限结论不是逐点、强算子或弱算子收敛的闭性结论。本文只建立紧算子的理想与闭性基础，
Fredholm 备择和紧扰动下指数稳定性仍处于冻结窗口。
