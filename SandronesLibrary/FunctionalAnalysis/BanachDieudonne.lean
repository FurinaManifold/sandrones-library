/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.FunctionalAnalysis.WeakStarMetrizable
import Mathlib.Topology.ContinuousMap.ZeroAtInfty
import Mathlib.Analysis.Normed.Module.HahnBanach
import Mathlib.Analysis.Normed.Group.Quotient
import Mathlib.Topology.Algebra.Module.ContinuousLinearMap.Quotient

/-!
# Banach–Dieudonné 定理

本文件构造 Banach–Dieudonné 弱星闭性判据。子空间保留在范数连续对偶
`StrongDual ℝ X` 中；需要讨论弱星拓扑时，才通过 `StrongDual.toWeakDual` 送入
`WeakDual ℝ X`。
-/

namespace SandronesLibrary.FunctionalAnalysis

open Filter Metric ZeroAtInfty

variable {X : Type*} [NormedAddCommGroup X] [NormedSpace ℝ X]

private def c0OfTendsto (u : ℕ → ℝ) (hu : Tendsto u atTop (nhds 0)) : C₀(ℕ, ℝ) where
  toFun := u
  continuous_toFun := continuous_of_discreteTopology
  zero_at_infty' := by
    simpa only [Filter.cocompact_eq_cofinite, Nat.cofinite_eq_atTop] using hu

@[simp] private theorem c0OfTendsto_apply (u : ℕ → ℝ) (hu) (n : ℕ) :
    c0OfTendsto u hu n = u n := rfl

private def c0Truncation (u : C₀(ℕ, ℝ)) (N : ℕ) : C₀(ℕ, ℝ) where
  toFun n := if n < N then u n else 0
  continuous_toFun := continuous_of_discreteTopology
  zero_at_infty' := by
    rw [Filter.cocompact_eq_cofinite, Nat.cofinite_eq_atTop]
    apply tendsto_const_nhds.congr'
    filter_upwards [eventually_ge_atTop N] with n hn
    simp [not_lt.mpr hn]

@[simp] private theorem c0Truncation_apply (u : C₀(ℕ, ℝ)) (N n : ℕ) :
    c0Truncation u N n = if n < N then u n else 0 := rfl

private theorem c0Truncation_tendsto (u : C₀(ℕ, ℝ)) :
    Tendsto (c0Truncation u) atTop (nhds u) := by
  rw [ZeroAtInftyContinuousMap.tendsto_iff_tendstoUniformly,
    Metric.tendstoUniformly_iff]
  intro ε hε
  have hu := Metric.tendsto_nhds.mp (zero_at_infty u) ε hε
  rw [Filter.cocompact_eq_cofinite, Nat.cofinite_eq_atTop] at hu
  obtain ⟨N, hN⟩ := eventually_atTop.1 hu
  filter_upwards [eventually_ge_atTop N] with M hM
  intro n
  by_cases hn : n < M
  · simpa [c0Truncation, hn] using hε
  · simpa [c0Truncation, hn, Real.dist_eq, abs_sub_comm] using
      hN n (hM.trans (not_lt.mp hn))

private def c0Single (i : ℕ) : C₀(ℕ, ℝ) :=
  c0OfTendsto (Pi.single i 1) <| by
    apply tendsto_const_nhds.congr'
    filter_upwards [eventually_ne_atTop i] with n hn
    simp [Pi.single_eq_of_ne hn]

@[simp] private theorem c0Single_apply (i n : ℕ) :
    c0Single i n = if i = n then 1 else 0 := by
  classical
  by_cases h : i = n
  · subst n
    simp [c0Single]
  · simp [c0Single, h]

private theorem c0_finset_sum_apply (s : Finset ℕ) (a : ℕ → ℝ) (n : ℕ) :
    (∑ i ∈ s, a i • c0Single i) n = ∑ i ∈ s, a i * c0Single i n := by
  induction s using Finset.induction_on with
  | empty => simp
  | @insert i s hi ih =>
      simp only [Finset.sum_insert, hi, not_false_eq_true,
        ZeroAtInftyContinuousMap.add_apply, ZeroAtInftyContinuousMap.smul_apply, ih,
        smul_eq_mul]

private theorem c0_dual_coordinates_sum_le (Λ : C₀(ℕ, ℝ) →L[ℝ] ℝ) (s : Finset ℕ) :
    ∑ i ∈ s, |Λ (c0Single i)| ≤ ‖Λ‖ := by
  classical
  let v : C₀(ℕ, ℝ) :=
    ∑ i ∈ s, (if 0 ≤ Λ (c0Single i) then (1 : ℝ) else -1) • c0Single i
  have hv : ‖v‖ ≤ 1 := by
    change ‖v.toBCF‖ ≤ 1
    rw [BoundedContinuousFunction.norm_le zero_le_one]
    intro n
    have hvn : v n =
        ∑ i ∈ s, (if 0 ≤ Λ (c0Single i) then 1 else -1) * c0Single i n := by
      change (∑ i ∈ s, (if 0 ≤ Λ (c0Single i) then 1 else -1) • c0Single i) n = _
      exact c0_finset_sum_apply s
        (fun i ↦ if 0 ≤ Λ (c0Single i) then (1 : ℝ) else -1) n
    rw [show v.toBCF n = v n from rfl, hvn, Real.norm_eq_abs]
    by_cases hn : n ∈ s
    · simp only [c0Single_apply]
      by_cases h : 0 ≤ Λ (c0Single n) <;> simp [h, hn]
    · simp [c0Single_apply, hn]
  calc
    ∑ i ∈ s, |Λ (c0Single i)| = Λ v := by
      simp only [v, map_sum, map_smul, smul_eq_mul]
      apply Finset.sum_congr rfl
      intro i hi
      by_cases h : 0 ≤ Λ (c0Single i)
      · simp [h, abs_of_nonneg h]
      · simp [h, abs_of_neg (lt_of_not_ge h)]
    _ ≤ |Λ v| := le_abs_self _
    _ ≤ ‖Λ‖ * ‖v‖ := Λ.le_opNorm v
    _ ≤ ‖Λ‖ * 1 := mul_le_mul_of_nonneg_left hv (norm_nonneg Λ)
    _ = ‖Λ‖ := mul_one _

private theorem c0_dual_coordinates_summable (Λ : C₀(ℕ, ℝ) →L[ℝ] ℝ) :
    Summable fun i ↦ |Λ (c0Single i)| := by
  apply summable_of_sum_le (fun i ↦ abs_nonneg (Λ (c0Single i)))
  exact c0_dual_coordinates_sum_le Λ

private theorem c0_dual_coordinates_tsum_le (Λ : C₀(ℕ, ℝ) →L[ℝ] ℝ) :
    ∑' i, |Λ (c0Single i)| ≤ ‖Λ‖ :=
  (c0_dual_coordinates_summable Λ).tsum_le_of_sum_le (c0_dual_coordinates_sum_le Λ)

private theorem c0Truncation_eq_sum (u : C₀(ℕ, ℝ)) (N : ℕ) :
    c0Truncation u N = ∑ i ∈ Finset.range N, u i • c0Single i := by
  ext n
  rw [c0_finset_sum_apply]
  simp [c0Truncation, c0Single_apply]

