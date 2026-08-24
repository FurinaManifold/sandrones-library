/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.SetTheory.GoodsteinFinitePowerBorrow

/-!
# SetTheory / GoodsteinHereditaryExponentBorrow —— 底数自身作为指数

本文件从数字指数 `k` 推进到真正嵌套的指数族 `B^(B¹)`。它不是
一个固定数值算例：底数和前缀均为参数。升底后，内层 `B¹` 的值是
`q=base+1`，因而复用有限幂递归展开来编码 `q^q-1`。
-/

namespace SandronesLibrary.SetTheory.Googology

open SandronesLibrary.SetTheory.Ordinal

noncomputable section

/--
遗传指数 `B¹` 的带证书正规子类。底数至少为二，所以内层指数数字
`1` 在当前底数下合法。
-/
structure BaseExponentOneNormalForm (base : ℕ) where
  base_ge_two : 2 ≤ base

/-- 指数表达式 `B¹`；它将作为另一个底数幂的指数子树。 -/
def BaseExponentOneNormalForm.expression {base : ℕ}
    (_ : BaseExponentOneNormalForm base) : HereditaryBaseExpr :=
  .basePow (.digit 1)

/--
指数协议的三项基本事实：它在原底数下合法，在新底数下求值为
`base+1`，并且把底数换成 `ω` 后的序数值为 `ω`。
-/
theorem BaseExponentOneNormalForm.protocol {base : ℕ}
    (e : BaseExponentOneNormalForm base) :
    e.expression.Valid base ∧
      e.expression.eval (base + 1) = base + 1 ∧
      e.expression.omegaValue = Ordinal.omega0 := by
  have hone_lt_base : 1 < base := lt_of_lt_of_le Nat.one_lt_two e.base_ge_two
  refine ⟨hone_lt_base, by simp [BaseExponentOneNormalForm.expression,
    HereditaryBaseExpr.eval], ?_⟩
  simp only [BaseExponentOneNormalForm.expression, HereditaryBaseExpr.omegaValue]
  change ordinalPow Ordinal.omega0 (Order.succ 0) = Ordinal.omega0
  rw [ordinalPow_succ, ordinalPow_zero]
  simp [ordinalMul]

/--
外层借位形 `head + B^(B¹)`。指数不是数字叶子，而是一棵包含底数幂的
遗传表达式。
-/
structure HereditaryBaseExponentTailBorrowForm (base : ℕ) where
  exponent : BaseExponentOneNormalForm base
  head : HereditaryBaseExpr
  head_valid : head.Valid base

/-- 借位前的真正嵌套表达式 `head + B^(B¹)`。 -/
def HereditaryBaseExponentTailBorrowForm.expression {base : ℕ}
    (f : HereditaryBaseExponentTailBorrowForm base) : HereditaryBaseExpr :=
  .add f.head (.basePow f.exponent.expression)

/--
升底后内层指数求值为 `base+1`，因此用有限幂递归展开编码
`(base+1)^(base+1)-1`。
-/
def HereditaryBaseExponentTailBorrowForm.borrowedExpression {base : ℕ}
    (f : HereditaryBaseExponentTailBorrowForm base) : HereditaryBaseExpr :=
  .add f.head (finitePowerBorrowExpansion base (base + 1))

private theorem HereditaryBaseExpr.valid_at_next {e : HereditaryBaseExpr}
    {base : ℕ} (hvalid : e.Valid base) : e.Valid (base + 1) := by
  induction e with
  | zero => trivial
  | digit n => exact lt_trans hvalid (Nat.lt_succ_self base)
  | add left right leftIH rightIH =>
      exact ⟨leftIH hvalid.1, rightIH hvalid.2⟩
  | mul left right leftIH rightIH =>
      exact ⟨leftIH hvalid.1, rightIH hvalid.2⟩
  | basePow exponent exponentIH => exact exponentIH hvalid

private theorem finitePowerBorrowExpansion_valid_at_full_digit_range (base : ℕ) :
    ∀ k, k ≤ base + 1 →
      (finitePowerBorrowExpansion base k).Valid (base + 1)
  | 0, _ => by trivial
  | k + 1, hk => by
      simp only [finitePowerBorrowExpansion, HereditaryBaseExpr.Valid]
      exact ⟨⟨Nat.lt_of_succ_le hk, Nat.lt_succ_self base⟩,
        finitePowerBorrowExpansion_valid_at_full_digit_range base k
          (Nat.le_trans (Nat.le_succ k) hk)⟩

