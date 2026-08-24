/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.SetTheory.GoodsteinHigherBorrow

/-!
# SetTheory / GoodsteinFinitePowerBorrow —— 有限指数幂的递归借位

对新底数 `q=base+1`，本文件递归展开 `q^k-1`：
`q^(k+1)-1 = q^k·base + (q^k-1)`。这给出任意正有限数字指数
`0<k<base` 的显式借位，但不处理指数本身需要遗传展开的情形。
-/

namespace SandronesLibrary.SetTheory.Googology

open SandronesLibrary.SetTheory.Ordinal

noncomputable section

/--
在新底数 `base+1` 下对 `(base+1)^k-1` 的递归遗传展开。系数
`base` 是新底数下的最大合法数字。
-/
def finitePowerBorrowExpansion (base : ℕ) : ℕ → HereditaryBaseExpr
  | 0 => .zero
  | k + 1 =>
      .add (.mul (.basePow (.digit k)) (.digit base))
        (finitePowerBorrowExpansion base k)

/--
以有限正数字为指数的带证书借位形。`exponent_valid` 保证指数叶子
在原底数下合法；这正是本条与任意遗传指数之间的边界。
-/
structure FinitePowerBorrowForm (base : ℕ) where
  base_ge_two : 2 ≤ base
  exponent : ℕ
  exponent_positive : 0 < exponent
  exponent_valid : exponent < base
  head : HereditaryBaseExpr
  head_valid : head.Valid base

/-- 借位前的表达式 `head + B^exponent`。 -/
def FinitePowerBorrowForm.expression {base : ℕ}
    (f : FinitePowerBorrowForm base) : HereditaryBaseExpr :=
  .add f.head (.basePow (.digit f.exponent))

/-- 换到新底数后，以递归展开替换末尾的底数幂。 -/
def FinitePowerBorrowForm.borrowedExpression {base : ℕ}
    (f : FinitePowerBorrowForm base) : HereditaryBaseExpr :=
  .add f.head (finitePowerBorrowExpansion base f.exponent)

private theorem HereditaryBaseExpr.valid_at_larger_base {e : HereditaryBaseExpr}
    {oldBase newBase : ℕ} (hvalid : e.Valid oldBase) (hbase : oldBase ≤ newBase) :
    e.Valid newBase := by
  induction e with
  | zero => trivial
  | digit n => exact lt_of_lt_of_le hvalid hbase
  | add left right leftIH rightIH =>
      exact ⟨leftIH hvalid.1, rightIH hvalid.2⟩
  | mul left right leftIH rightIH =>
      exact ⟨leftIH hvalid.1, rightIH hvalid.2⟩
  | basePow exponent exponentIH => exact exponentIH hvalid

theorem finitePowerBorrowExpansion_eval (base k : ℕ) :
    (finitePowerBorrowExpansion base k).eval (base + 1) =
      (base + 1) ^ k - 1 := by
  induction k with
  | zero => simp [finitePowerBorrowExpansion, HereditaryBaseExpr.eval]
  | succ k ih =>
      simp only [finitePowerBorrowExpansion, HereditaryBaseExpr.eval, ih]
      rw [← Nat.add_sub_assoc (Nat.one_le_pow k (base + 1) (by omega))]
      simp [Nat.pow_succ, Nat.mul_add]

theorem finitePowerBorrowExpansion_valid {base k : ℕ} (hk : k ≤ base) :
    (finitePowerBorrowExpansion base k).Valid (base + 1) := by
  induction k with
  | zero => trivial
  | succ k ih =>
      simp only [finitePowerBorrowExpansion, HereditaryBaseExpr.Valid]
      exact ⟨⟨lt_trans (Nat.lt_of_succ_le hk) (Nat.lt_succ_self base),
          Nat.lt_succ_self base⟩,
        ih (Nat.le_trans (Nat.le_succ k) hk)⟩

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

