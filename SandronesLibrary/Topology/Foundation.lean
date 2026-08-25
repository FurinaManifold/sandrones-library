/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib.Topology.Continuous

/-!
# A textbook foundation for topology

This file defines the elementary objects of topology inside Sandrone's Library.  Mathlib's
`TopologicalSpace` is used only through an explicit bridge after the textbook definitions and their
first consequences have been established.

Current entry:

* `topology.foundation.structure`.
-/

open Set Function

namespace SandronesLibrary.Topology

/-- A topology on `X`, presented by its open sets and the three open-set axioms.

> **Entry**: topology.foundation.structure -/
structure TextbookTopology (X : Type*) where
  /-- The predicate selecting the open subsets. -/
  IsOpen : Set X → Prop
  /-- The whole space is open. -/
  isOpen_univ : IsOpen univ
  /-- The intersection of two open sets is open. -/
  isOpen_inter : ∀ s t, IsOpen s → IsOpen t → IsOpen (s ∩ t)
  /-- The union of an arbitrary collection of open sets is open. -/
  isOpen_sUnion : ∀ S : Set (Set X), (∀ s ∈ S, IsOpen s) → IsOpen (⋃₀ S)

namespace TextbookTopology

variable {X Y Z : Type*}

/-- The empty set is open, derived as the union of the empty collection. -/
theorem isOpen_empty (τ : TextbookTopology X) : τ.IsOpen ∅ := by
  rw [← sUnion_empty]
  exact τ.isOpen_sUnion ∅ (by simp)

/-- The union of two open sets is open. -/
theorem isOpen_union (τ : TextbookTopology X) {s t : Set X}
    (hs : τ.IsOpen s) (ht : τ.IsOpen t) : τ.IsOpen (s ∪ t) := by
  rw [← sUnion_pair]
  exact τ.isOpen_sUnion {s, t} (by simpa using And.intro hs ht)

/-- A set is closed when its complement is open. -/
def IsClosed (τ : TextbookTopology X) (s : Set X) : Prop :=
  τ.IsOpen sᶜ

/-- A set is a neighborhood of `x` when it contains an open set containing `x`. -/
def IsNeighborhood (τ : TextbookTopology X) (x : X) (s : Set X) : Prop :=
  ∃ u, τ.IsOpen u ∧ x ∈ u ∧ u ⊆ s

/-- A map is continuous when the preimage of every open set is open. -/
def Continuous (τX : TextbookTopology X) (τY : TextbookTopology Y) (f : X → Y) : Prop :=
  ∀ v, τY.IsOpen v → τX.IsOpen (f ⁻¹' v)

/-- The identity map is continuous. -/
theorem continuous_id (τ : TextbookTopology X) : Continuous τ τ id := by
  intro v hv
  simpa using hv

/-- A composite of continuous maps is continuous. -/
theorem Continuous.comp {τX : TextbookTopology X} {τY : TextbookTopology Y}
    {τZ : TextbookTopology Z} {f : X → Y} {g : Y → Z}
    (hg : Continuous τY τZ g) (hf : Continuous τX τY f) :
    Continuous τX τZ (g ∘ f) := by
  intro w hw
  change τX.IsOpen (f ⁻¹' (g ⁻¹' w))
  exact hf _ (hg _ hw)

/-- A textbook homeomorphism is an equivalence whose forward and inverse maps are continuous. -/
structure Homeomorphism (τX : TextbookTopology X) (τY : TextbookTopology Y) where
  toEquiv : X ≃ Y
  continuous_toFun : Continuous τX τY toEquiv
  continuous_invFun : Continuous τY τX toEquiv.symm

/-- A textbook topology gives a Mathlib topology with exactly the same open sets.  This is an
implementation bridge, not the definition used by the textbook layer. -/
@[instance_reducible]
def toMathlib (τ : TextbookTopology X) : TopologicalSpace X where
  IsOpen := τ.IsOpen
  isOpen_univ := τ.isOpen_univ
  isOpen_inter := τ.isOpen_inter
  isOpen_sUnion := τ.isOpen_sUnion

/-- The Mathlib bridge preserves the predicate of being open definitionally. -/
@[simp]
theorem isOpen_toMathlib (τ : TextbookTopology X) (s : Set X) :
    @_root_.IsOpen X τ.toMathlib s ↔ τ.IsOpen s :=
  Iff.rfl

/-- Textbook continuity is exactly Mathlib continuity after installing the two explicit bridges. -/
theorem continuous_iff_mathlib (τX : TextbookTopology X) (τY : TextbookTopology Y) (f : X → Y) :
    Continuous τX τY f ↔ @_root_.Continuous X Y τX.toMathlib τY.toMathlib f := by
  rw [_root_.continuous_def]
  rfl

end TextbookTopology

end SandronesLibrary.Topology
