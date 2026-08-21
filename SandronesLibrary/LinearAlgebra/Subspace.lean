/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib
import SandronesLibrary.LinearAlgebra.VectorSpace

open Filter Topology
open scoped Filter Topology

/-!
# LinearAlgebra / Subspace —— 子空间与生成（线性代数第一学期 L1 补充）

本文件当前条目（引理清单，§3.11：一次一条，逐条编译）：

* **linear-algebra.vector-space.subspace**（子空间：加法与数乘封闭）。
* **linear-algebra.vector-space.span**（生成子空间：含 s 的最小子空间）。

> **语言说明**：本文件用教材语言——子空间是满足"加法与数乘封闭"的非空子集
> （`IsSubspace`），不用 mathlib 的 `Submodule` 结构类名。
-/

namespace SandronesLibrary

namespace LinearAlgebra.VectorSpace

/-- **子空间**：V 的一个非空子集 W，对加法和数乘都封闭。
  （教材定义；mathlib 底层是 `Submodule`，这里用人话记号。） -/
def IsSubspace (K : Type*) {V : Type*} [Field K] [AddCommGroup V] [Module K V]
    (W : Set V) : Prop :=
  W.Nonempty ∧ (∀ ⦃u⦄, u ∈ W → ∀ ⦃v⦄, v ∈ W → u + v ∈ W) ∧
    (∀ (c : K) ⦃v⦄, v ∈ W → c • v ∈ W)

/-- **子空间的加法封闭性**：u, v ∈ W ⟹ u + v ∈ W。 
> **Entry**: linear-algebra.vector-space.subspace
-/
theorem subspace_add_mem {K : Type*} {V : Type*} [Field K]
    [AddCommGroup V] [Module K V] {W : Set V} (hW : IsSubspace K W)
    {u v : V} (hu : u ∈ W) (hv : v ∈ W) : u + v ∈ W :=
  hW.2.1 hu hv

/-- **子空间的数乘封闭性**：v ∈ W ⟹ c·v ∈ W。 
> **Entry**: linear-algebra.vector-space.subspace
-/
theorem subspace_smul_mem {K : Type*} {V : Type*} [Field K]
    [AddCommGroup V] [Module K V] {W : Set V} (hW : IsSubspace K W)
    (c : K) {v : V} (hv : v ∈ W) : c • v ∈ W :=
  hW.2.2 c hv

/-- **子空间包含零向量**：子空间非空，故含 0。 
> **Entry**: linear-algebra.vector-space.subspace
-/
theorem subspace_zero_mem {K : Type*} {V : Type*} [Field K]
    [AddCommGroup V] [Module K V] {W : Set V} (hW : IsSubspace K W) :
    (0 : V) ∈ W := by
  rcases hW with ⟨⟨z, hz⟩, _hadd, _hsmul⟩
  have : (0 : K) • z = 0 := zero_smul K z
  have hz0 : (0 : K) • z ∈ W := _hsmul (0 : K) hz
  simpa [this] using hz0

/-- **生成子空间的最小性**：s ⊆ W 且 W 是子空间，则 span(s) ⊆ W。
  （span(s) 是包含 s 的最小子空间；mathlib 的 `Submodule.span_le` 即此意。） 
> **Entry**: linear-algebra.vector-space.span
-/
theorem span_le {K : Type*} {V : Type*} [Field K]
    [AddCommGroup V] [Module K V] {s : Set V} {W : Submodule K V} :
    Submodule.span K s ≤ W ↔ s ⊆ W :=
  Submodule.span_le

/-- **生成子空间包含原集合**：s ⊆ span(s)。 
> **Entry**: linear-algebra.vector-space.span
-/
theorem subset_span {K : Type*} {V : Type*} [Field K]
    [AddCommGroup V] [Module K V] {s : Set V} : s ⊆ Submodule.span K s :=
  Submodule.subset_span

/-- **生成子空间的单调性**：s ⊆ t ⟹ span(s) ⊆ span(t)。 
> **Entry**: linear-algebra.vector-space.span
-/
theorem span_mono {K : Type*} {V : Type*} [Field K]
    [AddCommGroup V] [Module K V] {s t : Set V} (h : s ⊆ t) :
    Submodule.span K s ≤ Submodule.span K t :=
  Submodule.span_mono h

end LinearAlgebra.VectorSpace

end SandronesLibrary