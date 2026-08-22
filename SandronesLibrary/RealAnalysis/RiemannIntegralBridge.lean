/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.RealAnalysis.RiemannCriterion

/-!
# 任意 Riemann 可积函数的积分值桥梁

`Riemann.lean` 已经对闭区间连续函数证明了自建 Darboux 积分与 Mathlib 的
Lebesgue 区间积分数值相同。本文件利用 `RiemannCriterion.lean` 中完成的 Lebesgue
判据，把该结论推广到标准意义下的全部 Riemann 可积函数。

这里的“标准意义”由 `RiemannIntegrableWithBound f a b` 表示：函数在 `[a,b]`
有界，并且 Darboux 上下和之差可以任意小。之所以不直接使用早期定义
`RiemannIntegrable`，是因为后者只记录上下和逼近条件，没有把教材定义中的有界性
写入类型。

证明分三层：

1. Lebesgue 判据给出几乎处处连续性；删去包含全部不连续点的可测零测集后，函数在
   剩余可测集上连续，因此强可测，再与全局有界性合并得到 `Ioc a b` 上可积。
2. 对任意 Darboux 分划，用各小闭区间上的下确界和上确界构造两个阶梯函数。全局
   有界性保证这些确界有限，并逐点得到 `sP ≤ f ≤ uP`。
3. 阶梯函数积分分别等于 Darboux 下和与上和，故每个下和不超过 Lebesgue 积分、
   每个上和不小于它。最后用 Riemann 可积性提供任意小的上下和间隙完成夹逼。
-/

namespace SandronesLibrary.RealAnalysis.Riemann

open MeasureTheory
open scoped ENNReal Interval BigOperators

/-- 标准 Riemann 可积函数在相应半开区间上也是 Lebesgue 可积的。

由 Lebesgue 判据取得几乎处处连续性，再把坏点装入可测零测集 `N`。函数在
`Icc a b \ N` 上连续，所以在该集合的限制测度下强可测；零测集不改变限制测度。
最后由闭区间有界性和区间有限测度得到可积性。 -/
private lemma integrableOn_Ioc_of_riemannIntegrableWithBound {f : ℝ → ℝ} {a b : ℝ}
    (hab : a ≤ b) (h : RiemannIntegrableWithBound f a b) :
    IntegrableOn f (Set.Ioc a b) volume := by
  have hc := riemannIntegrableWithBound_ae_continuousOn hab h
  obtain ⟨N, hNmeas, hbad, hNnull⟩ := ae_continuity_exceptional_measurable_hull hc
  let G := Set.Icc a b \ N
  have hGmeas : MeasurableSet G := measurableSet_Icc.diff hNmeas
  have hfG : ContinuousOn f G := by
    intro x hx
    have hxcont : ContinuousWithinAt f (Set.Icc a b) x := by
      by_contra hxnot
      exact hx.2 (hbad ⟨hx.1, hxnot⟩)
    exact hxcont.mono Set.sdiff_subset
  have hmeasG : AEStronglyMeasurable f (volume.restrict G) :=
    hfG.aestronglyMeasurable hGmeas
  have haeN : ∀ᵐ x ∂volume, x ∉ N := by
    rw [ae_iff]
    simpa using hNnull
  have hae : Set.Icc a b =ᵐ[volume] G := by
    filter_upwards [haeN] with x hx
    apply propext
    change x ∈ Set.Icc a b ↔ x ∈ Set.Icc a b ∧ x ∉ N
    exact ⟨fun hmem => ⟨hmem, hx⟩, fun hmem => hmem.1⟩
  have hmeasIcc : AEStronglyMeasurable f (volume.restrict (Set.Icc a b)) := by
    rw [Measure.restrict_congr_set hae]
    exact hmeasG
  have hmeasIoc : AEStronglyMeasurable f (volume.restrict (Set.Ioc a b)) :=
    hmeasIcc.mono_set Set.Ioc_subset_Icc_self
  obtain ⟨C, hC⟩ := h.1
  have hfinite : (volume.restrict (Set.Ioc a b)) Set.univ ≠ ∞ := by
    rw [Measure.restrict_apply MeasurableSet.univ, Set.univ_inter, Real.volume_Ioc]
    exact ENNReal.ofReal_ne_top
  have hbound : ∀ᵐ x ∂(volume.restrict (Set.Ioc a b)).restrict Set.univ, ‖f x‖ ≤ C := by
    rw [Measure.restrict_univ]
    filter_upwards [ae_restrict_mem measurableSet_Ioc] with x hx
    simpa [Real.norm_eq_abs] using hC x (Set.Ioc_subset_Icc_self hx)
  simpa [IntegrableOn] using
    Measure.integrableOn_of_bounded (μ := volume.restrict (Set.Ioc a b))
      (s := Set.univ) hfinite hmeasIoc hbound

