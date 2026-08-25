/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.FunctionalAnalysis.ClosedRangeConsequences

/-!
# 原算子与对偶算子的闭值域等价

本文件完成闭值域定理的范数闭性对称形式。关键桥是将范数闭的对偶值域
的单位球截面表示为一个弱星紧球的连续像与弱星单位球的交，再使用
Banach--Dieudonné 判据。
-/

namespace SandronesLibrary.FunctionalAnalysis

open Set

variable {E F : Type*}
variable [NormedAddCommGroup E] [NormedSpace ℝ E]
variable [NormedAddCommGroup F] [NormedSpace ℝ F]

private noncomputable def weakDualOperator (T : E →L[ℝ] F) :
    WeakDual ℝ F → WeakDual ℝ E := fun g ↦
  StrongDual.toWeakDual (dualOperator T (WeakDual.toStrongDual g))

@[simp] private theorem weakDualOperator_apply (T : E →L[ℝ] F)
    (g : WeakDual ℝ F) (x : E) : weakDualOperator T g x = g (T x) := rfl

private theorem weakDualOperator_continuous (T : E →L[ℝ] F) :
    Continuous (weakDualOperator T) := by
  apply WeakDual.continuous_of_continuous_eval
  intro x
  simpa only [weakDualOperator_apply] using WeakDual.eval_continuous (T x)

