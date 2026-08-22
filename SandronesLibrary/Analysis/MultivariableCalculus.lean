/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Topology.NormedSpace
import Mathlib.Algebra.BigOperators.Pi
import Mathlib.Analysis.Calculus.FDeriv.Comp
import Mathlib.Analysis.Calculus.Gradient.Basic
import Mathlib.Data.Matrix.Mul

/-!
# 多元微积分：Fréchet 全微分、方向导数与梯度

多元函数在一点的最佳线性近似不是一个数，而是连续线性映射。若
`f(x+h)=f(x)+A(h)+o(‖h‖)`，则 `A` 是 `f` 在 `x` 处的 Fréchet 导数，也就是教材
中的全微分。将 `A` 作用于方向 `v` 得到该方向上的方向导数。

对实内积空间上的实值函数，Riesz 表示把线性泛函 `A` 唯一写成
`A(v)=⟪∇f(x),v⟫`；这个代表向量就是梯度。本模块建立这些概念之间的统一接口，
并给出连续性、恒等映射和链式法则。坐标偏导、Jacobian 与 Hessian 将在后续小节
由这一无坐标定义推出。
-/

namespace SandronesLibrary.Analysis.Multivariable

variable {E F G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℝ E]
  [NormedAddCommGroup F] [NormedSpace ℝ F]
  [NormedAddCommGroup G] [NormedSpace ℝ G]

/-- 教材中的全微分：定义域到值域的连续实线性映射。

> **Entry**: analysis.multivariable.frechet
-/
abbrev TotalDerivative := E →L[ℝ] F

/-- 方向导数取 Fréchet 导数在线性方向 `v` 上的值。不可微时 Mathlib 的 `fderiv`
按约定取零，因此需要实际计算时通常同时携带 `HasFDerivAt` 假设。 -/
noncomputable def DirectionalDerivative (f : E → F) (x v : E) : F :=
  fderiv ℝ f x v

/-- 已知的全微分等于 Mathlib 选出的 Fréchet 导数。 -/
theorem totalDerivative_unique {f : E → F} {x : E} {A : E →L[ℝ] F}
    (h : HasFDerivAt f A x) : fderiv ℝ f x = A := by
  exact h.fderiv

/-- Fréchet 可微蕴含在该点连续。 -/
theorem differentiable_continuousAt {f : E → F} {x : E}
    (h : DifferentiableAt ℝ f x) : ContinuousAt f x := by
  exact h.continuousAt

/-- 恒等映射的全微分是恒等连续线性映射。 -/
theorem totalDerivative_id (x : E) :
    HasFDerivAt id (ContinuousLinearMap.id ℝ E) x := by
  exact hasFDerivAt_id x

/-- **多元链式法则**：复合函数的全微分是两个全微分的复合。 -/
theorem totalDerivative_chain {f : E → F} {g : F → G}
    {x : E} {A : E →L[ℝ] F} {B : F →L[ℝ] G}
    (hf : HasFDerivAt f A x) (hg : HasFDerivAt g B (f x)) :
    HasFDerivAt (g ∘ f) (B.comp A) x := by
  exact hg.comp x hf

/-- 可微时，方向导数就是全微分作用于方向向量。 -/
theorem directionalDerivative_eq {f : E → F} {x v : E} {A : E →L[ℝ] F}
    (h : HasFDerivAt f A x) : DirectionalDerivative f x v = A v := by
  simp [DirectionalDerivative, h.fderiv]

section Gradient

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℝ H] [CompleteSpace H]

/-- 梯度通过内积给出实值函数的全微分。

> **Entry**: analysis.multivariable.gradient
-/
theorem gradient_totalDerivative {f : H → ℝ} {x grad : H}
    (h : HasGradientAt f grad x) :
    HasFDerivAt f (InnerProductSpace.toDual ℝ H grad) x := by
  exact h.hasFDerivAt

/-- **方向导数—梯度公式**：`D_v f(x)=⟪∇f(x),v⟫`。 -/
theorem directionalDerivative_eq_inner_gradient {f : H → ℝ} {x grad v : H}
    (h : HasGradientAt f grad x) :
    DirectionalDerivative f x v = inner ℝ grad v := by
  simpa [DirectionalDerivative] using h.fderiv_apply (y := v)

end Gradient

section Coordinates

open scoped BigOperators Matrix

/-!
## 坐标偏导与 Jacobian

以下固定定义域为 `ℝⁿ = Fin n → ℝ`、值域为 `ℝᵐ = Fin m → ℝ`。第 `j` 个标准基
向量写作 `Pi.single j 1`。全微分作用于这个向量就得到第 `j` 个坐标方向的偏导向量；
再取其第 `i` 个分量，便得到教材中的 `∂fᵢ/∂xⱼ`。将这些数按“输出分量为行、输入
变量为列”排列，就得到 `m × n` Jacobian 矩阵。
-/

