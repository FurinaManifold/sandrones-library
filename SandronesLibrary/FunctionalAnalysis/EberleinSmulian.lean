/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.FunctionalAnalysis.WeakTopology
import SandronesLibrary.FunctionalAnalysis.BanachAlaoglu
import SandronesLibrary.FunctionalAnalysis.BidualReflexive
import SandronesLibrary.FunctionalAnalysis.BanachDieudonne
import SandronesLibrary.FunctionalAnalysis.AnnihilatorClosure
import SandronesLibrary.FunctionalAnalysis.SeparableDual
import Mathlib.Analysis.LocallyConvex.Separation
import Mathlib.Analysis.LocallyConvex.WeakDual

/-!
# Eberlein--Šmulian 定理

本文件沿 Bühler--Salamon 定理 3.4.1 的范围，研究实 Banach 空间闭单位球的自反性、
弱紧致性、弱序列紧致性与有界序列抽取性质。
-/

namespace SandronesLibrary.FunctionalAnalysis

open Filter Set

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

private def dualRestrictionLinear (S : Submodule ℝ E) :
    StrongDual ℝ E →ₗ[ℝ] StrongDual ℝ S where
  toFun f := f.domRestrict S
  map_add' f g := by ext; rfl
  map_smul' c f := by ext; rfl

private theorem dualRestrictionLinear_norm_le (S : Submodule ℝ E) (f : StrongDual ℝ E) :
    ‖dualRestrictionLinear S f‖ ≤ 1 * ‖f‖ := by
  rw [one_mul]
  apply ContinuousLinearMap.opNorm_le_bound _ (norm_nonneg f)
  intro x
  exact (f.le_opNorm (x : E)).trans_eq (by simp)

private noncomputable def dualRestriction (S : Submodule ℝ E) :
    StrongDual ℝ E →L[ℝ] StrongDual ℝ S :=
  LinearMap.mkContinuous (𝕜 := ℝ) (𝕜₂ := ℝ) (σ := RingHom.id ℝ)
    (E := StrongDual ℝ E) (F := StrongDual ℝ S)
    (dualRestrictionLinear S) 1 (dualRestrictionLinear_norm_le S)

@[simp] private theorem dualRestriction_apply (S : Submodule ℝ E)
    (f : StrongDual ℝ E) (x : S) : dualRestriction S f x = f x := by
  simp [dualRestriction, dualRestrictionLinear]

/-- Closed subspaces inherit surjectivity of the canonical bidual embedding. -/
theorem reflexive_closedSubspace
    (S : Submodule ℝ E) (hS : IsClosed (S : Set E))
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)) :
    Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ S) := by
  intro Φ
  let ΦE : StrongDual ℝ (StrongDual ℝ E) := Φ.comp (dualRestriction S)
  obtain ⟨x, hx⟩ := hE ΦE
  have hxS : x ∈ S := by
    apply (mem_closedSubspace_iff_forall_annihilator S hS x).mpr
    intro f hf
    have hrestrict : dualRestriction S f = 0 := by
      apply ContinuousLinearMap.ext
      intro y
      simpa using (mem_continuousAnnihilator_iff S f).mp hf y y.property
    have hxeval : f x = ΦE f := by
      have := congrArg (fun G : StrongDual ℝ (StrongDual ℝ E) ↦ G f) hx
      simpa only [bidual_evaluation] using this
    rw [hxeval]
    simp [ΦE, hrestrict]
  let y : S := ⟨x, hxS⟩
  refine ⟨y, ?_⟩
  apply ContinuousLinearMap.ext
  intro g
  obtain ⟨f, hfext, _hfnorm⟩ := exists_extension_norm_eq S g
  have hrestrict : dualRestriction S f = g := by
    apply ContinuousLinearMap.ext
    intro z
    exact hfext z
  have hxeval : f x = ΦE f := by
    have := congrArg (fun G : StrongDual ℝ (StrongDual ℝ E) ↦ G f) hx
    simpa only [bidual_evaluation] using this
  rw [bidual_evaluation]
  change g y = Φ g
  rw [← hrestrict, dualRestriction_apply, show (y : E) = x from rfl, hxeval]
  rfl

/-- 原赋范空间闭单位球在弱拓扑类型中的像。

> **Entry**: functional-analysis.eberlein-smulian
-/
def weakClosedUnitBall : Set (WeakSpace ℝ E) :=
  toWeakSpace ℝ E '' Metric.closedBall (0 : E) 1

@[simp] private theorem toStrongDual_inclusionInDoubleDualWeak (x : E) :
    WeakDual.toStrongDual
      (NormedSpace.inclusionInDoubleDualWeak ℝ E (toWeakSpace ℝ E x)) =
        NormedSpace.inclusionInDoubleDual ℝ E x := by
  apply ContinuousLinearMap.ext
  intro f
  rfl

/-- 弱闭单位球也可以看作双对偶弱星闭单位球沿典范弱嵌入的原像。 -/
theorem weakClosedUnitBall_eq_preimage_bidualBall :
    weakClosedUnitBall (E := E) =
      NormedSpace.inclusionInDoubleDualWeak ℝ E ⁻¹'
        (WeakDual.toStrongDual ⁻¹'
          Metric.closedBall (0 : StrongDual ℝ (StrongDual ℝ E)) 1) := by
  ext x
  constructor
  · rintro ⟨y, hy, rfl⟩
    have hy' : y ∈ (NormedSpace.inclusionInDoubleDualLi ℝ) ⁻¹'
        Metric.closedBall (NormedSpace.inclusionInDoubleDualLi ℝ (0 : E)) 1 := by
      simpa using hy
    change NormedSpace.inclusionInDoubleDual ℝ E y ∈
      Metric.closedBall (NormedSpace.inclusionInDoubleDual ℝ E 0) 1 at hy'
    simpa only [Set.mem_preimage, toStrongDual_inclusionInDoubleDualWeak, map_zero] using hy'
  · intro hx
    rw [← (toWeakSpace ℝ E).apply_symm_apply x] at hx
    refine ⟨(toWeakSpace ℝ E).symm x, ?_, by simp⟩
    change WeakDual.toStrongDual
      (NormedSpace.inclusionInDoubleDualWeak ℝ E
        (toWeakSpace ℝ E ((toWeakSpace ℝ E).symm x))) ∈
          Metric.closedBall (0 : StrongDual ℝ (StrongDual ℝ E)) 1 at hx
    have hx' : (toWeakSpace ℝ E).symm x ∈
        (NormedSpace.inclusionInDoubleDualLi ℝ) ⁻¹'
          Metric.closedBall (NormedSpace.inclusionInDoubleDualLi ℝ (0 : E)) 1 := by
      change NormedSpace.inclusionInDoubleDual ℝ E ((toWeakSpace ℝ E).symm x) ∈
        Metric.closedBall (NormedSpace.inclusionInDoubleDual ℝ E 0) 1
      simpa only [toStrongDual_inclusionInDoubleDualWeak, map_zero] using hx
    simpa using hx'

/-- 闭单位球在弱拓扑中为闭集。 -/
theorem weakClosedUnitBall_isClosed :
    IsClosed (weakClosedUnitBall (E := E)) := by
  rw [weakClosedUnitBall_eq_preimage_bidualBall]
  exact (weakStar_isClosed_closedBall (E := StrongDual ℝ E) 0 1).preimage
    (NormedSpace.inclusionInDoubleDualWeak ℝ E).continuous

