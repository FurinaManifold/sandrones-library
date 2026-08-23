---
id: linear-algebra.symplectic.basis
kind: theorem
state: verified
title: "辛正交补、辛基与线性 Darboux 定理"
premises: ["linear-algebra.matrix.symplectic", "linear-algebra.vector-space.basis"]
mathlib: ["LinearMap.BilinForm.orthogonal", "LinearMap.BilinForm.isCompl_orthogonal_of_restrict_nondegenerate", "LinearMap.BilinForm.finrank_orthogonal"]
provenance:
  source_type: book
  ref: "本科线性代数与经典辛几何：有限维线性 Darboux 定理"
---

# 动机

辛形式是斜对称且非退化的双线性配对。线性 Darboux 定理说明：有限维辛空间没有额外的
线性分类不变量；选取合适的基后，每个辛形式都具有同一个标准配对矩阵。

# 直觉

从任意非零向量 `p₀` 出发，非退化性保证存在 `q₀` 与它的配对非零；缩放 `q₀` 后可令
`ω(p₀,q₀)=1`。二者张成一个二维辛平面。该平面的辛正交补仍非退化，并与平面直和生成
全空间，因此可以在维数下降二的正交补上重复这一过程。

# 陈述（自然语言）

有限维实辛空间存在向量 `p₁,…,pₙ,q₁,…,qₙ` 构成一组基，并满足
`ω(pᵢ,pⱼ)=ω(qᵢ,qⱼ)=0`、`ω(pᵢ,qⱼ)=δᵢⱼ`。特别地，空间维数等于 `2n`，因而为偶数。

# 陈述（Lean 对照）

- `SymplecticForm`：教材式辛形式结构。
- `symplecticOrthogonal`：集合的辛正交补。
- `IsSymplecticBasis ω p q`：标准辛配对条件与基条件。
- `exists_symplecticBasis`：有限维线性 Darboux 定理。
- `even_dim`：有限维辛空间的维数为偶数。

# 思维脉络（thinking trace）

1. 将教材接口桥接为内部双线性形式。
2. 构造规范辛对并证明其线性无关。
3. 证明二维辛平面上的限制非退化。
4. 用辛正交补将空间分解成二维平面与低二维的辛空间。
5. 对维数作强归纳，并通过直和基同构拼接辛基。

# 自然语言 ↔ Lean 映射

- “非退化”对应 `LinearMap.BilinForm.Nondegenerate`。
- “辛正交补”在证明内部对应 `LinearMap.BilinForm.orthogonal`。
- “直和分解”对应 `IsCompl W U` 与 `Submodule.prodEquivOfIsCompl`。
- “每次下降二维”对应 `LinearMap.BilinForm.finrank_orthogonal`。

# 依赖（人话版）

依赖有限维向量空间的基与维数理论，以及双线性形式的正交补和限制非退化理论。

# 应用与陷阱

定理要求辛形式非退化；退化的斜对称形式一般只能得到带零块的标准形。公开定理签名使用
本库教材接口 `LinearSpace`、`dim` 与 `IsBasis`，`Module`、`Submodule` 只用于证明内部。
