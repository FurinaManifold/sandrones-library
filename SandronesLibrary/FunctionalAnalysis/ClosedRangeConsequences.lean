/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.FunctionalAnalysis.ClosedRange
import SandronesLibrary.FunctionalAnalysis.BanachDieudonne

/-!
# 闭值域的双零化子后果

本文件在 `ClosedRange.lean` 的核心充要刻画上，给出原值域的双零化子描述，
并记录闭值域时对偶值域的范数闭性和弱星闭性。
-/

namespace SandronesLibrary.FunctionalAnalysis

open Set

variable {E F : Type*}
variable [NormedAddCommGroup E] [NormedSpace ℝ E]
variable [NormedAddCommGroup F] [NormedSpace ℝ F]

/-- 原算子值域的拓扑闭包等于对偶算子核的共同零点。

> **Entry**: functional-analysis.closed-range.double-annihilator
-/
theorem mem_range_topologicalClosure_iff_forall_dualOperator_ker
    (T : E →L[ℝ] F) (y : F) :
    y ∈ T.range.topologicalClosure ↔
      ∀ f : StrongDual ℝ F, f ∈ (dualOperator T).ker → f y = 0 := by
  rw [mem_topologicalClosure_iff_forall_annihilator]
  constructor
  · intro h f hf
    exact h f ((dualOperator_ker_eq_range_annihilator T).symm ▸ hf)
  · intro h f hf
    exact h f (dualOperator_ker_eq_range_annihilator T ▸ hf)

/-- 值域闭时，不需再取闭包：原值域精确由对偶算子核的共同零点恢复。 -/
theorem mem_range_iff_forall_dualOperator_ker [CompleteSpace E] [CompleteSpace F]
    (T : E →L[ℝ] F) (hT : IsClosed (Set.range T)) (y : F) :
    y ∈ T.range ↔
      ∀ f : StrongDual ℝ F, f ∈ (dualOperator T).ker → f y = 0 := by
  rw [← mem_range_topologicalClosure_iff_forall_dualOperator_ker T y]
  constructor
  · intro hy
    exact T.range.le_topologicalClosure hy
  · apply T.range.topologicalClosure_minimal le_rfl
    rw [show (T.range : Set F) = Set.range T by ext; simp]
    exact hT

/-- 原算子值域闭时，对偶算子值域在对偶范数拓扑中闭。 -/
theorem dualOperator_range_isClosed_of_isClosed_range
    [CompleteSpace E] [CompleteSpace F] (T : E →L[ℝ] F)
    (hT : IsClosed (Set.range T)) :
    IsClosed ((dualOperator T).range : Set (StrongDual ℝ E)) := by
  rw [dualOperator_range_eq_ker_annihilator_of_isClosed_range T hT]
  exact continuousAnnihilator_isClosed T.ker

/-- 连续零化子送入弱星对偶后是弱星闭集。 -/
theorem weakStarImage_continuousAnnihilator_isClosed (S : Submodule ℝ E) :
    IsClosed (weakStarImage (StrongDual.polarSubmodule ℝ S : Set (StrongDual ℝ E))) := by
  rw [show weakStarImage (StrongDual.polarSubmodule ℝ S : Set (StrongDual ℝ E)) =
      ⋂ x ∈ S, {f : WeakDual ℝ E | f x = 0} by
    ext g
    constructor
    · rintro ⟨f, hf, rfl⟩
      simp only [Set.mem_iInter, Set.mem_ofPred_eq]
      exact fun x hx ↦ (mem_continuousAnnihilator_iff S f).mp hf x hx
    · intro hg
      simp only [Set.mem_iInter, Set.mem_ofPred_eq] at hg
      refine ⟨WeakDual.toStrongDual g, ?_, WeakDual.toWeakDual_toStrongDual g⟩
      exact (mem_continuousAnnihilator_iff S _).2 hg]
  exact isClosed_biInter fun x _ ↦
    isClosed_singleton.preimage (WeakDual.eval_continuous x)

/-- 原算子值域闭时，对偶值域不仅范数闭，而且在弱星拓扑中闭。 -/
theorem dualOperator_range_isWeakStarClosed_of_isClosed_range
    [CompleteSpace E] [CompleteSpace F] (T : E →L[ℝ] F)
    (hT : IsClosed (Set.range T)) :
    IsClosed (weakStarImage ((dualOperator T).range : Set (StrongDual ℝ E))) := by
  rw [dualOperator_range_eq_ker_annihilator_of_isClosed_range T hT]
  exact weakStarImage_continuousAnnihilator_isClosed T.ker

end SandronesLibrary.FunctionalAnalysis
