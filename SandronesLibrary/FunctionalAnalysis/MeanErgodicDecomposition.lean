/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.FunctionalAnalysis.EberleinSmulian
import SandronesLibrary.FunctionalAnalysis.ClosedRangeConsequences
import Mathlib.Analysis.InnerProductSpace.MeanErgodic

/-!
# Power-bounded operators and the mean ergodic decomposition

This file formalizes the first, non-reflexive batch of Bühler--Salamon Theorem 3.6.9.  It uses
Mathlib's `birkhoffAverage` as the pointwise Cesàro average and equips the same formula with a
continuous-linear-map carrier in order to state uniform operator bounds.
-/

namespace SandronesLibrary.FunctionalAnalysis

open Filter Function Set

noncomputable section

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- A bounded linear endomorphism is power-bounded when all nonnegative powers have one common
operator-norm bound.  This is equation (3.6.7) of Bühler--Salamon, with the harmless normalization
`1 ≤ c` included in the witness.

> **Entry**: functional-analysis.ergodic.mean
-/
def IsPowerBounded (T : E →L[ℝ] E) : Prop :=
  ∃ c : ℝ, 1 ≤ c ∧ ∀ n : ℕ, ‖T ^ n‖ ≤ c

/-- The continuous-linear-map lift of Mathlib's pointwise `birkhoffAverage`.  It is not a second
notion of average: `meanErgodicAverage_apply` below identifies the two formulas definitionally.

> **Entry**: functional-analysis.ergodic.mean
-/
def meanErgodicAverage (T : E →L[ℝ] E) (n : ℕ) : E →L[ℝ] E :=
  (n : ℝ)⁻¹ • ∑ k ∈ Finset.range n, T ^ k

/-- The operator-valued lift evaluates to Mathlib's `birkhoffAverage`.

> **Entry**: functional-analysis.ergodic.mean
-/
@[simp] theorem meanErgodicAverage_apply (T : E →L[ℝ] E) (n : ℕ) (x : E) :
    meanErgodicAverage T n x = birkhoffAverage ℝ T _root_.id n x := by
  simp [meanErgodicAverage, birkhoffAverage, birkhoffSum]

/-- The textbook convergence domain: vectors whose Cesàro averages converge in norm.  The carrier
is a submodule because every `meanErgodicAverage T n` is linear.

> **Entry**: functional-analysis.ergodic.mean
-/
def meanErgodicConvergenceSubmodule [CompleteSpace E] (T : E →L[ℝ] E) : Submodule ℝ E where
  carrier := {x | ∃ y, Tendsto (fun n ↦ meanErgodicAverage T n x) atTop (nhds y)}
  zero_mem' := ⟨0, by simpa only [map_zero] using (tendsto_const_nhds :
    Tendsto (fun _n : ℕ ↦ (0 : E)) atTop (nhds 0))⟩
  add_mem' := by
    rintro x y ⟨a, ha⟩ ⟨b, hb⟩
    exact ⟨a + b, by simpa only [map_add] using ha.add hb⟩
  smul_mem' := by
    rintro c x ⟨a, ha⟩
    refine ⟨c • a, ?_⟩
    simpa only [map_smul] using ha.const_smul c

/-- The fixed-point subspace used in the mean ergodic decomposition.  This is a notation-level
bridge to Mathlib `LinearMap.eqLocus`, not a new fixed-point predicate.

> **Entry**: functional-analysis.ergodic.mean
-/
abbrev meanErgodicFixedSubmodule (T : E →L[ℝ] E) : Submodule ℝ E :=
  (T : E →ₗ[ℝ] E).eqLocus 1

/-- The closed difference range in Theorem 3.6.9.  The sign is immaterial, but we freeze `T - 1`
to match Mathlib's Birkhoff telescoping lemmas.

> **Entry**: functional-analysis.ergodic.mean
-/
abbrev meanErgodicDifferenceClosure (T : E →L[ℝ] E) : Submodule ℝ E :=
  (T - 1).range.topologicalClosure

