/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

universe u v

open Filter Topology
open scoped Filter Topology

/-!
# LinearAlgebra / VectorSpace —— 向量空间基础条目（线性代数第一学期 L1）

本文件当前条目（引理清单，§3.11：一次一条，逐条编译）：

* **linear-algebra.vector-space.def**（向量空间 = 域上加法群配合数乘）。
* **linear-algebra.vector-space.independent**（线性无关：无关组长度 ≤ 维数）。
* **linear-algebra.vector-space.basis**（基：基的大小 = 维数；dim ℝⁿ = n）。
* **linear-algebra.vector-space.dimension**（维数：dim 与秩的一致；零维 ⟺ 平凡空间）。

> **语言说明**：本文件的词条签名只用教材记号——`LinearSpace`（向量空间）、`dim`（维数）、
> `IsLinearIndependent`（线性无关）、`IsBasis`（基）。mathlib 的更广抽象
> （`Module`、`Module.finrank`、`LinearIndependent`、`Submodule`）只出现在 `:= by` 之后的证明内部，
> 绝不出现在定理描述里。
-/

namespace SandronesLibrary

namespace LinearAlgebra.VectorSpace

/-- **向量空间**（教材记号）：`[LinearSpace K V]` 表示 V 是数域 K 上的向量空间。
  `LinearSpace K V` 携带一个 K 模结构，且**系数限定为域** `[Field K]`
  （域上的模 ⟹ 无挠，正是向量空间；不会退化为环上的带挠模）。
  证明内部通过 `LinearSpace.toModule` 取出该模结构使用。 -/
class LinearSpace (K : Type u) (V : Type v) [Field K] [AddCommGroup V] where
  toModule : Module K V

attribute [instance] LinearSpace.toModule
attribute [instance_reducible] LinearSpace.toModule

/-- 数域 K 是自身上的向量空间。 -/
instance LinearSpace.self {K : Type u} [Field K] : LinearSpace K K where
  toModule := inferInstance

/-- 函数空间 K^I 是向量空间。 -/
instance LinearSpace.pi {K : Type u} {I : Type v} [Field K] [Fintype I] : LinearSpace K (I → K) where
  toModule := inferInstance

/-- 向量空间的**维数**（教材记号）：`dim V` 即 V 的基的元素个数。 -/
noncomputable abbrev dim (𝕜 : Type*) (V : Type*) [Field 𝕜] [AddCommGroup V] [LinearSpace 𝕜 V] : ℕ :=
  Module.finrank 𝕜 V

/-- **有限维**（教材记号）：`[IsFiniteDimensional K V]` 表示 V 是 K 上的有限维向量空间。 -/
abbrev IsFiniteDimensional (K : Type*) (V : Type*) [Field K] [AddCommGroup V] [LinearSpace K V] : Prop :=
  Module.Finite K V

/-- **线性无关**（教材记号）：向量组 {vᵢ} 线性无关，若它们的线性组合为 0 时系数全为 0。 -/
def IsLinearIndependent (𝕜 : Type*) {V : Type*} [Field 𝕜] [AddCommGroup V] [LinearSpace 𝕜 V]
    {ι : Type*} (v : ι → V) : Prop :=
  LinearIndependent 𝕜 v

/-- **基**（教材记号）：{bᵢ} 是 V 的一组基，若它线性无关且张成整个空间 V。 -/
def IsBasis (𝕜 : Type*) {V : Type*} [Field 𝕜] [AddCommGroup V] [LinearSpace 𝕜 V]
    {ι : Type*} [Fintype ι] (b : ι → V) : Prop :=
  LinearIndependent 𝕜 b ∧ Submodule.span 𝕜 (Set.range b) = ⊤

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
    [AddCommGroup V] [LinearSpace 𝕜 V] [IsFiniteDimensional 𝕜 V]
    {ι : Type*} [Fintype ι] {v : ι → V}
    (h : IsLinearIndependent 𝕜 v) : Fintype.card ι ≤ dim 𝕜 V := by
  change LinearIndependent 𝕜 v at h
  unfold dim
  exact LinearIndependent.fintype_card_le_finrank h

/-- 基的元素个数等于维数：若 {bᵢ} 是 V 的一组基，则 dim V = 该基的大小。 
> **Entry**: linear-algebra.vector-space.basis
-/
lemma dim_eq_card_basis {𝕜 : Type*} {V : Type*} [Field 𝕜]
    [AddCommGroup V] [LinearSpace 𝕜 V]
    {ι : Type*} [Fintype ι] {b : ι → V} (h : IsBasis 𝕜 b) : dim 𝕜 V = Fintype.card ι := by
  unfold IsBasis at h
  rcases h with ⟨hli, hspan⟩
  let b' : Module.Basis ι 𝕜 V := Module.Basis.mk hli (by simp [hspan])
  haveI : Module.Finite 𝕜 V := Module.Finite.of_basis b'
  unfold dim
  exact Module.finrank_eq_card_basis b'

end LinearAlgebra.VectorSpace
