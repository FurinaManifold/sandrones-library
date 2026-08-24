/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib.SetTheory.Ordinal.Veblen
import Mathlib.SetTheory.Ordinal.CantorNormalForm
import Mathlib.SetTheory.Ordinal.Principal
import Mathlib.SetTheory.Cardinal.Cofinality.Ordinal

/-!
# SetTheory / Ordinal —— 序数理论

本文件当前条目：

* **settheory.ordinal.order-type**：良序同构当且仅当序型相同，且自然数序型为 `ω`。
* **settheory.ordinal.transfinite-induction**：序数上的超限归纳。
* **settheory.ordinal.transfinite-recursion**：按零、后继、极限三类进行超限递归。
* **settheory.ordinal.addition**：序数加法不交换。
* **settheory.ordinal.multiplication**：序数乘法不交换。
* **settheory.ordinal.exponentiation**：序数幂的后继递推式。
* **settheory.ordinal.successor-limit**：后继序数与极限序数的基本性质。
* **settheory.ordinal.supremum**：序数族上确界的严格小于刻画。
* **settheory.ordinal.cofinality**：零、后继与 `ω` 的共尾数。
* **settheory.ordinal.normal-function**：底数大于一的序数幂函数是正规函数。
* **settheory.ordinal.cantor-normal-form**：Cantor 正规形求值还原原序数。
* **settheory.ordinal.epsilon-zero**：`ε₀` 是 `α ↦ ω^α` 的最小前不动点。
* **settheory.ordinal.no-infinite-descent**：序数严格序良基，支撑 Goodstein 下降论证。
-/

namespace SandronesLibrary.SetTheory.Ordinal

open Order

noncomputable section

/--
> **Entry**: settheory.ordinal.order-type
> **一句话**: 两个良序具有相同序型当且仅当它们序同构；自然数通常序的序型是 `ω`。
> **依赖**: 无
> **mathlib**: `Ordinal.type_eq`、`Ordinal.type_nat_lt`
-/
theorem orderType_classification {α β : Type} {r : α → α → Prop} {s : β → β → Prop}
    [IsWellOrder α r] [IsWellOrder β s] :
    (Ordinal.type r = Ordinal.type s ↔ Nonempty (r ≃r s)) ∧
      Ordinal.type (α := ℕ) (· < ·) = Ordinal.omega0 := by
  exact ⟨Ordinal.type_eq, Ordinal.type_nat_lt⟩

/--
> **Entry**: settheory.ordinal.transfinite-induction
> **一句话**: 若性质在“所有更小序数成立”时可推出当前序数成立，则它对全部序数成立。
> **依赖**: `settheory.ordinal.order-type`
> **mathlib**: `WellFoundedLT.induction`
-/
theorem transfinite_induction {P : Ordinal → Prop}
    (step : ∀ α, (∀ β < α, P β) → P α) : ∀ α, P α := by
  intro α
  exact WellFoundedLT.induction α step

/--
> **Entry**: settheory.ordinal.transfinite-recursion
> **一句话**: 序数递归可分别给出零、后继和非零极限三个分支。
> **依赖**: `settheory.ordinal.transfinite-induction`
> **mathlib**: `Ordinal.limitRecOn`
-/
def transfiniteRec {M : Ordinal → Sort*} (zero : M 0)
    (succ : ∀ α, M α → M (α + 1))
    (limit : ∀ α, IsSuccLimit α → (∀ β < α, M β) → M α) : ∀ α, M α :=
  fun α ↦ Ordinal.limitRecOn α zero succ limit

/--
> **Entry**: settheory.ordinal.addition
> **一句话**: `1 + ω = ω`，但 `ω + 1 ≠ ω`，所以序数加法不交换。
> **依赖**: 无
> **mathlib**: `Ordinal.add_omega0`、`Order.lt_succ`
-/
theorem addition_not_commutative :
    (1 : Ordinal) + Ordinal.omega0 = Ordinal.omega0 ∧
      Ordinal.omega0 + 1 ≠ Ordinal.omega0 := by
  constructor
  · exact Ordinal.add_omega0 Ordinal.one_lt_omega0
  · exact ne_of_gt (Order.lt_succ Ordinal.omega0)

/--
> **Entry**: settheory.ordinal.multiplication
> **一句话**: `2 · ω = ω`，但 `ω · 2 ≠ ω`，所以序数乘法不交换。
> **依赖**: `settheory.ordinal.addition`
> **mathlib**: `Ordinal.natCast_mul_omega0`、`Ordinal.mul_two`
-/
theorem multiplication_not_commutative :
    (2 : Ordinal) * Ordinal.omega0 = Ordinal.omega0 ∧
      Ordinal.omega0 * 2 ≠ Ordinal.omega0 := by
  constructor
  · exact Ordinal.natCast_mul_omega0 (by decide)
  · rw [Ordinal.mul_two]
    exact ne_of_gt (lt_add_of_pos_right Ordinal.omega0 Ordinal.omega0_pos)