private theorem c0_dual_hasSum_coordinates (Λ : C₀(ℕ, ℝ) →L[ℝ] ℝ) (u : C₀(ℕ, ℝ)) :
    HasSum (fun i ↦ Λ (c0Single i) * u i) (Λ u) := by
  have hΛ := c0_dual_coordinates_summable Λ
  have hnorm : Summable fun i ↦ ‖Λ (c0Single i) * u i‖ :=
    (hΛ.mul_left ‖u‖).of_nonneg_of_le (fun i ↦ norm_nonneg _) fun i ↦ by
      calc
        ‖Λ (c0Single i) * u i‖ = |Λ (c0Single i)| * |u i| := by
          rw [norm_mul, Real.norm_eq_abs, Real.norm_eq_abs]
        _ ≤ |Λ (c0Single i)| * ‖u‖ :=
          mul_le_mul_of_nonneg_left
            (BoundedContinuousFunction.norm_coe_le_norm u.toBCF i) (abs_nonneg _)
        _ = ‖u‖ * |Λ (c0Single i)| := mul_comm _ _
  rw [hasSum_iff_tendsto_nat_of_summable_norm hnorm]
  have hlim : Tendsto (fun N ↦ Λ (c0Truncation u N)) atTop (nhds (Λ u)) :=
    (Λ.continuous.tendsto u).comp (c0Truncation_tendsto u)
  apply hlim.congr'
  filter_upwards [] with N
  rw [c0Truncation_eq_sum, map_sum]
  simp only [map_smul, smul_eq_mul, mul_comm]

private theorem dual_eval_tendsto_zero (x : ℕ → X) (hx₀ : Tendsto x atTop (nhds 0))
    (f : StrongDual ℝ X) : Tendsto (fun i ↦ f (x i)) atTop (nhds 0) := by
  simpa only [Function.comp_def, map_zero] using (f.continuous.tendsto 0).comp hx₀

private noncomputable def dualEvaluationToC0Linear (x : ℕ → X)
    (hx₀ : Tendsto x atTop (nhds 0)) : StrongDual ℝ X →ₗ[ℝ] C₀(ℕ, ℝ) where
    toFun f := c0OfTendsto (fun i ↦ f (x i)) (dual_eval_tendsto_zero x hx₀ f)
    map_add' := by
      intro f g
      ext i
      simp
    map_smul' := by
      intro c f
      ext i
      simp

private theorem dualEvaluationToC0Linear_norm_le (x : ℕ → X)
    (hx₀ : Tendsto x atTop (nhds 0)) (hx : ∀ i, ‖x i‖ ≤ 1) (f : StrongDual ℝ X) :
    ‖dualEvaluationToC0Linear x hx₀ f‖ ≤ 1 * ‖f‖ := by
  change ‖(c0OfTendsto (fun i ↦ f (x i)) (dual_eval_tendsto_zero x hx₀ f)).toBCF‖ ≤
    1 * ‖f‖
  rw [BoundedContinuousFunction.norm_le (mul_nonneg zero_le_one (norm_nonneg f))]
  intro i
  exact (f.le_opNorm (x i)).trans <| by
    simpa only [one_mul, mul_one] using mul_le_mul_of_nonneg_left (hx i) (norm_nonneg f)

private noncomputable def dualEvaluationToC0 (x : ℕ → X)
    (hx₀ : Tendsto x atTop (nhds 0)) (hx : ∀ i, ‖x i‖ ≤ 1) :
    StrongDual ℝ X →L[ℝ] C₀(ℕ, ℝ) :=
  (dualEvaluationToC0Linear x hx₀).mkContinuous 1
    (dualEvaluationToC0Linear_norm_le x hx₀ hx)

@[simp] private theorem dualEvaluationToC0_apply (x : ℕ → X)
    (hx₀ : Tendsto x atTop (nhds 0)) (hx : ∀ i, ‖x i‖ ≤ 1)
    (f : StrongDual ℝ X) (i : ℕ) : dualEvaluationToC0 x hx₀ hx f i = f (x i) := rfl

private theorem exists_dual_annihilating_submodule_of_quotient_norm_pos
    {E : Type*} [SeminormedAddCommGroup E] [NormedSpace ℝ E]
    (Y : Submodule ℝ E) (z : E) (hz : 0 < ‖Y.mkQ z‖) :
    ∃ Λ : StrongDual ℝ E, ‖Λ‖ ≤ 1 ∧ Λ z = ‖Y.mkQ z‖ ∧ ∀ y ∈ Y, Λ y = 0 := by
  obtain ⟨g, hg, hgz⟩ := exists_dual_vector ℝ (Y.mkQ z) (ne_of_gt hz)
  let Λ : StrongDual ℝ E := g.comp Y.mkQL
  have hmk : ‖Y.mkQL‖ ≤ 1 := by
    apply ContinuousLinearMap.opNorm_le_bound _ zero_le_one
    intro x
    rw [one_mul, Submodule.mkQL_apply, Submodule.mkQ_apply]
    exact Submodule.Quotient.norm_mk_le (S := Y) x
  refine ⟨Λ, (g.opNorm_comp_le Y.mkQL).trans ?_, ?_, ?_⟩
  · simpa [hg] using mul_le_mul_of_nonneg_left hmk (norm_nonneg g)
  · simpa [Λ, Submodule.mkQL_apply] using hgz
  · intro y hy
    have hy₀ : Y.mkQL y = 0 := by
      rw [Submodule.mkQL_apply, Submodule.mkQ_apply]
      exact (Submodule.Quotient.mk_eq_zero Y).2 hy
    simp [Λ, hy₀]

private theorem quotient_norm_ge_of_separated_image
    {A B : Type*} [SeminormedAddCommGroup A] [NormedSpace ℝ A]
    [SeminormedAddCommGroup B] [NormedSpace ℝ B]
    (T : A →L[ℝ] B) (M : Submodule ℝ A) (f₀ : A) {δ : ℝ}
    (hsep : ∀ f ∈ M, δ < ‖T f - T f₀‖) :
    δ ≤ ‖(Submodule.map T.toLinearMap M).mkQ (T f₀)‖ := by
  let Y := Submodule.map T.toLinearMap M
  change δ ≤ ‖QuotientAddGroup.mk' Y.toAddSubgroup (T f₀)‖
  rw [quotient_norm_mk_eq]
  apply le_csInf
  · exact ⟨‖T f₀ + 0‖, ⟨0, Y.zero_mem, rfl⟩⟩
  · intro r hr
    obtain ⟨y, hy, rfl⟩ := hr
    obtain ⟨f, hf, rfl⟩ := hy
    have h := (hsep (-f) (M.neg_mem hf)).le
    have heq : T (-f) - T f₀ = -(T f₀ + T f) := by
      rw [map_neg]
      module
    rw [heq, norm_neg] at h
    exact h

