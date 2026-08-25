/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.FunctionalAnalysis.Operator
import Mathlib.Analysis.Normed.Operator.Banach

/-!
# Operator norm and completeness

The norm already carried by `ContinuousLinearMap` is exactly the textbook operator norm.  This
file records its global estimate, least-bound characterization, and the completeness of the
operator space when the codomain is Banach.
-/

namespace SandronesLibrary.FunctionalAnalysis

open SandronesLibrary.Topology.NormedSpace

variable {E F : Type*}
variable [NormedAddCommGroup E] [NormedAddCommGroup F]
variable [NormedLinearSpace ℝ E] [NormedLinearSpace ℝ F]

/-- The operator norm is nonnegative.

> **Entry**: functional-analysis.operator.space -/
theorem operatorNorm_nonneg (T : E →L[ℝ] F) : 0 ≤ ‖T‖ := by
  exact norm_nonneg T

/-- The operator norm globally controls the norm of every output. -/
theorem norm_apply_le_operatorNorm (T : E →L[ℝ] F) (x : E) :
    ‖T x‖ ≤ ‖T‖ * ‖x‖ := by
  exact T.le_opNorm x

/-- The operator norm is no larger than any nonnegative global bound. -/
theorem operatorNorm_le_of_bound (T : E →L[ℝ] F) {C : ℝ} (hC : 0 ≤ C)
    (hbound : ∀ x : E, ‖T x‖ ≤ C * ‖x‖) : ‖T‖ ≤ C := by
  exact T.opNorm_le_bound hC hbound

/-- Least-bound characterization of the operator norm: it is itself a global bound and is no
larger than every other nonnegative global bound. -/
theorem operatorNorm_is_least_bound (T : E →L[ℝ] F) :
    (∀ x : E, ‖T x‖ ≤ ‖T‖ * ‖x‖) ∧
      ∀ C : ℝ, 0 ≤ C → (∀ x : E, ‖T x‖ ≤ C * ‖x‖) → ‖T‖ ≤ C := by
  exact ⟨norm_apply_le_operatorNorm T, fun _ hC hbound ↦
    operatorNorm_le_of_bound T hC hbound⟩

/-- If the codomain is Banach, the space of continuous linear operators is complete. -/
theorem continuousLinearMap_complete [BanachSpace F] : CompleteSpace (E →L[ℝ] F) := by
  infer_instance

end SandronesLibrary.FunctionalAnalysis