/-- 第 `j` 个坐标方向的偏导向量。由于它由 `fderiv` 定义，不可微点按 Mathlib 的约定
取零；具体计算时应携带 `HasFDerivAt` 假设。 -/
noncomputable def partialDerivative {n m : ℕ} (f : (Fin n → ℝ) → (Fin m → ℝ))
    (x : Fin n → ℝ) (j : Fin n) : Fin m → ℝ :=
  DirectionalDerivative f x (Pi.single j 1)

/-- `f : ℝⁿ → ℝᵐ` 在 `x` 处的 Jacobian 矩阵。矩阵第 `i,j` 项是输出分量 `fᵢ`
对输入坐标 `xⱼ` 的偏导数。 -/
noncomputable def jacobian {n m : ℕ} (f : (Fin n → ℝ) → (Fin m → ℝ))
    (x : Fin n → ℝ) : Matrix (Fin m) (Fin n) ℝ :=
  fun i j ↦ partialDerivative f x j i

/-- 已知 Fréchet 导数 `A` 时，第 `j` 个偏导向量就是 `A eⱼ`。

> **Entry**: analysis.multivariable.coordinates
-/
theorem partialDerivative_eq {n m : ℕ} {f : (Fin n → ℝ) → (Fin m → ℝ)}
    {x : Fin n → ℝ} {A : (Fin n → ℝ) →L[ℝ] (Fin m → ℝ)}
    (h : HasFDerivAt f A x) (j : Fin n) :
    partialDerivative f x j = A (Pi.single j 1) := by
  exact directionalDerivative_eq h

/-- Jacobian 元素公式：`Jf(x)ᵢⱼ = (Df(x)eⱼ)ᵢ`。 -/
theorem jacobian_apply {n m : ℕ} {f : (Fin n → ℝ) → (Fin m → ℝ)}
    {x : Fin n → ℝ} {A : (Fin n → ℝ) →L[ℝ] (Fin m → ℝ)}
    (h : HasFDerivAt f A x) (i : Fin m) (j : Fin n) :
    jacobian f x i j = A (Pi.single j 1) i := by
  rw [jacobian, partialDerivative_eq h]

/-- **全微分的 Jacobian 表示**：在标准坐标中，全微分作用于向量 `v` 等于
Jacobian 矩阵乘以列向量 `v`。这是抽象 Fréchet 导数与教材矩阵记法之间的桥。 -/
theorem totalDerivative_apply_eq_jacobian_mulVec {n m : ℕ}
    {f : (Fin n → ℝ) → (Fin m → ℝ)} {x v : Fin n → ℝ}
    {A : (Fin n → ℝ) →L[ℝ] (Fin m → ℝ)} (h : HasFDerivAt f A x) :
    A v = jacobian f x *ᵥ v := by
  classical
  have hb (j : Fin n) : (fun k ↦ if j = k then (1 : ℝ) else 0) = Pi.single j 1 := by
    ext k
    simp [Pi.single_apply, eq_comm]
  have hA : A v = ∑ j, v j • A (Pi.single j 1) := by
    change A.toLinearMap v = ∑ j, v j • A.toLinearMap (Pi.single j 1)
    simpa only [hb] using A.toLinearMap.pi_apply_eq_sum_univ v
  rw [hA]
  ext i
  simp [Matrix.mulVec, dotProduct, jacobian_apply h, mul_comm]

/-- 恒等映射在任意点的 Jacobian 都是单位矩阵。 -/
theorem jacobian_id {n : ℕ} (x : Fin n → ℝ) :
    jacobian id x = (1 : Matrix (Fin n) (Fin n) ℝ) := by
  classical
  ext i j
  rw [jacobian_apply (totalDerivative_id x)]
  simp [Pi.single_apply, Matrix.one_apply]

/-- **Jacobian 链式法则**：复合映射的 Jacobian 是两个 Jacobian 的矩阵乘积。
矩阵次序与函数复合次序相反：先作用 `Jf(x)`，再作用 `Jg(f(x))`。 -/
theorem jacobian_chain {n m p : ℕ}
    {f : (Fin n → ℝ) → (Fin m → ℝ)} {g : (Fin m → ℝ) → (Fin p → ℝ)}
    {x : Fin n → ℝ}
    {A : (Fin n → ℝ) →L[ℝ] (Fin m → ℝ)}
    {B : (Fin m → ℝ) →L[ℝ] (Fin p → ℝ)}
    (hf : HasFDerivAt f A x) (hg : HasFDerivAt g B (f x)) :
    jacobian (g ∘ f) x = jacobian g (f x) * jacobian f x := by
  classical
  have hc : HasFDerivAt (g ∘ f) (B.comp A) x := totalDerivative_chain hf hg
  ext i j
  rw [jacobian_apply hc, Matrix.mul_apply]
  change B (A (Pi.single j 1)) i = _
  rw [congrFun (totalDerivative_apply_eq_jacobian_mulVec hg
    (v := A (Pi.single j 1))) i]
  simp [Matrix.mulVec, dotProduct, jacobian_apply hf]

end Coordinates

end SandronesLibrary.Analysis.Multivariable