private theorem exists_summable_dual_separator
    (M : Submodule ℝ (StrongDual ℝ X)) (f₀ : StrongDual ℝ X)
    (x : ℕ → X) (hx₀ : Tendsto x atTop (nhds 0)) (hx : ∀ i, ‖x i‖ ≤ 1)
    {δ : ℝ} (hδ : 0 < δ)
    (hsep : ∀ f ∈ M, δ < ‖dualEvaluationToC0 x hx₀ hx f - dualEvaluationToC0 x hx₀ hx f₀‖) :
    ∃ a : ℕ → ℝ, Summable (fun i ↦ |a i|) ∧ (∑' i, |a i|) ≤ δ⁻¹ ∧
      HasSum (fun i ↦ a i * f₀ (x i)) 1 ∧
      ∀ f ∈ M, HasSum (fun i ↦ a i * f (x i)) 0 := by
  let T := dualEvaluationToC0 x hx₀ hx
  let Y := Submodule.map T.toLinearMap M
  have hq : δ ≤ ‖Y.mkQ (T f₀)‖ := quotient_norm_ge_of_separated_image T M f₀ hsep
  have hqpos : 0 < ‖Y.mkQ (T f₀)‖ := hδ.trans_le hq
  obtain ⟨Λ, hΛnorm, hΛf₀, hΛM⟩ :=
    exists_dual_annihilating_submodule_of_quotient_norm_pos Y (T f₀) hqpos
  let c : ℝ := Λ (T f₀)
  have hc : δ ≤ c := by simpa [c, hΛf₀] using hq
  have hcpos : 0 < c := hδ.trans_le hc
  let b : ℕ → ℝ := fun i ↦ Λ (c0Single i)
  let a : ℕ → ℝ := fun i ↦ c⁻¹ * b i
  have hb : Summable fun i ↦ |b i| := c0_dual_coordinates_summable Λ
  have ha : Summable fun i ↦ |a i| := by
    simpa [a, abs_mul, abs_of_pos (inv_pos.mpr hcpos)] using hb.mul_left c⁻¹
  refine ⟨a, ha, ?_, ?_, ?_⟩
  · calc
      ∑' i, |a i| = c⁻¹ * ∑' i, |b i| := by
        simp_rw [a, abs_mul, abs_of_pos (inv_pos.mpr hcpos)]
        exact tsum_mul_left
      _ ≤ c⁻¹ * ‖Λ‖ :=
        mul_le_mul_of_nonneg_left (c0_dual_coordinates_tsum_le Λ) (inv_nonneg.mpr hcpos.le)
      _ ≤ c⁻¹ * 1 := mul_le_mul_of_nonneg_left hΛnorm (inv_nonneg.mpr hcpos.le)
      _ = c⁻¹ := mul_one _
      _ ≤ δ⁻¹ := (inv_le_inv₀ hcpos hδ).2 hc
  · have hsum := (c0_dual_hasSum_coordinates Λ (T f₀)).const_smul c⁻¹
    simpa only [a, b, T, dualEvaluationToC0_apply, smul_eq_mul, mul_assoc, c,
      inv_mul_cancel₀ hcpos.ne'] using hsum
  · intro f hf
    have hTf : T f ∈ Y := ⟨f, hf, rfl⟩
    have hsum := (c0_dual_hasSum_coordinates Λ (T f)).const_smul c⁻¹
    have hzero : Λ (T f) = 0 := hΛM (T f) hTf
    simpa only [a, b, T, dualEvaluationToC0_apply, smul_eq_mul, mul_assoc, hzero,
      mul_zero] using hsum

/-- 把范数连续对偶中的集合视为弱星对偶中的同一集合。

> **Entry**: functional-analysis.weak-star.banach-dieudonne
-/
def weakStarImage (s : Set (StrongDual ℝ X)) : Set (WeakDual ℝ X) :=
  StrongDual.toWeakDual '' s

/-- 对偶线性子空间与对偶闭单位球的交。 -/
def dualUnitSlice (M : Submodule ℝ (StrongDual ℝ X)) : Set (StrongDual ℝ X) :=
  (M : Set (StrongDual ℝ X)) ∩ Metric.closedBall 0 1

/-- 对偶线性子空间与半径 `R` 的对偶闭球之交。 -/
def dualBallSlice (M : Submodule ℝ (StrongDual ℝ X)) (R : ℝ) :
    Set (StrongDual ℝ X) :=
  (M : Set (StrongDual ℝ X)) ∩ Metric.closedBall 0 R

/-- Banach–Dieudonné 证明的第一步：若子空间的闭单位球截面弱星闭，则该子空间范数闭。 -/
theorem dualSubmodule_normClosed_of_weakStarUnitSlice_closed
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M))) :
    IsClosed (M : Set (StrongDual ℝ X)) := by
  rw [← isSeqClosed_iff_isClosed]
  intro u f huM huf
  obtain ⟨R, hR⟩ :=
    (Metric.isBounded_iff_subset_closedBall (0 : StrongDual ℝ X)).mp
      (Metric.isBounded_range_of_tendsto u huf)
  let c : ℝ := max R 1
  have hc : 0 < c := lt_of_lt_of_le zero_lt_one (le_max_right R 1)
  have huc_mem : ∀ n, c⁻¹ • u n ∈ dualUnitSlice M := by
    intro n
    constructor
    · exact M.smul_mem _ (huM n)
    · rw [Metric.mem_closedBall, dist_zero_right, norm_smul, norm_inv, Real.norm_eq_abs,
        abs_of_pos hc, inv_mul_le_one₀ hc]
      have hun : dist (u n) 0 ≤ R := hR (Set.mem_range_self n)
      have hun' : ‖u n‖ ≤ R := by simpa [dist_zero_right] using hun
      exact hun'.trans (le_max_left R 1)
  have hweak : Tendsto (fun n ↦ StrongDual.toWeakDual (c⁻¹ • u n)) atTop
      (nhds (StrongDual.toWeakDual (c⁻¹ • f))) := by
    apply dual_norm_tendsto_implies_weakStar
    exact huf.const_smul c⁻¹
  have hscaled : StrongDual.toWeakDual (c⁻¹ • f) ∈
      weakStarImage (dualUnitSlice M) := by
    apply hunit.isSeqClosed (x := fun n ↦ StrongDual.toWeakDual (c⁻¹ • u n))
    · intro n
      exact ⟨c⁻¹ • u n, huc_mem n, rfl⟩
    · exact hweak
  obtain ⟨g, hgM, hg⟩ := hscaled
  have hgf : g = c⁻¹ • f := StrongDual.toWeakDual.injective hg
  have : c • g = f := by simp [hgf, hc.ne']
  rw [← this]
  exact M.smul_mem c hgM.1

/-- Banach–Dieudonné 证明第一步的定量形式：待分离对偶与子空间之间有正的范数间隙。 -/
theorem exists_dualSubmodule_norm_gap_of_weakStarUnitSlice_closed
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    {f₀ : StrongDual ℝ X} (hf₀ : f₀ ∉ M) :
    ∃ δ > 0, ∀ f ∈ M, δ < ‖f - f₀‖ := by
  have hclosed : IsClosed (M : Set (StrongDual ℝ X)) :=
    dualSubmodule_normClosed_of_weakStarUnitSlice_closed M hunit
  have hf₀c : f₀ ∈ (M : Set (StrongDual ℝ X))ᶜ := hf₀
  obtain ⟨ε, hε, hball⟩ := Metric.isOpen_iff.mp hclosed.isOpen_compl f₀ hf₀c
  refine ⟨ε / 2, half_pos hε, ?_⟩
  intro f hf
  have hfball : f ∉ Metric.ball f₀ ε := fun h ↦ hball h hf
  have hεdist : ε ≤ dist f f₀ := by
    apply not_lt.mp
    simpa [Metric.mem_ball, dist_comm] using hfball
  exact (half_lt_self hε).trans_le <| by simpa [dist_eq_norm] using hεdist

/-- 弱星闭的对偶单位球截面是弱星紧的。这是 Banach–Dieudonné 证明第二步的
紧性载体。 -/
theorem weakStarImage_dualUnitSlice_isCompact
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M))) :
    IsCompact (weakStarImage (dualUnitSlice M)) := by
  refine weakStar_isCompact_unitBall.of_isClosed_subset hunit ?_
  rintro g ⟨f, hf, rfl⟩
  simpa [dualUnitSlice, Metric.mem_closedBall] using hf.2

