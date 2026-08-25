/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.ComplexAnalysis.HomotopyInvariance

/-!
# Constructing a primitive from path-integral independence

This file isolates the analytic construction in the standard simply-connected-domain argument.
Once admissible path integrals depend only on their endpoints, integration from a fixed base point
produces a primitive.  Proving the required independence from topological simple connectedness is a
separate remaining bridge.

Current entry:

* `complex-analysis.cauchy.primitive-from-path-independence-foundation`.
-/

open Set Metric MeasureTheory AffineMap Filter Function
open scoped Interval unitInterval Topology

namespace SandronesLibrary.ComplexAnalysis

noncomputable section

/-- An admissible path stays in `U` and the scalar one-form `f(z) dz` is integrable along it.

> **Entry**: complex-analysis.cauchy.primitive-from-path-independence-foundation -/
def AdmissiblePath {a b : ℂ} (f : ℂ → ℂ) (U : Set ℂ) (gamma : Path a b) : Prop :=
  range gamma ⊆ U ∧ PathIntegrable f gamma

/-- Path integrals are endpoint-independent on `U` if any two admissible paths with the same
endpoints have equal integrals.

> **Entry**: complex-analysis.cauchy.primitive-from-path-independence-foundation -/
def PathIntegralIndependentOn (f : ℂ → ℂ) (U : Set ℂ) : Prop :=
  ∀ {a b : ℂ} (gamma delta : Path a b),
    AdmissiblePath f U gamma → AdmissiblePath f U delta →
      pathIntegral f gamma = pathIntegral f delta

/-- If every point can be reached from a fixed base point by an admissible path and admissible path
integrals depend only on endpoints, then integration from the base point defines a primitive of `f`
on `U`.

This is the analytic construction needed for the simply-connected-domain theorem.  The hypotheses
deliberately state the remaining global path problem instead of assuming a primitive in disguise.

> **Entry**: complex-analysis.cauchy.primitive-from-path-independence-foundation -/
theorem exists_primitive_of_pathIntegralIndependentOn
    {f : ℂ → ℂ} {U : Set ℂ} {c : ℂ}
    (hU : IsOpen U) (hf : HolomorphicOnTextbook f U)
    (hpaths : ∀ z ∈ U, ∃ gamma : Path c z, AdmissiblePath f U gamma)
    (hind : PathIntegralIndependentOn f U) :
    ∃ g : ℂ → ℂ, ∀ z ∈ U, HasDerivAt g (f z) z := by
  classical
  let P : ∀ z : U, {gamma : Path c z.1 // AdmissiblePath f U gamma} := fun z ↦
    ⟨Classical.choose (hpaths z z.property), Classical.choose_spec (hpaths z z.property)⟩
  let g : ℂ → ℂ := fun z ↦ if hz : z ∈ U then pathIntegral f (P ⟨z, hz⟩).1 else 0
  refine ⟨g, fun z hz ↦ ?_⟩
  obtain ⟨r, hr, hball⟩ := Metric.isOpen_iff.mp hU z hz
  have hdiff : DifferentiableOn ℂ f U :=
    (holomorphicOnTextbook_iff_differentiableOn hU).mp hf
  have hωball : ContinuousOn (scalarOneForm f) (ball z r) := by
    exact (ContinuousLinearMap.smulRightL ℂ ℂ ℂ
      (1 : ℂ →L[ℂ] ℂ)).continuous.comp_continuousOn (hdiff.continuousOn.mono hball)
  have hsegDeriv : HasDerivAt (fun w ↦ pathIntegral f (.segment z w)) (f z) z := by
    have hF := HasFDerivWithinAt.curveIntegral_segment_source
      (𝕜 := ℂ) (convex_ball z r) hωball (mem_ball_self hr)
    have hFA := hF.hasFDerivAt (isOpen_ball.mem_nhds (mem_ball_self hr))
    simpa [pathIntegral, scalarOneForm] using hFA.hasDerivAt
  have heq : g =ᶠ[nhds z] fun w ↦ g z + pathIntegral f (.segment z w) := by
    filter_upwards [Metric.ball_mem_nhds z hr] with w hw
    have hwU : w ∈ U := hball hw
    have hsegRange : range (Path.segment z w) ⊆ U := by
      rintro q ⟨t, rfl⟩
      exact hball ((convex_ball z r).lineMap_mem (mem_ball_self hr) hw t.2)
    have hsegInt : PathIntegrable f (.segment z w) := by
      rw [PathIntegrable, curveIntegrable_segment]
      have hline : MapsTo (lineMap z w) (Icc (0 : ℝ) 1) (ball z r) :=
        fun _ ht ↦ (convex_ball z r).lineMap_mem (mem_ball_self hr) hw ht
      have hcont : ContinuousOn (fun t : ℝ ↦ (w - z) * f (lineMap z w t)) (Icc 0 1) := by
        simpa [Function.comp_def] using
          ((hdiff.continuousOn.mono hball).comp lineMap_continuous.continuousOn hline).const_mul
            (w - z)
      have hi : IntervalIntegrable (fun t : ℝ ↦ (w - z) * f (lineMap z w t)) volume 0 1 :=
        (show ContinuousOn (fun t : ℝ ↦ (w - z) * f (lineMap z w t)) [[0, 1]] by
          simpa [uIcc_of_le zero_le_one] using hcont).intervalIntegrable
      simpa [scalarOneForm] using hi
    have hPz := (P ⟨z, hz⟩).property
    have hPw := (P ⟨w, hwU⟩).property
    have htrans : AdmissiblePath f U ((P ⟨z, hz⟩).1.trans (.segment z w)) := by
      constructor
      · rw [Path.trans_range]
        exact union_subset hPz.1 hsegRange
      · exact hPz.2.trans hsegInt
    have hi := hind (P ⟨w, hwU⟩).1 ((P ⟨z, hz⟩).1.trans (.segment z w)) hPw htrans
    rw [pathIntegral_trans f _ _ hPz.2 hsegInt] at hi
    simpa [g, hz, hwU] using hi
  exact (hsegDeriv.const_add (g z)).congr_of_eventuallyEq heq

end

end SandronesLibrary.ComplexAnalysis