set_option backward.isDefEq.respectTransparency.types false in
set_option maxHeartbeats 800000 in
-- Weak-dual type synonym unfolding and separation-functional synthesis need a larger elaboration budget.
/-- Goldstine's unit-ball form: the canonical image of the closed unit ball is weak-star dense
in the bidual closed unit ball. This is the approximation input used in the difficult direction
of Bühler--Salamon Theorem 3.4.1. -/
theorem closure_inclusionInDoubleDualWeak_unitBall :
    closure (NormedSpace.inclusionInDoubleDualWeak ℝ E '' weakClosedUnitBall (E := E)) =
      WeakDual.toStrongDual ⁻¹'
        Metric.closedBall (0 : StrongDual ℝ (StrongDual ℝ E)) 1 := by
  apply Set.Subset.antisymm
  · exact closure_minimal (by
      rintro Φ ⟨x, hx, rfl⟩
      exact (show x ∈ NormedSpace.inclusionInDoubleDualWeak ℝ E ⁻¹'
        (WeakDual.toStrongDual ⁻¹'
          Metric.closedBall (0 : StrongDual ℝ (StrongDual ℝ E)) 1) by
            rw [← weakClosedUnitBall_eq_preimage_bidualBall]
            exact hx))
      (weakStar_isClosed_closedBall (E := StrongDual ℝ E) 0 1)
  · intro Φ hΦ
    by_contra hnot
    let _ : LocallyConvexSpace ℝ (WeakDual ℝ (StrongDual ℝ E)) := by
      change LocallyConvexSpace ℝ
        (WeakBilin (topDualPairing ℝ (StrongDual ℝ E)))
      exact WeakBilin.locallyConvexSpace
        (𝕜 := ℝ) (E := StrongDual ℝ (StrongDual ℝ E)) (F := StrongDual ℝ E)
        (B := topDualPairing ℝ (StrongDual ℝ E))
    let A := NormedSpace.inclusionInDoubleDualWeak ℝ E '' weakClosedUnitBall (E := E)
    have hAconv : Convex ℝ A := by
      dsimp [A]
      change Convex ℝ (NormedSpace.inclusionInDoubleDualWeak ℝ E ''
        (toWeakSpace ℝ E '' Metric.closedBall (0 : E) 1))
      exact ((convex_closedBall (0 : E) 1).linear_image
        (toWeakSpace ℝ E).toLinearMap).linear_image
          (NormedSpace.inclusionInDoubleDualWeak ℝ E).toLinearMap
    obtain ⟨l, u, hlu, hul⟩ :=
      geometric_hahn_banach_closed_point hAconv.closure isClosed_closure hnot
    change StrongDual ℝ
      (WeakBilin (topDualPairing ℝ (StrongDual ℝ E))) at l
    obtain ⟨f, hf⟩ := LinearMap.dualEmbedding_surjective
      (𝕜 := ℝ) (E := StrongDual ℝ (StrongDual ℝ E)) (F := StrongDual ℝ E)
      (topDualPairing ℝ (StrongDual ℝ E)) l
    have hl_eval : ∀ Ψ : WeakDual ℝ (StrongDual ℝ E), l Ψ = Ψ f := by
      intro Ψ
      rw [← hf]
      rfl
    have hu_pos : 0 < u := by
      have hzero : (0 : WeakDual ℝ (StrongDual ℝ E)) ∈ closure A := by
        apply subset_closure
        refine ⟨(0 : WeakSpace ℝ E), ?_, by simp⟩
        exact ⟨0, by simp, by simp⟩
      simpa using hlu 0 hzero
    have hf_norm : ‖f‖ ≤ u := by
      apply f.opNorm_le_bound hu_pos.le
      intro x
      by_cases hx : x = 0
      · simp [hx]
      let y := ‖x‖⁻¹ • x
      have hy_norm : ‖y‖ = 1 := by
        simp [y, norm_smul, hx]
      have hy_ball : y ∈ Metric.closedBall (0 : E) 1 := by
        simp [Metric.mem_closedBall, dist_zero_right, hy_norm]
      have hpos : NormedSpace.inclusionInDoubleDualWeak ℝ E (toWeakSpace ℝ E y) ∈ A :=
        ⟨toWeakSpace ℝ E y, ⟨y, hy_ball, rfl⟩, rfl⟩
      have hneg : NormedSpace.inclusionInDoubleDualWeak ℝ E (toWeakSpace ℝ E (-y)) ∈ A := by
        refine ⟨toWeakSpace ℝ E (-y), ⟨-y, ?_, rfl⟩, rfl⟩
        simp [Metric.mem_closedBall, dist_zero_right, hy_norm]
      have hfy : |f y| < u := by
        rw [abs_lt]
        constructor
        · have := hlu _ (subset_closure hneg)
          have heval : l (NormedSpace.inclusionInDoubleDualWeak ℝ E
              (toWeakSpace ℝ E (-y))) = f (-y) := by
            rw [← hf]
            rfl
          have ht : f (-y) < u := heval ▸ this
          simp only [map_neg] at ht
          linarith
        · have := hlu _ (subset_closure hpos)
          have heval : l (NormedSpace.inclusionInDoubleDualWeak ℝ E
              (toWeakSpace ℝ E y)) = f y := by
            rw [← hf]
            rfl
          exact heval ▸ this
      calc
        ‖f x‖ = ‖‖x‖ • f y‖ := by
          have hxy : x = ‖x‖ • y := by
            simp [y, smul_smul, hx]
          congr 1
          calc
            f x = f (‖x‖ • y) := congrArg f hxy
            _ = ‖x‖ • f y := map_smul f _ _
        _ = ‖x‖ * |f y| := by
          rw [norm_smul, Real.norm_eq_abs, abs_of_nonneg (norm_nonneg x),
            Real.norm_eq_abs]
        _ ≤ u * ‖x‖ := by nlinarith [norm_nonneg x, le_of_lt hfy]
    have hΦf : Φ f ≤ u := by
      have hΦnorm : ‖WeakDual.toStrongDual Φ‖ ≤ 1 := by
        change WeakDual.toStrongDual Φ ∈
          Metric.closedBall (0 : StrongDual ℝ (StrongDual ℝ E)) 1 at hΦ
        exact (mem_closedBall_zero_iff
          (E := StrongDual ℝ (StrongDual ℝ E))).mp hΦ
      calc
        Φ f ≤ |Φ f| := le_abs_self _
        _ = ‖WeakDual.toStrongDual Φ f‖ := by rfl
        _ ≤ ‖WeakDual.toStrongDual Φ‖ * ‖f‖ :=
          (WeakDual.toStrongDual Φ).le_opNorm f
        _ ≤ 1 * u := mul_le_mul hΦnorm hf_norm (norm_nonneg f) zero_le_one
        _ = u := one_mul u
    rw [← hf] at hul
    change u < Φ f at hul
    exact (hul.trans_le hΦf).false

