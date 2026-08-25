---
id: functional-analysis.inverse-operator
kind: theorem
state: staging
title: Banach 有界逆定理
premises: [functional-analysis.open-mapping, functional-analysis.operator.space]
mathlib: [LinearEquiv.continuous_symm, LinearEquiv.toContinuousLinearEquivOfContinuous, ContinuousLinearEquiv]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

线性双射的代数逆总是存在，但一般不自动连续。有界逆定理说明，在 Banach 空间之间，连续线性双射
不会产生病态逆映射；正向和反向的拓扑结构自动相容。

# 教材定义与正式承载

代数线性双射直接由 `e : E ≃ₗ[ℝ] F` 承载，其逆是 `e.symm`。若正向连续，Mathlib 的
`LinearEquiv.continuous_symm` 给出逆连续，并可用 `LinearEquiv.toContinuousLinearEquivOfContinuous`
打包为 `E ≃L[ℝ] F`。这些接口与教材语义一致，本库不建立“有界逆算子”结构。

# 陈述（自然语言）

设 `E,F` 是 Banach 空间。若线性双射 `e : E → F` 连续，则其逆映射也连续，因此 `e` 是连续线性
等价。进一步存在非负常数 `C`，使所有 `y ∈ F` 都满足 `‖e⁻¹y‖ ≤ C‖y‖`。

# 陈述（Lean 对照）

对应 `linearEquiv_inverse_continuous`、`linearEquiv_upgrades_to_continuousLinearEquiv` 和
`linearEquiv_inverse_exists_norm_bound`。

# 思维脉络

正向映射是连续线性满射，由开映射定理可知它把开集映为开集。逆映射对开集的原像正是正向映射
下的像，所以逆连续。连续逆打包成连续线性映射后，F1 的算子范数基本估计立即给出定量全局界。

# 自然语言 ↔ Lean 映射

- 代数线性双射：`e : E ≃ₗ[ℝ] F`。
- 代数逆：`e.symm : F ≃ₗ[ℝ] E`。
- 正向连续：`Continuous e`。
- 双向连续线性等价：`E ≃L[ℝ] F`。
- 逆算子范数：打包后 `(eL.symm : F →L[ℝ] E)` 的范数。

# 依赖

依赖开映射定理以及 F1 的连续线性映射、算子范数基本估计。闭图定理是同一 Banach 三大定理链的
另一推论，但不是本条证明的必要前提。

# 应用与边界

两端完备性不可静默省略；在非完备赋范空间中，连续线性双射的逆可能不连续。本条只处理处处定义
的线性双射，不讨论无界算子的预解算子或谱。
