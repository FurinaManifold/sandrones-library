/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

open Filter Topology
open scoped Filter Topology

/-!
# LinearAlgebra / VectorSpace —— 向量空间基础条目（线性代数第一学期 L1）

本文件当前条目（引理清单，§3.11：一次一条，逐条编译）：

* **linear-algebra.vector-space.def**（向量空间 = 域上加法群配合数乘）。
* **linear-algebra.vector-space.independent**（线性无关：无关组长度 ≤ 维数）。
* **linear-algebra.vector-space.basis**（基：基的大小 = 维数；dim ℝⁿ = n）。
* **linear-algebra.vector-space.dimension**（维数：dim 与秩的一致；零维 ⟺ 平凡空间）。

> **实现注记**：教材里的"向量空间 V 的维数"在形式化层用 `Module.finrank`（有限维，ℕ 值）
> 与 `Module.rank`（一般，基数）表达；词条与叙述层只用教材记号（dim V、基、秩），
> 这两个 mathlib 名仅作为实现细节藏在叙述层，不对读者暴露。
-/

namespace SandronesLibrary

namespace LinearAlgebra.VectorSpace

/-- 向量空间的**维数**（人类友好记号）：`dim V` 即 V 的基的元素个数。
  （形式化实现是 `Module.finrank`，这里起别名以便教材记号。） -/
noncomputable abbrev dim (𝕜 : Type*) (V : Type*) [Field 𝕜] [AddCommGroup V] [Module 𝕜 V] : ℕ :=
  Module.finrank 𝕜 V

/-- 数域 K 作为它自身的向量空间，维数为 1：dim K K = 1。 
> **Entry**: linear-algebra.vector-space.def
-/
lemma dim_self (𝕜 : Type*) [Field 𝕜] : dim 𝕜 𝕜 = 1 :=
  Module.finrank_self 𝕜

/-- 函数空间 K^I 的维数等于指标集 I 的大小：dim K (K^I) = |I|。
  （即标准基有 |I| 个向量，故 dim ℝⁿ = n。） 
> **Entry**: linear-algebra.vector-space.def
-/
lemma dim_pi {𝕜 : Type*} {ι : Type*} [Field 𝕜] [Fintype ι] :
    dim 𝕜 (ι → 𝕜) = Fintype.card ι := by
  unfold dim
  rw [Module.finrank_pi]

/-- 线性无关组的长度不超过所在空间的维数：任何线性无关的向量组至多有 dim V 个向量。 
> **Entry**: linear-algebra.vector-space.independent
-/
lemma card_le_dim_of_linearIndependent {𝕜 : Type*} {V : Type*} [Field 𝕜]
    [AddCommGroup V] [Module 𝕜 V] [Module.Finite 𝕜 V]
    {ι : Type*} [Fintype ι] {v : ι → V}
    (h : LinearIndependent 𝕜 v) : Fintype.card ι ≤ dim 𝕜 V := by
  unfold dim
  exact LinearIndependent.fintype_card_le_finrank h

/-- 基的元素个数等于维数：若 {vᵢ} 是 V 的一组基，则 dim V = 该基的大小。 
> **Entry**: linear-algebra.vector-space.basis
-/
lemma dim_eq_card_basis {𝕜 : Type*} {V : Type*} [Field 𝕜]
    [AddCommGroup V] [Module 𝕜 V]
    {ι : Type*} [Fintype ι] (h : Module.Basis ι 𝕜 V) : dim 𝕜 V = Fintype.card ι := by
  unfold dim
  exact Module.finrank_eq_card_basis h

/-- 零维 ⟺ 平凡空间：dim V = 0 当且仅当 V 只有一个元素（零向量）。 
> **Entry**: linear-algebra.vector-space.dimension
-/
lemma dim_zero_iff_subsingleton {𝕜 : Type*} {V : Type*} [Field 𝕜]
    [AddCommGroup V] [Module 𝕜 V] [Module.Finite 𝕜 V] :
    dim 𝕜 V = 0 ↔ Subsingleton V := by
  unfold dim
  exact Module.finrank_zero_iff

end LinearAlgebra.VectorSpace

end SandronesLibrary