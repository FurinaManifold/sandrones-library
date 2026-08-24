/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.SetTheory.HydraRightmostSpineDescent

/-!
# Termination of certified rightmost-spine hydra plays

This file defines finite and infinite play interfaces for steps carrying the
rightmost-spine certificate from the preceding module.  Ordinal well-foundedness
rules out an infinite play all of whose steps have such a certificate.  This is
not a termination theorem for every `Hydra.Step`.
-/

namespace SandronesLibrary.SetTheory.HydraCertifiedPlayTermination

open SandronesLibrary.SetTheory
open SandronesLibrary.SetTheory.Ordinal
open SandronesLibrary.SetTheory.HydraOrdinalAssignment
open SandronesLibrary.SetTheory.HydraRightmostSpineDescent

/-- A step certified by some stage, finite rightmost ancestor spine, and the
two retained left sibling forests at the replication site. -/
def CertifiedStep (before after : Hydra) : Prop :=
  ∃ stage ancestors grandparentSiblings parentSiblings,
    RightmostSpineReplicatedCut stage ancestors grandparentSiblings
      parentSiblings before after

/-- A finite list is a certified play when every adjacent pair is a certified
step.  Empty and singleton lists are valid finite plays. -/
def IsCertifiedFinitePlay : List Hydra → Prop
  | [] => True
  | [_] => True
  | before :: after :: rest =>
      CertifiedStep before after ∧ IsCertifiedFinitePlay (after :: rest)

/-- An infinite certified play supplies a hydra at every natural time and a
rightmost-spine certificate for every transition. -/
structure CertifiedInfinitePlay where
  state : Nat → Hydra
  certified : ∀ n, CertifiedStep (state n) (state (n + 1))

/-- Every certified step strictly lowers the structural ordinal assignment. -/
theorem certifiedStep_decreases {before after : Hydra}
    (step : CertifiedStep before after) :
    hydraOrdinal.{0} after < hydraOrdinal.{0} before := by
  rcases step with ⟨stage, ancestors, grandparentSiblings, parentSiblings, cut⟩
  exact rightmostSpineReplicatedCut_decreases cut

/--
> **Entry**: settheory.googology.hydra-certified-play-termination
> **一句话**: 每一步都携带有限最右脊柱证书的 Hydra 游戏不可能形成自然数长度的无限轨迹，因为其结构序数逐步严格下降。
> **依赖**: `settheory.googology.hydra-rightmost-spine-descent`、
>   `settheory.ordinal.no-infinite-descent`
> **mathlib**: `wellFounded_iff_isEmpty_descending_chain`

This excludes only infinite plays built from `CertifiedStep`; it says nothing
about uncertified `Hydra.Step`s.
-/
theorem no_certifiedInfinitePlay : IsEmpty CertifiedInfinitePlay := by
  constructor
  intro play
  let rank : Nat → Ordinal.{0} := fun n => hydraOrdinal.{0} (play.state n)
  have descends : ∀ n, rank (n + 1) < rank n := by
    intro n
    exact certifiedStep_decreases (play.certified n)
  exact (wellFounded_iff_isEmpty_descending_chain.mp ordinal_lt_wellFounded).false
    ⟨rank, descends⟩

end SandronesLibrary.SetTheory.HydraCertifiedPlayTermination
