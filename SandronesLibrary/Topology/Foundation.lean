/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib.Topology.Continuous
import Mathlib.Topology.Homeomorph.Defs
import Mathlib.Topology.Neighborhoods

/-!
# The textbook meaning of Mathlib's topology foundation

Mathlib's `TopologicalSpace`, `IsOpen`, `Continuous`, and `Homeomorph` have exactly the meanings
used in the textbook course, so they are the official public carriers of this entry. The opening
theorems expose their textbook definitions without wrapping them in parallel structures.

The older `TextbookTopology` hierarchy remains below as a frozen compatibility layer for existing
SandronesLibrary declarations. New topology development must use the Mathlib carriers directly.

Current entry:

* `topology.foundation.structure`.
-/

open Set Function
open scoped Topology

namespace SandronesLibrary.Topology

variable {X Y : Type*}

/-- Mathlib's topology structure supplies exactly the textbook open-set axioms: the whole space is
open, binary intersections of open sets are open, and arbitrary unions of open sets are open. The
empty set is then the union of the empty family.

> **Entry**: topology.foundation.structure -/
theorem topologicalSpace_open_axioms [TopologicalSpace X] :
    IsOpen (Set.univ : Set X) ∧
      (∀ s t : Set X, IsOpen s → IsOpen t → IsOpen (s ∩ t)) ∧
      ∀ S : Set (Set X), (∀ s ∈ S, IsOpen s) → IsOpen (⋃₀ S) := by
  exact ⟨isOpen_univ, fun _ _ hs ht ↦ hs.inter ht,
    fun _ hS ↦ isOpen_sUnion hS⟩

/-- A function is continuous exactly when the preimage of every open set is open. This theorem
shows the textbook definition used by Mathlib's public `Continuous` predicate. -/
theorem continuous_iff_preimage_open [TopologicalSpace X] [TopologicalSpace Y]
    (f : X → Y) :
    _root_.Continuous f ↔ ∀ u : Set Y, _root_.IsOpen u → _root_.IsOpen (f ⁻¹' u) := by
  exact _root_.continuous_def

/-- Equivalently, a function is continuous exactly when the preimage of every closed set is
closed. This is derived from the open-set formulation using complements. -/
theorem continuous_iff_preimage_closed [TopologicalSpace X] [TopologicalSpace Y]
    (f : X → Y) :
    _root_.Continuous f ↔
      ∀ s : Set Y, _root_.IsClosed s → _root_.IsClosed (f ⁻¹' s) := by
  constructor
  · intro hf s hs
    exact hs.preimage hf
  · intro h
    rw [continuous_iff_preimage_open]
    intro u hu
    have hclosed : _root_.IsClosed (uᶜ) := hu.isClosed_compl
    have hpre := h (uᶜ) hclosed
    have hopen := hpre.isOpen_compl
    simpa only [preimage_compl, compl_compl] using hopen

/-- A set is a neighborhood of `x` exactly when it contains an open set containing `x`. Thus
membership in Mathlib's neighborhood filter is the standard textbook notion of neighborhood. -/
theorem mem_nhds_iff_exists_open [TopologicalSpace X] (x : X) (s : Set X) :
    s ∈ 𝓝 x ↔ ∃ u : Set X, _root_.IsOpen u ∧ x ∈ u ∧ u ⊆ s := by
  rw [_root_.mem_nhds_iff]
  constructor
  · rintro ⟨u, hus, hu, hxu⟩
    exact ⟨u, hu, hxu, hus⟩
  · rintro ⟨u, hu, hxu, hus⟩
    exact ⟨u, hus, hu, hxu⟩

/-- A homeomorphism exists exactly when there is an equivalence whose forward and inverse maps
are both continuous. Thus Mathlib's `Homeomorph` packages the usual textbook data without changing
its mathematical meaning. -/
theorem nonempty_homeomorph_iff_exists_equiv [TopologicalSpace X] [TopologicalSpace Y] :
    Nonempty (X ≃ₜ Y) ↔
      ∃ e : X ≃ Y, _root_.Continuous (e : X → Y) ∧
        _root_.Continuous (e.symm : Y → X) := by
  constructor
  · rintro ⟨e⟩
    exact ⟨e.toEquiv, e.continuous, e.symm.continuous⟩
  · rintro ⟨e, he, he'⟩
    exact ⟨{ toEquiv := e, continuous_toFun := he, continuous_invFun := he' }⟩

/-- Legacy explicit topology carrier retained only so already committed SandronesLibrary modules
continue to compile during the M2 migration. New declarations must use `TopologicalSpace`. -/
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

/-- Every constant map is continuous. -/
theorem continuous_const (τX : TextbookTopology X) (τY : TextbookTopology Y) (y : Y) :
    Continuous τX τY (fun _ : X ↦ y) := by
  intro v hv
  by_cases hy : y ∈ v
  · have hpre : (fun _ : X ↦ y) ⁻¹' v = univ := by ext; simp [hy]
    rw [hpre]
    exact τX.isOpen_univ
  · have hpre : (fun _ : X ↦ y) ⁻¹' v = ∅ := by ext; simp [hy]
    rw [hpre]
    exact τX.isOpen_empty

/-- A composite of continuous maps is continuous. -/
theorem Continuous.comp {τX : TextbookTopology X} {τY : TextbookTopology Y}
    {τZ : TextbookTopology Z} {f : X → Y} {g : Y → Z}
    (hg : Continuous τY τZ g) (hf : Continuous τX τY f) :
    Continuous τX τZ (g ∘ f) := by
  intro w hw
  change τX.IsOpen (f ⁻¹' (g ⁻¹' w))
  exact hf _ (hg _ hw)

/-- Legacy explicit homeomorphism carrier. New declarations use Mathlib's `Homeomorph`. -/
structure Homeomorphism (τX : TextbookTopology X) (τY : TextbookTopology Y) where
  toEquiv : X ≃ Y
  continuous_toFun : Continuous τX τY toEquiv
  continuous_invFun : Continuous τY τX toEquiv.symm

end TextbookTopology

end SandronesLibrary.Topology
