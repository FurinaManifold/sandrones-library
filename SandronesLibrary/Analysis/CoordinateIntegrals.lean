/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Analysis.ChangeOfVariables
import Mathlib.Analysis.SpecialFunctions.PolarCoord

/-!
# 坐标积分：二维极坐标

本模块开始建立多重积分的坐标计算层。第一批定义二维极坐标映射，计算其 Jacobian，
并把全平面 Lebesgue 积分改写成带权累次积分。角度采用 `(-π,π)`，半径采用 `(0,∞)`；
缺少的负实轴和原点是零测集，故不改变积分值。
-/

noncomputable section

namespace SandronesLibrary.Analysis.Multivariable

open Set MeasureTheory Real

/-- 教材中的二维极坐标映射 `(r,θ) ↦ (r cos θ,r sin θ)`。 -/
def polarMap (p : ℝ × ℝ) : ℝ × ℝ :=
  (p.1 * cos p.2, p.1 * sin p.2)

/-- 本库极坐标映射就是 Mathlib 极坐标局部同胚的逆向映射。 -/
theorem polarMap_eq_polarCoord_symm : polarMap = polarCoord.symm := by
  rfl

/-- **极坐标 Jacobian**：极坐标映射的导数行列式为半径 `r`。因此在 `r>0`
的标准坐标区域上，换元权重的绝对值就是 `r`。 -/
theorem det_fderiv_polarMap (p : ℝ × ℝ) :
    (fderiv ℝ polarMap p).det = p.1 := by
  rw [polarMap_eq_polarCoord_symm,
    (hasFDerivAt_polarCoord_symm p).fderiv]
  exact det_fderivPolarCoordSymm p

/-- **全平面极坐标公式**：

`∫_{ℝ²} f(x,y) dxdy = ∫_{r>0,-π<θ<π} r f(r cos θ,r sin θ) drdθ`。

负实轴和原点构成零测集，因此标准极坐标目标区域已经覆盖全平面积分。 -/
theorem integral_plane_eq_polar (f : ℝ × ℝ → ℝ) :
    (∫ z, f z) =
      ∫ p in Ioi (0 : ℝ) ×ˢ Ioo (-π) π, p.1 * f (polarMap p) := by
  simpa [polarMap, smul_eq_mul, polarCoord_target] using
    (integral_comp_polarCoord_symm f).symm

/-- 若极坐标拉回后的函数可积，则全平面积分可进一步写成先对角度、再对半径的
累次积分。显式的可积性假设保证 Fubini 换序合法。 -/
theorem integral_plane_eq_iterated_polar (f : ℝ × ℝ → ℝ)
    (hf : IntegrableOn (fun p ↦ p.1 * f (polarMap p))
      (Ioi (0 : ℝ) ×ˢ Ioo (-π) π) (volume.prod volume)) :
    (∫ z, f z) =
      ∫ r in Ioi (0 : ℝ), ∫ θ in Ioo (-π) π,
        r * f (r * cos θ, r * sin θ) := by
  rw [integral_plane_eq_polar]
  change (∫ p in Ioi (0 : ℝ) ×ˢ Ioo (-π) π,
      p.1 * f (polarMap p) ∂(volume.prod volume)) = _
  simpa [polarMap] using MeasureTheory.setIntegral_prod
    (fun p : ℝ × ℝ ↦ p.1 * f (polarMap p)) hf

/-! ## 三维柱坐标 -/

/-- 柱坐标映射 `((r,θ),z) ↦ ((r cos θ,r sin θ),z)`。三维空间在本模块中写成
`(ℝ × ℝ) × ℝ`，前两个分量构成水平平面。 -/
def cylindricalMap (p : (ℝ × ℝ) × ℝ) : (ℝ × ℝ) × ℝ :=
  (polarMap p.1, p.2)

/-- **全空间柱坐标公式**：若原函数及其柱坐标拉回可积，则

`∫_{ℝ³} f = ∫₀^∞ ∫_{-π}^π ∫_{-∞}^∞ r f(r cosθ,r sinθ,z) dz dθ dr`。

