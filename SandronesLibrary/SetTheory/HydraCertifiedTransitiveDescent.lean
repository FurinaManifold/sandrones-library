/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.SetTheory.HydraCertifiedStepWellFounded

/-!
# Finite certified hydra trajectories and transitive descent

Zero steps mean equality.  A positive exact step count gives strict ordinal
descent, and existentially quantifying a positive count yields the nonempty
transitive closure.  This closure inherits well-foundedness from certified
one-step predecessors.
-/

namespace SandronesLibrary.SetTheory.HydraCertifiedTransitiveDescent

open SandronesLibrary.SetTheory
open SandronesLibrary.SetTheory.HydraOrdinalAssignment
open SandronesLibrary.SetTheory.HydraCertifiedPlayTermination
open SandronesLibrary.SetTheory.HydraCertifiedStepWellFounded

/-- `CertifiedExactSteps n before after` means that exactly `n` certified
forward transitions lead from `before` to `after`. -/
def CertifiedExactSteps : Nat → Hydra → Hydra → Prop
  | 0, before, after => before = after
  | n + 1, before, after =>
      ∃ middle, CertifiedStep before middle ∧ CertifiedExactSteps n middle after

/-- The nonempty finite transitive closure of `CertifiedStep`. -/
def CertifiedTransitiveStep (before after : Hydra) : Prop :=
  ∃ n, CertifiedExactSteps (n + 1) before after

/-- The same nonempty closure in the predecessor orientation expected by
`WellFounded`. -/
def CertifiedTransitivePredecessor (after before : Hydra) : Prop :=
  CertifiedTransitiveStep before after

/-- A zero-step trajectory has equal endpoints, and endpoint equality always
gives the zero-step trajectory. -/
theorem certifiedExactSteps_zero_iff {before after : Hydra} :
    CertifiedExactSteps 0 before after ↔ before = after := by
  rfl

/-- Every finite trajectory containing at least one certified step has a
strictly smaller ordinal at its endpoint. -/
theorem certifiedExactSteps_succ_decreases {n : Nat} {before after : Hydra}
    (steps : CertifiedExactSteps (n + 1) before after) :
    hydraOrdinal.{0} after < hydraOrdinal.{0} before := by
  induction n generalizing before with
  | zero =>
      rcases steps with ⟨middle, first, rfl⟩
      exact certifiedStep_decreases first
  | succ n ih =>
      rcases steps with ⟨middle, first, remaining⟩
      exact (ih remaining).trans (certifiedStep_decreases first)

/-- Every predecessor in the library's nonempty finite closure belongs to the
standard transitive closure of the one-step predecessor relation. -/
theorem certifiedTransitivePredecessor_to_transGen {after before : Hydra}
    (steps : CertifiedTransitivePredecessor after before) :
    Relation.TransGen CertifiedPredecessor after before := by
  rcases steps with ⟨n, steps⟩
  induction n generalizing before with
  | zero =>
      rcases steps with ⟨middle, first, rfl⟩
      exact Relation.TransGen.single first
  | succ n ih =>
      rcases steps with ⟨middle, first, remaining⟩
      exact (ih remaining).tail first

/-- The nonempty finite certified predecessor relation is well-founded. -/
theorem certifiedTransitivePredecessor_wellFounded :
    WellFounded CertifiedTransitivePredecessor := by
  apply certifiedPredecessor_wellFounded.transGen.mono
  intro after before steps
  exact certifiedTransitivePredecessor_to_transGen steps

/--
> **Entry**: settheory.googology.hydra-certified-transitive-descent
> **一句话**: 零个认证步骤只保持端点相等，任意非空有限认证轨迹都严格降低结构序数，其非空传递闭包仍为良基关系。
> **依赖**: `settheory.googology.hydra-certified-step-well-founded`
> **mathlib**: `Relation.TransGen`、`WellFounded.transGen`

This induction ranges over nonempty finite certified reachability only.
-/
theorem certifiedTransitiveStep_induction {P : Hydra → Prop}
    (step : ∀ before,
      (∀ after, CertifiedTransitiveStep before after → P after) → P before) :
    ∀ before, P before := by
  intro before
  apply certifiedTransitivePredecessor_wellFounded.induction before
  intro current ih
  apply step current
  intro after steps
  exact ih after steps

end SandronesLibrary.SetTheory.HydraCertifiedTransitiveDescent
