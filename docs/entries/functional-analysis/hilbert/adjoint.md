---
id: functional-analysis.hilbert.adjoint
kind: theorem
state: verified
title: Hilbert 空间上有界算子的伴随
premises: [functional-analysis.hilbert.riesz, functional-analysis.operator.space]
mathlib: [ContinuousLinearMap.adjoint, ContinuousLinearMap.eq_adjoint_iff]
provenance: {source_type: book, ref: "Bühler–Salamon, Functional Analysis, Definition 5.3.7"}
---

# 动机

矩阵转置把线性变换从欧氏内积的一侧移到另一侧。Hilbert 空间中的伴随把这个有限维现象推广到
有界算子，是自伴算子、酉算子和谱理论的共同入口。

# 教材定义与正式承载

设 `A : E →L[ℝ] F`。它的伴随是唯一的连续线性映射 `A† : F →L[ℝ] E`，满足对所有 `x : E`、
`y : F` 都有 `⟪A x, y⟫ = ⟪x, A† y⟫`。Mathlib 的
`ContinuousLinearMap.adjoint` 正好承载这一对象，并把 `A ↦ A†` 打包成共轭线性的等距等价。
本库因此不复制伴随定义，只公开上述量词刻画及其一手性质。

# 陈述（自然语言）

一个反向有界算子等于 `A` 的伴随，当且仅当它满足全部向量上的内积转移公式。伴随保持算子范数，
取两次伴随得到原算子，并且复合算子的伴随按相反次序复合。

# 陈述（Lean 对照）

正式对象是 `A†`。刻画、标准公式、对合、范数和复合性质分别对应
`eq_adjoint_iff_inner_transfer`、`adjoint_inner_transfer`、`adjoint_involutive`、
`norm_adjoint_eq` 与 `adjoint_comp_reverse`。

# 思维脉络

固定 `y` 后，`x ↦ ⟪A x,y⟫` 是 `E` 上的连续线性泛函。Riesz 表示定理给出唯一向量 `A† y`；
再验证它随 `y` 线性且连续，便得到伴随算子。唯一刻画立即推出对合与复合反序；Riesz 等距性质
和算子范数的对称估计给出 `‖A†‖=‖A‖`。

# 自然语言 ↔ Lean 映射

- 有界算子：`A : E →L[ℝ] F`。
- 伴随：`ContinuousLinearMap.adjoint`，记作 `A†`，类型为 `F →L[ℝ] E`。
- 定义性刻画：`ContinuousLinearMap.eq_adjoint_iff`。
- 内积转移：`ContinuousLinearMap.adjoint_inner_right`。
- “等距”：`ContinuousLinearMap.adjoint` 本身是 `LinearIsometryEquiv`。

# 依赖

依赖 F1 的连续线性映射与算子范数，以及本批 Riesz 表示定理。后续正交规范基、酉算子和有界谱
理论可以直接依赖这里冻结的伴随接口。

# 应用与边界

本条固定实 Hilbert 空间，以便教材公式不被复数内积的共轭线性方向遮蔽。Mathlib 的正式对象也
适用于 `RCLike` 标量，此时 `A ↦ A†` 对标量是共轭线性的；这不意味着一般 Banach 空间中的对偶
算子，也不涵盖稠密定义域无界算子的伴随，后二者分别属于 F5 与 F7。