/-- 弱星闭单位球截面的任意标量倍仍弱星紧。 -/
theorem weakStarImage_smul_dualUnitSlice_isCompact
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M))) (R : ℝ) :
    IsCompact ((fun f : WeakDual ℝ X ↦ R • f) '' weakStarImage (dualUnitSlice M)) := by
  exact (weakStarImage_dualUnitSlice_isCompact M hunit).image (continuous_const_smul R)

/-- 正半径的对偶球截面，正是单位球截面在弱星对偶中的标量像。 -/
theorem weakStarImage_dualBallSlice_eq_smul
    (M : Submodule ℝ (StrongDual ℝ X)) {R : ℝ} (hR : 0 < R) :
    weakStarImage (dualBallSlice M R) =
      (fun f : WeakDual ℝ X ↦ R • f) '' weakStarImage (dualUnitSlice M) := by
  ext g
  constructor
  · rintro ⟨f, hf, rfl⟩
    refine ⟨StrongDual.toWeakDual (R⁻¹ • f), ?_, ?_⟩
    · refine ⟨R⁻¹ • f, ?_, rfl⟩
      constructor
      · exact M.smul_mem _ hf.1
      · rw [Metric.mem_closedBall, dist_zero_right, norm_smul, Real.norm_eq_abs,
          abs_of_pos (inv_pos.mpr hR)]
        have hfnorm : ‖f‖ ≤ R := by
          simpa [dualBallSlice, Metric.mem_closedBall, dist_zero_right] using hf.2
        exact (inv_mul_le_one₀ hR).2 hfnorm
    · simp [← map_smul, hR.ne']
  · rintro ⟨g, ⟨f, hf, rfl⟩, rfl⟩
    refine ⟨R • f, ?_, by simp [map_smul]⟩
    constructor
    · exact M.smul_mem _ hf.1
    · rw [Metric.mem_closedBall, dist_zero_right, norm_smul, Real.norm_eq_abs,
        abs_of_pos hR]
      have hfnorm : ‖f‖ ≤ 1 := by
        simpa [dualUnitSlice, Metric.mem_closedBall, dist_zero_right] using hf.2
      exact (mul_le_iff_le_one_right hR).2 hfnorm

/-- 若单位球截面弱星闭，则每个正半径的对偶球截面都弱星紧。 -/
theorem weakStarImage_dualBallSlice_isCompact
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M))) {R : ℝ} (hR : 0 < R) :
    IsCompact (weakStarImage (dualBallSlice M R)) := by
  rw [weakStarImage_dualBallSlice_eq_smul M hR]
  exact weakStarImage_smul_dualUnitSlice_isCompact M hunit R

/-- 由原空间中一组向量检测的弱星闭带。 -/
def weakStarEvaluationBand (f₀ : StrongDual ℝ X) (S : Set X) (ε : ℝ) :
    Set (WeakDual ℝ X) :=
  {f | ∀ x ∈ S, |f x - f₀ x| ≤ ε}

/-- 在任意一组原空间向量上同时施加闭求值界，得到弱星闭集。 -/
theorem weakStarEvaluationBand_isClosed
    (f₀ : StrongDual ℝ X) (S : Set X) (ε : ℝ) :
    IsClosed (weakStarEvaluationBand f₀ S ε) := by
  rw [show weakStarEvaluationBand f₀ S ε =
      ⋂ x ∈ S, {f | |f x - f₀ x| ≤ ε} by
    ext
    simp [weakStarEvaluationBand]]
  exact isClosed_biInter fun x _ ↦
    isClosed_le ((WeakDual.eval_continuous x).sub continuous_const).abs continuous_const

private def weakStarPriorBand (f₀ : StrongDual ℝ X) (δ : ℝ)
    (L : List (Finset X)) : Set (WeakDual ℝ X) :=
  {g | ∀ (k : ℕ) (hk : k < L.length) (x : X), x ∈ L[k]'hk →
    |g x - f₀ x| ≤ δ * k}

private theorem weakStarPriorBand_isClosed (f₀ : StrongDual ℝ X) (δ : ℝ)
    (L : List (Finset X)) : IsClosed (weakStarPriorBand f₀ δ L) := by
  rw [show weakStarPriorBand f₀ δ L =
      ⋂ k : ℕ, ⋂ hk : k < L.length, ⋂ x : X, ⋂ _hx : x ∈ L[k]'hk,
        {g : WeakDual ℝ X | |g x - f₀ x| ≤ δ * k} by
    ext g
    simp [weakStarPriorBand]]
  exact isClosed_iInter fun k ↦ isClosed_iInter fun hk ↦ isClosed_iInter fun x ↦
    isClosed_iInter fun _ ↦
      isClosed_le ((WeakDual.eval_continuous x).sub continuous_const).abs continuous_const

private theorem dual_norm_sub_le_of_mem_unitEvaluationBand
    (f₀ : StrongDual ℝ X) {g : WeakDual ℝ X} {ε : ℝ} (hε : 0 ≤ ε)
    (hg : g ∈ weakStarEvaluationBand f₀ (Metric.closedBall (0 : X) 1) ε) :
    ‖WeakDual.toStrongDual g - f₀‖ ≤ ε := by
  apply ContinuousLinearMap.opNorm_le_of_unit_norm hε
  intro x hx
  have h := hg x (by simpa [Metric.mem_closedBall, dist_zero_right] using hx.le)
  simpa [weakStarEvaluationBand, Real.norm_eq_abs] using h

private def DetectionInvariant (M : Submodule ℝ (StrongDual ℝ X))
    (f₀ : StrongDual ℝ X) (δ : ℝ) (L : List (Finset X)) : Prop :=
  ∀ f ∈ M, ‖f - f₀‖ ≤ δ * L.length →
    StrongDual.toWeakDual f ∉ weakStarPriorBand f₀ δ L

private structure DetectionState (M : Submodule ℝ (StrongDual ℝ X))
    (f₀ : StrongDual ℝ X) (δ : ℝ) where
  sets : List (Finset X)
  length_pos : 0 < sets.length
  norm_le_one : ∀ S ∈ sets, ∀ x ∈ S, ‖x‖ ≤ 1
  invariant : DetectionInvariant M f₀ δ sets

private def initialDetectionState (M : Submodule ℝ (StrongDual ℝ X))
    (f₀ : StrongDual ℝ X) {δ : ℝ}
    (hgap : ∀ f ∈ M, δ < ‖f - f₀‖) : DetectionState M f₀ δ where
  sets := [∅]
  length_pos := by simp
  norm_le_one := by simp
  invariant := by
    intro f hf hnorm _
    exact (not_le_of_gt (hgap f hf)) <| by simpa using hnorm

