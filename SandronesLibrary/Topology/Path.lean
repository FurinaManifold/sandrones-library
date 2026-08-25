/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Topology.RealLine
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum

/-!
# Textbook paths and loops

Paths are defined from the Sandrone unit interval and Sandrone continuity.  This module does not
import the Mathlib topology bridge or Mathlib's `Path`.

Current entry:

* `topology.homotopy.path-definition-foundation`.
* `topology.homotopy.path-concatenation-foundation`.
-/

open Set Function

namespace SandronesLibrary.Topology.TextbookTopology

variable {X Y : Type*}

/-!
> **Entry**: topology.homotopy.path-concatenation-foundation
-/
namespace UnitInterval

/-- Double a parameter in the left half of the unit interval. -/
def leftDouble (t : UnitInterval) (h : t.1 ≤ (1 / 2 : ℝ)) : UnitInterval :=
  ⟨2 * t.1, mul_nonneg (by norm_num) t.2.1, by linarith⟩

/-- Translate and double a parameter in the right half of the unit interval. -/
def rightDouble (t : UnitInterval) (h : ¬ t.1 ≤ (1 / 2 : ℝ)) : UnitInterval :=
  ⟨2 * t.1 - 1, by linarith, by linarith [t.2.2]⟩

end UnitInterval

/-- A path from `a` to `b` in `(X, τX)` is a continuous map from the closed unit interval whose
values at zero and one are `a` and `b`.

> **Entry**: topology.homotopy.path-definition-foundation -/
structure Path (τX : TextbookTopology X) (a b : X) where
  /-- The parametrized map underlying the path. -/
  toFun : UnitInterval → X
  /-- Continuity with respect to the Sandrone unit-interval topology. -/
  continuous : Continuous unitInterval τX toFun
  /-- The path starts at `a`. -/
  source : toFun UnitInterval.zero = a
  /-- The path ends at `b`. -/
  target : toFun UnitInterval.one = b

namespace Path

instance {τX : TextbookTopology X} {a b : X} : CoeFun (Path τX a b) (fun _ ↦ UnitInterval → X) :=
  ⟨Path.toFun⟩

@[ext]
theorem ext {τX : TextbookTopology X} {a b : X} {γ δ : Path τX a b}
    (h : ∀ t, γ t = δ t) : γ = δ := by
  cases γ with
  | mk γ hγ hγ0 hγ1 =>
      cases δ with
      | mk δ hδ hδ0 hδ1 =>
          have hfun : γ = δ := funext h
          subst δ
          rfl

/-- The constant path at `a`. -/
def refl (τX : TextbookTopology X) (a : X) : Path τX a a where
  toFun := fun _ ↦ a
  continuous := continuous_const unitInterval τX a
  source := rfl
  target := rfl

@[simp] theorem refl_apply (τX : TextbookTopology X) (a : X) (t : UnitInterval) :
    refl τX a t = a :=
  rfl

/-- A continuous map sends a path to a path between the images of its endpoints. -/
def map {τX : TextbookTopology X} {τY : TextbookTopology Y} {a b : X}
    (γ : Path τX a b) (f : X → Y) (hf : Continuous τX τY f) :
    Path τY (f a) (f b) where
  toFun := f ∘ γ
  continuous := hf.comp γ.continuous
  source := by simp [γ.source]
  target := by simp [γ.target]

@[simp] theorem map_apply {τX : TextbookTopology X} {τY : TextbookTopology Y} {a b : X}
    (γ : Path τX a b) (f : X → Y) (hf : Continuous τX τY f) (t : UnitInterval) :
    γ.map f hf t = f (γ t) :=
  rfl

/-- The reverse path traverses `γ` with reflected unit-interval parameter.

> **Entry**: topology.homotopy.path-reversal-foundation -/
def symm {τX : TextbookTopology X} {a b : X} (γ : Path τX a b) : Path τX b a where
  toFun := γ ∘ UnitInterval.reflect
  continuous := γ.continuous.comp continuous_unitInterval_reflect
  source := by simp [γ.target]
  target := by simp [γ.source]

