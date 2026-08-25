/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Topology.NormedSpace
import Mathlib.Analysis.Normed.Group.Quotient

/-!
# Quotients by closed subspaces

A linear subspace is represented directly by `Submodule`, and closedness by `IsClosed` on its
carrier.  Mathlib's module quotient and quotient norm have the textbook semantics, so this file
only records the distance formula, the role of closedness, and Banach completeness.
-/

namespace SandronesLibrary.FunctionalAnalysis

open SandronesLibrary.Topology.NormedSpace

variable {E : Type*} [NormedAddCommGroup E] [NormedLinearSpace ℝ E]

/-- The quotient norm of the coset of `x` is the distance from `x` to the subspace.

This is the textbook formula `‖x + S‖ = inf {‖x - s‖ | s ∈ S}` expressed by Mathlib's
`Metric.infDist`.

> **Entry**: functional-analysis.subspace.quotient
-/
theorem quotientNorm_eq_infDist (S : Submodule ℝ E) (x : E) :
    ‖(Submodule.Quotient.mk x : E ⧸ S)‖ = Metric.infDist x S := by
  exact QuotientAddGroup.norm_mk x

/-- Without assuming closedness, quotient norm zero means membership in the closure. -/
theorem quotientNorm_eq_zero_iff_mem_closure (S : Submodule ℝ E) (x : E) :
    ‖(Submodule.Quotient.mk x : E ⧸ S)‖ = 0 ↔ x ∈ closure (S : Set E) := by
  exact QuotientAddGroup.norm_mk_eq_zero_iff_mem_closure

/-- For a closed subspace, quotient norm zero detects exactly the zero coset. -/
theorem quotientNorm_eq_zero_iff_mem (S : Submodule ℝ E) (hS : IsClosed (S : Set E))
    (x : E) : ‖(Submodule.Quotient.mk x : E ⧸ S)‖ = 0 ↔ x ∈ S := by
  let _ : IsClosed (S : Set E) := hS
  exact QuotientAddGroup.norm_mk_eq_zero

/-- The canonical quotient map does not increase norm. -/
theorem quotientMap_norm_le (S : Submodule ℝ E) (x : E) :
    ‖(Submodule.Quotient.mk x : E ⧸ S)‖ ≤ ‖x‖ := by
  exact Submodule.Quotient.norm_mk_le S x

/-- Quotienting a Banach space by a closed linear subspace gives a complete quotient space. -/
theorem closedSubspace_quotient_complete (S : Submodule ℝ E) (hS : IsClosed (S : Set E))
    [BanachSpace E] : CompleteSpace (E ⧸ S) := by
  let _ : IsClosed (S : Set E) := hS
  infer_instance

end SandronesLibrary.FunctionalAnalysis