/--
> **Entry**: settheory.ordinal.exponentiation
> **一句话**: 序数幂在后继指数处满足 `a^(b+1) = a^b · a`。
> **依赖**: `settheory.ordinal.multiplication`
> **mathlib**: `Ordinal.opow_succ`
-/
theorem exponentiation_successor (a b : Ordinal) :
    a ^ Order.succ b = a ^ b * a := Ordinal.opow_succ a b

/--
> **Entry**: settheory.ordinal.successor-limit
> **一句话**: 后继序数紧邻原序数，而 `ω` 是非零极限序数。
> **依赖**: `settheory.ordinal.order-type`
> **mathlib**: `Order.lt_succ`、`Order.lt_succ_iff`、`Ordinal.isSuccLimit_omega0`
-/
theorem successor_and_limit (a : Ordinal) :
    a < Order.succ a ∧ (∀ b, a < b → ¬ b < Order.succ a) ∧ IsSuccLimit Ordinal.omega0 := by
  refine ⟨Order.lt_succ a, ?_, Ordinal.isSuccLimit_omega0⟩
  intro b hab hbs
  exact (not_le_of_gt hab) (Order.lt_succ_iff.mp hbs)

/--
> **Entry**: settheory.ordinal.supremum
> **一句话**: 一个序数严格小于小指标序数族的上确界，当且仅当它严格小于其中某项。
> **依赖**: `settheory.ordinal.transfinite-recursion`
> **mathlib**: `Ordinal.lt_iSup_iff`
-/
theorem lt_supremum_iff {ι : Type} [Small ι] (f : ι → Ordinal) (a : Ordinal) :
    a < ⨆ i, f i ↔ ∃ i, a < f i := Ordinal.lt_iSup_iff

/--
> **Entry**: settheory.ordinal.cofinality
> **一句话**: 零的共尾数为零，后继序数的共尾数为一，而 `ω` 的共尾数为 `ℵ₀`。
> **依赖**: `settheory.ordinal.successor-limit`、`settheory.ordinal.supremum`
> **mathlib**: `Ordinal.cof_zero`、`Ordinal.cof_add_one`、`Ordinal.cof_omega0`
-/
theorem basic_cofinalities (a : Ordinal) :
    (0 : Ordinal).cof = 0 ∧ (a + 1).cof = 1 ∧ Ordinal.omega0.cof = Cardinal.aleph0 := by
  exact ⟨Ordinal.cof_zero, Ordinal.cof_add_one a, Ordinal.cof_omega0⟩

/--
> **Entry**: settheory.ordinal.normal-function
> **一句话**: 当 `1 < a` 时，函数 `β ↦ a^β` 严格递增且在极限处连续，因而是正规函数。
> **依赖**: `settheory.ordinal.exponentiation`、`settheory.ordinal.supremum`
> **mathlib**: `Ordinal.isNormal_opow`
-/
theorem exponentiation_isNormal {a : Ordinal} (ha : 1 < a) :
    IsNormal (fun β : Ordinal ↦ a ^ β) := Ordinal.isNormal_opow ha

/--
> **Entry**: settheory.ordinal.cantor-normal-form
> **一句话**: 将序数的 Cantor 正规形按 `b^指数 · 系数 + 余项` 求值，会精确还原原序数。
> **依赖**: `settheory.ordinal.exponentiation`
> **mathlib**: `Ordinal.CNF.foldr`
-/
theorem cantorNormalForm_reconstructs (b o : Ordinal) :
    (Ordinal.CNF b o).foldr (fun p r ↦ b ^ p.1 * p.2 + r) 0 = o :=
  Ordinal.CNF.foldr b o

/--
> **Entry**: settheory.ordinal.epsilon-zero
> **一句话**: `ε₀` 满足 `ω^ε₀ = ε₀`，并且不大于任何满足 `ω^α ≤ α` 的序数。
> **依赖**: `settheory.ordinal.normal-function`、`settheory.ordinal.cantor-normal-form`
> **mathlib**: `Ordinal.omega0_opow_epsilon`、`Ordinal.epsilon_zero_le_of_omega0_opow_le`
-/
theorem epsilonZero_fixed_and_least :
    Ordinal.omega0 ^ Ordinal.epsilon 0 = Ordinal.epsilon 0 ∧
      ∀ α : Ordinal, Ordinal.omega0 ^ α ≤ α → Ordinal.epsilon 0 ≤ α := by
  exact ⟨Ordinal.omega0_opow_epsilon 0, fun _ h ↦
    Ordinal.epsilon_zero_le_of_omega0_opow_le h⟩

/--
> **Entry**: settheory.ordinal.no-infinite-descent
> **一句话**: 序数的严格小于关系良基；因此任何逐步严格下降的序数过程必定终止。
> **依赖**: `settheory.ordinal.transfinite-induction`
> **mathlib**: `Ordinal.lt_wf`
-/
theorem ordinal_lt_wellFounded : WellFounded ((· < ·) : Ordinal → Ordinal → Prop) :=
  Ordinal.lt_wf

end

end SandronesLibrary.SetTheory.Ordinal
