/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.RealAnalysis.RiemannAlgebra
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Periodic

/-!
# Riemann 积分中值定理与周期积分

本模块证明数学分析教材中的第一积分中值定理，并说明连续周期函数在任意完整
周期上的积分与起点无关。中值定理保留教材证明结构：最值定理给出上下界，积分
单调性控制平均值，介值定理最后产生中值点。
-/

namespace SandronesLibrary.RealAnalysis.Riemann

open MeasureTheory
open scoped ENNReal Interval BigOperators

/-- 第一积分中值定理：连续函数的积分等于某个函数值乘以区间长度。
> **Entry**: real-analysis.riemann.mean-value
-/
theorem riemannIntegral_mean_value {f : ℝ → ℝ} {a b : ℝ} (hab : a < b)
    (hf : ContinuousOn f (Set.Icc a b)) :
    ∃ ξ ∈ Set.Icc a b, riemannIntegral f a b = f ξ * (b - a) := by
  obtain ⟨xm, hxm, hm⟩ :=
    SandronesLibrary.Analysis.Continuity.exists_isLeast_on_Icc hab.le hf
  obtain ⟨xM, hxM, hM⟩ :=
    SandronesLibrary.Analysis.Continuity.exists_isGreatest_on_Icc hab.le hf
  have hlower : f xm * (b - a) ≤ riemannIntegral f a b := by
    rw [← riemannIntegral_const (a := a) (b := b) (c := f xm) hab]
    exact riemannIntegral_mono hab continuousOn_const hf hm
  have hupper : riemannIntegral f a b ≤ f xM * (b - a) := by
    rw [← riemannIntegral_const (a := a) (b := b) (c := f xM) hab]
    exact riemannIntegral_mono hab hf continuousOn_const hM
  let A := riemannIntegral f a b / (b - a)
  have hA_lower : f xm ≤ A := by
    dsimp [A]
    exact (le_div_iff₀ (sub_pos.mpr hab)).mpr hlower
  have hA_upper : A ≤ f xM := by
    dsimp [A]
    exact (div_le_iff₀ (sub_pos.mpr hab)).mpr hupper
  have hxmM : f xm ≤ f xM := hm xM hxM
  have hsub : Set.uIcc xm xM ⊆ Set.Icc a b := Set.uIcc_subset_Icc hxm hxM
  have hA_mem : A ∈ Set.uIcc (f xm) (f xM) := by
    rw [Set.uIcc_of_le hxmM]
    exact ⟨hA_lower, hA_upper⟩
  have himg := intermediate_value_uIcc (hf.mono hsub) hA_mem
  rcases himg with ⟨ξ, hξ, hξA⟩
  refine ⟨ξ, hsub hξ, ?_⟩
  rw [hξA]
  dsimp [A]
  rw [div_mul_cancel₀ _ (ne_of_gt (sub_pos.mpr hab))]

/-- 连续周期函数在任意一个完整周期上的黎曼积分与起点无关。

这里 `T>0` 保证两个积分区间均按正向排列；连续性使等值桥梁在任意平移后的
闭区间上都可使用。 -/
theorem riemannIntegral_periodic_one_period {f : ℝ → ℝ} {T : ℝ}
    (hT : 0 < T) (hfcont : Continuous f) (hfper : Function.Periodic f T) (s t : ℝ) :
    riemannIntegral f t (t + T) = riemannIntegral f s (s + T) := by
  rw [riemannIntegral_eq_interval (lt_add_of_pos_right t hT) hfcont.continuousOn,
    riemannIntegral_eq_interval (lt_add_of_pos_right s hT) hfcont.continuousOn,
    ← intervalIntegral.integral_of_le (le_add_of_nonneg_right hT.le),
    ← intervalIntegral.integral_of_le (le_add_of_nonneg_right hT.le)]
  exact hfper.intervalIntegral_add_eq t s

end SandronesLibrary.RealAnalysis.Riemann