private def detectionCompactSet (M : Submodule ℝ (StrongDual ℝ X))
    (f₀ : StrongDual ℝ X) (δ : ℝ) (L : List (Finset X)) : Set (WeakDual ℝ X) :=
  (weakStarImage (dualBallSlice M (‖f₀‖ + δ * (L.length + 1)))) ∩
    (WeakDual.toStrongDual ⁻¹'
      Metric.closedBall f₀ (δ * (L.length + 1))) ∩
    weakStarPriorBand f₀ δ L

private theorem detectionCompactSet_isCompact
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ) (L : List (Finset X)) :
    IsCompact (detectionCompactSet M f₀ δ L) := by
  have hR : 0 < ‖f₀‖ + δ * (L.length + 1) := by positivity
  exact ((weakStarImage_dualBallSlice_isCompact M hunit hR).inter_right
    (WeakDual.isClosed_closedBall f₀ (δ * (L.length + 1)))).inter_right
      (weakStarPriorBand_isClosed f₀ δ L)

private theorem detectionCompactSet_inter_unitBand_empty
    (M : Submodule ℝ (StrongDual ℝ X)) (f₀ : StrongDual ℝ X)
    {δ : ℝ} (hδ : 0 < δ) (st : DetectionState M f₀ δ) :
    detectionCompactSet M f₀ δ st.sets ∩
      weakStarEvaluationBand f₀ (Metric.closedBall (0 : X) 1)
        (δ * st.sets.length) = ∅ := by
  rw [Set.eq_empty_iff_forall_notMem]
  intro g hg
  obtain ⟨⟨⟨f, hf, rfl⟩, _hcenter⟩, hprior⟩ := hg.1
  have hnorm : ‖f - f₀‖ ≤ δ * st.sets.length := by
    simpa using dual_norm_sub_le_of_mem_unitEvaluationBand f₀
      (mul_nonneg hδ.le (Nat.cast_nonneg _)) hg.2
  exact (st.invariant f hf.1 hnorm) hprior

