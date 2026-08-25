/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.SetTheory.HereditaryNatPowerRank
import SandronesLibrary.SetTheory.OrdinalPowerBridge

/-!
# 遗传指数族 `B^(B^k)` 的 Goodstein 借位

本文件处理 `head + B^(B^k)` 的换底减一步，其中 `k` 是正的合法数字。新数值
`q^(q^k)-1` 不再靠有限位数的手工借位展开，而是交给一般遗传自然数编码器重新编码。
-/

namespace SandronesLibrary.SetTheory.Googology

open SandronesLibrary.SetTheory.Ordinal

noncomputable section

/--
> **Entry**: settheory.googology.goodstein-hereditary-power-exponent-borrow
> **一句话**: 正数字 `k` 的参数族 `head+B^(B^k)` 在升底减一并完全重编码后，数值正确且 `ω` 度量严格下降。
> **依赖**: `settheory.googology.hereditary-natural-power-rank`、
>   `settheory.ordinal.power-bridge`
> **mathlib**: `Ordinal.natCast_lt_omega0`、`Ordinal.opow_le_opow_right`

`head + B^(B^k)` 这一族表达式的带证书数据，其中 `k` 是正的合法数字。
-/
structure HereditaryPowerExponentBorrowForm (base : ℕ) where
  base_ge_two : 2 ≤ base
  exponent : ℕ
  exponent_positive : 0 < exponent
  exponent_valid : exponent < base
  head : HereditaryBaseExpr
  head_valid : head.Valid base

/-- 内层遗传指数 `B^k`。 -/
def HereditaryPowerExponentBorrowForm.exponentExpression {base : ℕ}
    (f : HereditaryPowerExponentBorrowForm base) : HereditaryBaseExpr :=
  .basePow (.digit f.exponent)

/-- 原表达式 `head + B^(B^k)`。 -/
def HereditaryPowerExponentBorrowForm.expression {base : ℕ}
    (f : HereditaryPowerExponentBorrowForm base) : HereditaryBaseExpr :=
  .add f.head (.basePow f.exponentExpression)

/-- 在新底数 `q=base+1` 下，把自然数 `q^(q^k)-1` 整体重新编码。 -/
def HereditaryPowerExponentBorrowForm.borrowedTail {base : ℕ}
    (f : HereditaryPowerExponentBorrowForm base) : HereditaryBaseExpr :=
  let q := base + 1
  hereditaryNatEncode q (le_trans f.base_ge_two (Nat.le_succ base))
    (q ^ (q ^ f.exponent) - 1)

/-- 保留头部，并用带证书的借位编码替换末尾幂。 -/
def HereditaryPowerExponentBorrowForm.borrowedExpression {base : ℕ}
    (f : HereditaryPowerExponentBorrowForm base) : HereditaryBaseExpr :=
  .add f.head f.borrowedTail

private theorem HereditaryBaseExpr.valid_at_next {e : HereditaryBaseExpr}
    {base : ℕ} (h : e.Valid base) : e.Valid (base + 1) := by
  induction e with
  | zero => trivial
  | digit n => exact lt_trans h (Nat.lt_succ_self base)
  | add left right leftIH rightIH => exact ⟨leftIH h.1, rightIH h.2⟩
  | mul left right leftIH rightIH => exact ⟨leftIH h.1, rightIH h.2⟩
  | basePow exponent exponentIH => exact exponentIH h

private theorem HereditaryPowerExponentBorrowForm.exponentProtocol {base : ℕ}
    (f : HereditaryPowerExponentBorrowForm base) :
    f.exponentExpression.Valid base ∧
      f.exponentExpression.eval (base + 1) = (base + 1) ^ f.exponent ∧
      f.exponentExpression.omegaValue =
        ordinalPow Ordinal.omega0 (f.exponent : Ordinal) := by
  exact ⟨f.exponent_valid, by
    simp [HereditaryPowerExponentBorrowForm.exponentExpression,
      HereditaryBaseExpr.eval], by
    rfl⟩

private theorem borrowedNumber_lt_power {base k : ℕ} :
    (base + 1) ^ ((base + 1) ^ k) - 1 <
      (base + 1) ^ ((base + 1) ^ k) := by
  have hpos : 0 < (base + 1) ^ ((base + 1) ^ k) :=
    pow_pos (Nat.succ_pos base) _
  omega

private theorem natPower_lt_omegaPower {q k : ℕ} (hk : 0 < k) :
    ((q ^ k : ℕ) : Ordinal) <
      ordinalPow Ordinal.omega0 (k : Ordinal) := by
  have hfinite : ((q ^ k : ℕ) : Ordinal) < Ordinal.omega0 :=
    Ordinal.natCast_lt_omega0 (q ^ k)
  have hone_le_k : (1 : Ordinal) ≤ (k : Ordinal) := by
    exact_mod_cast hk
  have homega_le : Ordinal.omega0 ≤ ordinalPow Ordinal.omega0 (k : Ordinal) := by
    rw [ordinalPow_eq_opow]
    simpa using Ordinal.opow_le_opow_right Ordinal.omega0_pos hone_le_k
  exact hfinite.trans_le homega_le

