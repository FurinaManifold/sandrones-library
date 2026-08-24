/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.SetTheory.GoodsteinHereditaryExponentBorrow

/-! # Hereditary natural-number encoding

This file constructs a genuine hereditary base representation by repeated quotient and remainder.
-/

namespace SandronesLibrary.SetTheory.Googology

open SandronesLibrary.SetTheory.Ordinal

noncomputable section

/-- Horner hereditary encoding: recursively encode the quotient, multiply it by the base, then add
the remainder digit. -/
def hereditaryNatEncode (base : ℕ) (hbase : 2 ≤ base) (n : ℕ) : HereditaryBaseExpr :=
  Nat.strongRec (motive := fun _ => HereditaryBaseExpr) (fun n rec =>
    if hn : n = 0 then .zero else
      .add (.mul
        (rec (n / base) (Nat.div_lt_self (Nat.pos_of_ne_zero hn)
          (lt_of_lt_of_le Nat.one_lt_two hbase)))
        (.basePow (.digit 1))) (.digit (n % base))) n

theorem hereditaryNatEncode_zero (base : ℕ) (hbase : 2 ≤ base) :
    hereditaryNatEncode base hbase 0 = .zero := by
  rw [hereditaryNatEncode, Nat.strongRec_eq]
  simp

theorem hereditaryNatEncode_of_pos (base : ℕ) (hbase : 2 ≤ base)
    {n : ℕ} (hn : 0 < n) :
    hereditaryNatEncode base hbase n =
      .add (.mul (hereditaryNatEncode base hbase (n / base))
        (.basePow (.digit 1))) (.digit (n % base)) := by
  rw [hereditaryNatEncode, Nat.strongRec_eq]
  simp only [dif_neg (Nat.ne_of_gt hn)]
  rfl

/--
> **Entry**: settheory.googology.hereditary-natural-encoding
> **一句话**: 对任意 `base≥2` 和自然数 `n`，商余递归构造合法遗传基表达式，且其求值精确等于 `n`。
> **依赖**: `settheory.googology.hereditary-base`
> **mathlib**: `Nat.strongRec`、`Nat.div_add_mod`
-/
theorem hereditaryNatEncode_valid_eval (base : ℕ) (hbase : 2 ≤ base) :
    ∀ n, (hereditaryNatEncode base hbase n).Valid base ∧
      (hereditaryNatEncode base hbase n).eval base = n := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n ih =>
      obtain rfl | hn := n.eq_zero_or_pos
      · simp [hereditaryNatEncode_zero, HereditaryBaseExpr.Valid,
          HereditaryBaseExpr.eval]
      · rw [hereditaryNatEncode_of_pos base hbase hn]
        have hdiv : n / base < n := Nat.div_lt_self hn
          (lt_of_lt_of_le Nat.one_lt_two hbase)
        have hrec := ih (n / base) hdiv
        constructor
        · exact ⟨⟨hrec.1, lt_of_lt_of_le Nat.one_lt_two hbase⟩,
            Nat.mod_lt n (by omega)⟩
        · simp only [HereditaryBaseExpr.eval, hrec.2, pow_one]
          rw [Nat.mul_comm, Nat.div_add_mod]

/-- A mechanically available strict ordinal ceiling for the encoded tree.  It contains no
comparison information about different inputs and is insufficient for a general borrow lemma. -/
def hereditaryNatEncodeOmegaCeiling (base : ℕ) (hbase : 2 ≤ base) (n : ℕ) : Ordinal :=
  Order.succ (hereditaryNatEncode base hbase n).omegaValue

theorem hereditaryNatEncode_omega_lt_ceiling (base : ℕ) (hbase : 2 ≤ base) (n : ℕ) :
    (hereditaryNatEncode base hbase n).omegaValue <
      hereditaryNatEncodeOmegaCeiling base hbase n :=
  Order.lt_succ _

end
end SandronesLibrary.SetTheory.Googology