private theorem ordinalPow_omega_nat (k : ℕ) :
    ordinalPow Ordinal.omega0 (k : Ordinal) =
      Ordinal.omega0 ^ (k : Ordinal) := by
  induction k with
  | zero => simp [ordinalPow_zero]
  | succ k ih =>
      change ordinalPow Ordinal.omega0 (Order.succ (k : Ordinal)) =
        Ordinal.omega0 ^ Order.succ (k : Ordinal)
      rw [ordinalPow_succ, Ordinal.opow_succ, ih]
      simp [ordinalMul]

/--
> **Entry**: settheory.googology.goodstein-hereditary-base-exponent-borrow
> **一句话**: 参数化嵌套族 `head+B^(B¹)` 换底减一后可递归重编码，且其 `ω` 度量严格下降。
> **依赖**: `settheory.googology.goodstein-finite-power-borrow`、
>   `settheory.googology.goodstein-ordinal-measure`
> **mathlib**: `Order.IsNormal.strictMono`、`Ordinal.natCast_lt_omega0`
-/
theorem hereditaryBaseExponent_goodstein_borrow_descent {base : ℕ}
    (f : HereditaryBaseExponentTailBorrowForm base) :
    f.expression.Valid base ∧
      goodsteinStep base f.expression =
        f.head.eval (base + 1) + ((base + 1) ^ (base + 1) - 1) ∧
      f.borrowedExpression.Valid (base + 1) ∧
      f.borrowedExpression.eval (base + 1) = goodsteinStep base f.expression ∧
      f.borrowedExpression.omegaValue < f.expression.omegaValue := by
  rcases f.exponent.protocol with ⟨hexponent_valid, hexponent_eval, hexponent_omega⟩
  have hhead_next : f.head.Valid (base + 1) :=
    HereditaryBaseExpr.valid_at_next f.head_valid
  have hpow_positive : 0 < (base + 1) ^ (base + 1) :=
    pow_pos (by omega) (base + 1)
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact ⟨f.head_valid, hexponent_valid⟩
  · simp only [goodsteinStep, hereditaryBaseChangeValue,
      HereditaryBaseExponentTailBorrowForm.expression,
      HereditaryBaseExpr.eval]
    rw [hexponent_eval]
    rw [Nat.add_sub_assoc (Nat.one_le_iff_ne_zero.mpr (Nat.ne_of_gt hpow_positive))]
  · exact ⟨hhead_next,
      finitePowerBorrowExpansion_valid_at_full_digit_range base (base + 1) le_rfl⟩
  · simp only [HereditaryBaseExponentTailBorrowForm.borrowedExpression,
      HereditaryBaseExponentTailBorrowForm.expression, goodsteinStep,
      hereditaryBaseChangeValue, HereditaryBaseExpr.eval]
    rw [hexponent_eval]
    rw [finitePowerBorrowExpansion_eval,
      Nat.add_sub_assoc (Nat.one_le_iff_ne_zero.mpr (Nat.ne_of_gt hpow_positive))]
  · simp only [HereditaryBaseExponentTailBorrowForm.borrowedExpression,
      HereditaryBaseExponentTailBorrowForm.expression,
      HereditaryBaseExpr.omegaValue]
    rw [hexponent_omega]
    have hfinite :
        (finitePowerBorrowExpansion base (base + 1)).omegaValue <
          ordinalPow Ordinal.omega0 ((base + 1 : ℕ) : Ordinal) := by
      rw [ordinalPow_omega_nat]
      exact finitePowerBorrowExpansion_omega_lt base (base + 1)
    have hindex : ((base + 1 : ℕ) : Ordinal) < Ordinal.omega0 :=
      Ordinal.natCast_lt_omega0 (base + 1)
    have houter : ordinalPow Ordinal.omega0 ((base + 1 : ℕ) : Ordinal) <
        ordinalPow Ordinal.omega0 Ordinal.omega0 :=
      (exponentiation_isNormal Ordinal.one_lt_omega0).1 hindex
    have htail := hfinite.trans houter
    rw [show ordinalAdd f.head.omegaValue
          (finitePowerBorrowExpansion base (base + 1)).omegaValue =
          f.head.omegaValue +
            (finitePowerBorrowExpansion base (base + 1)).omegaValue by simp [ordinalAdd],
      show ordinalAdd f.head.omegaValue
          (ordinalPow Ordinal.omega0 Ordinal.omega0) =
          f.head.omegaValue + ordinalPow Ordinal.omega0 Ordinal.omega0 by
            simp [ordinalAdd]]
    exact (add_lt_add_iff_left f.head.omegaValue).2 htail

end

end SandronesLibrary.SetTheory.Googology
