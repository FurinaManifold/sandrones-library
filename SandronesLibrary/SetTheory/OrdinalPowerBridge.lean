/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.SetTheory.Ordinal

/-!
# SetTheory / OrdinalPowerBridge —— 本库序数幂与 mathlib 序数幂的桥

Goodstein 的遗传底数表达式使用本库的 `ordinalPow`。不管是比较两个
`omega`—幂，还是调用 mathlib 中已经证明的 Cantor 项引理，都需要一条
公开而精确的运算对应。本文件只提供这条对应及其直接的指数比较接口。
-/

namespace SandronesLibrary.SetTheory.Ordinal

noncomputable section

universe u

/--
> **Entry**: settheory.ordinal.power-bridge
> **一句话**: 本库按零、后继和极限分支定义的序数幂，在任意底数和指数上都等于 mathlib 序数幂。
> **依赖**: `settheory.ordinal.exponentiation`
> **mathlib**: `Ordinal.limitRecOn`、`Ordinal.opow_succ`、`Ordinal.opow_limit`
-/
theorem ordinalPow_eq_opow (a b : Ordinal.{u}) :
    ordinalPow a b = a ^ b := by
  obtain rfl | ha := eq_or_ne a 0
  · obtain rfl | hb := eq_or_ne b 0
    · simp [ordinalPow]
    · simp [ordinalPow, hb, Ordinal.zero_opow hb]
  induction b using Ordinal.limitRecOn with
  | zero => simp [ordinalPow, ha]
  | add_one b ih =>
      rw [← Order.succ_eq_add_one b, ordinalPow_succ, ih, Ordinal.opow_succ]
      simp [ordinalMul]
  | limit b hb ih =>
      rw [ordinalPow_limit a b ha hb]
      have hfun : (fun x : Set.Iio b => ordinalPow a x.1) =
          (fun x : Set.Iio b => a ^ x.1) := by
        funext x
        exact ih x.1 x.2
      rw [hfun]
      exact (Ordinal.opow_limit ha hb).symm

/--
底数严格大于一时，比较两个本库序数幂等价于比较它们的指数。
这是从通用桥直接转移的顺序接口，不是新的幂定义。
-/
theorem ordinalPow_lt_ordinalPow_iff {a b c : Ordinal} (ha : 1 < a) :
    ordinalPow a b < ordinalPow a c ↔ b < c := by
  rw [ordinalPow_eq_opow, ordinalPow_eq_opow]
  exact Ordinal.opow_lt_opow_iff_right ha

/--
Goodstein 度量最常用的专用形式：`omega`—幂严格大小完全由指数决定。
-/
theorem omegaPow_lt_omegaPow_iff {a b : Ordinal} :
    ordinalPow Ordinal.omega0 a < ordinalPow Ordinal.omega0 b ↔ a < b := by
  exact ordinalPow_lt_ordinalPow_iff Ordinal.one_lt_omega0

end

end SandronesLibrary.SetTheory.Ordinal
