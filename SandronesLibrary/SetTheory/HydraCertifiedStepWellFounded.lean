/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.SetTheory.HydraCertifiedPlayTermination

/-!
# Well-founded induction for certified hydra steps

The forward game relation is reversed into the predecessor orientation expected
by `WellFounded`.  Pulling ordinal well-foundedness back along `hydraOrdinal`
then yields public `WellFounded`, `Acc`, and induction interfaces for certified
successors only.
-/

namespace SandronesLibrary.SetTheory.HydraCertifiedStepWellFounded

open SandronesLibrary.SetTheory
open SandronesLibrary.SetTheory.Ordinal
open SandronesLibrary.SetTheory.HydraOrdinalAssignment
open SandronesLibrary.SetTheory.HydraCertifiedPlayTermination

/-- The predecessor-oriented relation used by `WellFounded`: `after` is below
`before` exactly when the game has a certified forward step from `before` to
`after`. -/
def CertifiedPredecessor (after before : Hydra) : Prop :=
  CertifiedStep before after

/-- Certified predecessor steps form a well-founded relation.  The proof pulls
ordinal strict order back along the structural rank and then restricts that
larger rank relation to certified game steps. -/
theorem certifiedPredecessor_wellFounded : WellFounded CertifiedPredecessor := by
  let rank : Hydra → Ordinal.{0} := hydraOrdinal.{0}
  have rankWellFounded : WellFounded (InvImage (· < ·) rank) :=
    ordinal_lt_wellFounded.onFun
  apply rankWellFounded.mono
  intro after before certified
  exact certifiedStep_decreases certified

/-- Every hydra is accessible for the certified predecessor relation. -/
theorem certifiedStep_accessible (before : Hydra) :
    Acc CertifiedPredecessor before := by
  exact certifiedPredecessor_wellFounded.apply before

/--
> **Entry**: settheory.googology.hydra-certified-step-well-founded
> **一句话**: 认证 Hydra 步骤按“后态低于前态”的方向构成良基关系，因此可对一个状态的全部认证后继作良基归纳。
> **依赖**: `settheory.googology.hydra-certified-play-termination`
> **mathlib**: `WellFounded.onFun`、`WellFounded.mono`、`WellFounded.induction`

The induction hypothesis covers every certified successor of the current
hydra; it does not cover arbitrary `Hydra.Step` successors.
-/
theorem certifiedStep_induction {P : Hydra → Prop}
    (step : ∀ before, (∀ after, CertifiedStep before after → P after) → P before) :
    ∀ before, P before := by
  intro before
  apply certifiedPredecessor_wellFounded.induction before
  intro current ih
  apply step current
  intro after certified
  exact ih after certified

end SandronesLibrary.SetTheory.HydraCertifiedStepWellFounded
