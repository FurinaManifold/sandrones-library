/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Analysis.GreenGaussStokes
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

/-!
# Gauss 与 Stokes 公式例题

本文件给出两个标准教材计算。Gauss 例题在单位立方体上取位置向量场，散度恒为 `3`；
Stokes 例题在水平单位正方形上取 1-形式 `x dy`，其拉回为 `u dv`，外微分密度恒为
`1`。两个证明分别调用理论层的 `gauss_box3` 和 `stokes_parametrized_rectangle`，
同时完成最终积分数值的计算。
-/

noncomputable section

namespace SandronesLibrary.Examples.GaussStokes

open Set MeasureTheory Matrix
open scoped Interval Matrix
open SandronesLibrary.Analysis.Multivariable
open SandronesLibrary.Analysis.GreenGaussStokes

/-! ## Gauss 公式：单位立方体 -/

/-- 单位立方体的左下端点。 -/
def unitCubeLower : Fin 3 → ℝ := fun _ ↦ 0

/-- 单位立方体的右上端点。 -/
def unitCubeUpper : Fin 3 → ℝ := fun _ ↦ 1

/-- **Gauss 例题**：单位立方体上位置向量场 `F(x)=x` 的总外向通量等于 `3`。

位置向量场的 Fréchet 导数是恒等映射，故散度为 `1+1+1=3`。调用盒上的 Gauss
公式后，右端成为常数 `3` 在体积为 `1` 的单位立方体上的积分。
-/
theorem gauss_unitCube_identity :
    boxBoundaryFlux3 (fun x : Fin 3 → ℝ ↦ x) unitCubeLower unitCubeUpper = 3 := by
  let F' : (Fin 3 → ℝ) → (Fin 3 → ℝ) →L[ℝ] (Fin 3 → ℝ) :=
    fun _ ↦ ContinuousLinearMap.id ℝ (Fin 3 → ℝ)
  have hab : unitCubeLower ≤ unitCubeUpper := by
    intro i
    simp [unitCubeLower, unitCubeUpper]
  have hdiv : ∀ x, divergence3 F' x = 3 := by
    intro x
    simp [divergence3, F']
  have hint : IntegrableOn (divergence3 F') (Icc unitCubeLower unitCubeUpper) := by
    refine IntegrableOn.congr_fun
      (integrableOn_const (C := (3 : ℝ)) (measure_Icc_lt_top.ne)) ?_
      measurableSet_Icc
    intro x _
    exact (hdiv x).symm
  rw [gauss_box3 unitCubeLower unitCubeUpper hab (fun x ↦ x) F'
    continuous_id.continuousOn (fun x _ ↦ by unfold F'; fun_prop) hint]
  simp_rw [hdiv]
  rw [setIntegral_const]
  change (volume (Icc unitCubeLower unitCubeUpper)).toReal * 3 = 3
  rw [Real.volume_Icc_pi_toReal hab]
  simp [unitCubeLower, unitCubeUpper]

/-! ## Stokes 公式：水平单位正方形 -/

/-- `z=0` 平面内的水平单位正方形参数化 `σ(u,v)=(u,v,0)`。 -/
def horizontalUnitSquare : ParametrizedSurface 3 :=
  affinePlane 0 ![1, 0, 0] ![0, 1, 0]

/-- 空间 1-形式 `x dy`：在点 `x` 处把切向量 `v` 映为 `x₀v₁`。 -/
def xDyForm (x : Fin 3 → ℝ) : (Fin 3 → ℝ) →L[ℝ] ℝ :=
  x 0 • (ContinuousLinearMap.proj 1)

/-- **Stokes 例题**：水平单位正方形上 `x dy` 的边界环流等于 `1`。

参数化拉回后，`du` 系数为 `0`，`dv` 系数为 `u`，所以外微分密度为 `1`。
参数曲面 Stokes 公式把边界环流化为单位参数正方形上常数 `1` 的积分。
-/
theorem stokes_horizontalUnitSquare_xDy :
    rectangleBoundaryIntegral
      (surfacePullbackCoeff₁ xDyForm horizontalUnitSquare)
      (surfacePullbackCoeff₂ xDyForm horizontalUnitSquare) 0 0 1 1 = 1 := by
  have hP : surfacePullbackCoeff₁ xDyForm horizontalUnitSquare = fun _ ↦ 0 := by
    funext z
    simp [surfacePullbackCoeff₁, xDyForm, horizontalUnitSquare,
      surfaceTangent₁_affinePlane]
  have hQ : surfacePullbackCoeff₂ xDyForm horizontalUnitSquare = fun z ↦ z.1 := by
    funext z
    simp [surfacePullbackCoeff₂, xDyForm, horizontalUnitSquare, affinePlane,
      surfaceTangent₂_affinePlane]
  let P' : ℝ × ℝ → (ℝ × ℝ →L[ℝ] ℝ) := fun _ ↦ 0
  let Q' : ℝ × ℝ → (ℝ × ℝ →L[ℝ] ℝ) :=
    fun _ ↦ ContinuousLinearMap.fst ℝ ℝ ℝ
  have hstokes := stokes_parametrized_rectangle xDyForm horizontalUnitSquare
    P' Q' 0 0 1 1
    (by rw [hP]; fun_prop)
    (by rw [hQ]; fun_prop)
    (by intro z hz; rw [hP]; unfold P'; fun_prop)
    (by intro z hz; rw [hQ]; unfold Q'; fun_prop)
    (by
      have heq : (fun z ↦ Q' z (1, 0) - P' z (0, 1)) = fun _ ↦ (1 : ℝ) := by
        funext z
        simp [P', Q']
      rw [heq]
      exact integrableOn_const ((isCompact_Icc.prod isCompact_Icc).measure_lt_top.ne))
  rw [hstokes]
  simp [P', Q']

end SandronesLibrary.Examples.GaussStokes