theorem IsPowerBounded.nonneg_bound {T : E →L[ℝ] E} (hT : IsPowerBounded T) :
    ∃ c : ℝ, 0 ≤ c ∧ ∀ n : ℕ, ‖T ^ n‖ ≤ c := by
  obtain ⟨c, hc, hcn⟩ := hT
  exact ⟨c, hc.trans' zero_le_one, hcn⟩

theorem isBounded_orbit_of_powerBounded {T : E →L[ℝ] E} {c : ℝ}
    (hT : ∀ n : ℕ, ‖T ^ n‖ ≤ c) (x : E) :
    Bornology.IsBounded (Set.range (_root_.id <| T^[·] x)) := by
  refine isBounded_iff_forall_norm_le.2 ⟨c * ‖x‖, Set.forall_mem_range.2 fun n ↦ ?_⟩
  have hn := (ContinuousLinearMap.le_opNorm (T ^ n) x).trans
    (mul_le_mul_of_nonneg_right (hT n) (norm_nonneg x))
  simp only [id_eq]
  have hiter : T^[n] x = (T ^ n) x := by
    induction n with
    | zero => simp
    | succ n ih => simp [Function.iterate_succ_apply, pow_succ]
  rw [hiter]
  exact hn

/-- Power-boundedness gives the uniform operator bound `‖Sₙ‖ ≤ c` from Step 1 of the textbook
proof.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem norm_meanErgodicAverage_le {T : E →L[ℝ] E} {c : ℝ}
    (hc : 0 ≤ c) (hT : ∀ n : ℕ, ‖T ^ n‖ ≤ c) (n : ℕ) :
    ‖meanErgodicAverage T n‖ ≤ c := by
  apply ContinuousLinearMap.opNorm_le_bound _ hc
  intro x
  rcases n with _ | n
  · simp only [meanErgodicAverage_apply, birkhoffAverage_zero', Pi.zero_apply, norm_zero]
    exact mul_nonneg hc (norm_nonneg x)
  simp only [meanErgodicAverage, smul_apply]
  rw [norm_smul]
  calc
    ‖((n + 1 : ℕ) : ℝ)⁻¹‖ * ‖(∑ k ∈ Finset.range (n + 1), T ^ k) x‖
        ≤ ((n + 1 : ℝ) : ℝ)⁻¹ * ∑ k ∈ Finset.range (n + 1), ‖(T ^ k) x‖ := by
          rw [norm_inv, norm_natCast]
          simp only [Nat.cast_add_one]
          exact mul_le_mul_of_nonneg_left
            (by simpa only [sum_apply] using
              (norm_sum_le (Finset.range (n + 1)) fun k ↦ (T ^ k) x))
            (inv_nonneg.mpr (by positivity))
    _ ≤ ((n + 1 : ℝ) : ℝ)⁻¹ * ∑ _k ∈ Finset.range (n + 1), c * ‖x‖ := by
          gcongr with k hk
          exact (ContinuousLinearMap.le_opNorm (T ^ k) x).trans
            (mul_le_mul_of_nonneg_right (hT k) (norm_nonneg x))
    _ = c * ‖x‖ := by
      simp only [Finset.sum_const, Finset.card_range, nsmul_eq_mul, Nat.cast_add_one]
      field_simp

/-- On a fixed point, every nonzero Cesàro average is the point itself.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem meanErgodicAverage_fixed {T : E →L[ℝ] E} {x : E}
    (hx : x ∈ meanErgodicFixedSubmodule T) {n : ℕ} (hn : n ≠ 0) :
    meanErgodicAverage T n x = x := by
  rw [meanErgodicAverage_apply]
  have hfix : IsFixedPt T x := by simpa [IsFixedPt] using hx
  exact hfix.birkhoffAverage_eq ℝ _root_.id (Nat.cast_ne_zero.mpr hn)

/-- Cesàro averages of a difference `(T - 1)x` tend to zero by telescoping.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem tendsto_meanErgodicAverage_difference {T : E →L[ℝ] E} {c : ℝ}
    (_hc : 0 ≤ c) (hT : ∀ n : ℕ, ‖T ^ n‖ ≤ c) (x : E) :
    Tendsto (fun n ↦ meanErgodicAverage T n ((T - 1) x)) atTop (nhds 0) := by
  have horbit : Bornology.IsBounded (Set.range (_root_.id <| T^[·] x)) := by
    exact isBounded_orbit_of_powerBounded hT x
  have htel := tendsto_birkhoffAverage_apply_sub_birkhoffAverage ℝ horbit
  convert htel using 1
  ext n
  simp [meanErgodicAverage_apply, birkhoffAverage, birkhoffSum,
    iterate_map_sub, Finset.sum_sub_distrib, smul_sub]

/-- A power bound makes the family of Cesàro operators uniformly equicontinuous.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem uniformEquicontinuous_meanErgodicAverage {T : E →L[ℝ] E} {c : ℝ}
    (hc : 0 ≤ c) (hT : ∀ n : ℕ, ‖T ^ n‖ ≤ c) :
    UniformEquicontinuous (fun n : ℕ ↦ meanErgodicAverage T n) := by
  let C : NNReal := ⟨c, hc⟩
  apply LipschitzWith.uniformEquicontinuous _ C
  intro n
  exact (meanErgodicAverage T n).lipschitz.weaken (by
    change ‖meanErgodicAverage T n‖₊ ≤ C
    exact_mod_cast norm_meanErgodicAverage_le hc hT n)

/-- Cesàro averages tend to zero on the closure of `range (T - 1)`.  This is the closure step in
Bühler--Salamon Theorem 3.6.9 and uses uniform equicontinuity rather than assuming that the range is
closed.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem tendsto_meanErgodicAverage_differenceClosure {T : E →L[ℝ] E} {c : ℝ}
    (hc : 0 ≤ c) (hT : ∀ n : ℕ, ‖T ^ n‖ ≤ c)
    {y : E} (hy : y ∈ meanErgodicDifferenceClosure T) :
    Tendsto (fun n ↦ meanErgodicAverage T n y) atTop (nhds 0) := by
  have hequi := (uniformEquicontinuous_meanErgodicAverage hc hT).equicontinuous
  have hclosed : IsClosed
      {z : E | Tendsto (fun n ↦ meanErgodicAverage T n z) atTop (nhds 0)} :=
    hequi.isClosed_setOfPred_tendsto continuous_const
  have hsubset : ((T - 1).range : Set E) ⊆
      {z : E | Tendsto (fun n ↦ meanErgodicAverage T n z) atTop (nhds 0)} := by
    rintro _ ⟨x, rfl⟩
    exact tendsto_meanErgodicAverage_difference hc hT x
  have hyclosure : y ∈ closure ((T - 1).range : Set E) := by
    change y ∈ (T - 1).range.topologicalClosure at hy
    change y ∈ (T - 1).range.topologicalClosure
    exact hy
  exact (closure_minimal hsubset hclosed) hyclosure

/-- Cesàro averages of a fixed point converge to that point.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem tendsto_meanErgodicAverage_fixed {T : E →L[ℝ] E}
    {x : E} (hx : x ∈ meanErgodicFixedSubmodule T) :
    Tendsto (fun n ↦ meanErgodicAverage T n x) atTop (nhds x) := by
  apply tendsto_const_nhds.congr'
  filter_upwards [eventually_ne_atTop 0] with n hn
  exact (meanErgodicAverage_fixed hx hn).symm

/-- On the algebraic sum of the fixed space and the closed difference range, Cesàro averages
converge in norm to the fixed component.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem tendsto_meanErgodicAverage_add_fixed_differenceClosure
    {T : E →L[ℝ] E} {c : ℝ} (hc : 0 ≤ c) (hT : ∀ n : ℕ, ‖T ^ n‖ ≤ c)
    {x y : E} (hx : x ∈ meanErgodicFixedSubmodule T)
    (hy : y ∈ meanErgodicDifferenceClosure T) :
    Tendsto (fun n ↦ meanErgodicAverage T n (x + y)) atTop (nhds x) := by
  simpa only [map_add, add_zero] using
    (tendsto_meanErgodicAverage_fixed hx).add
      (tendsto_meanErgodicAverage_differenceClosure hc hT hy)

/-- The fixed-plus-difference sum lies in the norm-convergence domain.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem meanErgodic_sup_le_convergence [CompleteSpace E]
    {T : E →L[ℝ] E} {c : ℝ} (hc : 0 ≤ c) (hT : ∀ n : ℕ, ‖T ^ n‖ ≤ c) :
    meanErgodicFixedSubmodule T ⊔ meanErgodicDifferenceClosure T ≤
      meanErgodicConvergenceSubmodule T := by
  intro z hz
  obtain ⟨x, hx, y, hy, rfl⟩ := Submodule.mem_sup.mp hz
  exact ⟨x, tendsto_meanErgodicAverage_add_fixed_differenceClosure hc hT hx hy⟩

/-- Cesàro averages commute with the underlying operator.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem meanErgodicAverage_commute (T : E →L[ℝ] E) (n : ℕ) :
    (meanErgodicAverage T n).comp T = T.comp (meanErgodicAverage T n) := by
  apply ContinuousLinearMap.ext
  intro x
  change meanErgodicAverage T n (T x) = T (meanErgodicAverage T n x)
  simp only [meanErgodicAverage, smul_apply, sum_apply, map_smul, map_sum]
  congr 1
  apply Finset.sum_congr rfl
  intro k hk
  change ((T ^ k) * T) x = (T * (T ^ k)) x
  rw [← pow_succ, ← pow_succ']

/-- A functional annihilating `range (T - 1)` takes every nonzero Cesàro average of `x` to
`f x`.  This is the annihilator form of the elementary quotient-space observation used in Step 7.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem dual_annihilator_meanErgodicAverage {T : E →L[ℝ] E}
    {f : StrongDual ℝ E} (hf : f ∈ (dualOperator (T - 1)).ker)
    (x : E) {n : ℕ} (hn : n ≠ 0) :
    f (meanErgodicAverage T n x) = f x := by
  have hfix (u : E) : f (T u) = f u := by
    have hzero := congrArg (fun g : StrongDual ℝ E ↦ g u) hf
    exact sub_eq_zero.mp (by simpa [dualOperator_apply] using hzero)
  have hiter (k : ℕ) : f (T^[k] x) = f x := by
    induction k with
    | zero => simp
    | succ k ih =>
        rw [Function.iterate_succ_apply']
        exact (hfix _).trans ih
  simp only [meanErgodicAverage, smul_apply, sum_apply, map_smul, map_sum]
  simp [hiter, hn]

/-- If the Cesàro averages of `x` converge to `z`, then `z` is fixed by `T`.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem mem_fixed_of_tendsto_meanErgodicAverage {T : E →L[ℝ] E} {c : ℝ}
    (_hc : 0 ≤ c) (hT : ∀ n : ℕ, ‖T ^ n‖ ≤ c) {x z : E}
    (hz : Tendsto (fun n ↦ meanErgodicAverage T n x) atTop (nhds z)) :
    z ∈ meanErgodicFixedSubmodule T := by
  have htel := tendsto_birkhoffAverage_apply_sub_birkhoffAverage ℝ
    (isBounded_orbit_of_powerBounded hT x)
  have hzero : Tendsto
      (fun n ↦ T (meanErgodicAverage T n x) - meanErgodicAverage T n x)
      atTop (nhds 0) := by
    convert htel using 1
    ext n
    rw [← meanErgodicAverage_apply, ← meanErgodicAverage_apply]
    have hcomm := congrArg (fun A : E →L[ℝ] E ↦ A x) (meanErgodicAverage_commute T n)
    simpa [sub_eq_add_neg] using hcomm.symm
  have hlimit : Tendsto
      (fun n ↦ T (meanErgodicAverage T n x) - meanErgodicAverage T n x)
      atTop (nhds (T z - z)) := (T.continuous.continuousAt.tendsto.comp hz).sub hz
  have : T z - z = 0 := tendsto_nhds_unique hlimit hzero
  change T z = z
  exact sub_eq_zero.mp this

/-- If the Cesàro averages of `x` converge to `z`, then `x - z` lies in the closed difference
range.  The proof uses the existing annihilator characterization of topological range closure.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem sub_mem_differenceClosure_of_tendsto_meanErgodicAverage
    {T : E →L[ℝ] E} {x z : E}
    (hz : Tendsto (fun n ↦ meanErgodicAverage T n x) atTop (nhds z)) :
    x - z ∈ meanErgodicDifferenceClosure T := by
  rw [mem_range_topologicalClosure_iff_forall_dualOperator_ker]
  intro f hf
  have hfz : Tendsto (fun n ↦ f (meanErgodicAverage T n x)) atTop (nhds (f z)) :=
    f.continuous.continuousAt.tendsto.comp hz
  have hfx : Tendsto (fun n ↦ f (meanErgodicAverage T n x)) atTop (nhds (f x)) := by
    apply tendsto_const_nhds.congr'
    filter_upwards [eventually_ne_atTop 0] with n hn
    exact (dual_annihilator_meanErgodicAverage hf x hn).symm
  have : f z = f x := tendsto_nhds_unique hfz hfx
  simp [this]

/-- Norm convergence forces the vector into the fixed-plus-difference sum.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem meanErgodic_convergence_le_sup [CompleteSpace E]
    {T : E →L[ℝ] E} {c : ℝ} (hc : 0 ≤ c) (hT : ∀ n : ℕ, ‖T ^ n‖ ≤ c) :
    meanErgodicConvergenceSubmodule T ≤
      meanErgodicFixedSubmodule T ⊔ meanErgodicDifferenceClosure T := by
  intro x hx
  obtain ⟨z, hz⟩ := hx
  have hzfix : z ∈ meanErgodicFixedSubmodule T :=
    mem_fixed_of_tendsto_meanErgodicAverage hc hT hz
  have hdiff : x - z ∈ meanErgodicDifferenceClosure T :=
    sub_mem_differenceClosure_of_tendsto_meanErgodicAverage hz
  apply Submodule.mem_sup.mpr
  exact ⟨z, hzfix, x - z, hdiff, by abel⟩

/-- The norm-convergence domain is exactly the sum of the fixed-point space and the closed range
of `T - 1`.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem meanErgodicConvergenceSubmodule_eq_sup [CompleteSpace E]
    {T : E →L[ℝ] E} {c : ℝ} (hc : 0 ≤ c) (hT : ∀ n : ℕ, ‖T ^ n‖ ≤ c) :
    meanErgodicConvergenceSubmodule T =
      meanErgodicFixedSubmodule T ⊔ meanErgodicDifferenceClosure T :=
  le_antisymm (meanErgodic_convergence_le_sup hc hT)
    (meanErgodic_sup_le_convergence hc hT)

/-- The fixed space and the closed difference range intersect trivially, so the preceding sum is
direct.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem disjoint_meanErgodicFixed_differenceClosure
    {T : E →L[ℝ] E} {c : ℝ} (hc : 0 ≤ c) (hT : ∀ n : ℕ, ‖T ^ n‖ ≤ c) :
    Disjoint (meanErgodicFixedSubmodule T) (meanErgodicDifferenceClosure T) := by
  rw [Submodule.disjoint_def]
  intro x hxfix hxdiff
  have htoX := tendsto_meanErgodicAverage_fixed hxfix
  have hto0 := tendsto_meanErgodicAverage_differenceClosure hc hT hxdiff
  exact tendsto_nhds_unique htoX hto0

/-- A weakly convergent subsequence of Cesàro averages already forces membership in the
fixed-plus-difference sum.  This is the difficult implication in Step 7 of the textbook proof.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem mem_sup_of_meanErgodicAverage_weak_subsequence
    {T : E →L[ℝ] E} {c : ℝ} (_hc : 0 ≤ c) (hT : ∀ n : ℕ, ‖T ^ n‖ ≤ c)
    {x z : E} {φ : ℕ → ℕ} (hφ : StrictMono φ)
    (hweak : ∀ f : StrongDual ℝ E,
      Tendsto (fun n ↦ f (meanErgodicAverage T (φ n) x)) atTop (nhds (f z))) :
    x ∈ meanErgodicFixedSubmodule T ⊔ meanErgodicDifferenceClosure T := by
  have htel := tendsto_birkhoffAverage_apply_sub_birkhoffAverage ℝ
    (isBounded_orbit_of_powerBounded hT x)
  have hzero : Tendsto
      (fun n ↦ T (meanErgodicAverage T n x) - meanErgodicAverage T n x)
      atTop (nhds 0) := by
    convert htel using 1
    ext n
    rw [← meanErgodicAverage_apply, ← meanErgodicAverage_apply]
    have hcomm := congrArg (fun A : E →L[ℝ] E ↦ A x) (meanErgodicAverage_commute T n)
    simpa [sub_eq_add_neg] using hcomm.symm
  have hzfix : z ∈ meanErgodicFixedSubmodule T := by
    change T z = z
    apply sub_eq_zero.mp
    apply SeparatingDual.eq_zero_of_forall_dual_eq_zero (R := ℝ) (V := E)
    intro f
    have hlim : Tendsto
        (fun n ↦ f (T (meanErgodicAverage T (φ n) x) -
          meanErgodicAverage T (φ n) x)) atTop (nhds (f (T z - z))) := by
      simpa only [map_sub, dualOperator_apply] using
        (hweak (dualOperator T f)).sub (hweak f)
    have h0 : Tendsto
        (fun n ↦ f (T (meanErgodicAverage T (φ n) x) -
          meanErgodicAverage T (φ n) x)) atTop (nhds 0) := by
      simpa only [Function.comp_def, map_sub, map_zero] using
        (f.continuous.continuousAt.tendsto.comp (hzero.comp hφ.tendsto_atTop))
    exact tendsto_nhds_unique hlim h0
  have hdiff : x - z ∈ meanErgodicDifferenceClosure T := by
    rw [mem_range_topologicalClosure_iff_forall_dualOperator_ker]
    intro f hf
    have hconst : Tendsto (fun n ↦ f (meanErgodicAverage T (φ n) x))
        atTop (nhds (f x)) := by
      apply tendsto_const_nhds.congr'
      filter_upwards [hφ.tendsto_atTop.eventually (eventually_ne_atTop 0)] with n hn
      exact (dual_annihilator_meanErgodicAverage hf x hn).symm
    have : f z = f x := tendsto_nhds_unique (hweak f) hconst
    simp [this]
  exact Submodule.mem_sup.mpr ⟨z, hzfix, x - z, hdiff, by abel⟩

/-- Bühler--Salamon Theorem 3.6.9(i): the Cesàro averages converge in norm exactly when they have a
weakly convergent subsequence, expressed pointwise on every continuous linear functional.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem mem_meanErgodicConvergenceSubmodule_iff_weak_subsequence [CompleteSpace E]
    {T : E →L[ℝ] E} {c : ℝ} (hc : 0 ≤ c) (hT : ∀ n : ℕ, ‖T ^ n‖ ≤ c) (x : E) :
    x ∈ meanErgodicConvergenceSubmodule T ↔
      ∃ z : E, ∃ φ : ℕ → ℕ, StrictMono φ ∧
        ∀ f : StrongDual ℝ E,
          Tendsto (fun n ↦ f (meanErgodicAverage T (φ n) x)) atTop (nhds (f z)) := by
  constructor
  · rintro ⟨z, hz⟩
    refine ⟨z, _root_.id, strictMono_id, ?_⟩
    intro f
    simpa only [Function.comp_def, id_eq] using f.continuous.continuousAt.tendsto.comp hz
  · rintro ⟨z, φ, hφ, hweak⟩
    apply meanErgodic_sup_le_convergence hc hT
    exact mem_sup_of_meanErgodicAverage_weak_subsequence hc hT hφ hweak

/-- Step 3's quantitative estimate for the fixed component of a decomposition. -/
theorem norm_fixed_le_norm_add_differenceClosure
    {T : E →L[ℝ] E} {c : ℝ} (hc : 0 ≤ c) (hT : ∀ n : ℕ, ‖T ^ n‖ ≤ c)
    {x y : E} (hx : x ∈ meanErgodicFixedSubmodule T)
    (hy : y ∈ meanErgodicDifferenceClosure T) :
    ‖x‖ ≤ c * ‖x + y‖ := by
  have hlim := (tendsto_meanErgodicAverage_add_fixed_differenceClosure hc hT hx hy).norm
  apply le_of_tendsto hlim
  exact Filter.Eventually.of_forall fun n ↦
    (ContinuousLinearMap.le_opNorm (meanErgodicAverage T n) (x + y)).trans
      (mul_le_mul_of_nonneg_right (norm_meanErgodicAverage_le hc hT n)
        (norm_nonneg (x + y)))

private noncomputable def meanErgodicAddMap (T : E →L[ℝ] E) :
    (meanErgodicFixedSubmodule T × meanErgodicDifferenceClosure T) →L[ℝ] E :=
  ((meanErgodicFixedSubmodule T).subtypeL.comp
      (ContinuousLinearMap.fst ℝ _ _)) +
    ((meanErgodicDifferenceClosure T).subtypeL.comp
      (ContinuousLinearMap.snd ℝ _ _))

private theorem meanErgodicAddMap_apply (T : E →L[ℝ] E)
    (p : meanErgodicFixedSubmodule T × meanErgodicDifferenceClosure T) :
    meanErgodicAddMap T p = (p.1 : E) + (p.2 : E) := by
  simp [meanErgodicAddMap]

private theorem meanErgodicAddMap_antilipschitz
    {T : E →L[ℝ] E} {c : ℝ} (hc : 0 ≤ c) (hT : ∀ n : ℕ, ‖T ^ n‖ ≤ c) :
    ∃ K, AntilipschitzWith K (meanErgodicAddMap T) := by
  rw [antilipschitzWith_iff_exists_mul_le_norm]
  refine ⟨(c + 1)⁻¹, by positivity, ?_⟩
  intro p
  have hx : ‖(p.1 : E)‖ ≤ c * ‖(p.1 : E) + (p.2 : E)‖ :=
    norm_fixed_le_norm_add_differenceClosure hc hT p.1.property p.2.property
  have hy : ‖(p.2 : E)‖ ≤ (c + 1) * ‖(p.1 : E) + (p.2 : E)‖ := by
    calc
      ‖(p.2 : E)‖ = ‖((p.1 : E) + (p.2 : E)) - (p.1 : E)‖ := by
        congr 1
        abel
      _ ≤ ‖(p.1 : E) + (p.2 : E)‖ + ‖(p.1 : E)‖ := norm_sub_le _ _
      _ ≤ ‖(p.1 : E) + (p.2 : E)‖ + c * ‖(p.1 : E) + (p.2 : E)‖ :=
        add_le_add_right hx _
      _ = (c + 1) * ‖(p.1 : E) + (p.2 : E)‖ := by ring
  have hp : ‖p‖ ≤ (c + 1) * ‖meanErgodicAddMap T p‖ := by
    rw [Prod.norm_def, meanErgodicAddMap_apply]
    exact max_le
      (hx.trans <| mul_le_mul_of_nonneg_right (by linarith) (norm_nonneg _)) hy
  calc
    (c + 1)⁻¹ * ‖p‖ ≤ (c + 1)⁻¹ * ((c + 1) * ‖meanErgodicAddMap T p‖) :=
      mul_le_mul_of_nonneg_left hp (inv_nonneg.mpr (by positivity))
    _ = ‖meanErgodicAddMap T p‖ := by field_simp

private theorem range_meanErgodicAddMap (T : E →L[ℝ] E) :
    Set.range (meanErgodicAddMap T) =
      (meanErgodicFixedSubmodule T ⊔ meanErgodicDifferenceClosure T : Submodule ℝ E) := by
  ext z
  constructor
  · rintro ⟨p, rfl⟩
    rw [meanErgodicAddMap_apply]
    exact Submodule.add_mem_sup p.1.property p.2.property
  · intro hz
    obtain ⟨x, hx, y, hy, hxy⟩ := Submodule.mem_sup.mp hz
    refine ⟨(⟨x, hx⟩, ⟨y, hy⟩), ?_⟩
    simpa [meanErgodicAddMap_apply] using hxy

set_option linter.style.haveILetI false in
/-- The convergence domain in Theorem 3.6.9 is closed. -/
theorem isClosed_meanErgodicConvergenceSubmodule [CompleteSpace E]
    {T : E →L[ℝ] E} {c : ℝ} (hc : 0 ≤ c) (hT : ∀ n : ℕ, ‖T ^ n‖ ≤ c) :
    IsClosed (meanErgodicConvergenceSubmodule T : Set E) := by
  let _ : IsClosed (meanErgodicFixedSubmodule T : Set E) :=
    ContinuousLinearMap.isClosed_eqLocus T 1
  letI : CompleteSpace (meanErgodicFixedSubmodule T) := IsClosed.completeSpace_coe
  let _ : IsClosed (meanErgodicDifferenceClosure T : Set E) :=
    Submodule.isClosed_topologicalClosure (T - 1).range
  letI : CompleteSpace (meanErgodicDifferenceClosure T) := IsClosed.completeSpace_coe
  obtain ⟨K, hK⟩ := meanErgodicAddMap_antilipschitz hc hT
  have hrange : IsClosed (Set.range (meanErgodicAddMap T)) :=
    hK.isClosed_range (meanErgodicAddMap T).uniformContinuous
  rw [range_meanErgodicAddMap T, ← meanErgodicConvergenceSubmodule_eq_sup hc hT] at hrange
  exact hrange

/-- The convergence domain is invariant under the power-bounded operator.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem map_mem_meanErgodicConvergenceSubmodule [CompleteSpace E]
    {T : E →L[ℝ] E} {x : E} (hx : x ∈ meanErgodicConvergenceSubmodule T) :
    T x ∈ meanErgodicConvergenceSubmodule T := by
  obtain ⟨z, hz⟩ := hx
  refine ⟨T z, ?_⟩
  have hTz : Tendsto (fun n ↦ T (meanErgodicAverage T n x)) atTop (nhds (T z)) :=
    T.continuous.continuousAt.tendsto.comp hz
  convert hTz using 1
  ext n
  exact congrArg (fun A : E →L[ℝ] E ↦ A x) (meanErgodicAverage_commute T n)

/-- The first-batch mean ergodic decomposition, with the textbook power-boundedness premise:
the norm-convergence domain is a closed invariant subspace, is the direct sum of the fixed space
and the closed difference range, and these summands intersect trivially.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem meanErgodic_decomposition_of_powerBounded [CompleteSpace E]
    {T : E →L[ℝ] E} (hT : IsPowerBounded T) :
    meanErgodicConvergenceSubmodule T =
        meanErgodicFixedSubmodule T ⊔ meanErgodicDifferenceClosure T ∧
      Disjoint (meanErgodicFixedSubmodule T) (meanErgodicDifferenceClosure T) ∧
      IsClosed (meanErgodicConvergenceSubmodule T : Set E) := by
  obtain ⟨c, hc1, hc⟩ := hT
  have hc0 : 0 ≤ c := zero_le_one.trans hc1
  exact ⟨meanErgodicConvergenceSubmodule_eq_sup hc0 hc,
    disjoint_meanErgodicFixed_differenceClosure hc0 hc,
    isClosed_meanErgodicConvergenceSubmodule hc0 hc⟩

/-- The weak-subsequence criterion with the textbook power-boundedness premise.

> **Entry**: functional-analysis.ergodic.mean
-/
theorem mem_meanErgodicConvergenceSubmodule_iff_weak_subsequence_of_powerBounded
    [CompleteSpace E] {T : E →L[ℝ] E} (hT : IsPowerBounded T) (x : E) :
    x ∈ meanErgodicConvergenceSubmodule T ↔
      ∃ z : E, ∃ φ : ℕ → ℕ, StrictMono φ ∧
        ∀ f : StrongDual ℝ E,
          Tendsto (fun n ↦ f (meanErgodicAverage T (φ n) x)) atTop (nhds (f z)) := by
  obtain ⟨c, hc1, hc⟩ := hT
  exact mem_meanErgodicConvergenceSubmodule_iff_weak_subsequence
    (zero_le_one.trans hc1) hc x

end

end SandronesLibrary.FunctionalAnalysis
