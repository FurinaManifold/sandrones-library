/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

/-!
# Analysis / Series —— 数项级数基础

本模块以 `Summable`、`HasSum` 和有限集部分和为接口，整理级数的第一批教材层结果：
几何级数、调和级数发散、绝对收敛蕴含收敛，以及 Cauchy 收敛准则。
-/

namespace SandronesLibrary
namespace Analysis.Series

open Filter Asymptotics
open scoped Topology

/-- 公比绝对值小于 `1` 时的几何级数。 -/
theorem geometric_series {r : ℝ} (hr : |r| < 1) :
    HasSum (fun n : ℕ => r ^ n) (1 / (1 - r)) := by
  simpa [one_div] using (hasSum_geometric_of_norm_lt_one hr)

/-- 调和级数发散。 -/
theorem harmonic_diverges :
    ¬ Summable (fun n : ℕ => 1 / (n : ℝ)) := by
  exact Real.not_summable_one_div_natCast

/-- 绝对收敛蕴含收敛。
> **Entry**: analysis.series.basic
-/
theorem summable_of_absolute {f : ℕ → ℝ}
    (h : Summable (fun n => |f n|)) : Summable f := by
  apply Summable.of_norm
  simpa only [Real.norm_eq_abs] using h

/-- 以有限集部分和表述的 Cauchy 收敛准则。 -/
theorem summable_iff_cauchy {f : ℕ → ℝ} :
    Summable f ↔ CauchySeq (fun N : Finset ℕ => ∑ n ∈ N, f n) := by
  exact summable_iff_cauchySeq_finset

/-! ### 判别法

这些定理把教材中的常用判别法保留为面向实数项级数的薄接口；具体的
过滤器和范数技术仍由 Mathlib 负责。 -/

/-- 以一个可和的实数序列作渐近上界的比较判别法。 -/
/-
> **Entry**: analysis.series.tests
-/
theorem summable_of_isBigO_nat {f : ℕ → ℝ} {g : ℕ → ℝ}
    (hg : Summable g) (hfg : f =O[atTop] g) : Summable f := by
  exact _root_.summable_of_isBigO_nat hg hfg

/-- 比值极限小于 `1` 时的比值判别法。 -/
theorem summable_of_ratio_test {f : ℕ → ℝ} {l : ℝ} (hl : l < 1)
    (hne : ∀ᶠ n in atTop, f n ≠ 0)
    (hlim : Tendsto (fun n ↦ ‖f (n + 1)‖ / ‖f n‖) atTop (𝓝 l)) :
    Summable f := by
  exact summable_of_ratio_test_tendsto_lt_one hl hne hlim

/-- 比值极限大于 `1` 时的发散判别法。 -/
theorem not_summable_of_ratio_test {f : ℕ → ℝ} {l : ℝ} (hl : 1 < l)
    (hlim : Tendsto (fun n ↦ ‖f (n + 1)‖ / ‖f n‖) atTop (𝓝 l)) :
    ¬ Summable f := by
  exact not_summable_of_ratio_test_tendsto_gt_one hl hlim

/-- 非负递减项趋于零时，交错级数的部分和构成 Cauchy 序列。 -/
theorem alternating_series_cauchy {f : ℕ → ℝ} (hmono : Antitone f)
    (hzero : Tendsto f atTop (𝓝 0)) :
    CauchySeq (fun N : ℕ ↦ ∑ n ∈ Finset.range N, (-1 : ℝ) ^ n * f n) := by
  exact hmono.cauchySeq_alternating_series_of_tendsto_zero hzero

/-- 有界于收敛几何级数的尾项级数可和；这是根值判别法的几何上界下层引理。 -/
theorem summable_of_eventually_geometric_bound {f : ℕ → ℝ} {r C : ℝ}
    (hr : |r| < 1) (hC : 0 ≤ C)
    (hbound : ∀ᶠ n in atTop, |f n| ≤ C * |r| ^ n) : Summable f := by
  have hgeom : Summable (fun n : ℕ => |r| ^ n) := by
    simpa [Real.norm_eq_abs] using
      (summable_geometric_of_norm_lt_one (x := r)
        (by simpa [Real.norm_eq_abs] using hr))
  have hmajor : Summable (fun n : ℕ => C * |r| ^ n) := hgeom.mul_left C
  apply Summable.of_norm_bounded_eventually_nat hmajor
  simpa only [Real.norm_eq_abs] using hbound