private theorem weakStarImage_dualOperator_range_unitSlice_isClosed_of_range_isClosed
    [CompleteSpace E] [CompleteSpace F] (T : E →L[ℝ] F)
    (hdual : IsClosed ((dualOperator T).range : Set (StrongDual ℝ E))) :
    IsClosed (weakStarImage (dualUnitSlice (dualOperator T).range)) := by
  let _ : IsClosed ((dualOperator T).range : Set (StrongDual ℝ E)) := hdual
  let R := (dualOperator T).rangeRestrict
  have hRsurj : Function.Surjective R := (dualOperator T).surjective_rangeRestrict
  obtain ⟨C, hCpos, hpre⟩ := ContinuousLinearMap.exists_preimage_norm_le
    (𝕜 := ℝ) (𝕜' := ℝ) (E := StrongDual ℝ F)
    (F := (dualOperator T).range) R hRsurj
  let B : Set (WeakDual ℝ F) :=
    WeakDual.toStrongDual ⁻¹' Metric.closedBall (0 : StrongDual ℝ F) C
  have hBcompact : IsCompact B := weakStar_isCompact_closedBall (0 : StrongDual ℝ F) C
  have hImageCompact : IsCompact (weakDualOperator T '' B) :=
    hBcompact.image (weakDualOperator_continuous T)
  have hUnitClosed : IsClosed
      (WeakDual.toStrongDual ⁻¹' Metric.closedBall (0 : StrongDual ℝ E) 1) :=
    WeakDual.isClosed_closedBall 0 1
  rw [show weakStarImage (dualUnitSlice (dualOperator T).range) =
      weakDualOperator T '' B ∩
        (WeakDual.toStrongDual ⁻¹' Metric.closedBall (0 : StrongDual ℝ E) 1) by
    ext f
    constructor
    · rintro ⟨f', ⟨hf'range, hf'norm⟩, rfl⟩
      obtain ⟨g, hgR, hgnorm⟩ := hpre ⟨f', hf'range⟩
      have hgdual : dualOperator T g = f' := congrArg Subtype.val hgR
      constructor
      · refine ⟨StrongDual.toWeakDual g, ?_, ?_⟩
        · simpa [B, Metric.mem_closedBall, dist_zero_right] using hgnorm.trans <| by
            simpa [Metric.mem_closedBall, dist_zero_right] using
              mul_le_mul_of_nonneg_left
                (show ‖(⟨f', hf'range⟩ : (dualOperator T).range)‖ ≤ 1 by simpa using hf'norm)
                hCpos.le
        · apply WeakDual.toStrongDual.injective
          exact hgdual
      · simpa [Metric.mem_closedBall, dist_zero_right] using hf'norm
    · rintro ⟨⟨g, hgB, hgf⟩, hfnorm⟩
      let g' := WeakDual.toStrongDual g
      refine ⟨dualOperator T g', ?_, ?_⟩
      · constructor
        · exact (dualOperator T).mem_range_self g'
        · have hstrong := congrArg WeakDual.toStrongDual hgf
          have heq : dualOperator T g' = WeakDual.toStrongDual f := hstrong
          rw [heq]
          simpa [Metric.mem_closedBall, dist_zero_right] using hfnorm
      · exact hgf]
  exact hImageCompact.inter_right hUnitClosed |>.isClosed

private theorem dualOperator_range_eq_ker_annihilator_of_range_isClosed
    [CompleteSpace E] [CompleteSpace F] (T : E →L[ℝ] F)
    (hdual : IsClosed ((dualOperator T).range : Set (StrongDual ℝ E))) :
    (dualOperator T).range = StrongDual.polarSubmodule ℝ T.ker := by
  let M := (dualOperator T).range
  have hunit : IsClosed (weakStarImage (dualUnitSlice M)) := by
    simpa [M] using weakStarImage_dualOperator_range_unitSlice_isClosed_of_range_isClosed T hdual
  apply le_antisymm (dualOperator_range_le_ker_annihilator T)
  intro f hf
  by_contra hfM
  obtain ⟨x₀, hfx₀, hMx₀⟩ :=
    exists_weakStar_separator_of_dualUnitSlice_closed M hunit hfM
  have hTx₀ : T x₀ = 0 := by
    by_contra hne
    have hnormne : ‖T x₀‖ ≠ 0 := norm_ne_zero_iff.mpr hne
    obtain ⟨g, _hgNorm, hgTx₀⟩ := exists_dual_vector ℝ (T x₀) hnormne
    have hzero := hMx₀ (dualOperator T g) ((dualOperator T).mem_range_self g)
    rw [dualOperator_apply, hgTx₀] at hzero
    exact hnormne hzero
  have hx₀ker : x₀ ∈ T.ker := LinearMap.mem_ker.mpr hTx₀
  have hzero := (mem_continuousAnnihilator_iff T.ker f).mp hf x₀ hx₀ker
  rw [hzero] at hfx₀
  norm_num at hfx₀

/-- **Closed range theorem, norm-closed form.** For bounded operators between real Banach spaces,
the original range is closed if and only if the adjoint range is norm closed.

> **Entry**: functional-analysis.closed-range.duality
-/
theorem isClosed_range_iff_dualOperator_range_isClosed
    [CompleteSpace E] [CompleteSpace F] (T : E →L[ℝ] F) :
    IsClosed (Set.range T) ↔
      IsClosed ((dualOperator T).range : Set (StrongDual ℝ E)) := by
  constructor
  · exact dualOperator_range_isClosed_of_isClosed_range T
  · intro hdual
    apply isClosed_range_of_dualOperator_range_eq_ker_annihilator T
    exact dualOperator_range_eq_ker_annihilator_of_range_isClosed T hdual

/-- 原值域闭，当且仅当它精确由对偶算子核的共同零点恢复。 -/
theorem isClosed_range_iff_forall_mem_range_iff_dualOperator_ker
    [CompleteSpace E] [CompleteSpace F] (T : E →L[ℝ] F) :
    IsClosed (Set.range T) ↔
      ∀ y : F, y ∈ T.range ↔
        ∀ f : StrongDual ℝ F, f ∈ (dualOperator T).ker → f y = 0 := by
  constructor
  · intro hT y
    exact mem_range_iff_forall_dualOperator_ker T hT y
  · intro hchar
    rw [show Set.range T =
        ⋂ f : StrongDual ℝ F, ⋂ (_hf : f ∈ (dualOperator T).ker),
          {y : F | f y = 0} by
      ext y
      change y ∈ T.range ↔ _
      simpa only [Set.mem_iInter, Set.mem_ofPred_eq] using hchar y]
    exact isClosed_iInter fun f ↦ isClosed_iInter fun _ ↦ f.isClosed_ker

/-- 闭值域定理的四项联合形式：原值域范数闭、对偶值域范数闭、
对偶值域等于原核的零化子，以及原值域等于对偶核的共同零点，
四者同时成立当且仅当原值域闭。 -/
theorem closedRange_four_way
    [CompleteSpace E] [CompleteSpace F] (T : E →L[ℝ] F) :
    IsClosed (Set.range T) ↔
      IsClosed ((dualOperator T).range : Set (StrongDual ℝ E)) ∧
      (dualOperator T).range = StrongDual.polarSubmodule ℝ T.ker ∧
      (∀ y : F, y ∈ T.range ↔
        ∀ f : StrongDual ℝ F, f ∈ (dualOperator T).ker → f y = 0) := by
  constructor
  · intro hT
    exact ⟨(dualOperator_range_isClosed_of_isClosed_range T hT),
      dualOperator_range_eq_ker_annihilator_of_isClosed_range T hT,
      (isClosed_range_iff_forall_mem_range_iff_dualOperator_ker T).1 hT⟩
  · exact fun h ↦ (isClosed_range_iff_forall_mem_range_iff_dualOperator_ker T).2 h.2.2

end SandronesLibrary.FunctionalAnalysis
