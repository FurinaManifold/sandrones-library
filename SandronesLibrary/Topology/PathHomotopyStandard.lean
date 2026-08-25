/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Topology.Path
import Mathlib.Topology.Homotopy.Path
import Mathlib.Tactic.Linarith

/-!
# Standard homotopies between paths

This module explains Mathlib's `Path.Homotopy` directly as a continuous two-parameter deformation
whose two path endpoints stay fixed.  It does not route new topology through the frozen
`TextbookTopology` homotopy structures.

Current entry:

* `topology.homotopy.path-homotopy-standard`.
-/

open Set

namespace SandronesLibrary.Topology

universe u

variable {X : Type u} [TopologicalSpace X]
variable {x y : X} {p q r : _root_.Path x y}

/-- A standard homotopy between paths is exactly a continuous map on the square whose time-zero
and time-one slices are the given paths and whose two spatial endpoints remain fixed for all time.
The first coordinate is homotopy time and the second coordinate is path position.

> **Entry**: topology.homotopy.path-homotopy-standard -/
theorem nonempty_pathHomotopy_iff_exists_fixed_endpoint_deformation :
    Nonempty (p.Homotopy q) ↔
      ∃ F : unitInterval × unitInterval → X, Continuous F ∧
        (∀ s, F (0, s) = p s) ∧
        (∀ s, F (1, s) = q s) ∧
        (∀ t, F (t, 0) = x) ∧
        (∀ t, F (t, 1) = y) := by
  constructor
  · rintro ⟨H⟩
    exact ⟨H, H.continuous, H.apply_zero, H.apply_one, H.source, H.target⟩
  · rintro ⟨F, hF, hzero, hone, hsource, htarget⟩
    refine ⟨{
      toHomotopy := {
        toFun := F
        continuous_toFun := hF
        map_zero_left := hzero
        map_one_left := hone
      }
      prop' := ?_
    }⟩
    intro t s hs
    rcases hs with rfl | rfl
    · exact (hsource t).trans p.source.symm
    · exact (htarget t).trans p.target.symm

/-- The reflexive path homotopy is constant in homotopy time. -/
theorem pathHomotopy_refl_apply (p : _root_.Path x y)
    (z : unitInterval × unitInterval) :
    _root_.Path.Homotopy.refl p z = p z.2 := by
  exact _root_.Path.Homotopy.refl_apply p z

/-- Reversing a path homotopy reflects only its time coordinate; it does not reverse the paths. -/
theorem pathHomotopy_symm_apply (H : p.Homotopy q)
    (z : unitInterval × unitInterval) :
    H.symm z = H (unitInterval.symm z.1, z.2) := by
  exact _root_.Path.Homotopy.symm_apply H z

/-- During the first half of a composite homotopy, time is doubled in the first deformation. -/
theorem pathHomotopy_trans_apply_of_le (H : p.Homotopy q) (K : q.Homotopy r)
    (z : unitInterval × unitInterval) (h : (z.1 : ℝ) ≤ 1 / 2) :
    H.trans K z = H (⟨2 * z.1, by constructor <;> linarith [z.1.2.1, z.1.2.2]⟩, z.2) := by
  rw [_root_.Path.Homotopy.trans_apply]
  simp only [dif_pos h]

/-- During the second half of a composite homotopy, translated doubled time runs through the
second deformation. -/
theorem pathHomotopy_trans_apply_of_not_le (H : p.Homotopy q) (K : q.Homotopy r)
    (z : unitInterval × unitInterval) (h : ¬(z.1 : ℝ) ≤ 1 / 2) :
    H.trans K z = K (⟨2 * z.1 - 1, by constructor <;> linarith [z.1.2.1, z.1.2.2]⟩, z.2) := by
  rw [_root_.Path.Homotopy.trans_apply]
  simp only [dif_neg h]

end SandronesLibrary.Topology