private theorem HereditaryPowerExponentBorrowForm.borrowedTail_omega_lt {base : ℕ}
    (f : HereditaryPowerExponentBorrowForm base) :
    f.borrowedTail.omegaValue <
      ordinalPow Ordinal.omega0
        (ordinalPow Ordinal.omega0 (f.exponent : Ordinal)) := by
  let q := base + 1
  have hq : 2 ≤ q := le_trans f.base_ge_two (Nat.le_succ base)
  have hnumber : q ^ (q ^ f.exponent) - 1 < q ^ (q ^ f.exponent) := by
    simp [q, borrowedNumber_lt_power (base := base) (k := f.exponent)]
  have hencoded :
      (hereditaryNatEncode q hq (q ^ (q ^ f.exponent) - 1)).omegaValue <
        ordinalPow Ordinal.omega0 ((q ^ f.exponent : ℕ) : Ordinal) :=
    hereditaryNatEncode_lt_power_omegaValue hq hnumber
  have hexponent : ((q ^ f.exponent : ℕ) : Ordinal) <
      ordinalPow Ordinal.omega0 (f.exponent : Ordinal) :=
    natPower_lt_omegaPower (q := q) (k := f.exponent) f.exponent_positive
  have houter :
      ordinalPow Ordinal.omega0 ((q ^ f.exponent : ℕ) : Ordinal) <
        ordinalPow Ordinal.omega0
          (ordinalPow Ordinal.omega0 (f.exponent : Ordinal)) :=
    omegaPow_lt_omegaPow_iff.mpr hexponent
  change
    (hereditaryNatEncode q hq (q ^ (q ^ f.exponent) - 1)).omegaValue <
      ordinalPow Ordinal.omega0
        (ordinalPow Ordinal.omega0 (f.exponent : Ordinal))
  exact hencoded.trans houter

/-- 对整个参数族证明换底减一后的数值规格、合法性与严格序数下降。 -/
theorem hereditaryPowerExponent_goodstein_borrow_descent {base : ℕ}
    (f : HereditaryPowerExponentBorrowForm base) :
    f.expression.Valid base ∧
      goodsteinStep base f.expression =
        f.head.eval (base + 1) +
          ((base + 1) ^ ((base + 1) ^ f.exponent) - 1) ∧
      f.borrowedExpression.Valid (base + 1) ∧
      f.borrowedExpression.eval (base + 1) = goodsteinStep base f.expression ∧
      f.borrowedExpression.omegaValue < f.expression.omegaValue := by
  let q := base + 1
  have hq : 2 ≤ q := le_trans f.base_ge_two (Nat.le_succ base)
  rcases f.exponentProtocol with
    ⟨hexponent_valid, hexponent_eval, hexponent_omega⟩
  have hhead_next : f.head.Valid q :=
    HereditaryBaseExpr.valid_at_next f.head_valid
  have houter_pos : 0 < q ^ (q ^ f.exponent) :=
    pow_pos (Nat.succ_pos base) _
  have hborrowed := hereditaryNatEncode_valid_eval q hq
    (q ^ (q ^ f.exponent) - 1)
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact ⟨f.head_valid, hexponent_valid⟩
  · simp only [goodsteinStep, hereditaryBaseChangeValue,
      HereditaryPowerExponentBorrowForm.expression,
      HereditaryPowerExponentBorrowForm.exponentExpression,
      HereditaryBaseExpr.eval]
    rw [Nat.add_sub_assoc
      (Nat.one_le_iff_ne_zero.mpr (Nat.ne_of_gt houter_pos))]
  · exact ⟨hhead_next, hborrowed.1⟩
  · simp only [HereditaryPowerExponentBorrowForm.borrowedExpression,
      HereditaryPowerExponentBorrowForm.borrowedTail,
      HereditaryPowerExponentBorrowForm.expression,
      HereditaryPowerExponentBorrowForm.exponentExpression,
      goodsteinStep, hereditaryBaseChangeValue, HereditaryBaseExpr.eval]
    rw [hborrowed.2, Nat.add_sub_assoc
      (Nat.one_le_iff_ne_zero.mpr (Nat.ne_of_gt houter_pos))]
  · simp only [HereditaryPowerExponentBorrowForm.borrowedExpression,
      HereditaryPowerExponentBorrowForm.expression,
      HereditaryBaseExpr.omegaValue]
    rw [hexponent_omega]
    rw [show ordinalAdd f.head.omegaValue f.borrowedTail.omegaValue =
          f.head.omegaValue + f.borrowedTail.omegaValue by simp [ordinalAdd],
      show ordinalAdd f.head.omegaValue
          (ordinalPow Ordinal.omega0
            (ordinalPow Ordinal.omega0 (f.exponent : Ordinal))) =
          f.head.omegaValue +
            ordinalPow Ordinal.omega0
              (ordinalPow Ordinal.omega0 (f.exponent : Ordinal)) by
        simp [ordinalAdd]]
    exact (add_lt_add_iff_left f.head.omegaValue).2 f.borrowedTail_omega_lt

end
end SandronesLibrary.SetTheory.Googology
