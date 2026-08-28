---
id: functional-analysis.hilbert.compact-selfadjoint-spectral
family: functional-analysis.operator
variant: compact-selfadjoint
kind: theorem
state: verified
title: 紧自伴算子的正交特征分解
summary: 紧自伴算子的特征值为实，特征空间正交且闭线性张成稠密
premises: [functional-analysis.compact-spectrum, functional-analysis.hilbert.adjoint]
mathlib: [IsCompactOperator, LinearMap.IsSymmetric, ContinuousLinearMap.orthogonalComplement_iSup_eigenspaces_eq_bot]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 定义承载

设 `E` 是完备的 `𝕜`-内积空间，其中 `𝕜` 是 `RCLike` 标量，且
`T : E →L[𝕜] E`。

- `IsCompactOperator T` 表示 `T` 把有界集合送到预紧集合；这是 Mathlib 的全局谓词，不是新的
  算子类型；
- `(T : E →ₗ[𝕜] E).IsSymmetric` 表示
  `⟪T x, y⟫ = ⟪x, T y⟫`。对于处处定义的有界 Hilbert 空间算子，这就是本条所需的自伴性承载；
- `eigenspace (T : Module.End 𝕜 E) μ` 是 `T-μI` 的核。本库不另建 self-adjoint、compact 或
  eigenspace wrapper。

# 谱分解结论

`compact_isSymmetric_spectral_decomposition hK hT` 同时给出四项：

1. 若 `μ` 是特征值，则 `star μ = μ`；在复数上这说明 `μ` 为实数；
2. 互异特征值的特征空间彼此正交；
3. 所有特征空间之和在 `E` 中稠密；
4. 每个非零特征空间有限维。

第三项必须按拓扑意义理解。Mathlib 的核心谱定理首先给出

`(⨆ μ, eigenspace T μ)ᗮ = ⊥`。

本条再利用正交补不改变于闭包，以及闭子空间的正交补为底当且仅当该闭子空间为顶，把它转写为
`Dense`。所以这里不是声称未闭的代数和已经等于全空间，而是声称其闭线性张成等于全空间。

# 与教材及 Mathlib 的边界

Salamon Theorem 5.3.15(v) 对紧正规算子选择由特征向量组成的正交归一基；本条取其紧自伴特例。
Mathlib 已经包含特征值实性、特征空间正交、正交补为底和非零特征空间有限维的核心结果。本库的
新增内容是把这些结果按教材定义链组装，并把“正交补为底”显式解释为稠密性，而不是重证最终
谱定理。

本条没有选择一个无限维 `HilbertBasis`，也没有进入一般正规算子、广义特征空间、连续函数演算、
谱投影或谱测度。核可能无限维；有限维结论只针对非零特征值。

# Lean 对照

- `compact_isSymmetric_spectral_decomposition`：紧性与自伴性推出上述四项谱分解结论。
