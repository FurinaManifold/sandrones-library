/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.SetTheory.HydraOrdinalAssignment

/-!
# Strict descent for one replicated hydra cut

This file proves strict ordinal descent for a genuine stage-dependent cut: a
root has one parent branch, that parent has one head, and cutting the head
replaces the pruned parent by `stage + 1` copies.  No claim is made about all
hydra shapes or all `Hydra.Step`s.
-/

namespace SandronesLibrary.SetTheory.HydraOneLevelDescent

open SandronesLibrary.SetTheory
open SandronesLibrary.SetTheory.Ordinal
open SandronesLibrary.SetTheory.HydraOrdinalAssignment

private theorem ordinalAdd_eq_native (a b : Ordinal) : ordinalAdd a b = a + b := by
  simp [ordinalAdd]

private theorem ordinalMul_eq_native (a b : Ordinal) : ordinalMul a b = a * b := by
  simp [ordinalMul]

private theorem ordinalPow_eq_native (a b : Ordinal) : ordinalPow a b = a ^ b := by
  obtain rfl | ha := eq_or_ne a 0
  · obtain rfl | hb := eq_or_ne b 0
    · simp [ordinalPow]
    · simp [ordinalPow, hb, Ordinal.zero_opow hb]
  induction b using Ordinal.limitRecOn with
  | zero => simp [ordinalPow, ha]
  | add_one b ih =>
      rw [← Order.succ_eq_add_one b, ordinalPow_succ, ordinalMul_eq_native, ih,
        Ordinal.opow_succ]
  | limit b hb ih =>
      rw [ordinalPow_limit a b ha hb]
      have hfun : (fun x : Set.Iio b => ordinalPow a x.1) =
          (fun x : Set.Iio b => a ^ x.1) := by
        funext x
        exact ih x.1 x.2
      rw [hfun]
      exact (Ordinal.opow_limit ha hb).symm

/-- The library's finite repeated sum agrees privately with right
multiplication by a finite ordinal.  Native multiplication is used only as a
proof bridge; `ordinalRepeat` remains the public definition. -/
private theorem ordinalRepeat_eq_mul (term : Ordinal) (n : Nat) :
    ordinalRepeat term n = term * (n : Ordinal) := by
  induction n with
  | zero => simp [ordinalRepeat]
  | succ n ih =>
      rw [ordinalRepeat, ih]
      rw [ordinalAdd_eq_native]
      calc
        term + term * (n : Ordinal) = term * (1 + (n : Ordinal)) := by
          rw [mul_add, mul_one]
        _ = term * ((n : Ordinal) + 1) := by
          congr 1
          rw [← Nat.cast_one, ← Nat.cast_add, ← Nat.cast_add]
          congr 1
          omega
        _ = term * ((Nat.succ n : Nat) : Ordinal) := by
          rw [Nat.cast_succ]

/-- Any finite repetition of `ω^level` lies below the next omega power.  Both
operations in the public statement are the library's own definitions. -/
theorem ordinalRepeat_omegaPow_lt_succ (level : Ordinal) (copies : Nat) :
    ordinalRepeat (ordinalPow Ordinal.omega0 level) copies <
      ordinalPow Ordinal.omega0 (Order.succ level) := by
  rw [ordinalRepeat_eq_mul, ordinalPow_succ]
  rw [ordinalMul_eq_native, ordinalPow_eq_native]
  simpa only [Ordinal.opow_succ] using
    Ordinal.opow_mul_lt_opow (Ordinal.natCast_lt_omega0 copies)
      (Order.lt_succ level)

/-- The one-level replicated cut considered in this file.  It is an actual
hydra step for every stage, not merely a comparison of two unrelated trees. -/
def OneLevelReplicatedCut (stage : Nat) (before after : Hydra) : Prop :=
  before = .node [.node [Hydra.head]] ∧
    after = .node (List.replicate (stage + 1) (.node []))

theorem oneLevelReplicatedCut_isStep {stage : Nat} {before after : Hydra}
    (cut : OneLevelReplicatedCut stage before after) :
    Hydra.Step stage before after := by
  rcases cut with ⟨rfl, rfl⟩
  refine ⟨[0, 0], ?_, ?_⟩
  · constructor
    · simp
    · rfl
  · simp [Hydra.chop, Hydra.replaceAtWith, Hydra.head]

/-- The stage-dependent replicated cut strictly lowers the structural ordinal
assignment, however large the finite stage is. -/
theorem oneLevelReplicatedCut_decreases {stage : Nat} {before after : Hydra}
    (cut : OneLevelReplicatedCut stage before after) :
    hydraOrdinal after < hydraOrdinal before := by
  rcases cut with ⟨rfl, rfl⟩
  rw [hydraOrdinal, forestOrdinal_replicate]
  simp only [hydraOrdinal, forestOrdinal, ordinalAdd_zero]
  rw [hydraOrdinal_head, ordinalPow_zero]
  simpa only [ordinalPow_zero, Order.succ_eq_add_one, zero_add] using
    ordinalRepeat_omegaPow_lt_succ 0 (stage + 1)

/--
> **Entry**: settheory.googology.hydra-one-level-descent
> **一句话**: 一层深处的独头被砍后按阶段复制空父树，这个真实 Hydra 单步使本库结构序数赋值严格下降。
> **依赖**: `settheory.googology.hydra-ordinal-assignment`
> **mathlib**: `Ordinal.opow_mul_lt_opow`、`Ordinal.natCast_lt_omega0`

This packages legality and descent only for `OneLevelReplicatedCut`; it is not
a termination theorem for arbitrary hydras.
-/
theorem oneLevelReplicatedCut_verified {stage : Nat} {before after : Hydra}
    (cut : OneLevelReplicatedCut stage before after) :
    Hydra.Step stage before after ∧ hydraOrdinal after < hydraOrdinal before := by
  exact ⟨oneLevelReplicatedCut_isStep cut, oneLevelReplicatedCut_decreases cut⟩

end SandronesLibrary.SetTheory.HydraOneLevelDescent
