/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.FunctionalAnalysis.FredholmCompactPerturbation
import Mathlib.Analysis.Normed.Algebra.Spectrum

/-!
# Fredholm 算子的小扰动稳定性

本文件证明 Fredholm 算子集合在算子范数拓扑中是开集，并且 Fredholm 指数在一个充分小的邻域
中保持不变。证明用拟逆把扰动化为 Neumann 可逆项，再消费紧扰动稳定性处理有限秩误差。
-/

namespace SandronesLibrary.FunctionalAnalysis

open Function LinearMap
open LinearMap.FiniteRangeSetoid
open scoped LinearMap.FiniteRangeSetoid

variable {E F : Type*}
  [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
  [NormedAddCommGroup F] [NormedSpace ℝ F] [CompleteSpace F]

/-- 可逆有界自同态是 Fredholm，且指数为零。 -/
private theorem isFredholm_and_index_zero_of_isUnit (B : F →L[ℝ] F) (hB : IsUnit B) :
    B.IsFredholm ∧ B.toLinearMap.index = 0 := by
  let V : F →L[ℝ] F := hB.unit.inv
  have hVB : V.comp B = ContinuousLinearMap.id ℝ F := by
    change hB.unit.inv * B = 1
    calc
      hB.unit.inv * B = hB.unit.inv * (hB.unit : F →L[ℝ] F) :=
        congrArg (hB.unit.inv * ·) hB.unit_spec.symm
      _ = 1 := hB.unit.inv_val
  have hBV : B.comp V = ContinuousLinearMap.id ℝ F := by
    change B * hB.unit.inv = 1
    calc
      B * hB.unit.inv = (hB.unit : F →L[ℝ] F) * hB.unit.inv :=
        congrArg (· * hB.unit.inv) hB.unit_spec.symm
      _ = 1 := hB.unit.val_inv
  have hqi : V.IsQuasiInverse B := by
    constructor
    · change V.toLinearMap.comp B.toLinearMap ≈ LinearMap.id
      rw [← ContinuousLinearMap.toLinearMap_comp, hVB]
      change LinearMap.id ≈ LinearMap.id
      rfl
    · change B.toLinearMap.comp V.toLinearMap ≈ LinearMap.id
      rw [← ContinuousLinearMap.toLinearMap_comp, hBV]
      change LinearMap.id ≈ LinearMap.id
      rfl
  have hBfred : B.IsFredholm :=
    ContinuousLinearMap.IsFredholm.of_isQuasiInverse hqi
  have hbij : Function.Bijective B :=
    ContinuousLinearMap.isUnit_iff_bijective.mp hB
  have hindex : B.toLinearMap.index = 0 := by
    let _ : FiniteDimensional ℝ B.ker := hBfred.finite_ker
    let _ : FiniteDimensional ℝ (F ⧸ B.range) := hBfred.finite_coker
    have hi := LinearMap.index_of_surjective (f := B.toLinearMap) hbij.2
    rw [LinearMap.ker_eq_bot.mpr hbij.1] at hi
    simpa using hi
  exact ⟨hBfred, hindex⟩

omit [CompleteSpace E] in
/-- Fredholm 性和指数在某个算子范数邻域内同时稳定。

> **Entry**: functional-analysis.fredholm.stability-small
-/
theorem exists_fredholm_smallPerturbation_radius {T : E →L[ℝ] F}
    (hT : T.IsFredholm) :
    ∃ ε > 0, ∀ K : E →L[ℝ] F, ‖K‖ < ε →
      (T + K).IsFredholm ∧
        (T + K).toLinearMap.index = T.toLinearMap.index := by
  obtain ⟨S, hS⟩ := hT.exists_isQuasiInverse
  let ε : ℝ := (‖S‖ + 1)⁻¹
  have hε : 0 < ε := by
    dsimp [ε]
    positivity
  refine ⟨ε, hε, fun K hK ↦ ?_⟩
  let U : E →L[ℝ] F := T + K
  let A : F →L[ℝ] F := K.comp S
  have hAnorm : ‖A‖ < 1 := by
    calc
      ‖A‖ ≤ ‖K‖ * ‖S‖ := ContinuousLinearMap.opNorm_comp_le K S
      _ ≤ ‖K‖ * (‖S‖ + 1) := by gcongr; norm_num
      _ < ε * (‖S‖ + 1) := mul_lt_mul_of_pos_right hK (by positivity)
      _ = 1 := by
        dsimp [ε]
        rw [inv_mul_cancel₀]
        positivity
  let B : F →L[ℝ] F := 1 + A
  have hBunit : IsUnit B := by
    have hneg : ‖-A‖ < 1 := by simpa using hAnorm
    have hu := isUnit_one_sub_of_norm_lt_one hneg
    simpa [B, sub_neg_eq_add] using hu
  obtain ⟨hBfred, hBindex⟩ := isFredholm_and_index_zero_of_isUnit B hBunit
  let R : F →L[ℝ] F := T.comp S - ContinuousLinearMap.id ℝ F
  have hRfinite : R.toLinearMap.HasFiniteRange := by
    change (T.toLinearMap.comp S.toLinearMap - LinearMap.id).HasFiniteRange
    exact LinearMap.FiniteRangeSetoid.equiv_iff_hasFiniteRange.mp hS.2.equiv
  have hRcompact : IsCompactOperator R :=
    isCompactOperator_of_hasFiniteRange_clm R hRfinite
  have hUS : U.comp S = B + R := by
    ext x
    simp [U, A, B, R]
    module
  have hUSfred : (U.comp S).IsFredholm := by
    rw [hUS]
    exact ContinuousLinearMap.IsFredholm.add_compact hBfred hRcompact
  have hUSindex : (U.comp S).toLinearMap.index = 0 := by
    rw [hUS, fredholmIndex_add_compact hBfred hRcompact, hBindex]
  obtain ⟨W, hW⟩ := hUSfred.exists_isQuasiInverse
  have hUfred : U.IsFredholm := by
    apply ContinuousLinearMap.IsFredholm.of_isQuasiInverse (v := S.comp W)
    exact hS.symm.of_comp_left hW
  have hSfred : S.IsFredholm :=
    ContinuousLinearMap.IsFredholm.of_isQuasiInverse hS.symm
  have hTSindex : (T.comp S).toLinearMap.index = 0 := by
    have hTScompact : IsCompactOperator (ContinuousLinearMap.id ℝ F - T.comp S) := by
      have hfin :
          (ContinuousLinearMap.id ℝ F - T.comp S).toLinearMap.HasFiniteRange := by
        change (LinearMap.id - T.toLinearMap.comp S.toLinearMap).HasFiniteRange
        simpa only [neg_sub] using
          (LinearMap.FiniteRangeSetoid.equiv_iff_hasFiniteRange.mp hS.2.equiv).neg
      exact isCompactOperator_of_hasFiniteRange_clm _ hfin
    have heq : T.comp S = identitySubCompact
        (ContinuousLinearMap.id ℝ F - T.comp S) := by
      ext x
      simp [identitySubCompact_apply]
    rw [heq, index_identitySubCompact_eq_zero _ hTScompact]
  have hcompU := fredholmIndex_comp hUfred hSfred
  have hcompT := fredholmIndex_comp hT hSfred
  rw [hUSindex] at hcompU
  rw [hTSindex] at hcompT
  refine ⟨hUfred, ?_⟩
  change U.toLinearMap.index = T.toLinearMap.index
  omega

end SandronesLibrary.FunctionalAnalysis
