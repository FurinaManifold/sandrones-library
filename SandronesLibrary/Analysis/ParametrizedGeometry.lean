/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Analysis.MultivariableCalculus
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral.IntegrationByParts

/-!
# 参数曲线与参数曲面

本模块建立经典微分几何和曲线曲面积分所需的教材层前置接口：参数曲线的速度、速率、正则性与弧长，以及二参数曲面的坐标切向量和正则性。第一批可计算模型是仿射直线与仿射平面。
-/

noncomputable section

namespace SandronesLibrary.Analysis.Multivariable

open Set MeasureTheory
open scoped Interval

/-- `ℝⁿ` 中的参数曲线。 -/
abbrev ParametrizedCurve (n : ℕ) := ℝ → (Fin n → ℝ)

/-- 参数曲线在 `t` 处的速度向量。 -/
def curveVelocity {n : ℕ} (γ : ParametrizedCurve n) (t : ℝ) : Fin n → ℝ :=
  deriv γ t

/-- 参数曲线在 `t` 处的速率。 -/
def curveSpeed {n : ℕ} (γ : ParametrizedCurve n) (t : ℝ) : ℝ :=
  ‖curveVelocity γ t‖

/-- 曲线在一点正则：该点可微且速度向量非零。 -/
def CurveRegularAt {n : ℕ} (γ : ParametrizedCurve n) (t : ℝ) : Prop :=
  DifferentiableAt ℝ γ t ∧ curveVelocity γ t ≠ 0

/-- 曲线在参数集合上正则。 -/
def CurveRegularOn {n : ℕ} (γ : ParametrizedCurve n) (s : Set ℝ) : Prop :=
  ∀ t ∈ s, CurveRegularAt γ t

/-- 参数曲线在有向区间 `[a,b]` 上的弧长。 -/
def curveArcLength {n : ℕ} (γ : ParametrizedCurve n) (a b : ℝ) : ℝ :=
  ∫ t in a..b, curveSpeed γ t

/-- 起点 `p` 、方向 `v` 的仿射直线。 -/
def affineLine {n : ℕ} (p v : Fin n → ℝ) : ParametrizedCurve n :=
  fun t ↦ p + t • v

theorem hasDerivAt_affineLine {n : ℕ} (p v : Fin n → ℝ) (t : ℝ) :
    HasDerivAt (affineLine p v) v t := by
  change HasDerivAt (fun s : ℝ ↦ p + s • v) v t
  simpa only [id_eq, one_smul] using
    ((hasDerivAt_id t).smul_const v |>.const_add p)

theorem curveVelocity_affineLine {n : ℕ} (p v : Fin n → ℝ) (t : ℝ) :
    curveVelocity (affineLine p v) t = v := by
  exact (hasDerivAt_affineLine p v t).deriv

theorem curveSpeed_affineLine {n : ℕ} (p v : Fin n → ℝ) (t : ℝ) :
    curveSpeed (affineLine p v) t = ‖v‖ := by
  rw [curveSpeed, curveVelocity_affineLine]

theorem curveRegularAt_affineLine_iff {n : ℕ} (p v : Fin n → ℝ) (t : ℝ) :
    CurveRegularAt (affineLine p v) t ↔ v ≠ 0 := by
  simp [CurveRegularAt, (hasDerivAt_affineLine p v t).differentiableAt,
    curveVelocity_affineLine]

theorem curveArcLength_affineLine {n : ℕ} (p v : Fin n → ℝ) (a b : ℝ) :
    curveArcLength (affineLine p v) a b = (b - a) * ‖v‖ := by
  simp [curveArcLength, curveSpeed_affineLine, intervalIntegral.integral_const,
    smul_eq_mul]

/-! ## 弧长与保向换参数 -/

/-- 曲线复合标量参数变换后的速度满足链式法则。 -/
theorem curveVelocity_comp {n : ℕ} (γ : ParametrizedCurve n) (φ : ℝ → ℝ) (t : ℝ)
    (hγ : DifferentiableAt ℝ γ (φ t)) (hφ : DifferentiableAt ℝ φ t) :
    curveVelocity (γ ∘ φ) t = deriv φ t • curveVelocity γ (φ t) := by
  exact (hγ.hasDerivAt.scomp t hφ.hasDerivAt).deriv

/-- 换参数后的速率等于原速率乘参数变化率的绝对值。 -/
theorem curveSpeed_comp {n : ℕ} (γ : ParametrizedCurve n) (φ : ℝ → ℝ) (t : ℝ)
    (hγ : DifferentiableAt ℝ γ (φ t)) (hφ : DifferentiableAt ℝ φ t) :
    curveSpeed (γ ∘ φ) t = |deriv φ t| * curveSpeed γ (φ t) := by
  rw [curveSpeed, curveVelocity_comp γ φ t hγ hφ, norm_smul, curveSpeed]
  exact congrArg (fun r ↦ r * ‖curveVelocity γ (φ t)‖) (Real.norm_eq_abs _)

