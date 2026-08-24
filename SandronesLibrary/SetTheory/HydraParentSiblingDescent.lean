/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.SetTheory.HydraSiblingDescent

/-!
# Hydra descent with siblings inside the copied parent

Both the root and the copied parent may retain arbitrary ordered left sibling
forests.  The selected parent and selected head must remain rightmost at their
respective levels.  This file proves legality and strict descent only for that
ordered subclass.
-/

namespace SandronesLibrary.SetTheory.HydraParentSiblingDescent

open SandronesLibrary.SetTheory
open SandronesLibrary.SetTheory.Ordinal
open SandronesLibrary.SetTheory.HydraOrdinalAssignment
open SandronesLibrary.SetTheory.HydraOneLevelDescent
open SandronesLibrary.SetTheory.HydraSiblingDescent

universe u

/-- Replacing the item just after a list prefix keeps the prefix and splices in
the replacement. -/
private theorem replaceAtWith_prefix_length {α : Type*}
    (initial replacement suffix : List α) (entry : α) :
    Hydra.replaceAtWith (initial ++ entry :: suffix) initial.length replacement =
      some (initial ++ replacement ++ suffix) := by
  induction initial with
  | nil => rfl
  | cons first initial ih =>
      simp only [List.cons_append, List.length_cons, Hydra.replaceAtWith]
      rw [ih]
      rfl

/-- A two-prefix replicated cut.  `rootSiblings` stay to the left of the copied
parent, while `parentSiblings` stay to the left of the head removed inside that
parent. -/
def ParentRightmostHeadReplicatedCut (stage : Nat)
    (rootSiblings parentSiblings : List Hydra) (before after : Hydra) : Prop :=
  before = .node
      (rootSiblings ++ [.node (parentSiblings ++ [Hydra.head])]) ∧
    after = .node
      (rootSiblings ++ List.replicate (stage + 1) (.node parentSiblings))

/-- The specified two-prefix transformation is exactly `chop` at the path
formed by the lengths of the two retained prefixes. -/
theorem parentRightmostHeadReplicatedCut_isStep {stage : Nat}
    {rootSiblings parentSiblings : List Hydra} {before after : Hydra}
    (cut : ParentRightmostHeadReplicatedCut stage rootSiblings parentSiblings
      before after) :
    Hydra.Step stage before after := by
  rcases cut with ⟨rfl, rfl⟩
  refine ⟨[rootSiblings.length, parentSiblings.length], ?_, ?_⟩
  · constructor
    · simp
    · simp [Hydra.subtreeAt, Hydra.head]
  · simp only [Hydra.chop]
    rw [show
      (rootSiblings ++ [.node (parentSiblings ++ [Hydra.head])])[rootSiblings.length]? =
        some (.node (parentSiblings ++ [Hydra.head])) by simp]
    simp [Hydra.head, replaceAtWith_prefix_length]

/-- The suffix consisting of the selected parent strictly decreases after its
rightmost head is removed and the pruned parent is copied finitely many times. -/
theorem copiedParentSuffix_decreases (stage : Nat) (parentSiblings : List Hydra) :
    forestOrdinal.{u}
        (List.replicate (stage + 1) (.node parentSiblings)) <
      forestOrdinal.{u} [.node (parentSiblings ++ [Hydra.head])] := by
  rw [forestOrdinal_replicate]
  simp only [hydraOrdinal, forestOrdinal, ordinalAdd_zero]
  rw [forestOrdinal_append_head]
  exact ordinalRepeat_omegaPow_lt_succ (forestOrdinal parentSiblings) (stage + 1)

/-- Retaining both ordered left prefixes preserves strict descent of the
stage-dependent copied-parent step. -/
theorem parentRightmostHeadReplicatedCut_decreases {stage : Nat}
    {rootSiblings parentSiblings : List Hydra} {before after : Hydra}
    (cut : ParentRightmostHeadReplicatedCut stage rootSiblings parentSiblings
      before after) :
    hydraOrdinal.{u} after < hydraOrdinal.{u} before := by
  rcases cut with ⟨rfl, rfl⟩
  simp only [hydraOrdinal]
  exact forestOrdinal_append_lt rootSiblings
    (copiedParentSuffix_decreases stage parentSiblings)

/--
> **Entry**: settheory.googology.hydra-parent-sibling-descent
> **一句话**: 根部和被复制父节点内部都可保留任意左兄弟森林；砍掉父内最右头并阶段复制后，真实 Hydra 单步严格降低结构序数。
> **依赖**: `settheory.googology.hydra-sibling-descent`
> **mathlib**: 无新增（复用前批序数幂界与加法单调接口）

This packages legality and descent for the two-prefix rightmost subclass, not
for every hydra step.
-/
theorem parentRightmostHeadReplicatedCut_verified {stage : Nat}
    {rootSiblings parentSiblings : List Hydra} {before after : Hydra}
    (cut : ParentRightmostHeadReplicatedCut stage rootSiblings parentSiblings
      before after) :
    Hydra.Step stage before after ∧
      hydraOrdinal.{u} after < hydraOrdinal.{u} before := by
  exact ⟨parentRightmostHeadReplicatedCut_isStep cut,
    parentRightmostHeadReplicatedCut_decreases cut⟩

end SandronesLibrary.SetTheory.HydraParentSiblingDescent
