/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Topology.MathlibBridge

/-!
# Compatibility between the legacy textbook topology and Mathlib

The legacy `TextbookTopology` carrier is structurally equivalent to Mathlib's `TopologicalSpace`.
This module supplies a temporary two-way compatibility layer for migration. New topology
development should use Mathlib's carrier directly and must not pass through `fromMathlib` merely
to continue the legacy parallel hierarchy.

Current entry:

* `topology.foundation.mathlib-compatibility`.
-/

namespace SandronesLibrary.Topology.TextbookTopology

variable {X : Type*}

set_option warn.classDefReducibility false in
/-- Regard a Mathlib topology as the frozen legacy textbook carrier with exactly the same open
sets. This is a migration bridge, not a new definition of topological space.

> **Entry**: topology.foundation.mathlib-compatibility -/
def fromMathlib (τ : TopologicalSpace X) : TextbookTopology X where
  IsOpen := @_root_.IsOpen X τ
  isOpen_univ := @_root_.isOpen_univ X τ
  isOpen_inter := fun s t ↦ @_root_.IsOpen.inter X τ s t
  isOpen_sUnion := @_root_.isOpen_sUnion X τ

/-- The reverse bridge preserves the open-set predicate definitionally. -/
@[simp]
theorem isOpen_fromMathlib (τ : TopologicalSpace X) (s : Set X) :
    (fromMathlib τ).IsOpen s ↔ @_root_.IsOpen X τ s :=
  Iff.rfl

/-- Converting a Mathlib topology into the legacy carrier and back changes no topology. -/
@[simp]
theorem toMathlib_fromMathlib (τ : TopologicalSpace X) :
    (fromMathlib τ).toMathlib = τ := by
  apply TopologicalSpace.ext
  rfl

/-- Converting a legacy topology to Mathlib and back changes no legacy topology. -/
@[simp]
theorem fromMathlib_toMathlib (τ : TextbookTopology X) :
    fromMathlib τ.toMathlib = τ := by
  cases τ
  rfl

/-- The bridge also preserves closed sets: on both sides, closed means that the complement is
open. -/
@[simp]
theorem isClosed_toMathlib (τ : TextbookTopology X) (s : Set X) :
    @_root_.IsClosed X τ.toMathlib s ↔ τ.IsClosed s := by
  constructor
  · intro h
    exact h.isOpen_compl
  · intro h
    exact @IsClosed.mk X τ.toMathlib s h

/-- The legacy neighborhood predicate is membership in Mathlib's neighborhood filter after
installing the same topology. -/
theorem isNeighborhood_iff_mem_nhds (τ : TextbookTopology X) (x : X) (s : Set X) :
    τ.IsNeighborhood x s ↔ s ∈ @nhds X τ.toMathlib x := by
  rw [@SandronesLibrary.Topology.mem_nhds_iff_exists_open X τ.toMathlib x s]
  rfl

/-- The frozen legacy topology carrier and Mathlib's topology carrier are equivalent structures.

This equivalence exists only to migrate old declarations. It is not an invitation to transport
new Mathlib-facing theorems back into the legacy hierarchy. -/
def equivMathlib : TextbookTopology X ≃ TopologicalSpace X where
  toFun := toMathlib
  invFun := fromMathlib
  left_inv := fromMathlib_toMathlib
  right_inv := toMathlib_fromMathlib

namespace Homeomorphism

variable {Y : Type*}

/-- Two legacy homeomorphisms with the same underlying equivalence are equal. -/
theorem ext {τX : TextbookTopology X} {τY : TextbookTopology Y}
    {e e' : Homeomorphism τX τY} (h : e.toEquiv = e'.toEquiv) : e = e' := by
  cases e
  cases e'
  cases h
  rfl

/-- Convert a legacy homeomorphism to Mathlib's official `Homeomorph` carrier. -/
def toMathlib {τX : TextbookTopology X} {τY : TextbookTopology Y}
    (e : Homeomorphism τX τY) :
    @Homeomorph X Y τX.toMathlib τY.toMathlib :=
  @Homeomorph.mk X Y τX.toMathlib τY.toMathlib e.toEquiv
    ((continuous_iff_mathlib τX τY _).mp e.continuous_toFun)
    ((continuous_iff_mathlib τY τX _).mp e.continuous_invFun)

/-- Convert a Mathlib homeomorphism between bridged topologies to the legacy carrier. -/
def fromMathlib {τX : TextbookTopology X} {τY : TextbookTopology Y}
    (e : @Homeomorph X Y τX.toMathlib τY.toMathlib) :
    Homeomorphism τX τY := by
  let _ := τX.toMathlib
  let _ := τY.toMathlib
  exact {
    toEquiv := e.toEquiv
    continuous_toFun := (continuous_iff_mathlib τX τY _).mpr e.continuous
    continuous_invFun := (continuous_iff_mathlib τY τX _).mpr e.symm.continuous }

/-- Converting a legacy homeomorphism to Mathlib and back changes no data. -/
@[simp]
theorem fromMathlib_toMathlib {τX : TextbookTopology X} {τY : TextbookTopology Y}
    (e : Homeomorphism τX τY) : fromMathlib (toMathlib e) = e := by
  apply ext
  rfl

/-- Converting a Mathlib homeomorphism to the legacy carrier and back changes no data. -/
@[simp]
theorem toMathlib_fromMathlib {τX : TextbookTopology X} {τY : TextbookTopology Y}
    (e : @Homeomorph X Y τX.toMathlib τY.toMathlib) :
    toMathlib (fromMathlib e) = e := by
  let _ := τX.toMathlib
  let _ := τY.toMathlib
  apply _root_.Homeomorph.ext
  intro x
  change e x = e x
  rfl

end Homeomorphism

end SandronesLibrary.Topology.TextbookTopology
