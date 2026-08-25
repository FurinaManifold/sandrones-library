/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.SetTheory.HereditaryNatEncodingOrder

/-! # Canonical Goodstein states

This file removes the arbitrary-expression choice from a Goodstein state: the expression carried
by a state is definitionally the hereditary natural-number encoding of its value at its base.
After base change and subtraction, the next value is encoded afresh at the successor base.

The file deliberately does not claim unconditional ordinal descent.  It names the exact missing
normalization bridge and proves descent only when that bridge and positivity are supplied.
-/

namespace SandronesLibrary.SetTheory.Googology

open SandronesLibrary.SetTheory.Ordinal

noncomputable section

/-
Proof inventory:
1. The canonical expression inherits validity and evaluation from `hereditaryNatEncode_valid_eval`.
2. The successor-base state inherits the same two certificates at its new base.
3. Strict monotonicity gives conditional ordinal descent once the missing normalization bridge is
   explicitly supplied.
-/

/-- A canonical Goodstein state records only its base and value.  Its hereditary expression is
computed by the library's fixed encoder, rather than selected as extra certificate data. -/
structure CanonicalGoodsteinState where
  base : ℕ
  base_ge_two : 2 ≤ base
  value : ℕ

/-- The distinguished hereditary expression of a canonical state. -/
def CanonicalGoodsteinState.expression (s : CanonicalGoodsteinState) :
    HereditaryBaseExpr :=
  hereditaryNatEncode s.base s.base_ge_two s.value

theorem CanonicalGoodsteinState.expression_valid (s : CanonicalGoodsteinState) :
    s.expression.Valid s.base :=
  (hereditaryNatEncode_valid_eval s.base s.base_ge_two s.value).1

theorem CanonicalGoodsteinState.expression_evaluates (s : CanonicalGoodsteinState) :
    s.expression.eval s.base = s.value :=
  (hereditaryNatEncode_valid_eval s.base s.base_ge_two s.value).2

/-- Raise the base, evaluate the old canonical tree there, subtract one, and canonically encode
the resulting natural number at the new base. -/
def canonicalGoodsteinStep (s : CanonicalGoodsteinState) : CanonicalGoodsteinState where
  base := s.base + 1
  base_ge_two := s.base_ge_two.trans (Nat.le_succ s.base)
  value := goodsteinStep s.base s.expression

/--
> **Entry**: settheory.googology.canonical-goodstein-state
> **一句话**: 规范 Goodstein 状态由底数和值唯一生成遗传编码；一步换底减一后，会在新底数下重新生成合法且求值正确的规范编码。
> **依赖**: `settheory.googology.hereditary-natural-encoding`、
> `settheory.googology.hereditary-natural-encoding-strict-order`
> **mathlib**: 无（本库显式状态与编码器）
-/
theorem canonicalGoodsteinStep_specification (s : CanonicalGoodsteinState) :
    (canonicalGoodsteinStep s).base = s.base + 1 ∧
      (canonicalGoodsteinStep s).expression.Valid (s.base + 1) ∧
      (canonicalGoodsteinStep s).expression.eval (s.base + 1) =
        goodsteinStep s.base s.expression := by
  exact ⟨rfl, (canonicalGoodsteinStep s).expression_valid,
    (canonicalGoodsteinStep s).expression_evaluates⟩

/-- The fixed-universe ordinal measure of a canonical state. -/
def CanonicalGoodsteinState.ordinalMeasure (s : CanonicalGoodsteinState) : Ordinal.{0} :=
  s.expression.omegaValue

/-- Re-encode at the successor base the value obtained by evaluating the old tree there, and then
read the re-encoded tree at `ω`.  This isolates the normalization side of base change. -/
def CanonicalGoodsteinState.baseChangeReencodingMeasure
    (s : CanonicalGoodsteinState) : Ordinal.{0} :=
  (hereditaryNatEncode (s.base + 1) (s.base_ge_two.trans (Nat.le_succ s.base))
    (s.expression.eval (s.base + 1))).omegaValue

/-- The exact normalization bridge still required for unconditional one-step ordinal descent.
It is a named obligation, not a theorem asserted by this module. -/
def CanonicalBaseChangeOmegaCompatible (s : CanonicalGoodsteinState) : Prop :=
  s.baseChangeReencodingMeasure = s.ordinalMeasure

/-- Once base-change normalization preserves the old ordinal tree, subtraction of a positive
new-base value strictly lowers the ordinal measure.  The compatibility premise is intentionally
visible because it has not yet been proved for every canonical state. -/
theorem canonicalGoodsteinStep_omega_lt_of_compatible
    (s : CanonicalGoodsteinState)
    (hpositive : 0 < s.expression.eval (s.base + 1))
    (hcompatible : CanonicalBaseChangeOmegaCompatible s) :
    (canonicalGoodsteinStep s).ordinalMeasure < s.ordinalMeasure := by
  have hstep : goodsteinStep s.base s.expression < s.expression.eval (s.base + 1) := by
    simp only [goodsteinStep, hereditaryBaseChangeValue]
    exact Nat.sub_lt hpositive (by decide)
  have hbase : 2 ≤ s.base + 1 := s.base_ge_two.trans (Nat.le_succ s.base)
  have hmono := hereditaryNatEncode_omega_strictMono (s.base + 1) hbase hstep
  change (hereditaryNatEncode (s.base + 1) _
      (goodsteinStep s.base s.expression)).omegaValue < s.expression.omegaValue
  exact hmono.trans_le hcompatible.le

end
end SandronesLibrary.SetTheory.Googology
