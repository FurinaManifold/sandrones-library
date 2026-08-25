/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.SetTheory.HydraCertifiedTransitiveDescent

/-!
# Termination of certified hydra strategy specifications

A strategy specification proves that every state is terminal or has a
certified successor.  Well-founded induction assembles a finite certified
trajectory from every start to some terminal endpoint.  The result is
existential: it supplies neither a computable selector nor a uniform step bound.
-/

namespace SandronesLibrary.SetTheory.HydraCertifiedStrategyTermination

open SandronesLibrary.SetTheory
open SandronesLibrary.SetTheory.HydraCertifiedPlayTermination
open SandronesLibrary.SetTheory.HydraCertifiedStepWellFounded
open SandronesLibrary.SetTheory.HydraCertifiedTransitiveDescent

/-- A logical strategy specification.  At every state it proves either the
chosen terminal condition or the existence of one certified forward step. -/
structure CertifiedStrategySpec where
  Terminal : Hydra → Prop
  progress : ∀ state, Terminal state ∨ ∃ next, CertifiedStep state next

/-- A start state reaches some strategy-terminal endpoint in an exact finite
number of certified steps. -/
def ReachesTerminal (strategy : CertifiedStrategySpec) (start : Hydra) : Prop :=
  ∃ steps endpoint,
    CertifiedExactSteps steps start endpoint ∧ strategy.Terminal endpoint

/-- Well-founded induction assembles a finite terminal trajectory from every
starting hydra satisfying the strategy specification. -/
theorem certifiedStrategy_reachesTerminal (strategy : CertifiedStrategySpec) :
    ∀ start, ReachesTerminal strategy start := by
  apply certifiedStep_induction
  intro state ih
  rcases strategy.progress state with terminal | ⟨next, certified⟩
  · exact ⟨0, state, rfl, terminal⟩
  · rcases ih next certified with ⟨steps, endpoint, trajectory, terminal⟩
    exact ⟨steps + 1, endpoint, ⟨next, certified, trajectory⟩, terminal⟩

/--
> **Entry**: settheory.googology.hydra-certified-strategy-termination
> **一句话**: 若策略规格在每个 Hydra 状态证明“已经终止”或给出一个认证后继，则任意起点都存在通往某个终止状态的有限认证轨迹。
> **依赖**: `settheory.googology.hydra-certified-transitive-descent`
> **mathlib**: 无新增（复用本库认证步骤良基归纳）

The theorem is constructive as a proof of existence, but the specification is
Prop-valued and does not claim an executable next-state function or step bound.
-/
theorem certifiedStrategy_terminates_from (strategy : CertifiedStrategySpec)
    (start : Hydra) :
    ∃ steps endpoint,
      CertifiedExactSteps steps start endpoint ∧ strategy.Terminal endpoint := by
  exact certifiedStrategy_reachesTerminal strategy start

end SandronesLibrary.SetTheory.HydraCertifiedStrategyTermination
