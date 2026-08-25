/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Topology.PathHomotopyStandard

/-!
# Standard and relative homotopies

This module explains Mathlib's general `ContinuousMap.Homotopy` and relative
`ContinuousMap.HomotopyRel` carriers, including their behavior under composition.  It does not
reuse the frozen `TextbookTopology.Homotopy` implementation.

Current entry:

* `topology.homotopy.standard`.
-/

open Set

namespace SandronesLibrary.Topology

universe u v w

variable {X : Type u} {Y : Type v} {Z : Type w}
variable [TopologicalSpace X] [TopologicalSpace Y] [TopologicalSpace Z]

/-- A general homotopy is exactly a continuous deformation whose time-zero and time-one slices
are the specified continuous maps.  The first coordinate is homotopy time.

> **Entry**: topology.homotopy.standard -/
theorem nonempty_homotopy_iff_exists_continuous_deformation
    {f g : C(X, Y)} :
    Nonempty (f.Homotopy g) ↔
      ∃ F : unitInterval × X → Y, Continuous F ∧
        (∀ x, F (0, x) = f x) ∧
        (∀ x, F (1, x) = g x) := by
  constructor
  · rintro ⟨H⟩
    exact ⟨H, H.continuous, H.apply_zero, H.apply_one⟩
  · rintro ⟨F, hF, hzero, hone⟩
    exact ⟨{
      toFun := F
      continuous_toFun := hF
      map_zero_left := hzero
      map_one_left := hone
    }⟩

/-- A homotopy relative to `S` is a continuous deformation whose points in `S` remain fixed for
every time, not merely one whose endpoint maps agree on `S`. -/
theorem nonempty_homotopyRel_iff_exists_continuous_deformation_fixed_on
    {f g : C(X, Y)} {S : Set X} :
    Nonempty (f.HomotopyRel g S) ↔
      ∃ F : unitInterval × X → Y, Continuous F ∧
        (∀ x, F (0, x) = f x) ∧
        (∀ x, F (1, x) = g x) ∧
        (∀ t x, x ∈ S → F (t, x) = f x) := by
  constructor
  · rintro ⟨H⟩
    exact ⟨H, H.continuous, H.apply_zero, H.apply_one, fun t x hx ↦ H.eq_fst t hx⟩
  · rintro ⟨F, hF, hzero, hone, hfixed⟩
    exact ⟨{
      toHomotopy := {
        toFun := F
        continuous_toFun := hF
        map_zero_left := hzero
        map_one_left := hone
      }
      prop' := hfixed
    }⟩

/-- Composing two compatible homotopies uses the same time coordinate and composes their spatial
values pointwise. -/
theorem homotopy_comp_apply
    {f₀ f₁ : C(X, Y)} {g₀ g₁ : C(Y, Z)}
    (G : g₀.Homotopy g₁) (F : f₀.Homotopy f₁)
    (z : unitInterval × X) :
    G.comp F z = G (z.1, F z) := by
  rfl

/-- Post-composition carries a homotopy relative to `S` to another homotopy relative to the same
set, by applying the continuous map to every stage. -/
theorem homotopyRel_compContinuousMap_apply
    {f₀ f₁ : C(X, Y)} {S : Set X}
    (F : f₀.HomotopyRel f₁ S) (g : C(Y, Z))
    (z : unitInterval × X) :
    F.compContinuousMap g z = g (F z) := by
  rfl

end SandronesLibrary.Topology
