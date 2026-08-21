/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

open Filter Topology
open scoped Filter Topology

/-!
# Analysis / MVT —— 微分中值定理（第七章）

本文件当前条目（引理清单，§3.11：一次一条，逐条编译）：

* **analysis.mvt.rolle**（罗尔定理）。
* **analysis.mvt.lagrange**（拉格朗日中值定理）。
* **analysis.mvt.lagrange-deriv**（带导函数版 Lagrange）。
* **analysis.mvt.monotone-deriv**（导数符号判别单调）。
* **analysis.mvt.cauchy**（柯西中值定理）。
* ~~**analysis.mvt.lhopital**~~（L'Hôpital）：待批。
* ~~**analysis.mvt.taylor**~~（泰勒公式）：mathlib 单变量 Taylor 较繁，待批。
-/

namespace SandronesLibrary

namespace Analysis.MVT

/-- 罗尔定理：闭区间连续、开区间可导、端点值相等的函数，在开区间内某点导数为 0。 
> **Entry**: analysis.mvt.rolle
-/
theorem rolle {f : ℝ → ℝ} {a b : ℝ} (hab : a < b)
    (hfc : ContinuousOn f (Set.Icc a b))
    (_hfd : DifferentiableOn ℝ f (Set.Ioo a b)) (hfI : f a = f b) :
    ∃ c ∈ Set.Ioo a b, deriv f c = 0 :=
  exists_deriv_eq_zero hab hfc hfI

/-- 拉格朗日中值定理：闭区间连续、开区间可导，存在 c 使 f'(c) 等于割线斜率。 
> **Entry**: analysis.mvt.lagrange
-/
theorem lagrange {f : ℝ → ℝ} {a b : ℝ} (hab : a < b)
    (hfc : ContinuousOn f (Set.Icc a b))
    (hfd : DifferentiableOn ℝ f (Set.Ioo a b)) :
    ∃ c ∈ Set.Ioo a b, deriv f c = (f b - f a) / (b - a) :=
  exists_deriv_eq_slope f hab hfc hfd

/-- 拉格朗日中值定理（带导函数 f' 版本）：若 f' 是 f 的导数，则存在 c 使 f'(c) 等于割线斜率。 
> **Entry**: analysis.mvt.lagrange-deriv
-/
theorem lagrange_deriv {f f' : ℝ → ℝ} {a b : ℝ} (hab : a < b)
    (hfc : ContinuousOn f (Set.Icc a b))
    (hff' : ∀ x ∈ Set.Ioo a b, HasDerivAt f (f' x) x) :
    ∃ c ∈ Set.Ioo a b, f' c = (f b - f a) / (b - a) :=
  exists_hasDerivAt_eq_slope f f' hab hfc hff'

/-- 导数非负 ⟹ 单调不减：导数符号判别单调性的一个方向。
  （MVT 推论：f' ≥ 0 在区间内 ⟹ f 在该区间单调不减。） 
> **Entry**: analysis.mvt.monotone-deriv
-/
theorem monotone_of_deriv_nonneg {f : ℝ → ℝ} {a b : ℝ} (_hab : a < b)
    (hfc : ContinuousOn f (Set.Icc a b))
    (hfd : DifferentiableOn ℝ f (Set.Ioo a b))
    (hf' : ∀ x ∈ Set.Ioo a b, 0 ≤ deriv f x) :
    MonotoneOn f (Set.Icc a b) := by
  apply monotoneOn_of_deriv_nonneg (D := Set.Icc a b)
  · exact convex_Icc a b
  · exact hfc
  · simpa [interior_Icc] using hfd
  · intro x hx
    exact hf' x (by simpa [interior_Icc] using hx)

/-- 导数恒正 ⟹ 严格递增（MVT 推论）。 
> **Entry**: analysis.mvt.monotone-deriv
-/
theorem strict_mono_of_deriv_pos {f : ℝ → ℝ} {a b : ℝ} (_hab : a < b)
    (hfc : ContinuousOn f (Set.Icc a b))
    (hf' : ∀ x ∈ Set.Ioo a b, 0 < deriv f x) :
    StrictMonoOn f (Set.Icc a b) := by
  apply strictMonoOn_of_deriv_pos (D := Set.Icc a b)
  · exact convex_Icc a b
  · exact hfc
  · intro x hx
    exact hf' x (by simpa [interior_Icc] using hx)

/-- 柯西中值定理：两函数 f、g 在闭区间连续、开区间可导，则存在 c 使
  (g b − g a)·f'(c) = (f b − f a)·g'(c)。这是 L'Hôpital 法则的基础。
> **Entry**: analysis.mvt.cauchy
-/
theorem cauchy_mvt {f g : ℝ → ℝ} {a b : ℝ} (hab : a < b)
    (hfc : ContinuousOn f (Set.Icc a b)) (hgc : ContinuousOn g (Set.Icc a b))
    (hgd : DifferentiableOn ℝ g (Set.Ioo a b)) (hfd : DifferentiableOn ℝ f (Set.Ioo a b)) :
    ∃ c ∈ Set.Ioo a b, (g b - g a) * deriv f c = (f b - f a) * deriv g c :=
  exists_ratio_deriv_eq_ratio_slope f hab hfc hfd g hgc hgd

end Analysis.MVT

end SandronesLibrary