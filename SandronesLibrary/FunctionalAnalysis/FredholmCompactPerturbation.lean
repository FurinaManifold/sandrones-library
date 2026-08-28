/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.FunctionalAnalysis.FredholmComposition
import SandronesLibrary.FunctionalAnalysis.FredholmAlternative
import SandronesLibrary.FunctionalAnalysis.CompactOperatorComposition

/-!
# Fredholm 算子的紧扰动稳定性

本文件证明实 Banach 空间之间的 Fredholm 算子加上紧算子后仍为 Fredholm，且指数不变。
证明使用连续拟逆、恒等减紧算子的既有 Fredholm 链，以及已冻结的复合指数公式。
-/

namespace SandronesLibrary.FunctionalAnalysis

open Function LinearMap
open LinearMap.FiniteRangeSetoid
open scoped LinearMap.FiniteRangeSetoid

variable {E F : Type*}
  [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
  [NormedAddCommGroup F] [NormedSpace ℝ F] [CompleteSpace F]

/-- 有限秩连续线性映射是紧算子。证明经其有限维值域分解。 -/
private theorem isCompactOperator_of_hasFiniteRange {X Y : Type*}
    [NormedAddCommGroup X] [NormedSpace ℝ X]
    [NormedAddCommGroup Y] [NormedSpace ℝ Y]
    (R : X →L[ℝ] Y) (hR : R.toLinearMap.HasFiniteRange) :
    IsCompactOperator R := by
  let _ : FiniteDimensional ℝ R.range := .of_fg hR
  have hrange : IsCompactOperator R.rangeRestrict :=
    isCompactOperator_of_locallyCompactSpace_dom R.rangeRestrict
  have hcomp : IsCompactOperator (R.range.subtypeL.comp R.rangeRestrict) :=
    hrange.clm_comp R.range.subtypeL
  simpa using hcomp

/-- 恒等减紧算子是 Fredholm。此前建立的有限核、有限余核与闭值域，加上 Banach 开映射定理，
正好填充 Mathlib `IsFredholm` 的五个结构字段。 -/
private theorem identitySubCompact_isFredholm (K : E →L[ℝ] E)
    (hK : IsCompactOperator K) :
    (identitySubCompact K).IsFredholm := by
  let D := identitySubCompact K
  have hclosed : IsClosed (D.range : Set E) := by
    simpa [LinearMap.coe_range] using isClosed_range_identitySubCompact K hK
  let _ : FiniteDimensional ℝ D.ker :=
    finiteDimensional_kernel_identitySubCompact K hK
  let _ : FiniteDimensional ℝ (E ⧸ D.range) :=
    finiteDimensional_cokernel_identitySubCompact K hK
  have hstrict : _root_.Topology.IsStrictMap D := by
    let _ : IsClosed (D.range : Set E) := hclosed
    let _ : CompleteSpace D.range := IsClosed.completeSpace_coe
    have hsurj : Function.Surjective D.rangeRestrict :=
      LinearMap.range_eq_top.mp D.toLinearMap.range_rangeRestrict
    have hopen : IsOpenMap D.rangeRestrict := D.rangeRestrict.isOpenMap hsurj
    exact D.toLinearMap.isStrictMap_iff_isOpenQuotientMap_rangeRestrict.mpr
      ⟨hsurj, D.rangeRestrict.continuous, hopen⟩
  exact
    { isStrictMap := hstrict
      isClosed_range := hclosed
      finite_ker := inferInstance
      finite_coker := inferInstance
      closedComplemented_ker :=
        Submodule.ClosedComplemented.of_finiteDimensional D.ker }

omit [CompleteSpace E] in
/-- Fredholm 算子在紧扰动下保持 Fredholm 性。

> **Entry**: functional-analysis.fredholm.stability-compact
-/
theorem ContinuousLinearMap.IsFredholm.add_compact {T : E →L[ℝ] F}
    (hT : T.IsFredholm) {K : E →L[ℝ] F} (hK : IsCompactOperator K) :
    (T + K).IsFredholm := by
  obtain ⟨S, hS⟩ := hT.exists_isQuasiInverse
  let U : E →L[ℝ] F := T + K
  let C : F →L[ℝ] F := ContinuousLinearMap.id ℝ F - U.comp S
  have hfinite :
      (ContinuousLinearMap.id ℝ F - T.comp S).toLinearMap.HasFiniteRange := by
    change (LinearMap.id - T.toLinearMap.comp S.toLinearMap).HasFiniteRange
    simpa only [neg_sub] using
      (LinearMap.FiniteRangeSetoid.equiv_iff_hasFiniteRange.mp hS.2.equiv).neg
  have hfiniteCompact :
      IsCompactOperator (ContinuousLinearMap.id ℝ F - T.comp S) :=
    isCompactOperator_of_hasFiniteRange _ hfinite
  have hKS : IsCompactOperator (K.comp S) := IsCompactOperator.comp_right hK S
  have hC : IsCompactOperator C := by
    have heq : C = (ContinuousLinearMap.id ℝ F - T.comp S) - K.comp S := by
      ext x
      simp [C, U]
      module
    rw [heq]
    exact hfiniteCompact.sub hKS
  have hUS : U.comp S = identitySubCompact C := by
    ext x
    simp [C, identitySubCompact_apply]
  have hUSfred : (U.comp S).IsFredholm := by
    rw [hUS]
    exact identitySubCompact_isFredholm C hC
  obtain ⟨W, hW⟩ := hUSfred.exists_isQuasiInverse
  apply ContinuousLinearMap.IsFredholm.of_isQuasiInverse (v := S.comp W)
  exact hS.symm.of_comp_left hW

omit [CompleteSpace E] in
/-- 紧扰动不改变 Fredholm 指数。证明比较 `(T+K)S` 与 `TS`：二者都是恒等算子的紧扰动，
指数为零；再两次使用复合指数公式消去拟逆 `S` 的指数。 -/
theorem fredholmIndex_add_compact {T : E →L[ℝ] F}
    (hT : T.IsFredholm) {K : E →L[ℝ] F} (hK : IsCompactOperator K) :
    (T + K).toLinearMap.index = T.toLinearMap.index := by
  let U : E →L[ℝ] F := T + K
  have hU : U.IsFredholm := ContinuousLinearMap.IsFredholm.add_compact hT hK
  obtain ⟨S, hS⟩ := hT.exists_isQuasiInverse
  have hSfred : S.IsFredholm :=
    ContinuousLinearMap.IsFredholm.of_isQuasiInverse hS.symm
  let C₀ : F →L[ℝ] F := ContinuousLinearMap.id ℝ F - T.comp S
  let C₁ : F →L[ℝ] F := ContinuousLinearMap.id ℝ F - U.comp S
  have hfinite₀ :
      (ContinuousLinearMap.id ℝ F - T.comp S).toLinearMap.HasFiniteRange := by
    change (LinearMap.id - T.toLinearMap.comp S.toLinearMap).HasFiniteRange
    simpa only [neg_sub] using
      (LinearMap.FiniteRangeSetoid.equiv_iff_hasFiniteRange.mp hS.2.equiv).neg
  have hC₀ : IsCompactOperator C₀ :=
    isCompactOperator_of_hasFiniteRange _ hfinite₀
  have hC₁ : IsCompactOperator C₁ := by
    have hKS : IsCompactOperator (K.comp S) := IsCompactOperator.comp_right hK S
    have heq : C₁ = C₀ - K.comp S := by
      ext x
      simp [C₀, C₁, U]
      module
    rw [heq]
    exact hC₀.sub hKS
  have hTS : T.comp S = identitySubCompact C₀ := by
    ext x
    simp [C₀, identitySubCompact_apply]
  have hUS : U.comp S = identitySubCompact C₁ := by
    ext x
    simp [C₁, identitySubCompact_apply]
  have hcompU := fredholmIndex_comp hU hSfred
  have hcompT := fredholmIndex_comp hT hSfred
  rw [hUS, index_identitySubCompact_eq_zero C₁ hC₁] at hcompU
  rw [hTS, index_identitySubCompact_eq_zero C₀ hC₀] at hcompT
  change U.toLinearMap.index = T.toLinearMap.index
  omega

end SandronesLibrary.FunctionalAnalysis
