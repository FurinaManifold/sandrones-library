/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.SetTheory.HydraParentSiblingDescent

/-!
# Strict descent along an arbitrary finite rightmost spine

Replication still occurs only at the selected head's grandparent, exactly as
specified by `Hydra.chop`.  Above it, a certificate lists arbitrary left
sibling forests whose selected child is rightmost.  Legality and strict
ordinal descent are propagated through every certified ancestor.
-/

namespace SandronesLibrary.SetTheory.HydraRightmostSpineDescent

open SandronesLibrary.SetTheory
open SandronesLibrary.SetTheory.Ordinal
open SandronesLibrary.SetTheory.HydraOrdinalAssignment
open SandronesLibrary.SetTheory.HydraSiblingDescent
open SandronesLibrary.SetTheory.HydraParentSiblingDescent

universe u

/-- Insert a focused hydra under a finite sequence of rightmost-child
contexts.  Each list contains the siblings retained to the focus's left. -/
def plugRightmostSpine : List (List Hydra) → Hydra → Hydra
  | [], focus => focus
  | siblings :: ancestors, focus =>
      .node (siblings ++ [plugRightmostSpine ancestors focus])

/-- Prefix a path by the rightmost-child index selected at every certified
ancestor. -/
def rightmostSpinePath : List (List Hydra) → List Nat → List Nat
  | [], localPath => localPath
  | siblings :: ancestors, localPath =>
      siblings.length :: rightmostSpinePath ancestors localPath

private theorem rightmostSpinePath_two (ancestors : List (List Hydra))
    (first second : Nat) (rest : List Nat) :
    ∃ next following tail,
      rightmostSpinePath ancestors (first :: second :: rest) =
        next :: following :: tail := by
  induction ancestors with
  | nil => exact ⟨first, second, rest, rfl⟩
  | cons siblings ancestors ih =>
      rcases ih with ⟨next, following, tail, pathEq⟩
      exact ⟨siblings.length, next, following :: tail, by
        simp only [rightmostSpinePath, pathEq]⟩

/-- Replacing the entry after a prefix by one item preserves the prefix. -/
private theorem replaceAtWith_rightmost {α : Type*}
    (initial : List α) (old new : α) :
    Hydra.replaceAtWith (initial ++ [old]) initial.length [new] =
      some (initial ++ [new]) := by
  induction initial with
  | nil => rfl
  | cons first initial ih =>
      simp only [List.cons_append, List.length_cons, Hydra.replaceAtWith]
      rw [ih]
      rfl

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

/-- Following the certified spine and then a local path reaches the same
subtree as following the local path inside the focus. -/
theorem subtreeAt_plugRightmostSpine (ancestors : List (List Hydra))
    (focus : Hydra) (localPath : List Nat) :
    Hydra.subtreeAt (plugRightmostSpine ancestors focus)
        (rightmostSpinePath ancestors localPath) =
      Hydra.subtreeAt focus localPath := by
  induction ancestors with
  | nil => rfl
  | cons siblings ancestors ih =>
      simp only [plugRightmostSpine, rightmostSpinePath, Hydra.subtreeAt]
      rw [show (siblings ++ [plugRightmostSpine ancestors focus])[siblings.length]? =
          some (plugRightmostSpine ancestors focus) by simp]
      exact ih

/-- A successful cut whose path already has at least two indices can be lifted
through every certified rightmost ancestor without causing extra replication
at those higher levels. -/
theorem chop_plugRightmostSpine (stage : Nat) (ancestors : List (List Hydra))
    (before after : Hydra) (first second : Nat) (rest : List Nat)
    (cut : Hydra.chop stage before (first :: second :: rest) = some after) :
    Hydra.chop stage (plugRightmostSpine ancestors before)
        (rightmostSpinePath ancestors (first :: second :: rest)) =
      some (plugRightmostSpine ancestors after) := by
  induction ancestors with
  | nil => exact cut
  | cons siblings ancestors ih =>
      rcases rightmostSpinePath_two ancestors first second rest with
        ⟨next, following, tail, pathEq⟩
      rw [pathEq] at ih
      simp [plugRightmostSpine, rightmostSpinePath, pathEq, Hydra.chop, ih,
        replaceAtWith_rightmost]

