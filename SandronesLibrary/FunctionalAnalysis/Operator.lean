/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Topology.NormedSpace
import Mathlib.Analysis.Normed.Operator.ContinuousLinearMap
import Mathlib.Analysis.Normed.Group.Hom

/-!
# Continuous linear operators

Mathlib's `ContinuousLinearMap` has exactly the textbook data: a linear map together with
continuity.  It is therefore the public carrier rather than the target of a duplicate wrapper.
This file explains that carrier through the global norm bound characterization used in functional
analysis.
-/

namespace SandronesLibrary.FunctionalAnalysis

open SandronesLibrary.Topology.NormedSpace

variable {E F : Type*}
variable [NormedAddCommGroup E] [NormedAddCommGroup F]
variable [NormedLinearSpace ℝ E] [NormedLinearSpace ℝ F]

/-- Every continuous linear operator admits a nonnegative global norm bound.

This is the textbook boundedness property of the formal carrier `E →L[ℝ] F`.

> **Entry**: functional-analysis.operator.continuous-linear-map -/
theorem continuousLinearMap_exists_bound (T : E →L[ℝ] F) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ x : E, ‖T x‖ ≤ C * ‖x‖ := by
  exact ⟨‖T‖, norm_nonneg T, T.le_opNorm⟩

/-- The underlying function of a continuous linear operator is continuous. -/
theorem continuousLinearMap_continuous (T : E →L[ℝ] F) : Continuous T := by
  exact T.continuous

/-- The zero continuous linear operator has global bound zero, directly illustrating the carrier. -/
theorem continuousLinearMap_zero_bound :
    ∀ x : E, ‖(0 : E →L[ℝ] F) x‖ ≤ 0 * ‖x‖ := by
  intro x
  simp

/-- A linear map between real normed spaces is continuous exactly when it admits a nonnegative
global norm bound.

> **Entry**: functional-analysis.operator.bounded-iff -/
theorem linearMap_continuous_iff_exists_bound (T : E →ₗ[ℝ] F) :
    Continuous T ↔ ∃ C : ℝ, 0 ≤ C ∧ ∀ x : E, ‖T x‖ ≤ C * ‖x‖ := by
  constructor
  · intro hT
    let L : E →L[ℝ] F := ⟨T, hT⟩
    exact ⟨‖L‖, norm_nonneg L, fun x ↦ by simpa [L] using L.le_opNorm x⟩
  · rintro ⟨C, -, hbound⟩
    change Continuous (fun x ↦ T x)
    exact (T.mkContinuous C hbound).continuous

end SandronesLibrary.FunctionalAnalysis
