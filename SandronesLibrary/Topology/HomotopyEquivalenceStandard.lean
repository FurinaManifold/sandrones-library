/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Topology.HomotopyStandard
import Mathlib.Topology.Homotopy.Equiv

/-!
# Standard homotopy equivalences

This module explains Mathlib's `ContinuousMap.HomotopyEquiv` as two continuous maps whose two
composites are homotopic to the corresponding identities.  It also records the equivalence-relation
operations and the bridge from homeomorphisms.

Current entry:

* `topology.homotopy.equivalence-standard`.
-/

open ContinuousMap

namespace SandronesLibrary.Topology

universe u v w

variable {X : Type u} {Y : Type v} {Z : Type w}
variable [TopologicalSpace X] [TopologicalSpace Y] [TopologicalSpace Z]

/-- Two spaces are homotopy equivalent exactly when there are continuous maps in both
directions whose two composites are homotopic to the appropriate identity maps.

> **Entry**: topology.homotopy.equivalence-standard -/
theorem nonempty_homotopyEquiv_iff_exists_two_sided_homotopy_inverse :
    Nonempty (X ≃ₕ Y) ↔
      ∃ f : C(X, Y), ∃ g : C(Y, X),
        (g.comp f).Homotopic (ContinuousMap.id X) ∧
        (f.comp g).Homotopic (ContinuousMap.id Y) := by
  constructor
  · rintro ⟨e⟩
    exact ⟨e.toFun, e.invFun, e.left_inv, e.right_inv⟩
  · rintro ⟨f, g, hleft, hright⟩
    exact ⟨{
      toFun := f
      invFun := g
      left_inv := hleft
      right_inv := hright
    }⟩

/-- Every topological space is homotopy equivalent to itself. -/
theorem nonempty_homotopyEquiv_refl (X : Type u) [TopologicalSpace X] :
    Nonempty (X ≃ₕ X) :=
  ⟨ContinuousMap.HomotopyEquiv.refl X⟩

/-- Existence of a homotopy equivalence is symmetric. -/
theorem nonempty_homotopyEquiv_symm (h : Nonempty (X ≃ₕ Y)) :
    Nonempty (Y ≃ₕ X) :=
  h.map ContinuousMap.HomotopyEquiv.symm

/-- Existence of homotopy equivalences is transitive under composition. -/
theorem nonempty_homotopyEquiv_trans
    (hXY : Nonempty (X ≃ₕ Y)) (hYZ : Nonempty (Y ≃ₕ Z)) :
    Nonempty (X ≃ₕ Z) :=
  hXY.map2 ContinuousMap.HomotopyEquiv.trans hYZ

/-- The homotopy equivalence induced by a homeomorphism has exactly the same forward function. -/
theorem homeomorph_toHomotopyEquiv_apply (e : X ≃ₜ Y) (x : X) :
    e.toHomotopyEquiv x = e x :=
  rfl

end SandronesLibrary.Topology