/-- 任意 Darboux 下和都不超过函数的 Lebesgue 区间积分。

下阶梯函数在第 `i` 个小区间上取函数像集的下确界。有界性确保像集有下界，故该
下确界不超过区间内每个函数值；积分保序后使用阶梯积分公式即可。 -/
private lemma lowerSum_le_integral_of_riemannIntegrableWithBound {f : ℝ → ℝ} {a b : ℝ}
    (hab : a < b) (h : RiemannIntegrableWithBound f a b) (P : DarbouxPartition a b) :
    lowerSum f P ≤ ∫ x in Set.Ioc a b, f x ∂volume := by
  let sP : ℝ → ℝ := fun t => ∑ i ∈ Finset.range P.n,
    (Set.Ioc (P.x i) (P.x (i+1))).indicator
      (fun _ : ℝ => sInf (f '' Set.Icc (P.x i) (P.x (i+1)))) t
  have hstep : ∀ i ∈ Finset.range P.n, P.x i ≤ P.x (i+1) := by
    intro i hi
    exact (P.strict i (Finset.mem_range.mp hi)).le
  have hsub := partition_subinterval_sub hab.le P hstep
  have hsP : ∀ t, (Set.Ioc a b).indicator sP t = sP t := by
    intro t
    exact step_indicator_identity
      (c := fun i => sInf (f '' Set.Icc (P.x i) (P.x (i+1)))) hsub t
  have hsP_le : ∀ t ∈ Set.Ioc a b, sP t ≤ f t := by
    intro t ht
    rcases partition_cover P.x0 P.xN P.strict ht with ⟨i, hi, hti, hti1⟩
    have hdisj : ∀ j, j < P.n → j ≠ i →
        t ∉ Set.Ioc (P.x j) (P.x (j+1)) := by
      intro j hj hji
      exact partition_disjoint P.strict hi hj hji.symm ⟨hti, hti1⟩
    have heval : sP t = sInf (f '' Set.Icc (P.x i) (P.x (i+1))) := by
      exact step_eval_at hi ⟨hti, hti1⟩ hdisj
    obtain ⟨C, hC⟩ := h.1
    have hbdd : BddBelow (f '' Set.Icc (P.x i) (P.x (i+1))) := by
      refine ⟨-C, ?_⟩
      rintro y ⟨x, hx, rfl⟩
      have hxi := partition_point_mem hab.le P.x0 P.xN P.strict (le_of_lt hi)
      have hxi1 := partition_point_mem hab.le P.x0 P.xN P.strict (Nat.succ_le_of_lt hi)
      have hxab : x ∈ Set.Icc a b :=
        Set.Icc_subset_Icc hxi.1 hxi1.2 ⟨hx.1, hx.2⟩
      exact (abs_le.mp (hC x hxab)).1
    rw [heval]
    exact csInf_le hbdd ⟨t, ⟨le_of_lt hti, hti1⟩, rfl⟩
  have hmono : ∀ t, (Set.Ioc a b).indicator sP t ≤
      (Set.Ioc a b).indicator f t := by
    intro t
    by_cases ht : t ∈ Set.Ioc a b
    · simpa [Set.indicator_of_mem ht] using hsP_le t ht
    · simp [Set.indicator, ht]
  have hisP : Integrable ((Set.Ioc a b).indicator sP) volume := by
    have hsP_int : Integrable sP volume := by
      apply integrable_finsetSum
      intro i hi
      rw [integrable_indicator_iff (hs := measurableSet_Ioc)]
      have hfin : volume (Set.Ioc (P.x i) (P.x (i+1))) ≠ ∞ := by
        rw [Real.volume_Ioc]
        exact ENNReal.ofReal_ne_top
      exact integrableOn_const (μ := volume) (s := Set.Ioc (P.x i) (P.x (i+1)))
        (C := sInf (f '' Set.Icc (P.x i) (P.x (i+1)))) (hs := hfin)
    have hident : (Set.Ioc a b).indicator sP = sP := funext hsP
    rwa [hident]
  have hif : Integrable ((Set.Ioc a b).indicator f) volume := by
    rw [integrable_indicator_iff (hs := measurableSet_Ioc)]
    exact integrableOn_Ioc_of_riemannIntegrableWithBound hab.le h
  have hmain := lower_sum_le_interval (f := f) (sP := sP) (s := Set.Ioc a b)
    (hs := measurableSet_Ioc) (hsP := hsP) (hf_mono := hmono)
    (hisP := hisP) (hif := hif)
  calc
    lowerSum f P = ∫ t : ℝ, sP t ∂volume := (step_integral_eq_lowerSum P hstep).symm
    _ ≤ ∫ x in Set.Ioc a b, f x ∂volume := hmain