/-- Goldstine density in the finite-coordinate form used by the textbook proof: a bidual unit
functional can be approximated, with arbitrary accuracy, on any finite family of dual vectors by
evaluation at a point of the original closed unit ball. -/
theorem exists_unitBall_approx_bidual_on_finset
    (Φ : StrongDual ℝ (StrongDual ℝ E)) (hΦ : ‖Φ‖ ≤ 1)
    (s : Finset (StrongDual ℝ E)) {ε : ℝ} (hε : 0 < ε) :
    ∃ x ∈ Metric.closedBall (0 : E) 1, ∀ f ∈ s, |f x - Φ f| < ε := by
  let Φw : WeakDual ℝ (StrongDual ℝ E) := StrongDual.toWeakDual Φ
  let A := NormedSpace.inclusionInDoubleDualWeak ℝ E '' weakClosedUnitBall (E := E)
  let U : Set (WeakDual ℝ (StrongDual ℝ E)) :=
    ⋂ f ∈ s, (fun Ψ : WeakDual ℝ (StrongDual ℝ E) ↦ Ψ f) ⁻¹'
      Metric.ball (Φ f) ε
  have hΦball : Φw ∈ WeakDual.toStrongDual ⁻¹'
      Metric.closedBall (0 : StrongDual ℝ (StrongDual ℝ E)) 1 := by
    change Φ ∈ Metric.closedBall (0 : StrongDual ℝ (StrongDual ℝ E)) 1
    exact (mem_closedBall_zero_iff
      (E := StrongDual ℝ (StrongDual ℝ E))).mpr hΦ
  have hΦclosure : Φw ∈ closure A := by
    rw [closure_inclusionInDoubleDualWeak_unitBall]
    exact hΦball
  have hUopen : IsOpen U := by
    apply isOpen_biInter_finset
    intro f _hf
    exact Metric.isOpen_ball.preimage
      (WeakBilin.eval_continuous (topDualPairing ℝ (StrongDual ℝ E)) f)
  have hΦU : Φw ∈ U := by
    simp [U, Φw, hε]
  obtain ⟨Ψ, hΨU, hΨA⟩ := (mem_closure_iff.mp hΦclosure U hUopen hΦU)
  obtain ⟨xw, ⟨x, hx, rfl⟩, rfl⟩ := hΨA
  refine ⟨x, hx, ?_⟩
  intro f hf
  have hev := Set.mem_iInter₂.mp hΨU f hf
  change dist ((NormedSpace.inclusionInDoubleDualWeak ℝ E) (toWeakSpace ℝ E x) f)
    (Φ f) < ε at hev
  simpa only [NormedSpace.inclusionInDoubleDualWeak_apply, StrongDual.toWeakDual_apply,
    LinearIsometry.coe_toLinearMap, LinearEquiv.apply_symm_apply, LinearEquiv.symm_apply_apply,
    ContinuousLinearMap.coe_coe,
    Function.comp_apply, bidual_evaluation, Real.dist_eq] using hev

/-- Under the bounded-sequence extraction hypothesis, Goldstine approximation becomes exact on
each finite family of dual vectors. This is Step 1 in the difficult implication of
Bühler--Salamon Theorem 3.4.1. -/
theorem exists_unitBall_eq_bidual_on_finset
    (hbounded : ∀ u : ℕ → E, Bornology.IsBounded (Set.range u) →
      ∃ x : E, ∃ φ : ℕ → ℕ, StrictMono φ ∧
        ∀ f : StrongDual ℝ E,
          Tendsto (fun n ↦ f (u (φ n))) atTop (nhds (f x)))
    (Φ : StrongDual ℝ (StrongDual ℝ E)) (hΦ : ‖Φ‖ ≤ 1)
    (s : Finset (StrongDual ℝ E)) :
    ∃ x ∈ Metric.closedBall (0 : E) 1, ∀ f ∈ s, f x = Φ f := by
  have happrox : ∀ n : ℕ, ∃ x ∈ Metric.closedBall (0 : E) 1,
      ∀ f ∈ s, |f x - Φ f| < ((n + 1 : ℕ) : ℝ)⁻¹ := by
    intro n
    exact exists_unitBall_approx_bidual_on_finset Φ hΦ s (by positivity)
  choose u hu huf using happrox
  have hurange : Bornology.IsBounded (Set.range u) :=
    Metric.isBounded_closedBall.subset fun x hx ↦ by
      obtain ⟨n, rfl⟩ := hx
      exact hu n
  obtain ⟨x, φ, hφ, hconv⟩ := hbounded u hurange
  have hweak : Tendsto (fun n ↦ toWeakSpace ℝ E (u (φ n))) atTop
      (nhds (toWeakSpace ℝ E x)) :=
    (weak_tendsto_iff_forall_dual (u := u ∘ φ) (x := x)).mpr (by
      simpa only [Function.comp_apply] using hconv)
  have hxweak : toWeakSpace ℝ E x ∈ weakClosedUnitBall (E := E) :=
    weakClosedUnitBall_isClosed.mem_of_tendsto hweak
      (Filter.Eventually.of_forall fun n ↦ ⟨u (φ n), hu (φ n), rfl⟩)
  obtain ⟨y, hy, hyx⟩ := hxweak
  have hy_eq : y = x := (toWeakSpace ℝ E).injective hyx
  refine ⟨x, hy_eq ▸ hy, ?_⟩
  intro f hf
  have hbound : ∀ n, |f (u (φ n)) - Φ f| ≤ (((φ n + 1 : ℕ) : ℝ)⁻¹) :=
    fun n ↦ (huf (φ n) f hf).le
  have hright : Tendsto (fun n ↦ (((φ n + 1 : ℕ) : ℝ)⁻¹)) atTop (nhds 0) :=
    by
      simpa only [Function.comp_def, Nat.cast_add, Nat.cast_one, one_div] using
        (tendsto_one_div_add_atTop_nhds_zero_nat (𝕜 := ℝ)).comp hφ.tendsto_atTop
  have habs : Tendsto (fun n ↦ |f (u (φ n)) - Φ f|) atTop (nhds 0) :=
    squeeze_zero (fun _ ↦ abs_nonneg _) hbound hright
  have htoΦ : Tendsto (fun n ↦ f (u (φ n))) atTop (nhds (Φ f)) :=
    tendsto_iff_norm_sub_tendsto_zero.mpr (by
      simpa only [Real.norm_eq_abs] using habs)
  exact tendsto_nhds_unique (hconv f) htoΦ

/-- A closure point of a weak-star image can be approximated on any prescribed finite family of
vectors. This packages the neighborhood choice used repeatedly in Step 2 of the textbook proof. -/
theorem exists_mem_of_mem_closure_weakStarImage_on_finset
    {S : Set (StrongDual ℝ E)} {f₀ : StrongDual ℝ E}
    (hf₀ : StrongDual.toWeakDual f₀ ∈ closure (weakStarImage S))
    (t : Finset E) {ε : ℝ} (hε : 0 < ε) :
    ∃ f ∈ S, ∀ x ∈ t, |f x - f₀ x| < ε := by
  let U : Set (WeakDual ℝ E) :=
    ⋂ x ∈ t, (fun f : WeakDual ℝ E ↦ f x) ⁻¹' Metric.ball (f₀ x) ε
  have hUopen : IsOpen U := by
    apply isOpen_biInter_finset
    intro x _hx
    exact Metric.isOpen_ball.preimage (WeakDual.eval_continuous x)
  have hf₀U : StrongDual.toWeakDual f₀ ∈ U := by
    simp [U, hε]
  obtain ⟨g, hgU, hgw⟩ := mem_closure_iff.mp hf₀ U hUopen hf₀U
  obtain ⟨f, hfS, rfl⟩ := hgw
  refine ⟨f, hfS, ?_⟩
  intro x hx
  have hev := Set.mem_iInter₂.mp hgU x hx
  change dist ((StrongDual.toWeakDual f) x) (f₀ x) < ε at hev
  simpa only [StrongDual.toWeakDual_apply, Real.dist_eq] using hev

/-- A weak limit of a sequence can be approximated in norm by the convex hull of finitely many
terms of that sequence. This is the Mathlib-backed form of Bühler--Salamon (3.4.7). -/
theorem exists_finite_convex_approx_of_weak_tendsto
    (u : ℕ → E) (x₀ : E)
    (hu : Tendsto (fun n ↦ toWeakSpace ℝ E (u n)) atTop
      (nhds (toWeakSpace ℝ E x₀)))
    {ε : ℝ} (hε : 0 < ε) :
    ∃ t : Finset E, (t : Set E) ⊆ Set.range u ∧
      ∃ y ∈ convexHull ℝ (t : Set E), ‖x₀ - y‖ < ε := by
  let C : Set E := convexHull ℝ (Set.range u)
  have hconv : Convex ℝ C := convex_convexHull ℝ (Set.range u)
  have hxweak : toWeakSpace ℝ E x₀ ∈ closure (toWeakSpace ℝ E '' C) := by
    apply isClosed_closure.mem_of_tendsto hu
    exact Filter.Eventually.of_forall fun n ↦
      subset_closure ⟨u n,
        (subset_convexHull ℝ (Set.range u)) (Set.mem_range_self n), rfl⟩
  have hxnorm : x₀ ∈ closure C := by
    have himage : toWeakSpace ℝ E '' closure C =
        closure (toWeakSpace ℝ E '' C) := hconv.toWeakSpace_closure ℝ
    rw [← himage] at hxweak
    obtain ⟨y, hy, hyx⟩ := hxweak
    exact (toWeakSpace ℝ E).injective hyx ▸ hy
  obtain ⟨y, hyC, hyε⟩ := Metric.mem_closure_iff.mp hxnorm ε hε
  change y ∈ convexHull ℝ (Set.range u) at hyC
  rw [convexHull_eq_union_convexHull_finite_subsets] at hyC
  simp only [Set.mem_iUnion] at hyC
  obtain ⟨t, ht, hyt⟩ := hyC
  refine ⟨t, ht, y, hyt, ?_⟩
  simpa only [dist_eq_norm] using hyε

