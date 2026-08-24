/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.SetTheory.HydraOneLevelDescent

/-!
# Hydra descent with a retained left sibling forest

The copied parent branch is required to be the rightmost child of the root.
This exact order restriction lets strict monotonicity in the right argument of
ordinal addition transport the one-level descent across an arbitrary common
left sibling forest.  We do not claim descent with arbitrary right siblings.
-/

namespace SandronesLibrary.SetTheory.HydraSiblingDescent

open SandronesLibrary.SetTheory
open SandronesLibrary.SetTheory.Ordinal
open SandronesLibrary.SetTheory.HydraOrdinalAssignment
open SandronesLibrary.SetTheory.HydraOneLevelDescent

universe u

private theorem ordinalAdd_eq_native (a b : Ordinal.{u}) :
    ordinalAdd a b = a + b := by
  simp [ordinalAdd]

/-- The library's ordinal addition is strictly increasing in its right
argument.  The statement uses only the public library operation. -/
theorem ordinalAdd_lt_of_lt_right {left right : Ordinal.{u}} (h : left < right)
    (initial : Ordinal.{u}) :
    ordinalAdd initial left < ordinalAdd initial right := by
  rw [ordinalAdd_eq_native, ordinalAdd_eq_native]
  exact add_lt_add_right h initial

/-- Adding the same ordered forest on the left preserves a strict comparison
between two suffix forests. -/
theorem forestOrdinal_append_lt (initial : List Hydra) {left right : List Hydra}
    (h : forestOrdinal.{u} left < forestOrdinal.{u} right) :
    forestOrdinal.{u} (initial ++ left) <
      forestOrdinal.{u} (initial ++ right) := by
  induction initial with
  | nil => simpa using h
  | cons child initial ih =>
      simp only [List.cons_append, forestOrdinal]
      exact ordinalAdd_lt_of_lt_right ih _

/-- Replacing the entry immediately after a prefix preserves that prefix and
splices in the requested list. -/
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

/-- A genuine deep cut whose copied parent is the rightmost root child.  Any
ordered sibling forest to its left remains untouched. -/
def RightmostBranchReplicatedCut (stage : Nat) (siblings : List Hydra)
    (before after : Hydra) : Prop :=
  before = .node (siblings ++ [.node [Hydra.head]]) ∧
    after = .node (siblings ++ List.replicate (stage + 1) (.node []))

theorem rightmostBranchReplicatedCut_isStep {stage : Nat} {siblings : List Hydra}
    {before after : Hydra}
    (cut : RightmostBranchReplicatedCut stage siblings before after) :
    Hydra.Step stage before after := by
  rcases cut with ⟨rfl, rfl⟩
  refine ⟨[siblings.length, 0], ?_, ?_⟩
  · constructor
    · simp
    · simp [Hydra.subtreeAt, Hydra.head]
  · simp only [Hydra.chop]
    rw [show (siblings ++ [Hydra.node [Hydra.head]])[siblings.length]? =
        some (.node [Hydra.head]) by simp]
    simp [Hydra.head, Hydra.replaceAtWith, replaceAtWith_prefix_length]

/-- Retaining any common left sibling forest preserves the strict decrease of
the one-level replicated cut. -/
theorem rightmostBranchReplicatedCut_decreases {stage : Nat}
    {siblings : List Hydra} {before after : Hydra}
    (cut : RightmostBranchReplicatedCut stage siblings before after) :
    hydraOrdinal.{u} after < hydraOrdinal.{u} before := by
  rcases cut with ⟨rfl, rfl⟩
  simp only [hydraOrdinal]
  apply forestOrdinal_append_lt
  have baseCut : OneLevelReplicatedCut stage
      (.node [.node [Hydra.head]])
      (.node (List.replicate (stage + 1) (.node []))) := ⟨rfl, rfl⟩
  simpa only [hydraOrdinal] using oneLevelReplicatedCut_decreases baseCut

/--
> **Entry**: settheory.googology.hydra-sibling-descent
> **一句话**: 当发生阶段复制的父分支位于根孩子列表最右端时，任意保留的左兄弟森林不妨碍真实单步的序数下降。
> **依赖**: `settheory.googology.hydra-one-level-descent`
> **mathlib**: `add_lt_add_right`

This packages legality and descent for the rightmost-branch subclass only.
-/
theorem rightmostBranchReplicatedCut_verified {stage : Nat}
    {siblings : List Hydra} {before after : Hydra}
    (cut : RightmostBranchReplicatedCut stage siblings before after) :
    Hydra.Step stage before after ∧ hydraOrdinal after < hydraOrdinal before := by
  exact ⟨rightmostBranchReplicatedCut_isStep cut,
    rightmostBranchReplicatedCut_decreases cut⟩

end SandronesLibrary.SetTheory.HydraSiblingDescent
