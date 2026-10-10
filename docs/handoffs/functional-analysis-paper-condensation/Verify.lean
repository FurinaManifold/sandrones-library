import SandronesLibrary.FunctionalAnalysis.Condensation
import SandronesLibrary.FunctionalAnalysis.CondensationDivergence
import Mathlib.Tactic.NormNum

open Set Filter
open scoped Topology
open SandronesLibrary.FunctionalAnalysis
open SandronesLibrary.Topology.NormedSpace

-- Formal carrier, textbook characterizations, and upper consumers in one environment.
#check ContinuousLinearMap
#check BanachSpace
#check Metric.dense_iff
#check IsGδ.iInter_of_isOpen
#check Metric.cauchySeq_iff
#check cauchySeq_tendsto_of_complete
#check unbounded_on_tail_of_unbounded
#check isOpen_norm_exceeds_set
#check dense_norm_exceeds_set_of_unbounded
#check condensation_dense_Gδ
#check condensation_exists
#check condensation_of_unbounded_operatorNorm
#check isClosed_cauchy_points_of_operatorNorm_bound
#check dense_open_nonCauchy_points_of_operatorNorm_bound
#check exists_dense_Gδ_nonCauchy_points
#check condensation_divergence_dense
#check condensation_divergence_exists
#check condensation_nonconvergence_exists

namespace PaperReproductionChecks

noncomputable def growingOperator (q : ℕ) : ℝ →L[ℝ] ℝ :=
  ((q : ℝ) + 1) • ContinuousLinearMap.id ℝ ℝ

theorem growing_family_common_unbounded_point :
    ∃ x : ℝ, ∀ _p : ℕ, ∀ C : ℝ, ∀ N : ℕ,
      ∃ q, N ≤ q ∧ C < ‖growingOperator q x‖ := by
  apply condensation_exists (g := fun _ : ℕ => growingOperator)
  intro _p
  refine ⟨1, ?_⟩
  intro C
  obtain ⟨q, hq⟩ := exists_nat_gt C
  refine ⟨q, ?_⟩
  have hnorm : ‖growingOperator q 1‖ = (q : ℝ) + 1 := by
    simp [growingOperator, Real.norm_eq_abs,
      abs_of_nonneg (by positivity : 0 ≤ (q : ℝ) + 1)]
  rw [hnorm]
  linarith

noncomputable def alternatingOperator (q : ℕ) : ℝ →L[ℝ] ℝ :=
  (if q % 2 = 0 then (1 : ℝ) else -1) • ContinuousLinearMap.id ℝ ℝ

theorem alternating_at_one_not_cauchy :
    ¬ CauchySeq (fun q => alternatingOperator q 1) := by
  intro hc
  obtain ⟨N, hN⟩ := Metric.cauchySeq_iff.mp hc 1 (by norm_num)
  have hclose := hN (2 * N) (by omega) (2 * N + 1) (by omega)
  norm_num [alternatingOperator, Nat.add_mod, Nat.mul_mod, dist_eq_norm] at hclose

-- This family is uniformly norm-bounded, so it exercises the branch distinct from Theorem I.
example : Dense {x : ℝ | ¬ CauchySeq (fun q => alternatingOperator q x)} ∧
    IsOpen {x : ℝ | ¬ CauchySeq (fun q => alternatingOperator q x)} := by
  apply dense_open_nonCauchy_points_of_operatorNorm_bound (C := 1) (by norm_num)
  · intro q
    by_cases hq : q % 2 = 0 <;> simp [alternatingOperator, hq, norm_smul]
  · exact ⟨1, alternating_at_one_not_cauchy⟩

theorem alternating_family_common_nonconvergence_point :
    ∃ x : ℝ, ∀ _p : ℕ,
      ¬ ∃ y : ℝ, Tendsto (fun q => alternatingOperator q x) atTop (𝓝 y) := by
  apply condensation_nonconvergence_exists (g := fun _ : ℕ => alternatingOperator)
  intro _p
  refine ⟨1, ?_⟩
  rintro ⟨y, hy⟩
  exact alternating_at_one_not_cauchy hy.cauchySeq

end PaperReproductionChecks
