---
id: functional-analysis.compact-spectrum
family: functional-analysis.compact-spectrum
variant: complex-banach-space
kind: theorem
state: verified
title: 紧算子的非零谱、有限重数与零聚点边界
summary: 非零谱点等于特征值，广义特征空间有限维，且互异谱点序列只能趋于零
premises: [functional-analysis.spectrum.nonempty-compact, functional-analysis.fredholm.alternative-final]
mathlib: [IsCompactOperator.hasEigenvalue_iff_mem_spectrum, Module.End.genEigenspace, isCompactOperator_id_iff_finiteDimensional]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 紧算子的谱

设 `E` 是复 Banach 空间，`T : E →L[ℂ] E` 是紧算子。Salamon Theorem 5.2.8 的核心结论是：

- 每个非零谱点都是特征值；
- 非零特征值具有有限重数；
- 非零谱点是孤立的，因而零是谱唯一可能的聚点。

这里“唯一可能”很重要：在有限维空间或有限秩情形，谱可能是有限集，零未必真是聚点。

# Mathlib 挂靠

谱直接使用连续线性自同态 Banach 代数上的 `spectrum ℂ T`。特征值和广义特征空间分别使用
`Module.End.HasEigenvalue` 与 `Module.End.genEigenspace`；本库不另造谱值或特征空间 carrier。

Mathlib 已经通过紧算子 Fredholm alternative 证明

`HasEigenvalue (T : Module.End ℂ E) μ ↔ μ ∈ spectrum ℂ T`

（假设 `μ ≠ 0`）。本条直接复用这个成熟 iff，而不重复其闭值域／满射证明。

# 有限维广义特征空间

Mathlib 的一般 Banach 紧算子文件没有提供非零特征空间有限维的公共接口；紧自伴 Hilbert 文件
中的同名结论又不适用于这里。证明先对任意紧算子 `K` 建立：`I-K` 的核有限维，且
`(I-K)^n = I-Rₙ`，其中 `Rₙ` 仍紧。因此 `(I-K)^n` 的核对每个有限 `n` 都有限维。

对 `μ ≠ 0` 取 `K = μ⁻¹T`，利用

`T-μI = (-μ)(I-μ⁻¹T)`

便得到每个有限阶 `genEigenspace T μ n` 有限维。普通特征空间是 `n=1` 的情形，另有更轻量的
公开接口 `finiteDimensional_eigenspace_of_compact`。

# 零聚点边界

真正缺失的核心是如下定量形式：对每个 `ε>0`，集合

`{μ ∈ spectrum ℂ T | ε ≤ ‖μ‖}`

有限。反证若该集合无限，选择互异特征值 `μₙ` 及特征向量，并令 `Vₙ` 为前 `n` 个特征向量的
张成。不同特征值的特征向量线性无关，所以 `Vₙ < Vₙ₊₁`。Riesz 引理给出
`xₙ ∈ Vₙ₊₁`，其到 `Vₙ` 的距离至少为一；同时 `‖μₙ‖ ≥ ε` 迫使 `T xₙ` 两两至少相距
`ε`，与紧性矛盾。

由此，任何单射谱点序列最终避开每个远离零的有限谱集，故必趋于零。这是“不假装零一定是聚点”
的精确序列版本。

# Lean 对照

- `compact_hasEigenvalue_iff_mem_spectrum`：非零谱点／特征值判据；
- `finiteDimensional_eigenspace_of_compact`：普通非零特征空间有限维；
- `finiteDimensional_genEigenspace_of_compact`：每个有限阶广义特征空间有限维；
- `finite_spectrum_norm_ge_of_compact`：远离零的谱点有限；
- `tendsto_zero_of_injective_spectrum_sequence`：互异谱点序列趋零。

# 边界

本条没有引入 Hilbert 内积、自伴性或正交特征分解；这些属于 F6.5。Salamon Theorem 5.2.8 还
构造稳定广义特征空间的 Fitting 分解和谱投影，本条当前只登记 F6.4 ROADMAP 所要求的非零谱、
有限重数与零聚点边界，不提前开放后续全纯函数演算／谱投影窗口。