private theorem abs_apply_lt_of_mem_convexHull
    (g : StrongDual ℝ E) {t : Set E} {y : E} {ε : ℝ}
    (hy : y ∈ convexHull ℝ t) (ht : ∀ x ∈ t, |g x| < ε) :
    |g y| < ε := by
  have hsub : t ⊆ g.toLinearMap ⁻¹' Metric.ball (0 : ℝ) ε := by
    intro x hx
    change dist (g x) 0 < ε
    simpa only [Real.dist_eq, sub_zero] using ht x hx
  have hconv : Convex ℝ (g.toLinearMap ⁻¹' Metric.ball (0 : ℝ) ε) :=
    (convex_ball (0 : ℝ) ε).linear_preimage g.toLinearMap
  have hy' := convexHull_min hsub hconv hy
  change dist (g y) 0 < ε at hy'
  simpa only [Real.dist_eq, sub_zero] using hy'

private theorem apply_eq_of_mem_convexHull
    (g : StrongDual ℝ E) {t : Set E} {y : E} {c : ℝ}
    (hy : y ∈ convexHull ℝ t) (ht : ∀ x ∈ t, g x = c) :
    g y = c := by
  let A : Set E := {x | g x = c}
  have htA : t ⊆ A := fun x hx ↦ ht x hx
  have hAconv : Convex ℝ A := by
    intro x hx y hy a b ha hb hab
    change g (a • x + b • y) = c
    rw [map_add, map_smul, map_smul, hx, hy]
    simp [smul_eq_mul, ← add_mul, hab]
  exact convexHull_min htA hAconv hy

private structure EberleinChoiceData (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E] where
  boundedSubsequence : ∀ u : ℕ → E, Bornology.IsBounded (Set.range u) →
    ∃ x : E, ∃ φ : ℕ → ℕ, StrictMono φ ∧
      ∀ f : StrongDual ℝ E, Tendsto (fun n ↦ f (u (φ n))) atTop (nhds (f x))
  bidual : StrongDual ℝ (StrongDual ℝ E)
  bidual_norm : ‖bidual‖ ≤ 1
  dualSet : Set (StrongDual ℝ E)
  limitDual : StrongDual ℝ E
  limit_mem_closure : StrongDual.toWeakDual limitDual ∈ closure (weakStarImage dualSet)
  epsilon : ℝ
  epsilon_pos : 0 < epsilon

private structure EberleinHistory (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E] where
  duals : List (StrongDual ℝ E)
  points : List E

private noncomputable def EberleinChoiceData.nextPoint
    (d : EberleinChoiceData E) (st : EberleinHistory E) : E := by
  classical
  exact Classical.choose (exists_unitBall_eq_bidual_on_finset d.boundedSubsequence d.bidual
    d.bidual_norm (insert d.limitDual st.duals.toFinset))

private theorem EberleinChoiceData.nextPoint_mem_ball
    (d : EberleinChoiceData E) (st : EberleinHistory E) :
    d.nextPoint st ∈ Metric.closedBall (0 : E) 1 := by
  classical
  exact (Classical.choose_spec (exists_unitBall_eq_bidual_on_finset d.boundedSubsequence d.bidual
    d.bidual_norm (insert d.limitDual st.duals.toFinset))).1

private theorem EberleinChoiceData.nextPoint_limitDual
    (d : EberleinChoiceData E) (st : EberleinHistory E) :
    d.limitDual (d.nextPoint st) = d.bidual d.limitDual := by
  classical
  exact (Classical.choose_spec (exists_unitBall_eq_bidual_on_finset d.boundedSubsequence d.bidual
    d.bidual_norm (insert d.limitDual st.duals.toFinset))).2 d.limitDual (by simp)

private theorem EberleinChoiceData.nextPoint_oldDual
    (d : EberleinChoiceData E) (st : EberleinHistory E)
    {f : StrongDual ℝ E} (hf : f ∈ st.duals) :
    f (d.nextPoint st) = d.bidual f := by
  classical
  apply (Classical.choose_spec (exists_unitBall_eq_bidual_on_finset d.boundedSubsequence d.bidual
    d.bidual_norm (insert d.limitDual st.duals.toFinset))).2 f
  simp [hf]

private noncomputable def EberleinChoiceData.nextDual
    (d : EberleinChoiceData E) (st : EberleinHistory E) : StrongDual ℝ E := by
  classical
  exact Classical.choose (exists_mem_of_mem_closure_weakStarImage_on_finset d.limit_mem_closure
    (insert (d.nextPoint st) st.points.toFinset) d.epsilon_pos)

private theorem EberleinChoiceData.nextDual_mem
    (d : EberleinChoiceData E) (st : EberleinHistory E) :
    d.nextDual st ∈ d.dualSet := by
  classical
  exact (Classical.choose_spec (exists_mem_of_mem_closure_weakStarImage_on_finset
    d.limit_mem_closure (insert (d.nextPoint st) st.points.toFinset) d.epsilon_pos)).1

private theorem EberleinChoiceData.nextDual_newPoint
    (d : EberleinChoiceData E) (st : EberleinHistory E) :
    |d.nextDual st (d.nextPoint st) - d.limitDual (d.nextPoint st)| < d.epsilon := by
  classical
  apply (Classical.choose_spec (exists_mem_of_mem_closure_weakStarImage_on_finset
    d.limit_mem_closure (insert (d.nextPoint st) st.points.toFinset) d.epsilon_pos)).2
  simp

private theorem EberleinChoiceData.nextDual_oldPoint
    (d : EberleinChoiceData E) (st : EberleinHistory E) {x : E}
    (hx : x ∈ st.points) :
    |d.nextDual st x - d.limitDual x| < d.epsilon := by
  classical
  apply (Classical.choose_spec (exists_mem_of_mem_closure_weakStarImage_on_finset
    d.limit_mem_closure (insert (d.nextPoint st) st.points.toFinset) d.epsilon_pos)).2
  simp [hx]

private noncomputable def EberleinChoiceData.nextHistory
    (d : EberleinChoiceData E) (st : EberleinHistory E) : EberleinHistory E where
  duals := d.nextDual st :: st.duals
  points := d.nextPoint st :: st.points

private noncomputable def EberleinChoiceData.history
    (d : EberleinChoiceData E) : ℕ → EberleinHistory E
  | 0 => ⟨[], []⟩
  | n + 1 => d.nextHistory (d.history n)

private noncomputable def EberleinChoiceData.pointSequence
    (d : EberleinChoiceData E) (n : ℕ) : E := d.nextPoint (d.history n)

private noncomputable def EberleinChoiceData.dualSequence
    (d : EberleinChoiceData E) (n : ℕ) : StrongDual ℝ E := d.nextDual (d.history n)

private theorem EberleinChoiceData.history_succ_duals
    (d : EberleinChoiceData E) (n : ℕ) :
    (d.history (n + 1)).duals = d.dualSequence n :: (d.history n).duals := rfl

private theorem EberleinChoiceData.history_succ_points
    (d : EberleinChoiceData E) (n : ℕ) :
    (d.history (n + 1)).points = d.pointSequence n :: (d.history n).points := rfl

private theorem EberleinChoiceData.dual_mem_history
    (d : EberleinChoiceData E) {m n : ℕ} (hmn : m < n) :
    d.dualSequence m ∈ (d.history n).duals := by
  induction n with
  | zero => omega
  | succ n ih =>
      rw [d.history_succ_duals]
      by_cases hmn' : m = n
      · simp [hmn']
      · exact List.mem_cons_of_mem _ (ih (Nat.lt_of_le_of_ne (Nat.le_of_lt_succ hmn) hmn'))

private theorem EberleinChoiceData.point_mem_history
    (d : EberleinChoiceData E) {m n : ℕ} (hmn : m < n) :
    d.pointSequence m ∈ (d.history n).points := by
  induction n with
  | zero => omega
  | succ n ih =>
      rw [d.history_succ_points]
      by_cases hmn' : m = n
      · simp [hmn']
      · exact List.mem_cons_of_mem _ (ih (Nat.lt_of_le_of_ne (Nat.le_of_lt_succ hmn) hmn'))

private theorem EberleinChoiceData.pointSequence_mem_ball
    (d : EberleinChoiceData E) (n : ℕ) :
    d.pointSequence n ∈ Metric.closedBall (0 : E) 1 :=
  d.nextPoint_mem_ball (d.history n)

private theorem EberleinChoiceData.dualSequence_mem
    (d : EberleinChoiceData E) (n : ℕ) :
    d.dualSequence n ∈ d.dualSet := d.nextDual_mem (d.history n)

private theorem EberleinChoiceData.limitDual_pointSequence
    (d : EberleinChoiceData E) (n : ℕ) :
    d.limitDual (d.pointSequence n) = d.bidual d.limitDual :=
  d.nextPoint_limitDual (d.history n)

private theorem EberleinChoiceData.oldDual_pointSequence
    (d : EberleinChoiceData E) {m n : ℕ} (hmn : m < n) :
    d.dualSequence m (d.pointSequence n) = d.bidual (d.dualSequence m) :=
  d.nextPoint_oldDual (d.history n) (d.dual_mem_history hmn)

private theorem EberleinChoiceData.dualSequence_approximates_pointSequence
    (d : EberleinChoiceData E) {m n : ℕ} (hmn : m ≤ n) :
    |d.dualSequence n (d.pointSequence m) - d.limitDual (d.pointSequence m)| < d.epsilon := by
  by_cases h : m = n
  · subst m
    exact d.nextDual_newPoint (d.history n)
  · exact d.nextDual_oldPoint (d.history n)
      (d.point_mem_history (Nat.lt_of_le_of_ne hmn h))

/-- Step 2 of Bühler--Salamon Theorem 3.4.1: under bounded weak subsequence extraction, the
intersection of the kernel of a bidual unit functional with the dual unit ball is weak-star
closed. -/
theorem weakStarImage_dualUnitSlice_ker_isClosed_of_norm_le
    (hbounded : ∀ u : ℕ → E, Bornology.IsBounded (Set.range u) →
      ∃ x : E, ∃ φ : ℕ → ℕ, StrictMono φ ∧
        ∀ f : StrongDual ℝ E,
          Tendsto (fun n ↦ f (u (φ n))) atTop (nhds (f x)))
    (Φ : StrongDual ℝ (StrongDual ℝ E)) (hΦ : ‖Φ‖ ≤ 1) :
    IsClosed (weakStarImage (dualUnitSlice Φ.toLinearMap.ker)) := by
  apply isClosed_of_closure_subset
  intro f₀w hf₀closure
  · let f₀ : StrongDual ℝ E := WeakDual.toStrongDual f₀w
    have hf₀w_eq : StrongDual.toWeakDual f₀ = f₀w := WeakDual.toWeakDual_toStrongDual f₀w
    have hf₀closure' : StrongDual.toWeakDual f₀ ∈
        closure (weakStarImage (dualUnitSlice Φ.toLinearMap.ker)) := by
      simpa only [hf₀w_eq] using hf₀closure
    have hf₀ball : ‖f₀‖ ≤ 1 := by
      have hsub : closure (weakStarImage (dualUnitSlice Φ.toLinearMap.ker)) ⊆
          WeakDual.toStrongDual ⁻¹' Metric.closedBall (0 : StrongDual ℝ E) 1 :=
        closure_minimal (by
          rintro g ⟨f, hf, rfl⟩
          simpa using hf.2) weakStar_isCompact_unitBall.isClosed
      exact (mem_closedBall_zero_iff (E := StrongDual ℝ E)).mp (hsub hf₀closure')
    have hΦf₀ : Φ f₀ = 0 := by
      apply abs_eq_zero.mp
      apply le_antisymm
      · apply le_of_forall_pos_le_add
        intro δ hδ
        let ε := δ / 3
        have hε : 0 < ε := div_pos hδ (by norm_num)
        let d : EberleinChoiceData E :=
          { boundedSubsequence := hbounded
            bidual := Φ
            bidual_norm := hΦ
            dualSet := dualUnitSlice Φ.toLinearMap.ker
            limitDual := f₀
            limit_mem_closure := hf₀closure'
            epsilon := ε
            epsilon_pos := hε }
        have hpointsBounded : Bornology.IsBounded (Set.range d.pointSequence) :=
          Metric.isBounded_closedBall.subset fun x hx ↦ by
            obtain ⟨n, rfl⟩ := hx
            exact d.pointSequence_mem_ball n
        obtain ⟨x₀, φ, hφ, hconv⟩ := hbounded d.pointSequence hpointsBounded
        have hdual_zero (m : ℕ) : d.dualSequence m x₀ = 0 := by
          have heq : ∀ᶠ k in atTop, d.dualSequence m (d.pointSequence (φ k)) = 0 := by
            filter_upwards [eventually_gt_atTop m] with k hk
            have hmφ : m < φ k := hk.trans_le (hφ.id_le k)
            rw [d.oldDual_pointSequence hmφ]
            exact (d.dualSequence_mem m).1
          exact tendsto_nhds_unique (hconv (d.dualSequence m))
            (tendsto_const_nhds.congr' (Filter.EventuallyEq.symm heq))
        have hweak : Tendsto (fun k ↦ toWeakSpace ℝ E (d.pointSequence (φ k))) atTop
            (nhds (toWeakSpace ℝ E x₀)) :=
          (weak_tendsto_iff_forall_dual
            (u := d.pointSequence ∘ φ) (x := x₀)).mpr (by
              simpa only [Function.comp_apply] using hconv)
        obtain ⟨t, htRange, y, hyConv, hyNorm⟩ :=
          exists_finite_convex_approx_of_weak_tendsto
            (fun k ↦ d.pointSequence (φ k)) x₀ hweak hε
        classical
        choose idx hidx using fun z : {z // z ∈ t} ↦ htRange z.property
        let N : ℕ := t.attach.sup fun z ↦ φ (idx z)
        have hleN (z : {z // z ∈ t}) : φ (idx z) ≤ N := by
          exact Finset.le_sup (f := fun z : {z // z ∈ t} ↦ φ (idx z))
            (Finset.mem_attach t z)
        have happrox : ∀ z ∈ (t : Set E),
            |(d.dualSequence N - f₀) z| < ε := by
          intro z hz
          let zs : {z // z ∈ t} := ⟨z, hz⟩
          have hzseq : z = d.pointSequence (φ (idx zs)) := (hidx zs).symm
          rw [hzseq]
          simpa only [sub_apply] using
            d.dualSequence_approximates_pointSequence (hleN zs)
        have hdiffY : |(d.dualSequence N - f₀) y| < ε :=
          abs_apply_lt_of_mem_convexHull (d.dualSequence N - f₀) hyConv happrox
        have hf₀y : f₀ y = Φ f₀ := by
          apply apply_eq_of_mem_convexHull f₀ hyConv
          intro z hz
          obtain ⟨k, hk⟩ := htRange hz
          rw [← hk]
          exact d.limitDual_pointSequence (φ k)
        have hdualNorm : ‖d.dualSequence N‖ ≤ 1 :=
          (mem_closedBall_zero_iff (E := StrongDual ℝ E)).mp (d.dualSequence_mem N).2
        have hdualY : |d.dualSequence N y| < ε := by
          have hzero := hdual_zero N
          calc
            |d.dualSequence N y| = ‖d.dualSequence N (y - x₀)‖ := by
              rw [map_sub, hzero, sub_zero, Real.norm_eq_abs]
            _ ≤ ‖d.dualSequence N‖ * ‖y - x₀‖ :=
              (d.dualSequence N).le_opNorm (y - x₀)
            _ ≤ 1 * ‖y - x₀‖ :=
              mul_le_mul_of_nonneg_right hdualNorm (norm_nonneg _)
            _ < 1 * ε := mul_lt_mul_of_pos_left
              (by simpa only [norm_sub_rev] using hyNorm) zero_lt_one
            _ = ε := one_mul ε
        have htriangle : |Φ f₀| ≤ |(d.dualSequence N - f₀) y| +
            |d.dualSequence N y| := by
          rw [← hf₀y]
          have := abs_add_le (f₀ y - d.dualSequence N y) (d.dualSequence N y)
          rw [sub_add_cancel] at this
          simpa only [sub_apply, abs_sub_comm] using this
        have : |Φ f₀| < δ := by
          calc
            |Φ f₀| ≤ |(d.dualSequence N - f₀) y| + |d.dualSequence N y| := htriangle
            _ < ε + ε := add_lt_add hdiffY hdualY
            _ < δ := by dsimp [ε]; linarith
        simpa using this.le
      · exact abs_nonneg _
    exact ⟨f₀, ⟨hΦf₀, (mem_closedBall_zero_iff (E := StrongDual ℝ E)).mpr hf₀ball⟩,
      hf₀w_eq⟩

/-- The kernel unit slice of an arbitrary bidual functional is weak-star closed. The proof merely
normalizes the functional before applying the unit-norm Step 2 theorem. -/
theorem weakStarImage_dualUnitSlice_ker_isClosed
    (hbounded : ∀ u : ℕ → E, Bornology.IsBounded (Set.range u) →
      ∃ x : E, ∃ φ : ℕ → ℕ, StrictMono φ ∧
        ∀ f : StrongDual ℝ E,
          Tendsto (fun n ↦ f (u (φ n))) atTop (nhds (f x)))
    (Φ : StrongDual ℝ (StrongDual ℝ E)) :
    IsClosed (weakStarImage (dualUnitSlice Φ.toLinearMap.ker)) := by
  let c : ℝ := max ‖Φ‖ 1
  have hc : 0 < c := lt_of_lt_of_le zero_lt_one (le_max_right ‖Φ‖ 1)
  let Ψ : StrongDual ℝ (StrongDual ℝ E) := c⁻¹ • Φ
  have hΨnorm : ‖Ψ‖ ≤ 1 := by
    calc
      ‖Ψ‖ ≤ ‖c⁻¹‖ * ‖Φ‖ := by
        exact ContinuousLinearMap.opNorm_smul_le c⁻¹ Φ
      _ = c⁻¹ * ‖Φ‖ := by rw [Real.norm_eq_abs, abs_of_pos (inv_pos.mpr hc)]
      _ ≤ 1 := by
        rw [inv_mul_le_one₀ hc]
        exact le_max_left ‖Φ‖ 1
  have hker : Ψ.toLinearMap.ker = Φ.toLinearMap.ker := by
    ext f
    simp only [LinearMap.mem_ker]
    change c⁻¹ * Φ f = 0 ↔ Φ f = 0
    constructor
    · intro h
      exact (mul_eq_zero.mp h).resolve_left (inv_ne_zero hc.ne')
    · intro h
      simp [h]
  rw [← hker]
  exact weakStarImage_dualUnitSlice_ker_isClosed_of_norm_le hbounded Ψ hΨnorm

/-- The difficult implication in Bühler--Salamon Theorem 3.4.1: if every bounded sequence has a
weakly convergent subsequence, then the canonical map into the bidual is surjective. -/
theorem reflexive_of_bounded_sequence_has_weakly_convergent_subsequence [CompleteSpace E]
    (hbounded : ∀ u : ℕ → E, Bornology.IsBounded (Set.range u) →
      ∃ x : E, ∃ φ : ℕ → ℕ, StrictMono φ ∧
        ∀ f : StrongDual ℝ E,
          Tendsto (fun n ↦ f (u (φ n))) atTop (nhds (f x))) :
    Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E) := by
  intro Φ
  by_cases hΦzero : Φ = 0
  · refine ⟨0, ?_⟩
    simp [hΦzero]
  · have hexists : ∃ f₁ : StrongDual ℝ E, Φ f₁ ≠ 0 := by
      by_contra h
      push Not at h
      apply hΦzero
      ext f
      exact h f
    obtain ⟨f₁, hf₁⟩ := hexists
    let M : Submodule ℝ (StrongDual ℝ E) := Φ.toLinearMap.ker
    have hunit : IsClosed (weakStarImage (dualUnitSlice M)) :=
      weakStarImage_dualUnitSlice_ker_isClosed hbounded Φ
    obtain ⟨x, hf₁x, hMx⟩ :=
      exists_weakStar_separator_of_dualUnitSlice_closed M hunit
        (show f₁ ∉ M by simpa [M, LinearMap.mem_ker] using hf₁)
    let x₀ : E := (Φ f₁) • x
    refine ⟨x₀, ?_⟩
    apply ContinuousLinearMap.ext
    intro f
    let g : StrongDual ℝ E := f - (Φ f / Φ f₁) • f₁
    have hgM : g ∈ M := by
      change Φ g = 0
      simp [g, hf₁]
    have hgx : g x = 0 := hMx g hgM
    rw [bidual_evaluation]
    dsimp [x₀]
    rw [map_smul, smul_eq_mul]
    have hfx : f x = Φ f / Φ f₁ := by
      change f x - (Φ f / Φ f₁) * f₁ x = 0 at hgx
      rw [hf₁x, mul_one] at hgx
      linarith
    rw [hfx]
    field_simp

private theorem weakClosedUnitBall_isBounded_preimage :
    Bornology.IsBounded ((toWeakSpace ℝ E) ⁻¹' weakClosedUnitBall (E := E)) := by
  rw [show (toWeakSpace ℝ E) ⁻¹' weakClosedUnitBall (E := E) =
      Metric.closedBall (0 : E) 1 by
    ext x
    constructor
    · rintro ⟨y, hy, hxy⟩
      exact (toWeakSpace ℝ E).injective hxy ▸ hy
    · intro hx
      exact ⟨x, hx, rfl⟩]
  exact Metric.isBounded_closedBall

/-- 自反空间的闭单位球在弱拓扑中紧致。这里自反性按本库已经冻结的教材承载，
写成典范双对偶嵌入满射。 -/
theorem weakClosedUnitBall_isCompact_of_reflexive
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)) :
    IsCompact (weakClosedUnitBall (E := E)) := by
  have hrange : closure
      (NormedSpace.inclusionInDoubleDualWeak ℝ E '' weakClosedUnitBall (E := E)) ⊆
      Set.range (NormedSpace.inclusionInDoubleDualWeak ℝ E) := by
    intro Φ _
    obtain ⟨x, hx⟩ := hE (WeakDual.toStrongDual Φ)
    refine ⟨toWeakSpace ℝ E x, ?_⟩
    apply WeakDual.toStrongDual.injective
    simpa only [toStrongDual_inclusionInDoubleDualWeak] using hx
  have hcompact := NormedSpace.isCompact_closure_of_isBounded ℝ E
    (weakClosedUnitBall (E := E)) weakClosedUnitBall_isBounded_preimage hrange
  simpa only [weakClosedUnitBall_isClosed.closure_eq] using hcompact

/-- Weak compactness of the closed unit ball forces reflexivity. Goldstine density and compact
closedness show that the canonical image fills the bidual unit ball; scaling gives surjectivity. -/
theorem reflexive_of_weakClosedUnitBall_isCompact
    (hcompact : IsCompact (weakClosedUnitBall (E := E))) :
    Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E) := by
  let J := NormedSpace.inclusionInDoubleDualWeak ℝ E
  have hAcompact : IsCompact (J '' weakClosedUnitBall (E := E)) :=
    hcompact.image J.continuous
  have hAclosed : IsClosed (J '' weakClosedUnitBall (E := E)) := hAcompact.isClosed
  have hclosure : J '' weakClosedUnitBall (E := E) =
      WeakDual.toStrongDual ⁻¹'
        Metric.closedBall (0 : StrongDual ℝ (StrongDual ℝ E)) 1 := by
    rw [← closure_inclusionInDoubleDualWeak_unitBall]
    exact hAclosed.closure_eq.symm
  intro Φ
  let c : ℝ := max ‖Φ‖ 1
  have hc : 0 < c := lt_of_lt_of_le zero_lt_one (le_max_right ‖Φ‖ 1)
  let Ψ : StrongDual ℝ (StrongDual ℝ E) := c⁻¹ • Φ
  have hΨnorm : ‖Ψ‖ ≤ 1 := by
    calc
      ‖Ψ‖ ≤ ‖c⁻¹‖ * ‖Φ‖ := ContinuousLinearMap.opNorm_smul_le c⁻¹ Φ
      _ = c⁻¹ * ‖Φ‖ := by rw [Real.norm_eq_abs, abs_of_pos (inv_pos.mpr hc)]
      _ ≤ 1 := by
        rw [inv_mul_le_one₀ hc]
        exact le_max_left ‖Φ‖ 1
  have hΨw : StrongDual.toWeakDual Ψ ∈ J '' weakClosedUnitBall (E := E) := by
    rw [hclosure]
    change Ψ ∈ Metric.closedBall (0 : StrongDual ℝ (StrongDual ℝ E)) 1
    exact (mem_closedBall_zero_iff (E := StrongDual ℝ (StrongDual ℝ E))).mpr hΨnorm
  obtain ⟨xw, ⟨x, hx, rfl⟩, hJ⟩ := hΨw
  refine ⟨c • x, ?_⟩
  apply ContinuousLinearMap.ext
  intro f
  have hΨeval : f x = Ψ f := by
    have := congrArg (fun g : WeakDual ℝ (StrongDual ℝ E) ↦ g f) hJ
    change f x = Ψ f at this
    exact this
  rw [bidual_evaluation, map_smul, smul_eq_mul, hΨeval]
  dsimp [Ψ]
  simp [hc.ne']

/-- In the separable case, reflexivity turns sequential Banach--Alaoglu on the bidual ball into
weak sequential compactness of the original unit ball. -/
theorem weakClosedUnitBall_isSeqCompact_of_reflexive_of_separable
    [TopologicalSpace.SeparableSpace E]
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)) :
    IsSeqCompact (weakClosedUnitBall (E := E)) := by
  let _ : TopologicalSpace.SeparableSpace (StrongDual ℝ E) :=
    separable_dual_of_reflexive hE
  intro w hw
  choose u hu using hw
  have hJu : ∀ n, ‖NormedSpace.inclusionInDoubleDual ℝ E (u n)‖ ≤ 1 := by
    intro n
    rw [norm_bidual_evaluation]
    simpa [Metric.mem_closedBall, dist_zero_right] using (hu n).1
  obtain ⟨Φ, hΦ, φ, hφ, hlim⟩ :=
    exists_weakStar_convergent_subsequence_of_norm_le_one
      (E := StrongDual ℝ E) (fun n ↦ NormedSpace.inclusionInDoubleDual ℝ E (u n)) hJu
  obtain ⟨x, hx⟩ := hE Φ
  have hpointwise : ∀ f : StrongDual ℝ E,
      Tendsto (fun n ↦ f (u (φ n))) atTop (nhds (f x)) := by
    have h := (weakStar_tendsto_iff_forall.mp hlim)
    intro f
    have hf := h f
    have hval : Φ f = f x := by
      rw [← hx, bidual_evaluation]
    simpa only [bidual_evaluation, hval] using hf
  have hweak : Tendsto (fun n ↦ toWeakSpace ℝ E (u (φ n))) atTop
      (nhds (toWeakSpace ℝ E x)) :=
    (weak_tendsto_iff_forall_dual (u := u ∘ φ) (x := x)).mpr (by
      simpa only [Function.comp_apply] using hpointwise)
  have hxballw : toWeakSpace ℝ E x ∈ weakClosedUnitBall (E := E) :=
    weakClosedUnitBall_isClosed.mem_of_tendsto hweak
      (Filter.Eventually.of_forall fun n ↦ ⟨u (φ n), (hu (φ n)).1, rfl⟩)
  refine ⟨toWeakSpace ℝ E x, hxballw, φ, hφ, ?_⟩
  have hw_eq : w = fun n ↦ toWeakSpace ℝ E (u n) :=
    funext fun n ↦ (hu n).2.symm
  rw [hw_eq]
  exact hweak

/-- Reflexivity implies weak sequential compactness of the unit ball without a global
separability assumption: a given sequence is moved to the separable closed subspace it spans. -/
theorem weakClosedUnitBall_isSeqCompact_of_reflexive [CompleteSpace E]
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)) :
    IsSeqCompact (weakClosedUnitBall (E := E)) := by
  intro w hw
  choose u hu using hw
  let S : Submodule ℝ E := (Submodule.span ℝ (Set.range u)).topologicalClosure
  have huS (n : ℕ) : u n ∈ S :=
    (Submodule.span ℝ (Set.range u)).le_topologicalClosure
      (Submodule.subset_span (Set.mem_range_self n))
  have hSsep : TopologicalSpace.IsSeparable (S : Set E) := by
    change TopologicalSpace.IsSeparable
      (closure (Submodule.span ℝ (Set.range u) : Set E))
    exact (Set.countable_range u).isSeparable.span.closure
  let _ : TopologicalSpace.SeparableSpace S := hSsep.separableSpace
  have hSclosed : IsClosed (S : Set E) :=
    Submodule.isClosed_topologicalClosure (Submodule.span ℝ (Set.range u))
  have hSrefl : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ S) :=
    reflexive_closedSubspace S hSclosed hE
  have hSseq := weakClosedUnitBall_isSeqCompact_of_reflexive_of_separable hSrefl
  let us : ℕ → S := fun n ↦ ⟨u n, huS n⟩
  have hus : ∀ n, toWeakSpace ℝ S (us n) ∈ weakClosedUnitBall (E := S) := by
    intro n
    refine ⟨us n, ?_, rfl⟩
    simpa [Metric.mem_closedBall, dist_zero_right, us] using (hu n).1
  obtain ⟨ys, hysball, φ, hφ, hconvS⟩ := hSseq hus
  let y : S := (toWeakSpace ℝ S).symm ys
  have hpointwiseS : ∀ g : StrongDual ℝ S,
      Tendsto (fun n ↦ g (us (φ n))) atTop (nhds (g y)) :=
    (weak_tendsto_iff_forall_dual (u := us ∘ φ) (x := y)).mp (by
      simpa only [Function.comp_def, y, LinearEquiv.apply_symm_apply] using hconvS)
  have hconvE : Tendsto (fun n ↦ toWeakSpace ℝ E (u (φ n))) atTop
      (nhds (toWeakSpace ℝ E (y : E))) :=
    (weak_tendsto_iff_forall_dual (u := u ∘ φ) (x := (y : E))).mpr (by
      intro f
      simpa only [Function.comp_apply, us, dualRestriction_apply] using
        hpointwiseS (dualRestriction S f))
  have hyball : (y : E) ∈ Metric.closedBall (0 : E) 1 := by
    obtain ⟨z, hz, hzy⟩ := hysball
    have hz_eq : z = y := (toWeakSpace ℝ S).injective hzy
    have hznorm : ‖z‖ ≤ 1 := (mem_closedBall_zero_iff (E := S)).mp hz
    simpa [Metric.mem_closedBall, dist_zero_right] using hz_eq ▸ hznorm
  refine ⟨toWeakSpace ℝ E (y : E), ⟨(y : E), hyball, rfl⟩, φ, hφ, ?_⟩
  have hw_eq : w = fun n ↦ toWeakSpace ℝ E (u n) :=
    funext fun n ↦ (hu n).2.symm
  rw [hw_eq]
  exact hconvE

/-- 弱序列紧致的教材展开：每个取值于闭单位球的原空间序列，都有一个严格递增子列，
并在每个连续线性泛函下逐点收敛到球内一点。 -/
theorem weakClosedUnitBall_isSeqCompact_iff :
    IsSeqCompact (weakClosedUnitBall (E := E)) ↔
      ∀ u : ℕ → E, (∀ n, u n ∈ Metric.closedBall (0 : E) 1) →
        ∃ x ∈ Metric.closedBall (0 : E) 1, ∃ φ : ℕ → ℕ, StrictMono φ ∧
          ∀ f : StrongDual ℝ E,
            Tendsto (fun n ↦ f (u (φ n))) atTop (nhds (f x)) := by
  constructor
  · intro hB u hu
    obtain ⟨xw, ⟨x, hxB, rfl⟩, φ, hφ, hconv⟩ :=
      hB (fun n ↦ ⟨u n, hu n, rfl⟩)
    refine ⟨x, hxB, φ, hφ, ?_⟩
    change Tendsto (fun i ↦ toWeakSpace ℝ E (u (φ i))) atTop
      (nhds (toWeakSpace ℝ E x)) at hconv
    exact (weak_tendsto_iff_forall_dual (u := u ∘ φ) (x := x)).mp hconv
  · intro hB w hw
    choose u hu using hw
    obtain ⟨x, hxB, φ, hφ, hconv⟩ := hB u (fun n ↦ (hu n).1)
    refine ⟨toWeakSpace ℝ E x, ⟨x, hxB, rfl⟩, φ, hφ, ?_⟩
    have hw_eq : w = fun n ↦ toWeakSpace ℝ E (u n) :=
      funext fun n ↦ (hu n).2.symm
    rw [hw_eq]
    exact (weak_tendsto_iff_forall_dual (u := u ∘ φ) (x := x)).mpr (by
      simpa only [Function.comp_apply] using hconv)

/-- 闭单位球弱序列紧，当且仅当每个范数有界序列都有弱收敛子列。
右侧直接用范数有界的值域与逐对偶泛函收敛表述教材条件 (iv)。 -/
theorem weakClosedUnitBall_isSeqCompact_iff_bounded_sequence :
    IsSeqCompact (weakClosedUnitBall (E := E)) ↔
      ∀ u : ℕ → E, Bornology.IsBounded (Set.range u) →
        ∃ x : E, ∃ φ : ℕ → ℕ, StrictMono φ ∧
          ∀ f : StrongDual ℝ E,
            Tendsto (fun n ↦ f (u (φ n))) atTop (nhds (f x)) := by
  constructor
  · intro hB u hu
    obtain ⟨c, hcpos, hc⟩ := hu.exists_pos_norm_le
    have hvball : ∀ n, c⁻¹ • u n ∈ Metric.closedBall (0 : E) 1 := by
      intro n
      rw [Metric.mem_closedBall, dist_zero_right, norm_smul, norm_inv,
        Real.norm_eq_abs, abs_of_pos hcpos]
      calc
        c⁻¹ * ‖u n‖ ≤ c⁻¹ * c :=
          mul_le_mul_of_nonneg_left (hc (u n) ⟨n, rfl⟩) (inv_nonneg.mpr hcpos.le)
        _ = 1 := inv_mul_cancel₀ hcpos.ne'
    obtain ⟨x, _hxB, φ, hφ, hconv⟩ :=
      (weakClosedUnitBall_isSeqCompact_iff (E := E)).mp hB
        (fun n ↦ c⁻¹ • u n) hvball
    refine ⟨c • x, φ, hφ, ?_⟩
    intro f
    have hscaled : Tendsto (fun n ↦ c * f (c⁻¹ • u (φ n))) atTop
        (nhds (c * f x)) := tendsto_const_nhds.mul (hconv f)
    simpa only [map_smul, smul_eq_mul, Function.comp_apply, ← mul_assoc,
      mul_inv_cancel₀ hcpos.ne', one_mul] using hscaled
  · intro hbounded
    apply (weakClosedUnitBall_isSeqCompact_iff (E := E)).mpr
    intro u hu
    have hrange : Bornology.IsBounded (Set.range u) :=
      Metric.isBounded_closedBall.subset fun x hx ↦ by
        obtain ⟨n, rfl⟩ := hx
        exact hu n
    obtain ⟨x, φ, hφ, hconv⟩ := hbounded u hrange
    have hweak : Tendsto (fun n ↦ toWeakSpace ℝ E (u (φ n))) atTop
        (nhds (toWeakSpace ℝ E x)) :=
      (weak_tendsto_iff_forall_dual (u := u ∘ φ) (x := x)).mpr (by
        simpa only [Function.comp_apply] using hconv)
    have hxweak : toWeakSpace ℝ E x ∈ weakClosedUnitBall (E := E) :=
      weakClosedUnitBall_isClosed.mem_of_tendsto hweak
        (Filter.Eventually.of_forall fun n ↦ ⟨u (φ n), hu (φ n), rfl⟩)
    obtain ⟨y, hyB, hyx⟩ := hxweak
    have : y = x := (toWeakSpace ℝ E).injective hyx
    exact ⟨x, this ▸ hyB, φ, hφ, hconv⟩

/-- **Eberlein--Šmulian theorem**, in the four equivalent forms of Bühler--Salamon
Theorem 3.4.1: reflexivity, weak compactness of the closed unit ball, weak sequential compactness
of that ball, and weakly convergent subsequence extraction for every bounded sequence. -/
theorem eberlein_smulian_four_way [CompleteSpace E] :
    List.TFAE
      [ (Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)),
        (IsCompact (weakClosedUnitBall (E := E))),
        (IsSeqCompact (weakClosedUnitBall (E := E))),
        (∀ u : ℕ → E, Bornology.IsBounded (Set.range u) →
          ∃ x : E, ∃ φ : ℕ → ℕ, StrictMono φ ∧
            ∀ f : StrongDual ℝ E,
              Tendsto (fun n ↦ f (u (φ n))) atTop (nhds (f x))) ] := by
  tfae_have 1 → 2 := weakClosedUnitBall_isCompact_of_reflexive
  tfae_have 2 → 1 := reflexive_of_weakClosedUnitBall_isCompact
  tfae_have 1 → 3 := weakClosedUnitBall_isSeqCompact_of_reflexive
  tfae_have 3 ↔ 4 := weakClosedUnitBall_isSeqCompact_iff_bounded_sequence
  tfae_have 4 → 1 := reflexive_of_bounded_sequence_has_weakly_convergent_subsequence
  tfae_finish

end SandronesLibrary.FunctionalAnalysis