/-- 若弱星紧集与一族求值闭条件的全交不相交，则已有有限多个原空间向量检测到
这一点。有限集以 `B` 的子类型给出，因而其元素自带单位球成员证明。 -/
theorem exists_finite_weakStarEvaluation_witness
    (K : Set (WeakDual ℝ X)) (hK : IsCompact K)
    (f₀ : StrongDual ℝ X) (B : Set X) (ε : ℝ)
    (hall : K ∩ weakStarEvaluationBand f₀ B ε = ∅) :
    ∃ S : Finset {x // x ∈ B},
      K ∩ ⋂ x ∈ S, {f : WeakDual ℝ X | |f x.1 - f₀ x.1| ≤ ε} = ∅ := by
  have hall' :
      K ∩ ⋂ x : {x // x ∈ B}, {f : WeakDual ℝ X | |f x.1 - f₀ x.1| ≤ ε} = ∅ := by
    rw [← hall]
    congr 1
    ext f
    simp [weakStarEvaluationBand]
  apply hK.elim_finite_subfamily_closed
      (fun x : {x // x ∈ B} ↦ {f : WeakDual ℝ X | |f x.1 - f₀ x.1| ≤ ε})
  · intro x
    exact isClosed_le ((WeakDual.eval_continuous x.1).sub continuous_const).abs continuous_const
  · exact hall'

private theorem exists_next_detection_finset
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (st : DetectionState M f₀ δ) :
    ∃ S : Finset {x // x ∈ Metric.closedBall (0 : X) 1},
      detectionCompactSet M f₀ δ st.sets ∩
        ⋂ x ∈ S, {f : WeakDual ℝ X |
          |f x.1 - f₀ x.1| ≤ δ * st.sets.length} = ∅ := by
  exact exists_finite_weakStarEvaluation_witness
    (detectionCompactSet M f₀ δ st.sets)
    (detectionCompactSet_isCompact M hunit f₀ hδ st.sets)
    f₀ (Metric.closedBall (0 : X) 1) (δ * st.sets.length)
    (detectionCompactSet_inter_unitBand_empty M f₀ hδ st)

private theorem weakStarPriorBand_append_left
    (f₀ : StrongDual ℝ X) (δ : ℝ) (L : List (Finset X)) (S : Finset X)
    {g : WeakDual ℝ X} (hg : g ∈ weakStarPriorBand f₀ δ (L ++ [S])) :
    g ∈ weakStarPriorBand f₀ δ L := by
  intro k hk x hx
  apply hg k (by simp; omega) x
  simpa [List.getElem_append_left hk] using hx

private theorem weakStarPriorBand_append_last
    (f₀ : StrongDual ℝ X) (δ : ℝ) (L : List (Finset X)) (S : Finset X)
    {g : WeakDual ℝ X} (hg : g ∈ weakStarPriorBand f₀ δ (L ++ [S]))
    {x : X} (hx : x ∈ S) :
    |g x - f₀ x| ≤ δ * L.length := by
  have hk : L.length < (L ++ [S]).length := by simp
  exact hg L.length hk x (by simpa using hx)

private theorem exists_next_detection_state
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (st : DetectionState M f₀ δ) :
    ∃ st' : DetectionState M f₀ δ,
      ∃ S : Finset X, st'.sets = st.sets ++ [S] := by
  obtain ⟨S, hS⟩ := exists_next_detection_finset M hunit f₀ hδ st
  classical
  let S' : Finset X := S.image Subtype.val
  refine ⟨⟨st.sets ++ [S'], by simp, ?_, ?_⟩, S', rfl⟩
  · intro T hT x hx
    rw [List.mem_append] at hT
    rcases hT with hT | hT
    · exact st.norm_le_one T hT x hx
    · have hTS : T = S' := by simpa using hT
      subst T
      obtain ⟨y, hy, rfl⟩ := Finset.mem_image.mp hx
      simpa only [Metric.mem_closedBall, dist_zero_right] using y.property
  · intro f hf hnorm hprior
    have hold : StrongDual.toWeakDual f ∈ weakStarPriorBand f₀ δ st.sets :=
      weakStarPriorBand_append_left f₀ δ st.sets S' hprior
    have hcenter : ‖f - f₀‖ ≤ δ * (st.sets.length + 1) := by
      simpa using hnorm
    have hfnorm : ‖f‖ ≤ ‖f₀‖ + δ * (st.sets.length + 1) := by
      calc
        ‖f‖ = ‖f₀ + (f - f₀)‖ := by congr 1; abel
        _ ≤ ‖f₀‖ + ‖f - f₀‖ := norm_add_le _ _
        _ ≤ ‖f₀‖ + δ * (st.sets.length + 1) := by gcongr
    have hcompact : StrongDual.toWeakDual f ∈ detectionCompactSet M f₀ δ st.sets := by
      refine ⟨⟨⟨f, ⟨hf, ?_⟩, rfl⟩, ?_⟩, hold⟩
      · simpa [dualBallSlice, Metric.mem_closedBall, dist_zero_right] using hfnorm
      · simpa [dist_eq_norm] using hcenter
    have hfinite : StrongDual.toWeakDual f ∈
        ⋂ x ∈ S, {g : WeakDual ℝ X |
          |g x.1 - f₀ x.1| ≤ δ * st.sets.length} := by
      simp only [Set.mem_iInter]
      intro x hx
      apply weakStarPriorBand_append_last f₀ δ st.sets S' hprior
      exact Finset.mem_image.mpr ⟨x, hx, rfl⟩
    have : StrongDual.toWeakDual f ∈
        detectionCompactSet M f₀ δ st.sets ∩
          ⋂ x ∈ S, {g : WeakDual ℝ X |
            |g x.1 - f₀ x.1| ≤ δ * st.sets.length} := ⟨hcompact, hfinite⟩
    rw [hS] at this
    exact this

private noncomputable def nextDetectionState
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (st : DetectionState M f₀ δ) : DetectionState M f₀ δ :=
  Classical.choose (exists_next_detection_state M hunit f₀ hδ st)

private noncomputable def nextDetectionFinset
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (st : DetectionState M f₀ δ) : Finset X :=
  Classical.choose (Classical.choose_spec
    (exists_next_detection_state M hunit f₀ hδ st))

private theorem nextDetectionState_sets
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (st : DetectionState M f₀ δ) :
    (nextDetectionState M hunit f₀ hδ st).sets =
      st.sets ++ [nextDetectionFinset M hunit f₀ hδ st] :=
  Classical.choose_spec (Classical.choose_spec
    (exists_next_detection_state M hunit f₀ hδ st))

private noncomputable def detectionStates
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (hgap : ∀ f ∈ M, δ < ‖f - f₀‖) : ℕ → DetectionState M f₀ δ
  | 0 => initialDetectionState M f₀ hgap
  | n + 1 => nextDetectionState M hunit f₀ hδ (detectionStates M hunit f₀ hδ hgap n)

private theorem detectionStates_length
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (hgap : ∀ f ∈ M, δ < ‖f - f₀‖) (n : ℕ) :
    (detectionStates M hunit f₀ hδ hgap n).sets.length = n + 1 := by
  induction n with
  | zero => simp [detectionStates, initialDetectionState]
  | succ n ih =>
      rw [detectionStates, nextDetectionState_sets, List.length_append, ih]
      simp

private noncomputable def detectionBlock
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (hgap : ∀ f ∈ M, δ < ‖f - f₀‖) : ℕ → Finset X
  | 0 => ∅
  | n + 1 => nextDetectionFinset M hunit f₀ hδ
      (detectionStates M hunit f₀ hδ hgap n)

private theorem detectionStates_sets_eq_blocks
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (hgap : ∀ f ∈ M, δ < ‖f - f₀‖) (n : ℕ) :
    (detectionStates M hunit f₀ hδ hgap n).sets =
      (List.range (n + 1)).map (detectionBlock M hunit f₀ hδ hgap) := by
  induction n with
  | zero => simp [detectionStates, initialDetectionState, detectionBlock]
  | succ n ih =>
      rw [detectionStates, nextDetectionState_sets, ih]
      simp [List.range_succ, detectionBlock]

private theorem detectionBlock_norm_le_one
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (hgap : ∀ f ∈ M, δ < ‖f - f₀‖) (k : ℕ) {x : X}
    (hx : x ∈ detectionBlock M hunit f₀ hδ hgap k) : ‖x‖ ≤ 1 := by
  cases k with
  | zero => simp [detectionBlock] at hx
  | succ k =>
      let st := detectionStates M hunit f₀ hδ hgap (k + 1)
      have hmem : detectionBlock M hunit f₀ hδ hgap (k + 1) ∈ st.sets := by
        dsimp [st]
        rw [detectionStates, nextDetectionState_sets]
        simp [detectionBlock]
      exact st.norm_le_one _ hmem x hx

private theorem exists_detectionBlock_separating
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (hgap : ∀ f ∈ M, δ < ‖f - f₀‖)
    (f : StrongDual ℝ X) (hf : f ∈ M) :
    ∃ k > 0, ∃ x ∈ detectionBlock M hunit f₀ hδ hgap k,
      δ * k < |(StrongDual.toWeakDual f) x - f₀ x| := by
  obtain ⟨n, hn⟩ := exists_nat_ge (‖f - f₀‖ / δ)
  let st := detectionStates M hunit f₀ hδ hgap n
  have hnorm : ‖f - f₀‖ ≤ δ * st.sets.length := by
    rw [detectionStates_length M hunit f₀ hδ hgap n]
    have hbase : ‖f - f₀‖ ≤ δ * n := by
      have hn' := (div_le_iff₀ hδ).mp hn
      simpa [mul_comm] using hn'
    exact hbase.trans (mul_le_mul_of_nonneg_left (Nat.cast_le.2 (Nat.le_succ n)) hδ.le)
  have hnot := st.invariant f hf hnorm
  rw [weakStarPriorBand] at hnot
  simp only [Set.mem_ofPred_eq] at hnot
  obtain ⟨k, hnot⟩ := not_forall.mp hnot
  obtain ⟨hk, hnot⟩ := not_forall.mp hnot
  obtain ⟨x, hnot⟩ := not_forall.mp hnot
  obtain ⟨hx, hnot⟩ := not_forall.mp hnot
  have hsep := lt_of_not_ge hnot
  have hk' : k < n + 1 := by simpa [st, detectionStates_length M hunit f₀ hδ hgap n] using hk
  have hx' : x ∈ detectionBlock M hunit f₀ hδ hgap k := by
    have hsets := detectionStates_sets_eq_blocks M hunit f₀ hδ hgap n
    have hx'' : x ∈ (detectionStates M hunit f₀ hδ hgap n).sets[k] := by
      simpa [st] using hx
    simpa [hsets, hk'] using hx''
  have hkpos : 0 < k := by
    cases k with
    | zero => simp [detectionBlock] at hx'
    | succ k => omega
  exact ⟨k, hkpos, x, hx', hsep⟩

private noncomputable def detectionPoint
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (hgap : ∀ f ∈ M, δ < ‖f - f₀‖) (k j : ℕ) : X :=
  if hj : j < (detectionBlock M hunit f₀ hδ hgap k).toList.length then
    (detectionBlock M hunit f₀ hδ hgap k).toList[j]
  else 0

private theorem detectionPoint_norm_le_one
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (hgap : ∀ f ∈ M, δ < ‖f - f₀‖) (k j : ℕ) :
    ‖detectionPoint M hunit f₀ hδ hgap k j‖ ≤ 1 := by
  classical
  unfold detectionPoint
  split_ifs with hj
  · apply detectionBlock_norm_le_one M hunit f₀ hδ hgap k
    exact Finset.mem_toList.mp (List.getElem_mem hj)
  · simp

private theorem exists_detectionPoint_eq_of_mem
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (hgap : ∀ f ∈ M, δ < ‖f - f₀‖) (k : ℕ) {x : X}
    (hx : x ∈ detectionBlock M hunit f₀ hδ hgap k) :
    ∃ j, detectionPoint M hunit f₀ hδ hgap k j = x := by
  classical
  have hxlist : x ∈ (detectionBlock M hunit f₀ hδ hgap k).toList :=
    Finset.mem_toList.mpr hx
  obtain ⟨j, hj⟩ := List.get_of_mem hxlist
  refine ⟨j, ?_⟩
  rw [detectionPoint, dif_pos (by simpa using j.isLt)]
  exact hj

private noncomputable def detectionSequence
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (hgap : ∀ f ∈ M, δ < ‖f - f₀‖) (n : ℕ) : X :=
  let p := Nat.unpair n
  if p.1 = 0 then 0 else (p.1 : ℝ)⁻¹ •
    detectionPoint M hunit f₀ hδ hgap p.1 p.2

private theorem detectionSequence_norm_le_one
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (hgap : ∀ f ∈ M, δ < ‖f - f₀‖) (n : ℕ) :
    ‖detectionSequence M hunit f₀ hδ hgap n‖ ≤ 1 := by
  classical
  simp only [detectionSequence]
  split_ifs with hk
  · simp
  · rw [norm_smul, Real.norm_eq_abs, abs_of_nonneg (inv_nonneg.mpr (Nat.cast_nonneg _))]
    calc
      ((Nat.unpair n).1 : ℝ)⁻¹ * ‖detectionPoint M hunit f₀ hδ hgap (Nat.unpair n).1
          (Nat.unpair n).2‖ ≤ ((Nat.unpair n).1 : ℝ)⁻¹ * 1 :=
        mul_le_mul_of_nonneg_left
          (detectionPoint_norm_le_one M hunit f₀ hδ hgap _ _) (inv_nonneg.mpr (Nat.cast_nonneg _))
      _ ≤ 1 := by
        rw [mul_one, inv_le_one₀]
        · exact_mod_cast (Nat.one_le_iff_ne_zero.mpr hk)
        · exact_mod_cast (Nat.pos_of_ne_zero hk)

private theorem detectionSequence_tendsto_zero
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (hgap : ∀ f ∈ M, δ < ‖f - f₀‖) :
    Tendsto (detectionSequence M hunit f₀ hδ hgap) atTop (nhds 0) := by
  classical
  rw [Metric.tendsto_atTop]
  intro ε hε
  obtain ⟨q, hq⟩ := exists_nat_one_div_lt hε
  let K : ℕ := q + 1
  let F : Finset ℕ := (Finset.range K).biUnion fun k ↦
    (Finset.range (detectionBlock M hunit f₀ hδ hgap k).card).image (Nat.pair k)
  obtain ⟨N, hN⟩ := F.exists_nat_subset_range
  refine ⟨N, ?_⟩
  intro n hn
  have hnF : n ∉ F := by
    intro hnmem
    have := hN hnmem
    simp only [Finset.mem_range] at this
    omega
  let p := Nat.unpair n
  by_cases hp₀ : p.1 = 0
  · simpa [detectionSequence, p, hp₀] using hε
  by_cases hpK : K ≤ p.1
  · have hpoint := detectionPoint_norm_le_one M hunit f₀ hδ hgap p.1 p.2
    rw [show detectionSequence M hunit f₀ hδ hgap n =
        (p.1 : ℝ)⁻¹ • detectionPoint M hunit f₀ hδ hgap p.1 p.2 by
      simp [detectionSequence, p, hp₀]]
    rw [dist_zero_right, norm_smul, Real.norm_eq_abs,
      abs_of_nonneg (inv_nonneg.mpr (Nat.cast_nonneg _))]
    calc
      (p.1 : ℝ)⁻¹ * ‖detectionPoint M hunit f₀ hδ hgap p.1 p.2‖ ≤
          (p.1 : ℝ)⁻¹ := by
        simpa using mul_le_mul_of_nonneg_left hpoint (inv_nonneg.mpr (Nat.cast_nonneg _))
      _ ≤ (K : ℝ)⁻¹ := by
        exact inv_anti₀ (by exact_mod_cast (Nat.succ_pos q)) (by exact_mod_cast hpK)
      _ < ε := by simpa [K, one_div] using hq
  · have hplt : p.1 < K := Nat.lt_of_not_ge hpK
    have hpj : ¬p.2 < (detectionBlock M hunit f₀ hδ hgap p.1).card := by
      intro hpj
      apply hnF
      rw [Finset.mem_biUnion]
      refine ⟨p.1, Finset.mem_range.mpr hplt, ?_⟩
      rw [Finset.mem_image]
      exact ⟨p.2, Finset.mem_range.mpr hpj, Nat.pair_unpair n⟩
    have hpoint : detectionPoint M hunit f₀ hδ hgap p.1 p.2 = 0 := by
      simp [detectionPoint, hpj]
    simpa [detectionSequence, p, hp₀, hpoint] using hε

private theorem detectionSequence_uniformly_separates
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    (f₀ : StrongDual ℝ X) {δ : ℝ} (hδ : 0 < δ)
    (hgap : ∀ f ∈ M, δ < ‖f - f₀‖) :
    ∀ f ∈ M, δ <
      ‖dualEvaluationToC0 (detectionSequence M hunit f₀ hδ hgap)
          (detectionSequence_tendsto_zero M hunit f₀ hδ hgap)
          (detectionSequence_norm_le_one M hunit f₀ hδ hgap) f -
        dualEvaluationToC0 (detectionSequence M hunit f₀ hδ hgap)
          (detectionSequence_tendsto_zero M hunit f₀ hδ hgap)
          (detectionSequence_norm_le_one M hunit f₀ hδ hgap) f₀‖ := by
  intro f hf
  obtain ⟨k, hk, x, hx, hsep⟩ :=
    exists_detectionBlock_separating M hunit f₀ hδ hgap f hf
  obtain ⟨j, hj⟩ := exists_detectionPoint_eq_of_mem M hunit f₀ hδ hgap k hx
  let n := Nat.pair k j
  let u := dualEvaluationToC0 (detectionSequence M hunit f₀ hδ hgap)
    (detectionSequence_tendsto_zero M hunit f₀ hδ hgap)
    (detectionSequence_norm_le_one M hunit f₀ hδ hgap)
  have hseq : detectionSequence M hunit f₀ hδ hgap n = (k : ℝ)⁻¹ • x := by
    simp [n, detectionSequence, Nat.unpair_pair, hk.ne', hj]
  have hkinv : 0 < (k : ℝ)⁻¹ := inv_pos.mpr (by exact_mod_cast hk)
  have hcoord : δ < |f (detectionSequence M hunit f₀ hδ hgap n) -
      f₀ (detectionSequence M hunit f₀ hδ hgap n)| := by
    rw [hseq, map_smul, map_smul, smul_eq_mul, smul_eq_mul]
    have hm := mul_lt_mul_of_pos_left hsep hkinv
    have hkne : (k : ℝ) ≠ 0 := by exact_mod_cast hk.ne'
    have hleft : (k : ℝ)⁻¹ * (δ * k) = δ := by
      field_simp
    have hright : (k : ℝ)⁻¹ * |(StrongDual.toWeakDual f) x - f₀ x| =
        |(k : ℝ)⁻¹ * f x - (k : ℝ)⁻¹ * f₀ x| := by
      calc
        (k : ℝ)⁻¹ * |(StrongDual.toWeakDual f) x - f₀ x| =
            |(k : ℝ)⁻¹| * |(StrongDual.toWeakDual f) x - f₀ x| := by
              rw [abs_of_pos hkinv]
        _ = |(k : ℝ)⁻¹ * ((StrongDual.toWeakDual f) x - f₀ x)| := (abs_mul _ _).symm
        _ = |(k : ℝ)⁻¹ * f x - (k : ℝ)⁻¹ * f₀ x| := by
          congr 1
          change (k : ℝ)⁻¹ * (f x - f₀ x) = _
          ring
    rw [hleft, hright] at hm
    exact hm
  apply hcoord.trans_le
  have hpoint := BoundedContinuousFunction.norm_coe_le_norm (u f - u f₀).toBCF n
  simpa [u, Real.norm_eq_abs] using hpoint

/-- Banach–Dieudonné 证明的第五步：绝对可和的系数与单位球中的向量给出原空间中的
分离向量。系数对子空间中每个对偶求值为零，对待分离对偶求值为一。 -/
theorem dualSeparator_of_summable_series [CompleteSpace X]
    (M : Submodule ℝ (StrongDual ℝ X)) (f₀ : StrongDual ℝ X)
    (x : ℕ → X) (hx : ∀ i, ‖x i‖ ≤ 1) (a : ℕ → ℝ)
    (ha : Summable fun i ↦ |a i|) {C : ℝ} (haC : ∑' i, |a i| ≤ C)
    (hf₀ : HasSum (fun i ↦ a i * f₀ (x i)) 1)
    (hM : ∀ f ∈ M, HasSum (fun i ↦ a i * f (x i)) 0) :
    ∃ x₀ : X, f₀ x₀ = 1 ∧ ‖x₀‖ ≤ C ∧ ∀ f ∈ M, f x₀ = 0 := by
  have hnorm : Summable fun i ↦ ‖a i • x i‖ :=
    ha.of_norm_bounded fun i ↦ by
      simpa [norm_smul, Real.norm_eq_abs, abs_of_nonneg] using
        mul_le_of_le_one_right (abs_nonneg (a i)) (hx i)
  have hax : Summable fun i ↦ a i • x i := hnorm.of_norm
  refine ⟨∑' i, a i • x i, ?_, ?_, ?_⟩
  · rw [f₀.map_tsum hax]
    simpa [map_smul, smul_eq_mul] using hf₀.tsum_eq
  · exact (norm_tsum_le_tsum_norm hnorm).trans <|
      (hnorm.tsum_le_tsum (fun i ↦ by
        simpa [norm_smul, Real.norm_eq_abs, abs_of_nonneg] using
          mul_le_of_le_one_right (abs_nonneg (a i)) (hx i)) ha).trans haC
  · intro f hf
    rw [f.map_tsum hax]
    simpa [map_smul, smul_eq_mul] using (hM f hf).tsum_eq

/-- Banach--Dieudonné 的分离形式：若对偶子空间的闭单位球截面弱星闭，则每个不在
子空间中的对偶都可由一个原空间向量与整个子空间分离。 -/
theorem exists_weakStar_separator_of_dualUnitSlice_closed [CompleteSpace X]
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M)))
    {f₀ : StrongDual ℝ X} (hf₀ : f₀ ∉ M) :
    ∃ x₀ : X, f₀ x₀ = 1 ∧ ∀ f ∈ M, f x₀ = 0 := by
  obtain ⟨δ, hδ, hgap⟩ :=
    exists_dualSubmodule_norm_gap_of_weakStarUnitSlice_closed M hunit hf₀
  let x := detectionSequence M hunit f₀ hδ hgap
  have hx₀ : Tendsto x atTop (nhds 0) :=
    detectionSequence_tendsto_zero M hunit f₀ hδ hgap
  have hx : ∀ i, ‖x i‖ ≤ 1 :=
    detectionSequence_norm_le_one M hunit f₀ hδ hgap
  have hsep : ∀ f ∈ M, δ <
      ‖dualEvaluationToC0 x hx₀ hx f - dualEvaluationToC0 x hx₀ hx f₀‖ := by
    simpa [x] using detectionSequence_uniformly_separates M hunit f₀ hδ hgap
  obtain ⟨a, ha, haNorm, hf₀sum, hMsum⟩ :=
    exists_summable_dual_separator M f₀ x hx₀ hx hδ hsep
  obtain ⟨x₀, hf₀x₀, _hx₀norm, hMx₀⟩ :=
    dualSeparator_of_summable_series M f₀ x hx a ha haNorm hf₀sum hMsum
  exact ⟨x₀, hf₀x₀, hMx₀⟩

/-- **Banach--Dieudonné theorem.** In a real Banach space, a linear subspace of the
continuous dual is weak-star closed as soon as its intersection with the closed unit ball is
weak-star closed. -/
theorem weakStarImage_submodule_isClosed_of_dualUnitSlice_closed [CompleteSpace X]
    (M : Submodule ℝ (StrongDual ℝ X))
    (hunit : IsClosed (weakStarImage (dualUnitSlice M))) :
    IsClosed (weakStarImage (M : Set (StrongDual ℝ X))) := by
  rw [show weakStarImage (M : Set (StrongDual ℝ X)) =
      ⋂ x : X, ⋂ (_h : ∀ f ∈ M, f x = 0),
        {g : WeakDual ℝ X | g x = 0} by
    ext g
    constructor
    · rintro ⟨f, hf, rfl⟩
      simp only [Set.mem_iInter, Set.mem_ofPred_eq]
      intro x hx
      exact hx f hf
    · intro hg
      simp only [Set.mem_iInter, Set.mem_ofPred_eq] at hg
      by_contra hnot
      have hf₀ : WeakDual.toStrongDual g ∉ M := by
        intro hmem
        apply hnot
        exact ⟨WeakDual.toStrongDual g, hmem, WeakDual.toWeakDual_toStrongDual g⟩
      obtain ⟨x₀, hx₀one, hx₀zero⟩ :=
        exists_weakStar_separator_of_dualUnitSlice_closed M hunit hf₀
      have hgzero : g x₀ = 0 := hg x₀ hx₀zero
      have : g x₀ = 1 := by simpa using hx₀one
      linarith]
  exact isClosed_iInter fun x ↦ isClosed_iInter fun _ ↦
    isClosed_singleton.preimage (WeakDual.eval_continuous x)

/-- Banach--Dieudonné closedness criterion in iff form. -/
theorem weakStarImage_submodule_isClosed_iff_dualUnitSlice_closed [CompleteSpace X]
    (M : Submodule ℝ (StrongDual ℝ X)) :
    IsClosed (weakStarImage (M : Set (StrongDual ℝ X))) ↔
      IsClosed (weakStarImage (dualUnitSlice M)) := by
  constructor
  · intro hM
    rw [show weakStarImage (dualUnitSlice M) =
        weakStarImage (M : Set (StrongDual ℝ X)) ∩
          WeakDual.toStrongDual ⁻¹' Metric.closedBall (0 : StrongDual ℝ X) 1 by
      ext g
      constructor
      · rintro ⟨f, ⟨hfM, hfball⟩, rfl⟩
        exact ⟨⟨f, hfM, rfl⟩, by simpa using hfball⟩
      · rintro ⟨⟨f, hfM, hfg⟩, hgball⟩
        refine ⟨f, ⟨hfM, ?_⟩, hfg⟩
        simpa [← hfg, StrongDual.toStrongDual_toWeakDual] using hgball]
    exact hM.inter weakStar_isCompact_unitBall.isClosed
  · exact weakStarImage_submodule_isClosed_of_dualUnitSlice_closed M

end SandronesLibrary.FunctionalAnalysis