/-- 函数的 Lebesgue 区间积分不超过任意 Darboux 上和。

这是上一引理的对偶版本：上阶梯函数在每个小区间取函数像集的上确界；有界性保证
像集有上界，而上确界逐点支配 `f`。 -/
private lemma integral_le_upperSum_of_riemannIntegrableWithBound {f : ℝ → ℝ} {a b : ℝ}
    (hab : a < b) (h : RiemannIntegrableWithBound f a b) (P : DarbouxPartition a b) :
    (∫ x in Set.Ioc a b, f x ∂volume) ≤ upperSum f P := by
  let uP : ℝ → ℝ := fun t => ∑ i ∈ Finset.range P.n,
    (Set.Ioc (P.x i) (P.x (i+1))).indicator
      (fun _ : ℝ => sSup (f '' Set.Icc (P.x i) (P.x (i+1)))) t
  have hstep : ∀ i ∈ Finset.range P.n, P.x i ≤ P.x (i+1) := by
    intro i hi
    exact (P.strict i (Finset.mem_range.mp hi)).le
  have hsub := partition_subinterval_sub hab.le P hstep
  have huP : ∀ t, (Set.Ioc a b).indicator uP t = uP t := by
    intro t
    exact step_indicator_identity
      (c := fun i => sSup (f '' Set.Icc (P.x i) (P.x (i+1)))) hsub t
  have hf_le : ∀ t ∈ Set.Ioc a b, f t ≤ uP t := by
    intro t ht
    rcases partition_cover P.x0 P.xN P.strict ht with ⟨i, hi, hti, hti1⟩
    have hdisj : ∀ j, j < P.n → j ≠ i →
        t ∉ Set.Ioc (P.x j) (P.x (j+1)) := by
      intro j hj hji
      exact partition_disjoint P.strict hi hj hji.symm ⟨hti, hti1⟩
    have heval : uP t = sSup (f '' Set.Icc (P.x i) (P.x (i+1))) := by
      exact step_eval_at hi ⟨hti, hti1⟩ hdisj
    obtain ⟨C, hC⟩ := h.1
    have hbdd : BddAbove (f '' Set.Icc (P.x i) (P.x (i+1))) := by
      refine ⟨C, ?_⟩
      rintro y ⟨x, hx, rfl⟩
      have hxi := partition_point_mem hab.le P.x0 P.xN P.strict (le_of_lt hi)
      have hxi1 := partition_point_mem hab.le P.x0 P.xN P.strict (Nat.succ_le_of_lt hi)
      have hxab : x ∈ Set.Icc a b :=
        Set.Icc_subset_Icc hxi.1 hxi1.2 ⟨hx.1, hx.2⟩
      exact (abs_le.mp (hC x hxab)).2
    rw [heval]
    exact le_csSup hbdd ⟨t, ⟨le_of_lt hti, hti1⟩, rfl⟩
  have hmono : ∀ t, (Set.Ioc a b).indicator f t ≤
      (Set.Ioc a b).indicator uP t := by
    intro t
    by_cases ht : t ∈ Set.Ioc a b
    · simpa [Set.indicator_of_mem ht] using hf_le t ht
    · simp [Set.indicator, ht]
  have hif : Integrable ((Set.Ioc a b).indicator f) volume := by
    rw [integrable_indicator_iff (hs := measurableSet_Ioc)]
    exact integrableOn_Ioc_of_riemannIntegrableWithBound hab.le h
  have hiuP : Integrable ((Set.Ioc a b).indicator uP) volume := by
    have huP_int : Integrable uP volume := by
      apply integrable_finsetSum
      intro i hi
      rw [integrable_indicator_iff (hs := measurableSet_Ioc)]
      have hfin : volume (Set.Ioc (P.x i) (P.x (i+1))) ≠ ∞ := by
        rw [Real.volume_Ioc]
        exact ENNReal.ofReal_ne_top
      exact integrableOn_const (μ := volume) (s := Set.Ioc (P.x i) (P.x (i+1)))
        (C := sSup (f '' Set.Icc (P.x i) (P.x (i+1)))) (hs := hfin)
    have hident : (Set.Ioc a b).indicator uP = uP := funext huP
    rwa [hident]
  calc
    (∫ x in Set.Ioc a b, f x ∂volume) =
        ∫ t : ℝ, (Set.Ioc a b).indicator f t ∂volume :=
      (integral_indicator (hs := measurableSet_Ioc)).symm
    _ ≤ ∫ t : ℝ, (Set.Ioc a b).indicator uP t ∂volume :=
      integral_mono hif hiuP hmono
    _ = ∫ t : ℝ, uP t ∂volume := by rw [funext huP]
    _ = upperSum f P := step_sup_integral_eq_upperSum P hstep