/-- 对保向参数变换，参数导数非负，速率公式中的绝对值可以去掉。 -/
theorem curveSpeed_comp_of_deriv_nonneg {n : ℕ}
    (γ : ParametrizedCurve n) (φ : ℝ → ℝ) (t : ℝ)
    (hγ : DifferentiableAt ℝ γ (φ t)) (hφ : DifferentiableAt ℝ φ t)
    (hφnonneg : 0 ≤ deriv φ t) :
    curveSpeed (γ ∘ φ) t = curveSpeed γ (φ t) * deriv φ t := by
  rw [curveSpeed_comp γ φ t hγ hφ, abs_of_nonneg hφnonneg, mul_comm]

/-- 弧长在保向可微换参数下不变。

右端端点自动变为 `φ c`、`φ d`。假设 `deriv φ ≥ 0` 表示参数变换保向；
允许导数在个别位置为零，因此该结论也覆盖非严格但不反向的参数变化。
-/
theorem curveArcLength_comp_of_deriv_nonneg {n : ℕ}
    (γ : ParametrizedCurve n) (φ : ℝ → ℝ) (c d : ℝ)
    (hγ : Differentiable ℝ γ) (hφ : Differentiable ℝ φ)
    (hφnonneg : ∀ t, 0 ≤ deriv φ t) :
    curveArcLength (γ ∘ φ) c d = curveArcLength γ (φ c) (φ d) := by
  rw [curveArcLength, curveArcLength]
  simp_rw [curveSpeed_comp_of_deriv_nonneg γ φ _ (hγ _) (hφ _) (hφnonneg _)]
  simpa only [Function.comp_apply] using
    (intervalIntegral.integral_comp_mul_deriv_of_deriv_nonneg
      (a := c) (b := d) (f := φ) (f' := deriv φ) (g := curveSpeed γ)
      hφ.continuous.continuousOn
      (fun t _ ↦ (hφ t).hasDerivAt)
      (fun t _ ↦ hφnonneg t))

/-- 若换参数保持指定端点，则新旧参数化在相应区间上的弧长完全相同。 -/
theorem curveArcLength_comp_of_deriv_nonneg_of_endpoints {n : ℕ}
    (γ : ParametrizedCurve n) (φ : ℝ → ℝ) (a b c d : ℝ)
    (hγ : Differentiable ℝ γ) (hφ : Differentiable ℝ φ)
    (hφnonneg : ∀ t, 0 ≤ deriv φ t) (hc : φ c = a) (hd : φ d = b) :
    curveArcLength (γ ∘ φ) c d = curveArcLength γ a b := by
  simpa [hc, hd] using curveArcLength_comp_of_deriv_nonneg γ φ c d hγ hφ hφnonneg

/-! ## 参数曲面 -/

/-- `ℝⁿ` 中的二参数曲面片。 -/
abbrev ParametrizedSurface (n : ℕ) := (ℝ × ℝ) → (Fin n → ℝ)

/-- 曲面的第一个坐标切向量 `∂σ/∂u`。 -/
def surfaceTangent₁ {n : ℕ} (σ : ParametrizedSurface n) (p : ℝ × ℝ) : Fin n → ℝ :=
  fderiv ℝ σ p (1, 0)

/-- 曲面的第二个坐标切向量 `∂σ/∂v`。 -/
def surfaceTangent₂ {n : ℕ} (σ : ParametrizedSurface n) (p : ℝ × ℝ) : Fin n → ℝ :=
  fderiv ℝ σ p (0, 1)

/-- 曲面在一点正则：该点可微且微分作为 `ℝ² → ℝⁿ` 的线性映射单射。 -/
def SurfaceRegularAt {n : ℕ} (σ : ParametrizedSurface n) (p : ℝ × ℝ) : Prop :=
  DifferentiableAt ℝ σ p ∧ Function.Injective (fderiv ℝ σ p)

/-- 曲面在参数域上正则。 -/
def SurfaceRegularOn {n : ℕ} (σ : ParametrizedSurface n) (s : Set (ℝ × ℝ)) : Prop :=
  ∀ p ∈ s, SurfaceRegularAt σ p

/-- 起点 `p` 与两个方向 `u,v` 决定的仿射平面参数化。 -/
def affinePlane {n : ℕ} (p u v : Fin n → ℝ) : ParametrizedSurface n :=
  fun a ↦ p + a.1 • u + a.2 • v

theorem differentiable_affinePlane {n : ℕ} (p u v : Fin n → ℝ) :
    Differentiable ℝ (affinePlane p u v) := by
  unfold affinePlane
  fun_prop

/-- 仿射平面的微分与基点、参数点无关，并把参数增量 `(s,t)` 映到 `s u + t v`。 -/
theorem hasFDerivAt_affinePlane {n : ℕ} (p u v : Fin n → ℝ) (a : ℝ × ℝ) :
    HasFDerivAt (affinePlane p u v)
      ((ContinuousLinearMap.fst ℝ ℝ ℝ).smulRight u +
        (ContinuousLinearMap.snd ℝ ℝ ℝ).smulRight v) a := by
  unfold affinePlane
  fun_prop

/-- 仿射平面沿第一个参数方向的切向量就是第一个生成向量。 -/
theorem surfaceTangent₁_affinePlane {n : ℕ} (p u v : Fin n → ℝ) (a : ℝ × ℝ) :
    surfaceTangent₁ (affinePlane p u v) a = u := by
  rw [surfaceTangent₁, (hasFDerivAt_affinePlane p u v a).fderiv]
  simp

/-- 仿射平面沿第二个参数方向的切向量就是第二个生成向量。 -/
theorem surfaceTangent₂_affinePlane {n : ℕ} (p u v : Fin n → ℝ) (a : ℝ × ℝ) :
    surfaceTangent₂ (affinePlane p u v) a = v := by
  rw [surfaceTangent₂, (hasFDerivAt_affinePlane p u v a).fderiv]
  simp

/-- 仿射平面正则当且仅当两个生成方向线性无关。

这把“微分为单射”的坐标无关定义还原成教材中熟悉的判据：切平面的两个坐标方向不能退化到同一直线上。
-/
theorem surfaceRegularAt_affinePlane_iff {n : ℕ} (p u v : Fin n → ℝ) (a : ℝ × ℝ) :
    SurfaceRegularAt (affinePlane p u v) a ↔ LinearIndependent ℝ ![u, v] := by
  rw [SurfaceRegularAt, (hasFDerivAt_affinePlane p u v a).fderiv]
  simp only [(hasFDerivAt_affinePlane p u v a).differentiableAt, true_and]
  rw [Fintype.linearIndependent_iff]
  constructor
  · intro hinj g hg i
    have hpair : (g 0, g 1) = (0, 0) := hinj (by
      ext j
      simpa [Fin.sum_univ_two] using congrFun hg j)
    fin_cases i
    · simpa using congrArg (fun z ↦ z.1) hpair
    · simpa using congrArg (fun z ↦ z.2) hpair
  · intro hli x y hxy
    have hcoeff := hli ![x.1 - y.1, x.2 - y.2] (by
      ext j
      have hj := congrFun hxy j
      simp at hj
      simp [Fin.sum_univ_two]
      linear_combination hj)
    apply Prod.ext
    · exact sub_eq_zero.mp (hcoeff 0)
    · exact sub_eq_zero.mp (hcoeff 1)

/-! ## 仿射平面的坐标无关性 -/

/-- 由基点 `p` 和方向子空间 `span{u,v}` 决定的仿射平面点集。

写成 `x - p ∈ span{u,v}`，可以把几何对象本身与选取的参数坐标分开。
-/
def affinePlaneSet {n : ℕ} (p u v : Fin n → ℝ) : Set (Fin n → ℝ) :=
  {x | x - p ∈ Submodule.span ℝ ({u, v} : Set (Fin n → ℝ))}

/-- 参数化 `p + s u + t v` 的值域恰好是仿射点集 `p + span{u,v}`。 -/
theorem range_affinePlane {n : ℕ} (p u v : Fin n → ℝ) :
    Set.range (affinePlane p u v) = affinePlaneSet p u v := by
  ext x
  constructor
  · rintro ⟨a, rfl⟩
    rw [affinePlaneSet, Set.mem_ofPred_eq, Submodule.mem_span_pair]
    refine ⟨a.1, a.2, ?_⟩
    ext i
    simp [affinePlane]
    ring
  · intro hx
    rw [affinePlaneSet, Set.mem_ofPred_eq, Submodule.mem_span_pair] at hx
    obtain ⟨s, t, hst⟩ := hx
    refine ⟨(s, t), ?_⟩
    rw [affinePlane]
    ext i
    have hi := congrFun hst i
    simp at hi ⊢
    linarith

/-- 仿射平面不依赖于生成方向的具体选择，只依赖于它们张成的子空间。

因此，对方向组作任意可逆线性换基不会改变参数化的像集；改变的只是同一平面上的参数坐标。
-/
theorem range_affinePlane_eq_of_span_eq {n : ℕ}
    (p u v u' v' : Fin n → ℝ)
    (hspan : Submodule.span ℝ ({u, v} : Set (Fin n → ℝ)) =
      Submodule.span ℝ ({u', v'} : Set (Fin n → ℝ))) :
    Set.range (affinePlane p u v) = Set.range (affinePlane p u' v') := by
  rw [range_affinePlane, range_affinePlane]
  ext x
  simp only [affinePlaneSet, Set.mem_ofPred_eq, hspan]

end SandronesLibrary.Analysis.Multivariable
