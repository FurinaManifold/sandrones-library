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

* **linear-algebra.eigen.vector**（特征向量：T(x) = μ·x）。
* **linear-algebra.eigen.value**（特征值：存在非零特征向量 ⟺ 特征子空间非零）。
* **linear-algebra.eigen.spectrum**（谱：特征值属于谱）。
* **linear-algebra.eigen.charpoly**（特征多项式：对角阵特征多项式 = ∏(X−dᵢ)）。

> ~~similar-diagonal~~（相似与对角化）：mathlib 现成支持较弱，留待后续批次。

> **实现注记**：教材的"线性变换 T"在形式化层用 `Module.End K V`（V→V 的自同态）表示，
> "特征向量 x（μ）"用 `HasEigenvector`，"μ 是特征值"用 `HasEigenvalue`。
> 词条与叙述层只用教材记号（T、μ、特征向量/值、谱、特征多项式），mathlib 名只作实现注记。
-/

namespace SandronesLibrary

namespace LinearAlgebra.Eigenvalue

/-- **特征向量**：x ≠ 0 且 T(x) = μ·x，则 x 是 T 的属于特征值 μ 的特征向量。 
> **Entry**: linear-algebra.eigen.vector
-/
theorem eigenvector_apply {K : Type*} {V : Type*} [Field K]
    [AddCommGroup V] [Module K V] {T : Module.End K V} {μ : K} {x : V}
    (hx : T.HasEigenvector μ x) : T x = μ • x :=
  hx.apply_eq_smul

/-- **特征值**：μ 是 T 的特征值 ⟺ μ 的特征子空间非零（即存在非零特征向量）。
  这里 `T.eigenspace μ` 是 μ 对应的特征子空间。 
> **Entry**: linear-algebra.eigen.value
-/
theorem eigenvalue_iff_eigenspace_ne_bot {K : Type*} {V : Type*} [Field K]
    [AddCommGroup V] [Module K V] {T : Module.End K V} {μ : K} :
    T.HasEigenvalue μ ↔ T.eigenspace μ ≠ ⊥ :=
  Module.End.hasEigenvalue_iff

/-- **谱**：μ 是特征值，则 μ 属于 T 的谱 spectrum(T)。 
> **Entry**: linear-algebra.eigen.spectrum
-/
theorem eigenvalue_mem_spectrum {K : Type*} {V : Type*} [Field K]
    [AddCommGroup V] [Module K V] {T : Module.End K V} {μ : K}
    (hμ : T.HasEigenvalue μ) : μ ∈ spectrum K T :=
  hμ.mem_spectrum

/-- **特征多项式**：对角矩阵 diag(d₁,…,dₙ) 的特征多项式是 ∏ᵢ (X − dᵢ)。
  （对角元即特征值；这是"特征值是特征多项式根"的直接来源。） 
> **Entry**: linear-algebra.eigen.charpoly
-/
theorem charpoly_diagonal {K : Type*} {n : Type*} [Field K] [DecidableEq n] [Fintype n]
    (d : n → K) : (Matrix.diagonal d).charpoly = ∏ i, (Polynomial.X - Polynomial.C (d i)) :=
  Matrix.charpoly_diagonal d

/-- **特征多项式首一**：n 阶矩阵的特征多项式是首一的（次数 n，首项系数 1）。 
> **Entry**: linear-algebra.eigen.charpoly
-/
theorem charpoly_monic {K : Type*} {n : Type*} [Field K] [DecidableEq n] [Fintype n]
    (M : Matrix n n K) : M.charpoly.Monic :=
  M.charpoly_monic

end LinearAlgebra.Eigenvalue

end SandronesLibrary