/-- 根值判别法的几何主项界形式：最终被某个收敛几何级数控制即收敛。 -/
theorem root_test_of_eventually_geometric_majorant {f : ℕ → ℝ}
    (hroot : ∃ r C : ℝ, |r| < 1 ∧ 0 ≤ C ∧
      ∀ᶠ n in atTop, |f n| ≤ C * |r| ^ n) : Summable f := by
  rcases hroot with ⟨r, C, hr, hC, hbound⟩
  exact summable_of_eventually_geometric_bound hr hC hbound

/-- 最终根值上界推出几何主项界；第零项由 `n₀` 排除。 -/
theorem eventually_geometric_bound_of_root_bound {f : ℕ → ℝ} {r : ℝ}
    (hr : 0 ≤ r) (hr1 : r < 1) (n₀ : ℕ)
    (hroot : ∀ᶠ n in atTop, n₀ ≤ n → |f n| ^ (1 / (n : ℝ)) ≤ r) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ᶠ n in atTop, |f n| ≤ C * r ^ n := by
  refine ⟨1, zero_le_one, ?_⟩
  filter_upwards [hroot, eventually_ge_atTop (max n₀ 1)] with n hn hN
  have hn0 : n₀ ≤ n := (le_max_left n₀ 1).trans hN
  have hnpos : 0 < n := lt_of_lt_of_le Nat.zero_lt_one
    ((le_max_right n₀ 1).trans hN)
  have hncast : (0 : ℝ) < n := by exact_mod_cast hnpos
  have hpow := Real.rpow_le_rpow (x := |f n| ^ (1 / (n : ℝ)))
    (y := r) (z := (n : ℝ)) (by positivity) (hn hn0) hncast.le
  have hleft : (|f n| ^ (1 / (n : ℝ))) ^ (n : ℝ) = |f n| := by
    rw [show (1 / (n : ℝ)) = (n : ℝ)⁻¹ by simp [one_div]]
    simpa [Real.rpow_natCast] using
      (Real.rpow_inv_natCast_pow (abs_nonneg (f n)) (Nat.ne_of_gt hnpos))
  rw [hleft] at hpow
  simpa [Real.rpow_natCast, one_mul] using hpow

/-- 实数项级数绝对收敛与收敛的等价判据。 -/
/-
> **Entry**: analysis.series.absolute
-/
theorem summable_abs_iff {f : ℕ → ℝ} :
    Summable (fun n => |f n|) ↔ Summable f := by
  constructor
  · exact summable_of_absolute
  · intro hf
    exact hf.abs

/-- 可和级数的有限部分和趋于其无穷和。 -/
theorem partial_sum_tendsto_tsum {f : ℕ → ℝ} (hf : Summable f) :
    Tendsto (fun N : ℕ => ∑ n ∈ Finset.range N, f n) atTop (𝓝 (∑' n, f n)) := by
  exact hf.tendsto_sum_tsum_nat

/-- 非负递减项趋于零时，交错级数的部分和收敛。 -/
/-
> **Entry**: analysis.series.conditional
-/
theorem alternating_series_converges {f : ℕ → ℝ} (hmono : Antitone f)
    (hzero : Tendsto f atTop (𝓝 0)) :
    ∃ l : ℝ, Tendsto
      (fun N : ℕ => ∑ n ∈ Finset.range N, (-1 : ℝ) ^ n * f n)
      atTop (𝓝 l) := by
  exact hmono.tendsto_alternating_series_of_tendsto_zero hzero

/-- 绝对收敛级数在自然数指标的任意等价重排下保持其和。 -/
/-
> **Entry**: analysis.series.rearrangement
-/
theorem absolute_reindex_tsum {f : ℕ → ℝ} (hf : Summable (fun n => |f n|))
    (e : ℕ ≃ ℕ) :
    (∑' n, f (e n)) = ∑' n, f n := by
  exact e.tsum_eq f

/-- 绝对收敛级数的任意等价重排仍然绝对收敛。 -/
theorem absolute_reindex_summable {f : ℕ → ℝ} (hf : Summable (fun n => |f n|))
    (e : ℕ ≃ ℕ) : Summable (fun n => f (e n)) := by
  apply (e.summable_iff).2
  exact summable_of_absolute hf

end Analysis.Series
end SandronesLibrary
