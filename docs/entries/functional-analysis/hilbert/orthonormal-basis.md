---
id: functional-analysis.hilbert.orthonormal-basis
kind: theorem
state: staging
title: Hilbert 基、Fourier 展开与 Parseval 恒等式
premises: [functional-analysis.hilbert.projection, functional-analysis.hilbert.riesz]
mathlib: [HilbertBasis, HilbertBasis.orthonormal, HilbertBasis.hasSum_repr]
provenance: {source_type: book, ref: "Bühler–Salamon, Functional Analysis, Section 2.3.6"}
---

# 动机

有限维正交规范基把向量分解成有限个坐标；无限维 Hilbert 空间中，相同思想变成收敛级数。关键不只
是基向量彼此正交，还要保证它们足够多，使每个向量都能由 Fourier 系数恢复。

# 教材定义与正式承载

Hilbert 基是一族正交规范向量 `b i`，其线性张成在整个空间中稠密。Mathlib 的
`HilbertBasis ι ℝ E` 把这两个条件打包成等距线性等价 `E ≃ₗᵢ[ℝ] ℓ²(ι,ℝ)`：`repr x` 是平方
可和的 Fourier 系数族，而 `repr.symm` 完成级数重构。这与无限维教材语义一致，因此本库不另造
“完备正交系”结构。有限指标的 `OrthonormalBasis` 是相关但更窄的接口，不用来冒充无限维承载。

# 陈述（自然语言）

Hilbert 基首先是正交规范族，其线性张成稠密。任意向量 `x` 等于级数
`∑ i, ⟪b i,x⟫ b i` 的和；同时 Parseval 恒等式说明 Fourier 系数完整保存自内积，从而保存范数。

# 陈述（Lean 对照）

正交规范性、稠密张成、Fourier 展开和 Parseval 恒等式分别对应 `hilbertBasis_orthonormal`、
`hilbertBasis_dense_span`、`hilbertBasis_hasSum_fourier` 与 `hilbertBasis_parseval`。

# 思维脉络

先对有限线性组合应用勾股定理，得到 Bessel 不等式，所以 Fourier 系数属于 `ℓ²`。稠密性确保
有限部分和逼近任意向量，于是 Bessel 不等式升级为等号并得到 Fourier 展开。对展开式取内积，
便得到 Parseval 恒等式。Mathlib 的 `repr` 等距等价把这条证明链压缩成稳定的正式承载。

# 自然语言 ↔ Lean 映射

- Hilbert 基：`b : HilbertBasis ι ℝ E`。
- 基向量：`b i : E`。
- 正交规范：`Orthonormal ℝ b`。
- 完备性：`(Submodule.span ℝ (Set.range b)).topologicalClosure = ⊤`。
- Fourier 系数：`b.repr x i = inner ℝ (b i) x`。
- 级数重构：`HilbertBasis.hasSum_repr`。
- Parseval：`HilbertBasis.tsum_inner_mul_inner` 在 `x=y` 时的特例。

# 依赖

依赖 Hilbert 空间、闭子空间投影与 Riesz 表示所建立的几何语言。伴随并非 Parseval 证明的逻辑
前提，但本条按 F3 课程顺序位于伴随窗口之后，并为后续酉算子提供坐标解释。

# 应用与边界

本条给出任意指标类型的 Hilbert 基接口，不假设空间可分，也不声称基可由自然数编号。它固定实
Hilbert 空间；复 Hilbert 空间中 Parseval 乘积包含共轭，但同一个 Mathlib 承载仍适用。本条不讨论
一般 Banach 空间的 Schauder 基，也不预先进入 F6 的紧自伴谱分解。
