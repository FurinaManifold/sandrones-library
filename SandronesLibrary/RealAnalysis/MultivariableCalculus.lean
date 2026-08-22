/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Topology.NormedSpace
import Mathlib.Analysis.Calculus.FDeriv.Comp
import Mathlib.Analysis.Calculus.Gradient.Basic

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

namespace SandronesLibrary.RealAnalysis.Multivariable

variable {E F G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℝ E]
  [NormedAddCommGroup F] [NormedSpace ℝ F]
  [NormedAddCommGroup G] [NormedSpace ℝ G]

/-- 教材中的全微分：定义域到值域的连续实线性映射。

> **Entry**: real-analysis.multivariable.frechet
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

> **Entry**: real-analysis.multivariable.gradient
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

end SandronesLibrary.RealAnalysis.Multivariable
