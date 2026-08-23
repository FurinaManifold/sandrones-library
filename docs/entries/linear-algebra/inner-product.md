---
id: linear-algebra.inner-product
kind: theorem
state: verified
title: "内积、正交分解与伴随算子"
premises: ["linear-algebra.vector-space.def"]
mathlib: ["abs_real_inner_le_norm", "InnerProductSpace.gramSchmidtNormed_orthonormal", "Submodule.starProjection", "LinearMap.adjoint_inner_right"]
provenance:
  source_type: book
  ref: "本科线性代数：内积空间、正交化与伴随算子"
---

# 动机

内积把向量空间中的长度、角度和垂直关系统一起来。正交化与正交投影进一步把一般
线性问题化为彼此垂直的分量，而伴随算子则是实对称谱理论的坐标无关语言。

# 直觉

Gram–Schmidt 每一步减去先前方向上的投影，再把剩余向量归一化。对任意有限向量组，
一个向量都唯一分成“沿该向量组张成方向的部分”和“垂直于所有这些方向的部分”。

# 陈述（自然语言）

- Cauchy–Schwarz 不等式：内积的绝对值不超过两向量范数之积。
- 线性无关向量组经 Gram–Schmidt 后成为标准正交组，并保持原张成空间；基因此变成
  标准正交基。
- 任意向量相对于给定有限向量组存在唯一正交分解。
- 有限维实内积空间中的每个线性算子都有伴随；算子自伴当且仅当等于自身的伴随。

# 陈述（Lean 对照）

主要接口为 `cauchy_schwarz`、`orthonormalize_basis`、
`orthogonal_decomposition`、`adjoint_characterization` 与
`self_adjoint_iff_eq_adjoint`。公开签名使用线性组合、正交、基与线性算子等教材语言。

# 思维脉络（thinking trace）

正交化调用 mathlib 的有限 Gram–Schmidt 构造。正交分解在证明内部取有限向量组张成
空间上的正交投影；存在性来自投影，唯一性来自“属于张成空间且同时垂直于它”的向量
只能为零。伴随部分由 Riesz 表示所得的有限维伴随接口给出。

# 自然语言 ↔ Lean 映射

- 正交 ↔ `AreOrthogonal`；有限线性组合 ↔ `IsLinearCombination`。
- 标准正交化 ↔ `orthonormalize`；垂直于向量组 ↔ `IsOrthogonalToFamily`。
- 伴随 ↔ `adjointOperator`；自伴 ↔ `IsSelfAdjointOperator`。

# 依赖（人话版）

依赖实内积空间、有限维正交投影、Gram–Schmidt 与有限维伴随算子理论。

# 应用与陷阱

当前公开层针对实内积空间。复内积空间还要追踪共轭线性，矩阵语言中的对应对象是
Hermitian 矩阵。`orthogonal_decomposition` 不要求输入向量组线性无关。