theorem finitePowerBorrowExpansion_omega_lt (base : ℕ) :
    ∀ k, (finitePowerBorrowExpansion base k).omegaValue <
      Ordinal.omega0 ^ (k : Ordinal)
  | 0 => by simp [finitePowerBorrowExpansion, HereditaryBaseExpr.omegaValue]
  | k + 1 => by
      simp only [finitePowerBorrowExpansion, HereditaryBaseExpr.omegaValue,
        ordinalPow_omega_nat]
      rw [show ordinalMul (Ordinal.omega0 ^ (k : Ordinal)) base =
          (Ordinal.omega0 ^ (k : Ordinal)) * base by simp [ordinalMul],
        show ordinalAdd ((Ordinal.omega0 ^ (k : Ordinal)) * base)
            (finitePowerBorrowExpansion base k).omegaValue =
          (Ordinal.omega0 ^ (k : Ordinal)) * base +
            (finitePowerBorrowExpansion base k).omegaValue by simp [ordinalAdd]]
      have hsucc_cast : (((k + 1 : ℕ) : Ordinal)) =
          Order.succ (k : Ordinal) := by
        norm_num [Order.succ_eq_add_one]
      rw [hsucc_cast]
      exact Ordinal.opow_mul_add_lt_opow
        (Ordinal.natCast_lt_omega0 base)
        (finitePowerBorrowExpansion_omega_lt base k) (Order.lt_succ _)

/--
> **Entry**: settheory.googology.goodstein-finite-power-borrow
> **一句话**: 对 `0<k<base` 的有限数字指数，`head+B^k` 换底减一后有递归的合法重编码，且其 `ω` 度量严格下降。
> **依赖**: `settheory.googology.goodstein-base-power-two-borrow`、
>   `settheory.googology.goodstein-ordinal-measure`
> **mathlib**: `Ordinal.opow_mul_add_lt_opow`、`Ordinal.natCast_lt_omega0`
-/
theorem finitePower_goodstein_borrow_descent {base : ℕ}
    (f : FinitePowerBorrowForm base) :
    f.expression.Valid base ∧
      goodsteinStep base f.expression =
        f.head.eval (base + 1) + ((base + 1) ^ f.exponent - 1) ∧
      f.borrowedExpression.Valid (base + 1) ∧
      f.borrowedExpression.eval (base + 1) = goodsteinStep base f.expression ∧
      f.borrowedExpression.omegaValue < f.expression.omegaValue := by
  have hhead_next : f.head.Valid (base + 1) :=
    HereditaryBaseExpr.valid_at_larger_base f.head_valid (Nat.le_succ base)
  have hpow_positive : 0 < (base + 1) ^ f.exponent :=
    pow_pos (by omega) f.exponent
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact ⟨f.head_valid, f.exponent_valid⟩
  · simp only [goodsteinStep, hereditaryBaseChangeValue,
      FinitePowerBorrowForm.expression, HereditaryBaseExpr.eval]
    rw [Nat.add_sub_assoc (Nat.one_le_iff_ne_zero.mpr (Nat.ne_of_gt hpow_positive))]
  · exact ⟨hhead_next,
      finitePowerBorrowExpansion_valid (Nat.le_of_lt f.exponent_valid)⟩
  · simp only [FinitePowerBorrowForm.borrowedExpression,
      FinitePowerBorrowForm.expression, goodsteinStep,
      hereditaryBaseChangeValue, HereditaryBaseExpr.eval]
    rw [finitePowerBorrowExpansion_eval,
      Nat.add_sub_assoc (Nat.one_le_iff_ne_zero.mpr (Nat.ne_of_gt hpow_positive))]
  · simp only [FinitePowerBorrowForm.borrowedExpression,
      FinitePowerBorrowForm.expression, HereditaryBaseExpr.omegaValue,
      ordinalPow_omega_nat]
    rw [show ordinalAdd f.head.omegaValue
          (finitePowerBorrowExpansion base f.exponent).omegaValue =
          f.head.omegaValue +
            (finitePowerBorrowExpansion base f.exponent).omegaValue by simp [ordinalAdd],
      show ordinalAdd f.head.omegaValue
          (Ordinal.omega0 ^ (f.exponent : Ordinal)) =
          f.head.omegaValue + Ordinal.omega0 ^ (f.exponent : Ordinal) by
            simp [ordinalAdd]]
    exact (add_lt_add_iff_left f.head.omegaValue).2
      (finitePowerBorrowExpansion_omega_lt base f.exponent)

end

end SandronesLibrary.SetTheory.Googology
