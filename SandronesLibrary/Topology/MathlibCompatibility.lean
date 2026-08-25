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

/-- The frozen legacy topology carrier and Mathlib's topology carrier are equivalent structures.

This equivalence exists only to migrate old declarations. It is not an invitation to transport
new Mathlib-facing theorems back into the legacy hierarchy. -/
def equivMathlib : TextbookTopology X ≃ TopologicalSpace X where
  toFun := toMathlib
  invFun := fromMathlib
  left_inv := fromMathlib_toMathlib
  right_inv := toMathlib_fromMathlib

end SandronesLibrary.Topology.TextbookTopology