/-- Strict descent of the focus propagates through every rightmost ancestor:
each level applies the strictly increasing map `α ↦ ω^α`, then restores the
same left sibling prefix. -/
theorem hydraOrdinal_plugRightmostSpine_lt (ancestors : List (List Hydra))
    {before after : Hydra} (h : hydraOrdinal.{u} after < hydraOrdinal.{u} before) :
    hydraOrdinal.{u} (plugRightmostSpine ancestors after) <
      hydraOrdinal.{u} (plugRightmostSpine ancestors before) := by
  induction ancestors with
  | nil => exact h
  | cons siblings ancestors ih =>
      simp only [plugRightmostSpine, hydraOrdinal]
      apply forestOrdinal_append_lt
      simp only [forestOrdinal, ordinalAdd_zero]
      exact (exponentiation_isNormal Ordinal.one_lt_omega0).strictMono ih

/-- A certificate for an arbitrarily deep rightmost-spine cut.  The bottom two
levels contain the actual replication rule; `ancestors` records every higher
rightmost-child context. -/
def RightmostSpineReplicatedCut (stage : Nat) (ancestors : List (List Hydra))
    (grandparentSiblings parentSiblings : List Hydra)
    (before after : Hydra) : Prop :=
  before = plugRightmostSpine ancestors
    (.node (grandparentSiblings ++ [.node (parentSiblings ++ [Hydra.head])])) ∧
  after = plugRightmostSpine ancestors
    (.node (grandparentSiblings ++
      List.replicate (stage + 1) (.node parentSiblings)))

theorem rightmostSpineReplicatedCut_isStep {stage : Nat}
    {ancestors : List (List Hydra)} {grandparentSiblings parentSiblings : List Hydra}
    {before after : Hydra}
    (cut : RightmostSpineReplicatedCut stage ancestors grandparentSiblings
      parentSiblings before after) :
    Hydra.Step stage before after := by
  rcases cut with ⟨rfl, rfl⟩
  let localBefore : Hydra :=
    .node (grandparentSiblings ++ [.node (parentSiblings ++ [Hydra.head])])
  let localAfter : Hydra :=
    .node (grandparentSiblings ++
      List.replicate (stage + 1) (.node parentSiblings))
  have headPath : Hydra.IsHeadPosition localBefore
      [grandparentSiblings.length, parentSiblings.length] := by
    constructor
    · simp
    · simp [localBefore, Hydra.subtreeAt, Hydra.head]
  have chopPath : Hydra.chop stage localBefore
      [grandparentSiblings.length, parentSiblings.length] = some localAfter := by
    simp [localBefore, localAfter, Hydra.chop, Hydra.head,
      replaceAtWith_prefix_length]
  refine ⟨rightmostSpinePath ancestors
      [grandparentSiblings.length, parentSiblings.length], ?_, ?_⟩
  · constructor
    · rcases rightmostSpinePath_two ancestors grandparentSiblings.length
        parentSiblings.length [] with ⟨next, following, tail, pathEq⟩
      rw [pathEq]
      simp
    · rw [subtreeAt_plugRightmostSpine]
      exact headPath.2
  · exact chop_plugRightmostSpine stage ancestors localBefore localAfter
      grandparentSiblings.length parentSiblings.length [] chopPath

/-- Every cut carrying the finite rightmost-spine certificate strictly lowers
the structural ordinal assignment. -/
theorem rightmostSpineReplicatedCut_decreases {stage : Nat}
    {ancestors : List (List Hydra)} {grandparentSiblings parentSiblings : List Hydra}
    {before after : Hydra}
    (cut : RightmostSpineReplicatedCut stage ancestors grandparentSiblings
      parentSiblings before after) :
    hydraOrdinal.{u} after < hydraOrdinal.{u} before := by
  rcases cut with ⟨rfl, rfl⟩
  apply hydraOrdinal_plugRightmostSpine_lt
  exact parentRightmostHeadReplicatedCut_decreases ⟨rfl, rfl⟩

/--
> **Entry**: settheory.googology.hydra-rightmost-spine-descent
> **一句话**: 双层最右复制砍头可沿任意有限条“保留左兄弟、选择最右孩子”的祖先链提升，并保持真实 Step 与序数严格下降。
> **依赖**: `settheory.googology.hydra-parent-sibling-descent`
> **mathlib**: 无新增（复用本库正规序数幂与森林前缀接口）

This theorem covers certified rightmost spines only, not every hydra step.
-/
theorem rightmostSpineReplicatedCut_verified {stage : Nat}
    {ancestors : List (List Hydra)} {grandparentSiblings parentSiblings : List Hydra}
    {before after : Hydra}
    (cut : RightmostSpineReplicatedCut stage ancestors grandparentSiblings
      parentSiblings before after) :
    Hydra.Step stage before after ∧ hydraOrdinal.{u} after < hydraOrdinal.{u} before := by
  exact ⟨rightmostSpineReplicatedCut_isStep cut,
    rightmostSpineReplicatedCut_decreases cut⟩

end SandronesLibrary.SetTheory.HydraRightmostSpineDescent
