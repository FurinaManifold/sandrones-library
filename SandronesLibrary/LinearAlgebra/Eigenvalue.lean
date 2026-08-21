/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib
import SandronesLibrary.LinearAlgebra.LinearMap

open Filter Topology
open scoped Filter Topology

/-!
# LinearAlgebra / Eigenvalue —— 特征值 / 相似 / 对角化（线性代数第一学期 L4）

本文件当前条目（引理清单，§3.11：一次一条，逐条编译）：

* **linear-algebra.eigen.vector**（特征向量：T(x) = μ·x，x ≠ 0）。
* **linear-algebra.eigen.value**（特征值：存在非零特征向量 ⟺ 特征子空间非平凡）。
* **linear-algebra.eigen.spectrum**（谱：特征值属于谱）。
* **linear-algebra.eigen.charpoly**（特征多项式：对角阵特征多项式 = ∏(X−dᵢ)）。
* ~~**linear-algebra.eigen.independent**~~（不同特征值对应特征向量线性无关）：留待专门批次（需教材归纳证明）。

> **语言说明**：线性变换用 `T : V →ₗ[K] V`（LinearMap，本阶段内容）；
> 特征向量/值、特征子空间都用教材公式表达（不用 `Module.End`/`HasEigenvector` 结构类名）。
-/

namespace SandronesLibrary

open LinearAlgebra.VectorSpace

namespace LinearAlgebra.Eigenvalue

/-- **特征子空间**：属于特征值 μ 的全体特征向量加零向量。
  E_μ(T) = { x | T(x) = μ·x }。 -/
def eigenspace (K : Type*) {V : Type*} [Field K] [AddCommGroup V] [LinearSpace K V]
    (T : V →ₗ[K] V) (μ : K) : Set V :=
  { x | T x = μ • x }

/-- **特征向量**：x 是 T 的属于 μ 的特征向量，若 x ≠ 0 且 T(x) = μ·x。 -/
def HasEigenvector (K : Type*) {V : Type*} [Field K] [AddCommGroup V] [LinearSpace K V]
    (T : V →ₗ[K] V) (μ : K) (x : V) : Prop :=
  x ≠ 0 ∧ x ∈ eigenspace K T μ

/-- **特征值**：μ 是 T 的特征值，若存在非零向量 x 使 T(x) = μ·x。 -/
def HasEigenvalue (K : Type*) {V : Type*} [Field K] [AddCommGroup V] [LinearSpace K V]
    (T : V →ₗ[K] V) (μ : K) : Prop :=
  ∃ x ≠ 0, T x = μ • x

/-- **特征向量满足 T(x) = μ·x**：特征向量定义的第二条。 
> **Entry**: linear-algebra.eigen.vector
-/
theorem eigenvector_apply {K : Type*} {V : Type*} [Field K]
    [AddCommGroup V] [LinearSpace K V] {T : V →ₗ[K] V} {μ : K} {x : V}
    (hx : HasEigenvector K T μ x) : T x = μ • x :=
  hx.2

/-- **特征值 ⟺ 存在非零特征向量**：由定义直得。 
> **Entry**: linear-algebra.eigen.value
-/
theorem eigenvalue_iff_exists_eigenvector {K : Type*} {V : Type*} [Field K]
    [AddCommGroup V] [LinearSpace K V] {T : V →ₗ[K] V} {μ : K} :
    HasEigenvalue K T μ ↔ ∃ x, HasEigenvector K T μ x := by
  constructor
  · rintro ⟨x, hx0, hTx⟩
    exact ⟨x, hx0, hTx⟩
  · rintro ⟨x, hx0, hTx⟩
    exact ⟨x, hx0, hTx⟩

/-- **特征子空间非平凡 ⟺ 特征值**：E_μ(T) ≠ {0} 当且仅当 μ 是特征值。 
> **Entry**: linear-algebra.eigen.value
-/
theorem eigenvalue_iff_eigenspace_nontrivial {K : Type*} {V : Type*} [Field K]
    [AddCommGroup V] [LinearSpace K V] {T : V →ₗ[K] V} {μ : K} :
    HasEigenvalue K T μ ↔ ∃ x, x ∈ eigenspace K T μ ∧ x ≠ 0 := by
  constructor
  · rintro ⟨x, hx0, hTx⟩
    exact ⟨x, hTx, hx0⟩
  · rintro ⟨x, hx, hx0⟩
    exact ⟨x, hx0, hx⟩

/-- **谱**：T 的谱是全体特征值的集合。 -/
def spectrum (K : Type*) {V : Type*} [Field K] [AddCommGroup V] [LinearSpace K V]
    (T : V →ₗ[K] V) : Set K :=
  { μ | HasEigenvalue K T μ }

/-- **特征值属于谱**：μ 是特征值，则 μ ∈ spectrum(T)。 
> **Entry**: linear-algebra.eigen.spectrum
-/
theorem eigenvalue_mem_spectrum {K : Type*} {V : Type*} [Field K]
    [AddCommGroup V] [LinearSpace K V] {T : V →ₗ[K] V} {μ : K}
    (hμ : HasEigenvalue K T μ) : μ ∈ spectrum K T :=
  hμ

/-- **特征多项式**：对角矩阵 diag(d₁,…,dₙ) 的特征多项式是 ∏ᵢ (X − dᵢ)。
  （对角元即特征值；这是"特征值是特征多项式根"的直接来源。） 
> **Entry**: linear-algebra.eigen.charpoly
-/
theorem charpoly_diagonal {K : Type*} {n : Type*} [Field K] [DecidableEq n] [Fintype n]
    (d : n → K) : (Matrix.diagonal d).charpoly = ∏ i, (Polynomial.X - Polynomial.C (d i)) :=
  Matrix.charpoly_diagonal d

/-- **特征多项式首一**：n 阶矩阵的特征多项式是首一的。 
> **Entry**: linear-algebra.eigen.charpoly
-/
theorem charpoly_monic {K : Type*} {n : Type*} [Field K] [DecidableEq n] [Fintype n]
    (M : Matrix n n K) : M.charpoly.Monic :=
  M.charpoly_monic

end LinearAlgebra.Eigenvalue

end SandronesLibrary