证明把柱坐标视为“二维极坐标 × 恒等坐标”：先用 Fubini 分离竖直坐标，再应用
二维极坐标公式，最后再次使用 Fubini 展开成三重累次积分。 -/
theorem integral_space_eq_iterated_cylindrical (f : (ℝ × ℝ) × ℝ → ℝ)
    (hf : Integrable f ((volume.prod volume).prod volume))
    (hcyl : IntegrableOn (fun p ↦ p.1.1 * f (cylindricalMap p))
      ((Ioi (0 : ℝ) ×ˢ Ioo (-π) π) ×ˢ (univ : Set ℝ))
      ((volume.prod volume).prod volume)) :
    (∫ q, f q ∂((volume.prod volume).prod volume)) =
      ∫ r in Ioi (0 : ℝ), ∫ θ in Ioo (-π) π, ∫ z : ℝ,
        r * f ((r * cos θ, r * sin θ), z) := by
  have hfull :
      (∫ q, f q ∂((volume.prod volume).prod volume)) =
        ∫ p : ℝ × ℝ, ∫ z : ℝ, f (p, z) :=
    integral_prod f hf
  rw [hfull, integral_plane_eq_polar]
  have htarget : MeasurableSet (Ioi (0 : ℝ) ×ˢ Ioo (-π) π) :=
    measurableSet_Ioi.prod measurableSet_Ioo
  have hcylIndicator : Integrable
      (((Ioi (0 : ℝ) ×ˢ Ioo (-π) π) ×ˢ (univ : Set ℝ)).indicator
        (fun p ↦ p.1.1 * f (cylindricalMap p)))
      ((volume.prod volume).prod volume) :=
    hcyl.integrable_indicator (htarget.prod MeasurableSet.univ)
  have houter : IntegrableOn
      (fun p : ℝ × ℝ ↦ ∫ z : ℝ, p.1 * f (cylindricalMap (p, z)))
      (Ioi (0 : ℝ) ×ˢ Ioo (-π) π) (volume.prod volume) := by
    rw [← integrable_indicator_iff htarget]
    refine hcylIndicator.integral_prod_left.congr (Filter.Eventually.of_forall fun p ↦ ?_)
    by_cases hp : p ∈ Ioi (0 : ℝ) ×ˢ Ioo (-π) π <;> simp [hp]
  calc
    (∫ p in Ioi (0 : ℝ) ×ˢ Ioo (-π) π,
        p.1 * ∫ z : ℝ, f (polarMap p, z)) =
      ∫ p in Ioi (0 : ℝ) ×ˢ Ioo (-π) π,
        ∫ z : ℝ, p.1 * f (cylindricalMap (p, z)) := by
          apply setIntegral_congr_fun htarget
          intro p _
          dsimp
          rw [integral_const_mul]
          rfl
    _ = ∫ r in Ioi (0 : ℝ), ∫ θ in Ioo (-π) π, ∫ z : ℝ,
        r * f ((r * cos θ, r * sin θ), z) := by
      change (∫ p in Ioi (0 : ℝ) ×ˢ Ioo (-π) π,
        (∫ z : ℝ, p.1 * f (cylindricalMap (p, z))) ∂(volume.prod volume)) = _
      simpa [cylindricalMap, polarMap] using
        MeasureTheory.setIntegral_prod
          (fun p : ℝ × ℝ ↦ ∫ z : ℝ, p.1 * f (cylindricalMap (p, z))) houter

/-! ## 三维球坐标 -/

/-- 三维欧氏坐标的函数空间表示。 -/
abbrev Euclidean3 := Fin 3 → ℝ

/-- 球坐标映射，输入坐标依次为 `(ρ, θ, φ)`：径向距离、方位角和极角。

`(ρ,θ,φ) ↦ (ρ sinφ cosθ, ρ sinφ sinθ, ρ cosφ)`。 -/
def sphericalMap (p : Euclidean3) : Euclidean3 :=
  ![p 0 * sin (p 2) * cos (p 1),
    p 0 * sin (p 2) * sin (p 1),
    p 0 * cos (p 2)]