/-- **任意标准 Riemann 可积函数的积分值桥梁**：若 `a < b`，且 `f` 在 `[a,b]`
有界并满足 Darboux 可积条件，则本库定义的 Riemann 积分值等于 Mathlib 的 Lebesgue
区间积分值。

第一方向对所有下和取上确界；第二方向选择上下和间隙小于任意 `ε > 0` 的分划，
并把 Lebesgue 积分夹在该分划的下和与上和之间。

> **Entry**: real-analysis.riemann.eq-lebesgue-general
-/
theorem riemannIntegral_eq_interval_of_riemannIntegrableWithBound {f : ℝ → ℝ} {a b : ℝ}
    (hab : a < b) (h : RiemannIntegrableWithBound f a b) :
    riemannIntegral f a b = ∫ x in Set.Ioc a b, f x ∂volume := by
  apply le_antisymm
  · unfold riemannIntegral
    apply csSup_le
    · exact ⟨lowerSum f (uniformPartition a b 1 hab (by norm_num)),
        ⟨uniformPartition a b 1 hab (by norm_num), rfl⟩⟩
    · rintro y ⟨P, rfl⟩
      exact lowerSum_le_integral_of_riemannIntegrableWithBound hab h P
  · unfold riemannIntegral
    apply le_of_forall_pos_le_add
    intro ε hε
    obtain ⟨P, hgap⟩ := h.2 ε hε
    have hU := integral_le_upperSum_of_riemannIntegrableWithBound hab h P
    have hL : lowerSum f P ≤
        sSup {x : ℝ | ∃ Q : DarbouxPartition a b, x = lowerSum f Q} := by
      apply le_csSup
      · refine ⟨∫ x in Set.Ioc a b, f x ∂volume, ?_⟩
        rintro y ⟨Q, rfl⟩
        exact lowerSum_le_integral_of_riemannIntegrableWithBound hab h Q
      · exact ⟨P, rfl⟩
    linarith

end SandronesLibrary.RealAnalysis.Riemann
