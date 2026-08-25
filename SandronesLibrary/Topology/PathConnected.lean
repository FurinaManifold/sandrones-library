/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Topology.Path

/-!
# Path connectedness

The relation of being joined by a path, path components, and path connected subsets are built
from Sandrone paths and Sandrone subspace topologies.

Current entry:

* `topology.connectedness.path-components-foundation`.
-/

open Set

namespace SandronesLibrary.Topology.TextbookTopology

variable {X : Type*} (tau : TextbookTopology X)

/-- Two points are joined when a Sandrone path connects them.

> **Entry**: topology.connectedness.path-components-foundation -/
def Joined (a b : X) : Prop := Nonempty (Path tau a b)

/-- Every point is joined to itself by the constant path. -/
theorem joined_refl (a : X) : Joined tau a a :=
  Nonempty.intro (Path.refl tau a)

/-- Reversing a path reverses the joined relation. -/
theorem Joined.symm {a b : X} (h : Joined tau a b) : Joined tau b a := by
  obtain ⟨gamma⟩ := h
  exact ⟨gamma.symm⟩

/-- Concatenating paths makes the joined relation transitive. -/
theorem Joined.trans {a b c : X} (hab : Joined tau a b) (hbc : Joined tau b c) :
    Joined tau a c := by
  obtain ⟨gamma⟩ := hab
  obtain ⟨delta⟩ := hbc
  exact ⟨gamma.trans delta⟩

/-- Being joined by a path is an equivalence relation. -/
theorem joined_equivalence : Equivalence (Joined tau) :=
  ⟨joined_refl tau, fun {_ _} h ↦ Joined.symm tau h,
    fun {_ _ _} h k ↦ Joined.trans tau h k⟩

/-- The path component of `a` is its equivalence class under the joined relation. -/
def pathComponent (a : X) : Set X := {b | Joined tau a b}

theorem mem_pathComponent_iff (a b : X) : b ∈ pathComponent tau a ↔ Joined tau a b :=
  Iff.rfl

/-- A subset is path connected when it is nonempty and any two of its points can be joined by a
path in its Sandrone subspace topology. -/
def IsPathConnected (s : Set X) : Prop :=
  s.Nonempty ∧ ∀ a b : s, Joined (subspace s tau) a b

/-- Every singleton is path connected in its subspace topology. -/
theorem isPathConnected_singleton (a : X) : IsPathConnected tau {a} := by
  refine ⟨⟨a, by simp⟩, ?_⟩
  intro x y
  have hxy : x = y := by
    apply Subtype.ext
    exact x.2.trans y.2.symm
  subst y
  exact joined_refl (subspace {a} tau) x

/-- A continuous map sends joined points to joined points. -/
theorem Joined.map {Y : Type*} {τX : TextbookTopology X} {τY : TextbookTopology Y}
    {a b : X} {f : X → Y} (h : Joined τX a b) (hf : Continuous τX τY f) :
    Joined τY (f a) (f b) := by
  obtain ⟨gamma⟩ := h
  exact ⟨gamma.map f hf⟩

/-- The image of a path connected set under a continuous map is path connected in its subspace
topology. -/
theorem IsPathConnected.image {Y : Type*} {τX : TextbookTopology X}
    {τY : TextbookTopology Y} {s : Set X} {f : X → Y} (hs : IsPathConnected τX s)
    (hf : Continuous τX τY f) : IsPathConnected τY (f '' s) := by
  obtain ⟨x, hx⟩ := hs.1
  refine ⟨⟨f x, x, hx, rfl⟩, ?_⟩
  rintro ⟨_, x, hx, rfl⟩ ⟨_, y, hy, rfl⟩
  let lift : s → f '' s := fun z ↦ ⟨f z, z, z.2, rfl⟩
  have hlift : Continuous (subspace s τX) (subspace (f '' s) τY) lift := by
    apply continuous_subtype_mk
    exact hf.comp (continuous_subtype_val s τX)
  exact Joined.map (hs.2 ⟨x, hx⟩ ⟨y, hy⟩) hlift

/-- The base point belongs to its own path component. -/
theorem self_mem_pathComponent (a : X) : a ∈ pathComponent tau a :=
  joined_refl tau a

/-- Joined points determine the same path component. -/
theorem pathComponent_eq_of_joined {a b : X} (h : Joined tau a b) :
    pathComponent tau a = pathComponent tau b := by
  ext x
  constructor
  · intro hax
    exact Joined.trans tau (Joined.symm tau h) hax
  · intro hbx
    exact Joined.trans tau h hbx

/-- Two path components are equal exactly when their base points are joined. -/
theorem pathComponent_eq_iff_joined (a b : X) :
    pathComponent tau a = pathComponent tau b ↔ Joined tau a b := by
  constructor
  · intro h
    change b ∈ pathComponent tau a
    rw [h]
    exact self_mem_pathComponent tau b
  · exact pathComponent_eq_of_joined tau

/-- Path components which meet are equal. -/
theorem pathComponent_eq_of_mem_inter {a b : X}
    (h : (pathComponent tau a ∩ pathComponent tau b).Nonempty) :
    pathComponent tau a = pathComponent tau b := by
  obtain ⟨x, hax, hbx⟩ := h
  apply pathComponent_eq_of_joined tau
  exact Joined.trans tau hax (Joined.symm tau hbx)

/-- A continuous map sends a path component into the path component of the image point. -/
theorem image_pathComponent_subset {Y : Type*} {τY : TextbookTopology Y} {f : X → Y}
    (hf : Continuous tau τY f) (a : X) :
    f '' pathComponent tau a ⊆ pathComponent τY (f a) := by
  rintro _ ⟨x, hx, rfl⟩
  exact Joined.map hx hf

end SandronesLibrary.Topology.TextbookTopology