attribute [local instance 10000] NormedAlgebra.toNormedSpace

/-- 球坐标映射的教材 Jacobian 矩阵。列依次对应 `ρ,θ,φ`，行依次对应
直角坐标 `x,y,z`。 -/
def sphericalDerivativeMatrix (p : Euclidean3) : Matrix (Fin 3) (Fin 3) ℝ :=
  !![sin (p 2) * cos (p 1), -(p 0 * sin (p 2) * sin (p 1)),
      p 0 * cos (p 2) * cos (p 1);
    sin (p 2) * sin (p 1), p 0 * sin (p 2) * cos (p 1),
      p 0 * cos (p 2) * sin (p 1);
    cos (p 2), 0, -(p 0 * sin (p 2))]

/-- 球坐标 Jacobian 矩阵所表示的连续线性映射。 -/
def sphericalDerivative (p : Euclidean3) : Euclidean3 →L[ℝ] Euclidean3 :=
  (Matrix.toLin' (sphericalDerivativeMatrix p)).toContinuousLinearMap

/-- 球坐标映射的 Fréchet 导数就是显式 Jacobian 矩阵对应的线性映射。

证明逐坐标调用一维的 `sin`、`cos` 导数，再用乘积法则组装三个坐标函数；
最后将三个标量导数拼成向量值导数，并核对它与教材矩阵逐项一致。 -/
theorem hasFDerivAt_sphericalMap (p : Euclidean3) :
    HasFDerivAt sphericalMap (sphericalDerivative p) p := by
  have hρ : HasFDerivAt (fun q : Euclidean3 ↦ q 0)
      (ContinuousLinearMap.proj (R := ℝ) 0) p := by fun_prop
  have hθ : HasFDerivAt (fun q : Euclidean3 ↦ q 1)
      (ContinuousLinearMap.proj (R := ℝ) 1) p := by fun_prop
  have hφ : HasFDerivAt (fun q : Euclidean3 ↦ q 2)
      (ContinuousLinearMap.proj (R := ℝ) 2) p := by fun_prop
  have hsθ := (Real.hasDerivAt_sin (p 1)).hasFDerivAt.comp p hθ
  have hcθ := (Real.hasDerivAt_cos (p 1)).hasFDerivAt.comp p hθ
  have hsφ := (Real.hasDerivAt_sin (p 2)).hasFDerivAt.comp p hφ
  have hcφ := (Real.hasDerivAt_cos (p 2)).hasFDerivAt.comp p hφ
  let e0 : Euclidean3 →L[ℝ] ℝ := ContinuousLinearMap.proj 0
  let e1 : Euclidean3 →L[ℝ] ℝ := ContinuousLinearMap.proj 1
  let e2 : Euclidean3 →L[ℝ] ℝ := ContinuousLinearMap.proj 2
  let d0 := (p 0 * sin (p 2)) •
      (ContinuousLinearMap.toSpanSingleton ℝ (-sin (p 1)) ∘SL e1) +
    cos (p 1) • (p 0 •
      (ContinuousLinearMap.toSpanSingleton ℝ (cos (p 2)) ∘SL e2) +
      sin (p 2) • e0)
  let d1 := (p 0 * sin (p 2)) •
      (ContinuousLinearMap.toSpanSingleton ℝ (cos (p 1)) ∘SL e1) +
    sin (p 1) • (p 0 •
      (ContinuousLinearMap.toSpanSingleton ℝ (cos (p 2)) ∘SL e2) +
      sin (p 2) • e0)
  let d2 := p 0 •
      (ContinuousLinearMap.toSpanSingleton ℝ (-sin (p 2)) ∘SL e2) +
    cos (p 2) • e0
  have h0 := (hρ.mul hsφ).mul hcθ
  have h1 := (hρ.mul hsφ).mul hsθ
  have h2 := hρ.mul hcφ
  let D : Fin 3 → (Euclidean3 →L[ℝ] ℝ) := ![d0, d1, d2]
  have hD : HasFDerivAt sphericalMap (ContinuousLinearMap.pi D) p := by
    rw [hasFDerivAt_pi]
    intro i
    fin_cases i
    · change HasFDerivAt
        (((fun q : Euclidean3 ↦ q 0) * (fun q ↦ sin (q 2))) *
          (fun q ↦ cos (q 1))) _ p
      simpa [D, d0, e0, e1, e2, Function.comp_def] using h0
    · change HasFDerivAt
        (((fun q : Euclidean3 ↦ q 0) * (fun q ↦ sin (q 2))) *
          (fun q ↦ sin (q 1))) _ p
      simpa [D, d1, e0, e1, e2, Function.comp_def] using h1
    · change HasFDerivAt
        ((fun q : Euclidean3 ↦ q 0) * (fun q ↦ cos (q 2))) _ p
      simpa [D, d2, e0, e1, e2, Function.comp_def] using h2
  have heq : sphericalDerivative p = ContinuousLinearMap.pi D := by
    apply ContinuousLinearMap.ext
    intro v
    funext i
    fin_cases i <;>
      simp [sphericalDerivative, sphericalDerivativeMatrix, Matrix.toLin'_apply,
        Matrix.vecHead, Matrix.vecTail, D, d0, d1, d2, e0, e1, e2] <;> ring
  rw [heq]
  exact hD

/-- 球坐标 Jacobian 矩阵的行列式。负号来自本库采用的坐标顺序
`(ρ,θ,φ)`；教材常用的 `(ρ,φ,θ)` 交换了后两列。 -/
theorem det_sphericalDerivativeMatrix (p : Euclidean3) :
    (sphericalDerivativeMatrix p).det = -((p 0) ^ 2 * sin (p 2)) := by
  rw [Matrix.det_fin_three]
  simp [sphericalDerivativeMatrix]
  have hθ := sin_sq_add_cos_sq (p 1)
  have hφ := sin_sq_add_cos_sq (p 2)
  calc
    _ = -((p 0) ^ 2 * sin (p 2) *
        ((sin (p 1)) ^ 2 + (cos (p 1)) ^ 2) *
        ((sin (p 2)) ^ 2 + (cos (p 2)) ^ 2)) := by ring
    _ = _ := by rw [hθ, hφ]; ring

/-- 球坐标映射的导数行列式为 `-ρ² sin φ`。因此在标准区域
`ρ > 0, 0 < φ < π` 上，换元公式中的绝对 Jacobian 是 `ρ² sin φ`。 -/
theorem det_fderiv_sphericalMap (p : Euclidean3) :
    (fderiv ℝ sphericalMap p).det = -((p 0) ^ 2 * sin (p 2)) := by
  rw [(hasFDerivAt_sphericalMap p).fderiv]
  simpa [sphericalDerivative, ContinuousLinearMap.det,
    LinearMap.det_toMatrix'] using det_sphericalDerivativeMatrix p

/-- 球坐标映射在全空间上 Fréchet 可微。 -/
theorem differentiable_sphericalMap : Differentiable ℝ sphericalMap := by
  rw [differentiable_pi]
  intro i
  fin_cases i <;> simp [sphericalMap] <;> fun_prop

/-- 球坐标映射的第一坐标。 -/
theorem sphericalMap_apply_zero (p : Euclidean3) :
    sphericalMap p 0 = p 0 * sin (p 2) * cos (p 1) := by rfl

/-- 球坐标映射的第二坐标。 -/
theorem sphericalMap_apply_one (p : Euclidean3) :
    sphericalMap p 1 = p 0 * sin (p 2) * sin (p 1) := by rfl

/-- 球坐标映射的第三坐标。 -/
theorem sphericalMap_apply_two (p : Euclidean3) :
    sphericalMap p 2 = p 0 * cos (p 2) := by rfl

end SandronesLibrary.Analysis.Multivariable
