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
# LinearAlgebra / Determinant —— 行列式（线性代数第一学期 L3）

本文件当前条目（引理清单，§3.11：一次一条，逐条编译）：

* **linear-algebra.det.mul**（积的行列式：det(AB) = det A · det B）。
* **linear-algebra.det.transpose**（转置不变：det Aᵀ = det A）。
* **linear-algebra.det.invertible**（可逆 ⟺ det ≠ 0：det 为可逆元 ⟹ 有逆）。
* **linear-algebra.det.one-zero**（单位阵 det=1，零阵 det=0）。

> **实现注记**：教材的"行列式 det"在形式化层即 `Matrix.det`；"det A ≠ 0"对应
> `IsUnit A.det`（域上二者等价）。词条用教材记号（det、可逆），mathlib 名只作实现注记。
-/

namespace SandronesLibrary

namespace LinearAlgebra.Determinant

/-- **积的行列式**：det(A·B) = det A · det B。 
> **Entry**: linear-algebra.det.mul
-/
theorem det_mul {K : Type*} {n : Type*} [Field K] [DecidableEq n] [Fintype n]
    (A B : Matrix n n K) : (A * B).det = A.det * B.det :=
  Matrix.det_mul A B

/-- **转置不变**：det(Aᵀ) = det A。 
> **Entry**: linear-algebra.det.transpose
-/
theorem det_transpose {K : Type*} {n : Type*} [Field K] [DecidableEq n] [Fintype n]
    (A : Matrix n n K) : A.transpose.det = A.det :=
  Matrix.det_transpose A

/-- **可逆 ⟺ det ≠ 0**：若 det A 是域上的可逆元（等价于 det A ≠ 0），
  则 A⁻¹ 给出左右逆：A⁻¹·A = 1 且 A·A⁻¹ = 1。 
> **Entry**: linear-algebra.det.invertible
-/
theorem det_invertible {K : Type*} {n : Type*} [Field K] [DecidableEq n] [Fintype n]
    (A : Matrix n n K) (h : IsUnit A.det) :
    A⁻¹ * A = 1 ∧ A * A⁻¹ = 1 :=
  ⟨Matrix.nonsing_inv_mul A h, Matrix.mul_nonsing_inv A h⟩

/-- **单位阵的行列式**：det I = 1。 
> **Entry**: linear-algebra.det.one-zero
-/
theorem det_one {K : Type*} {n : Type*} [Field K] [DecidableEq n] [Fintype n] :
    (1 : Matrix n n K).det = 1 :=
  Matrix.det_one

/-- **零阵的行列式**：det 0 = 0（非平凡阶数）。 
> **Entry**: linear-algebra.det.one-zero
-/
theorem det_zero {K : Type*} {n : Type*} [Field K] [DecidableEq n] [Fintype n] [Nonempty n] :
    (0 : Matrix n n K).det = 0 :=
  Matrix.det_zero

end LinearAlgebra.Determinant

end SandronesLibrary