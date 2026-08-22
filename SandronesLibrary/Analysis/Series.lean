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

end Analysis.Series
end SandronesLibrary