@[simp]
theorem symm_apply {τX : TextbookTopology X} {a b : X}
    (γ : Path τX a b) (t : UnitInterval) : γ.symm t = γ t.reflect :=
  rfl

@[simp]
theorem symm_symm {τX : TextbookTopology X} {a b : X} (γ : Path τX a b) :
    γ.symm.symm = γ := by
  apply ext
  intro t
  simp

/-!
> **Entry**: topology.homotopy.path-concatenation-foundation
-/
variable {tau : TextbookTopology X}

/-- The piecewise parametrized function underlying concatenation of two paths. -/
noncomputable def transFun (gamma : Path tau a b) (delta : Path tau b c) (t : UnitInterval) : X :=
  if h : t.1 ≤ (1 / 2 : ℝ) then gamma (UnitInterval.leftDouble t h)
  else delta (UnitInterval.rightDouble t h)

theorem transFun_of_le (gamma : Path tau a b) (delta : Path tau b c) (t : UnitInterval)
    (h : t.1 ≤ (1 / 2 : ℝ)) :
    transFun gamma delta t = gamma (UnitInterval.leftDouble t h) := by
  rw [transFun]
  split
  · rfl
  · contradiction

theorem transFun_of_not_le (gamma : Path tau a b) (delta : Path tau b c) (t : UnitInterval)
    (h : ¬ t.1 ≤ (1 / 2 : ℝ)) :
    transFun gamma delta t = delta (UnitInterval.rightDouble t h) := by
  rw [transFun]
  split
  · contradiction
  · rfl

/-- The two halves of `transFun` glue continuously at their common endpoint. -/
theorem continuous_transFun (gamma : Path tau a b) (delta : Path tau b c) :
    Continuous unitInterval tau (transFun gamma delta) := by
  rw [continuous_from_unitInterval_iff]
  intro t v hv ht
  by_cases hleft : t.1 < (1 / 2 : ℝ)
  · have htle : t.1 ≤ (1 / 2 : ℝ) := le_of_lt hleft
    have hvalue := transFun_of_le gamma delta t htle
    obtain ⟨eta, heta, hgamma⟩ :=
      (continuous_from_unitInterval_iff tau gamma).mp gamma.continuous
        (UnitInterval.leftDouble t htle) v hv (hvalue ▸ ht)
    refine ⟨min ((1 / 2 : ℝ) - t.1) (eta / 2), lt_min (sub_pos.mpr hleft) (half_pos heta), ?_⟩
    intro u hu
    have habs := abs_lt.mp (lt_of_lt_of_le hu (min_le_left _ _))
    have huhalf : u.1 ≤ (1 / 2 : ℝ) := by linarith
    rw [transFun_of_le gamma delta u huhalf]
    apply hgamma
    dsimp [UnitInterval.leftDouble]
    have hsmall := abs_lt.mp (lt_of_lt_of_le hu (min_le_right _ _))
    rw [abs_lt]
    constructor <;> linarith
  · by_cases hright : (1 / 2 : ℝ) < t.1
    · have htno : ¬ t.1 ≤ (1 / 2 : ℝ) := not_le.mpr hright
      have hvalue := transFun_of_not_le gamma delta t htno
      obtain ⟨eta, heta, hdelta⟩ :=
        (continuous_from_unitInterval_iff tau delta).mp delta.continuous
          (UnitInterval.rightDouble t htno) v hv (hvalue ▸ ht)
      refine ⟨min (t.1 - (1 / 2 : ℝ)) (eta / 2),
        lt_min (sub_pos.mpr hright) (half_pos heta), ?_⟩
      intro u hu
      have habs := abs_lt.mp (lt_of_lt_of_le hu (min_le_left _ _))
      have huno : ¬ u.1 ≤ (1 / 2 : ℝ) := not_le.mpr (by linarith)
      rw [transFun_of_not_le gamma delta u huno]
      apply hdelta
      dsimp [UnitInterval.rightDouble]
      have hsmall := abs_lt.mp (lt_of_lt_of_le hu (min_le_right _ _))
      rw [abs_lt]
      constructor <;> linarith
    · have htval : t.1 = (1 / 2 : ℝ) := by linarith
      have htle : t.1 ≤ (1 / 2 : ℝ) := le_of_eq htval
      have hleftPoint : UnitInterval.leftDouble t htle = UnitInterval.one := by
        apply Subtype.ext
        dsimp [UnitInterval.leftDouble]
        linarith
      have hvalue : transFun gamma delta t = b := by
        simp only [transFun]
        split
        · rw [hleftPoint, gamma.target]
        · rename_i hbad
          exact (hbad htle).elim
      have hb : b ∈ v := hvalue ▸ ht
      obtain ⟨etaG, hetaG, hgamma⟩ :=
        (continuous_from_unitInterval_iff tau gamma).mp gamma.continuous UnitInterval.one v hv
          (gamma.target.symm ▸ hb)
      obtain ⟨etaD, hetaD, hdelta⟩ :=
        (continuous_from_unitInterval_iff tau delta).mp delta.continuous UnitInterval.zero v hv
          (delta.source.symm ▸ hb)
      refine ⟨min (etaG / 2) (etaD / 2), lt_min (half_pos hetaG) (half_pos hetaD), ?_⟩
      intro u hu
      by_cases hule : u.1 ≤ (1 / 2 : ℝ)
      · rw [transFun_of_le gamma delta u hule]
        apply hgamma
        dsimp [UnitInterval.leftDouble, UnitInterval.one]
        have hsmall := abs_lt.mp (lt_of_lt_of_le hu (min_le_left _ _))
        rw [abs_lt]
        constructor <;> linarith
      · rw [transFun_of_not_le gamma delta u hule]
        apply hdelta
        dsimp [UnitInterval.rightDouble, UnitInterval.zero]
        have hsmall := abs_lt.mp (lt_of_lt_of_le hu (min_le_right _ _))
        rw [abs_lt]
        constructor <;> linarith

