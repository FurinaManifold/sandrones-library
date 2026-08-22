/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.RealAnalysis.RiemannIntegralBridge
import SandronesLibrary.RealAnalysis.Calculus

/-!
# 自建 Riemann 积分的微积分基本定理

`RealAnalysis/Calculus.lean` 已经给出了 Mathlib 区间积分接口上的两种微积分基本定理：

* `RealAnalysis.Calculus.ftc_2` 把导数的区间积分化为端点函数值之差；
* `RealAnalysis.Calculus.ftc_1_right` 证明连续函数的变上限区间积分可导。

本文件不重证这些测度积分结果，而是利用 `RiemannIntegralBridge.lean` 中的积分值等同
定理，将它们转写成本库从 Darboux 下和定义的 `riemannIntegral`。第二形式只需一次
数值改写；第一形式还要注意：积分值桥要求下端点严格小于上端点。因此在目标点
`x>a` 的某个邻域内保证 `u>a`，证明两个变上限函数最终相等，再用导数的局部性转移
Mathlib 已有结论。
-/

namespace SandronesLibrary.RealAnalysis.Riemann

open MeasureTheory
open scoped Interval Topology

/-- **微积分基本定理第二形式（Newton–Leibniz 公式）**：若 `F' = f` 且 `f` 在
`[a,b]` 上连续，则 `f` 的自建 Riemann 积分等于 `F b - F a`。

连续性一方面让积分值桥可用，另一方面给出 `f` 的区间可积性，从而可以直接调用
`RealAnalysis.Calculus.ftc_2`。

> **Entry**: real-analysis.riemann.ftc
-/
theorem riemannIntegral_eq_sub_of_hasDerivAt {a b : ℝ} {F f : ℝ → ℝ}
    (hab : a < b) (hf : ContinuousOn f (Set.Icc a b))
    (hderiv : ∀ x ∈ Set.Icc a b, HasDerivAt F (f x) x) :
    riemannIntegral f a b = F b - F a := by
  rw [riemannIntegral_eq_interval hab hf,
    ← intervalIntegral.integral_of_le hab.le]
  apply RealAnalysis.Calculus.ftc_2
  · simpa [Set.uIcc_of_le hab.le] using hderiv
  · have hf' : ContinuousOn f [[a, b]] := by
      simpa [Set.uIcc_of_le hab.le] using hf
    exact hf'.intervalIntegrable

/-- **微积分基本定理第一形式**：若 `f` 在实线上连续，固定下端点 `a`，则变上限
Riemann 积分 `u ↦ riemannIntegral f a u` 在每个 `x>a` 处的导数等于 `f x`。

全局连续性是一个清晰的教材接口；证明实际只使用目标点附近的连续性，以及每个
`[a,u]` 上调用积分值桥所需的连续性。由于 `x>a`，条件 `u>a` 在 `x` 附近最终成立，
所以变上限 Riemann 积分与 Mathlib 变上限区间积分在该邻域相等。 -/
theorem hasDerivAt_riemannIntegral_right {a x : ℝ} {f : ℝ → ℝ}
    (hax : a < x) (hf : Continuous f) :
    HasDerivAt (fun u => riemannIntegral f a u) (f x) x := by
  have hFTC : HasDerivAt (fun u : ℝ => ∫ t in a..u, f t) (f x) x :=
    (RealAnalysis.Calculus.ftc_1_right (hf.intervalIntegrable a x)
      (hf.stronglyMeasurableAtFilter volume (𝓝 x)) hf.continuousAt).hasDerivAt
  apply hFTC.congr_of_eventuallyEq
  filter_upwards [eventually_gt_nhds hax] with u hau
  rw [riemannIntegral_eq_interval hau hf.continuousOn,
    ← intervalIntegral.integral_of_le hau.le]

end SandronesLibrary.RealAnalysis.Riemann
