/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.FunctionalAnalysis.FredholmIndex

/-!
# Fredholm 备择

本文件用第二窗已经建立的有限维核、有限维余核与指数零，完成恒等减紧算子的
单射／满射备择。它不导入 Mathlib 的最终 compact Fredholm alternative package。
-/

namespace SandronesLibrary.FunctionalAnalysis

open Function

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]

/-- **Fredholm alternative.** Banach 空间上紧算子 `K` 的恒等扰动 `I-K` 单射当且仅当满射。

> **Entry**: functional-analysis.fredholm.alternative-final
-/
theorem identitySubCompact_injective_iff_surjective (K : E →L[ℝ] E)
    (hK : IsCompactOperator K) :
    Function.Injective (identitySubCompact K) ↔
      Function.Surjective (identitySubCompact K) := by
  let D := identitySubCompact K
  let _ : FiniteDimensional ℝ D.ker :=
    finiteDimensional_kernel_identitySubCompact K hK
  let _ : FiniteDimensional ℝ (E ⧸ D.range) :=
    finiteDimensional_cokernel_identitySubCompact K hK
  have hindex : D.toLinearMap.index = 0 := index_identitySubCompact_eq_zero K hK
  change Function.Injective D ↔ Function.Surjective D
  constructor
  · intro hinj
    have hi := LinearMap.index_of_injective (f := D.toLinearMap) hinj
    rw [hindex] at hi
    have hfin : Module.finrank ℝ (E ⧸ D.range) = 0 := by omega
    have hall : ∀ x : E ⧸ D.range, x = 0 :=
      finrank_zero_iff_forall_zero.mp hfin
    have hsub : Subsingleton (E ⧸ D.range) :=
      ⟨fun x y ↦ (hall x).trans (hall y).symm⟩
    exact LinearMap.range_eq_top.mp
      (Submodule.Quotient.subsingleton_iff.mp hsub)
  · intro hsurj
    have hi := LinearMap.index_of_surjective (f := D.toLinearMap) hsurj
    rw [hindex] at hi
    have hfin : Module.finrank ℝ D.ker = 0 := by exact_mod_cast hi.symm
    exact LinearMap.ker_eq_bot.mp (Submodule.finrank_eq_zero.mp hfin)

/-- 子空间形式的 Fredholm 备择：`ker(I-K)=0` 当且仅当 `range(I-K)=E`。 -/
theorem identitySubCompact_ker_eq_bot_iff_range_eq_top (K : E →L[ℝ] E)
    (hK : IsCompactOperator K) :
    (identitySubCompact K).ker = ⊥ ↔ (identitySubCompact K).range = ⊤ := by
  rw [LinearMap.ker_eq_bot, LinearMap.range_eq_top]
  exact identitySubCompact_injective_iff_surjective K hK

end SandronesLibrary.FunctionalAnalysis
