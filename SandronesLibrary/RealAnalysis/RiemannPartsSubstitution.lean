/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.RealAnalysis.RiemannFTC
import SandronesLibrary.Analysis.SpecialFunctions
import Mathlib.MeasureTheory.Integral.IntervalIntegral.IntegrationByParts

/-!
# Riemann 积分的分部积分、换元法及例题

本模块把 Mathlib 区间积分的分部积分与换元公式转写为本库自建的 Darboux–Riemann
积分接口。证明统一经过 `riemannIntegral_eq_interval`：先把公式中每个连续函数的
Riemann 积分识别为区间积分，调用 Mathlib 的运算法则，再转回 `riemannIntegral`。

为了确认接口不只是抽象包装，文件末尾立即给出两道教材例题：

* 取 `u(x)=x`、`v(x)=exp x`，由分部积分计算 `∫ x exp x`；
* 取 `φ(x)=cx+d`、`g=exp`，由换元法计算 `∫ c exp(cx+d)`。

两个例子都显式调用本文件刚建立的 Riemann 公式，然后才用 Newton–Leibniz 公式
计算剩余的指数函数积分。
-/

namespace SandronesLibrary.RealAnalysis.Riemann

open MeasureTheory
open scoped Interval Topology

/-- **分部积分公式**：若 `u'=u'`、`v'=v'`，并且四个函数在 `[a,b]` 上连续，则

`∫ u v' = u(b)v(b)-u(a)v(a)-∫u'v`。

连续性保证公式两侧出现的所有自建 Riemann 积分均可通过积分值桥识别为 Mathlib
区间积分。

