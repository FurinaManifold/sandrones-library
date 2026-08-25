/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Topology.NormedSpace
import Mathlib.Analysis.Normed.Operator.ContinuousLinearMap
import Mathlib.Analysis.Normed.Group.Hom

/-!
# Bounded linear operators

A linear operator between normed spaces is bounded when one constant controls the norm of every
output by the norm of its input.  This textbook predicate is the public starting point;
Mathlib's bundled `ContinuousLinearMap` is connected by explicit construction and equivalence
theorems.
-/

namespace SandronesLibrary.FunctionalAnalysis

open SandronesLibrary.Topology.NormedSpace

variable {E F G : Type*}
variable [NormedAddCommGroup E] [NormedAddCommGroup F] [NormedAddCommGroup G]
variable [NormedLinearSpace ℝ E] [NormedLinearSpace ℝ F] [NormedLinearSpace ℝ G]

/-- A linear map is bounded when some nonnegative constant `C` satisfies
`‖T x‖ ≤ C ‖x‖` for every vector `x`.

> **Entry**: functional-analysis.operator.continuous-linear-map -/
def IsBoundedLinearOperator (T : E →ₗ[ℝ] F) : Prop :=
  ∃ C : ℝ, 0 ≤ C ∧ ∀ x : E, ‖T x‖ ≤ C * ‖x‖

/-- The zero linear operator is bounded, directly from the textbook definition. -/
theorem isBoundedLinearOperator_zero :
    IsBoundedLinearOperator (0 : E →ₗ[ℝ] F) := by
  refine ⟨0, le_rfl, ?_⟩
  intro x
  simp

/-- Package a textbook-bounded linear operator as Mathlib's continuous linear map. -/
noncomputable def toContinuousLinearMap (T : E →ₗ[ℝ] F) (hT : IsBoundedLinearOperator T) :
    E →L[ℝ] F := by
  choose C hC hbound using hT
  exact T.mkContinuous C hbound

/-- Forgetting the bridge construction returns the original linear map. -/
@[simp]
theorem toContinuousLinearMap_toLinearMap (T : E →ₗ[ℝ] F)
    (hT : IsBoundedLinearOperator T) :
    (toContinuousLinearMap T hT).toLinearMap = T := by
  rfl

/-- Textbook boundedness is exactly the existence of a bundled continuous linear map with the
same underlying linear map. -/
theorem isBoundedLinearOperator_iff_exists_continuousLinearMap (T : E →ₗ[ℝ] F) :
    IsBoundedLinearOperator T ↔ ∃ L : E →L[ℝ] F, L.toLinearMap = T := by
  constructor
  · intro hT
    exact ⟨toContinuousLinearMap T hT, toContinuousLinearMap_toLinearMap T hT⟩
  · rintro ⟨L, rfl⟩
    exact ⟨‖L‖, norm_nonneg L, L.le_opNorm⟩

/-- A textbook-bounded linear map is continuous.

> **Entry**: functional-analysis.operator.bounded-iff -/
theorem continuous_of_isBoundedLinearOperator {T : E →ₗ[ℝ] F}
    (hT : IsBoundedLinearOperator T) : Continuous T := by
  rcases hT with ⟨C, -, hbound⟩
  change Continuous (fun x ↦ T x)
  exact (T.mkContinuous C hbound).continuous

/-- A continuous linear map satisfies a global norm bound. -/
theorem isBoundedLinearOperator_of_continuous {T : E →ₗ[ℝ] F} (hT : Continuous T) :
    IsBoundedLinearOperator T := by
  let L : E →L[ℝ] F := ⟨T, hT⟩
  exact ⟨‖L‖, norm_nonneg L, fun x ↦ by simpa [L] using L.le_opNorm x⟩

/-- For linear maps between real normed spaces, global norm boundedness and continuity are
equivalent. -/
theorem isBoundedLinearOperator_iff_continuous (T : E →ₗ[ℝ] F) :
    IsBoundedLinearOperator T ↔ Continuous T :=
  ⟨continuous_of_isBoundedLinearOperator, isBoundedLinearOperator_of_continuous⟩

end SandronesLibrary.FunctionalAnalysis