/-- Concatenate paths with a common endpoint, traversing each path at twice the speed.

> **Entry**: topology.homotopy.path-concatenation-foundation -/
noncomputable def trans (gamma : Path tau a b) (delta : Path tau b c) : Path tau a c where
  toFun := transFun gamma delta
  continuous := continuous_transFun gamma delta
  source := by
    rw [show transFun gamma delta UnitInterval.zero = gamma UnitInterval.zero by
      simp [transFun, UnitInterval.leftDouble, UnitInterval.zero]]
    exact gamma.source
  target := by
    have h : ¬ (1 : ℝ) ≤ 1 / 2 := by norm_num
    rw [show transFun gamma delta UnitInterval.one = delta UnitInterval.one by
      simp only [transFun]
      split
      · rename_i hh
        exact (h (by simpa using hh)).elim
      · congr 1
        apply Subtype.ext
        norm_num [UnitInterval.rightDouble, UnitInterval.one]]
    exact delta.target

/-- On the left half, concatenation follows the first path at twice the speed. -/
theorem trans_apply_of_le (gamma : Path tau a b) (delta : Path tau b c) (t : UnitInterval)
    (h : t.1 ≤ (1 / 2 : ℝ)) :
    gamma.trans delta t = gamma (UnitInterval.leftDouble t h) :=
  transFun_of_le gamma delta t h

/-- On the right half, concatenation follows the second path at twice the speed. -/
theorem trans_apply_of_not_le (gamma : Path tau a b) (delta : Path tau b c) (t : UnitInterval)
    (h : ¬ t.1 ≤ (1 / 2 : ℝ)) :
    gamma.trans delta t = delta (UnitInterval.rightDouble t h) :=
  transFun_of_not_le gamma delta t h

end Path

/-- A loop based at `a` is a path which starts and ends at `a`.

> **Entry**: topology.homotopy.path-definition-foundation -/
def Loop (τX : TextbookTopology X) (a : X) := Path τX a a

/-- The constant path is the constant loop at its base point. -/
def loopRefl (τX : TextbookTopology X) (a : X) : Loop τX a :=
  Path.refl τX a

end SandronesLibrary.Topology.TextbookTopology