> **Entry**: real-analysis.riemann.parts-substitution
-/
theorem riemannIntegral_mul_deriv_eq_deriv_mul {a b : ℝ}
    {u v u' v' : ℝ → ℝ} (hab : a < b)
    (hu : ContinuousOn u (Set.Icc a b)) (hv : ContinuousOn v (Set.Icc a b))
    (hu' : ContinuousOn u' (Set.Icc a b)) (hv' : ContinuousOn v' (Set.Icc a b))
    (hdu : ∀ x ∈ Set.Icc a b, HasDerivAt u (u' x) x)
    (hdv : ∀ x ∈ Set.Icc a b, HasDerivAt v (v' x) x) :
    riemannIntegral (fun x => u x * v' x) a b =
      u b * v b - u a * v a - riemannIntegral (fun x => u' x * v x) a b := by
  rw [riemannIntegral_eq_interval (f := fun x => u x * v' x) hab (hu.mul hv'),
    riemannIntegral_eq_interval (f := fun x => u' x * v x) hab (hu'.mul hv),
    ← intervalIntegral.integral_of_le hab.le,
    ← intervalIntegral.integral_of_le hab.le]
  apply intervalIntegral.integral_mul_deriv_eq_deriv_mul
  · simpa [Set.uIcc_of_le hab.le] using hdu
  · simpa [Set.uIcc_of_le hab.le] using hdv
  · have hu'' : ContinuousOn u' [[a, b]] := by
      simpa [Set.uIcc_of_le hab.le] using hu'
    exact hu''.intervalIntegrable
  · have hv'' : ContinuousOn v' [[a, b]] := by
      simpa [Set.uIcc_of_le hab.le] using hv'
    exact hv''.intervalIntegrable

/-- **换元积分公式**：设 `φ'=φ'`，且 `g` 连续。若 `a<b`、`φ(a)<φ(b)`，则

`∫ₐᵇ g(φ(x))φ'(x) dx = ∫_{φ(a)}^{φ(b)} g(u) du`。

端点严格次序用于适配当前自建 Riemann 积分只处理正向非退化区间的约定。 -/
theorem riemannIntegral_comp_mul_deriv {a b : ℝ} {φ φ' g : ℝ → ℝ}
    (hab : a < b) (hφab : φ a < φ b)
    (hφ : ContinuousOn φ (Set.Icc a b))
    (hφ' : ContinuousOn φ' (Set.Icc a b))
    (hdφ : ∀ x ∈ Set.Icc a b, HasDerivAt φ (φ' x) x)
    (hg : Continuous g) :
    riemannIntegral (fun x => (g ∘ φ) x * φ' x) a b =
      riemannIntegral g (φ a) (φ b) := by
  have hcomp : ContinuousOn (g ∘ φ) (Set.Icc a b) :=
    hg.comp_continuousOn hφ
  rw [riemannIntegral_eq_interval
      (f := fun x => (g ∘ φ) x * φ' x) hab (hcomp.mul hφ'),
    riemannIntegral_eq_interval hφab hg.continuousOn,
    ← intervalIntegral.integral_of_le hab.le,
    ← intervalIntegral.integral_of_le hφab.le]
  apply intervalIntegral.integral_comp_mul_deriv
  · simpa [Set.uIcc_of_le hab.le] using hdφ
  · simpa [Set.uIcc_of_le hab.le] using hφ'
  · exact hg

/-- **分部积分例**：取 `u(x)=x`、`v(x)=eˣ`，得到定积分公式
`∫ₐᵇ x eˣ dx = b eᵇ-a eᵃ-(eᵇ-eᵃ)`。 -/
theorem riemannIntegral_id_mul_exp {a b : ℝ} (hab : a < b) :
    riemannIntegral (fun x => x * Real.exp x) a b =
      b * Real.exp b - a * Real.exp a - (Real.exp b - Real.exp a) := by
  have hparts := riemannIntegral_mul_deriv_eq_deriv_mul
    (u := fun x : ℝ => x) (v := Real.exp)
    (u' := fun _ : ℝ => 1) (v' := Real.exp) hab
    continuousOn_id Real.continuous_exp.continuousOn
    continuousOn_const Real.continuous_exp.continuousOn
    (fun x _ => hasDerivAt_id x) (fun x _ => Real.hasDerivAt_exp x)
  have hexp : riemannIntegral Real.exp a b = Real.exp b - Real.exp a :=
    riemannIntegral_eq_sub_of_hasDerivAt hab Real.continuous_exp.continuousOn
      (fun x _ => Real.hasDerivAt_exp x)
  simp only [one_mul] at hparts
  rw [hexp] at hparts
  simpa using hparts

/-- **线性换元例**：当 `c>0` 时令 `t=cx+d`，得到
`∫ₐᵇ c exp(cx+d) dx = exp(cb+d)-exp(ca+d)`。 -/
theorem riemannIntegral_const_mul_exp_affine {a b c d : ℝ}
    (hab : a < b) (hc : 0 < c) :
    riemannIntegral (fun x => Real.exp (c * x + d) * c) a b =
      Real.exp (c * b + d) - Real.exp (c * a + d) := by
  have hφab : c * a + d < c * b + d := by
    simpa [add_comm] using add_lt_add_right (mul_lt_mul_of_pos_left hab hc) d
  have hsubst := riemannIntegral_comp_mul_deriv
    (φ := fun x : ℝ => c * x + d) (φ' := fun _ : ℝ => c)
    (g := Real.exp) hab hφab
    ((continuousOn_const.mul continuousOn_id).add continuousOn_const)
    continuousOn_const
    (fun x _ => by simpa using ((hasDerivAt_id x).const_mul c).add_const d)
    Real.continuous_exp
  have hexp : riemannIntegral Real.exp (c * a + d) (c * b + d) =
      Real.exp (c * b + d) - Real.exp (c * a + d) :=
    riemannIntegral_eq_sub_of_hasDerivAt hφab Real.continuous_exp.continuousOn
      (fun x _ => Real.hasDerivAt_exp x)
  rw [hexp] at hsubst
  simpa [Function.comp_def] using hsubst

end SandronesLibrary.RealAnalysis.Riemann
