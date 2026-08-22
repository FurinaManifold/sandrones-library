/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Analysis.TaylorSeries
import SandronesLibrary.RealAnalysis.RiemannIntegralExamples

/-!
# Taylor 公式的 Riemann 积分型余项

Mathlib 已证明区间积分形式的 Taylor 余项。本模块完成三层教材接口转换：

1. 用 `taylorWithinEval_eq_polynomial` 把区间内 Taylor 多项式换成本库的
   `polynomial f n c x`；
2. 在非退化区间内部，用唯一可微性把 `iteratedDerivWithin` 换成全局
   `iteratedDeriv`；
3. 证明余项被积函数连续，再用积分值桥把 Mathlib 区间积分换成本库自建
   `riemannIntegral`。

最终陈述完全采用教材中的全局高阶导数和 Riemann 积分，并附带指数函数实例。
-/

namespace SandronesLibrary.Analysis.TaylorSeries

open Set
open SandronesLibrary.RealAnalysis.Riemann

/-- **Taylor 公式的积分型余项**：若 `f` 具有连续的 `n+1` 阶导数且 `c<x`，则

`f(x)=Pₙ(x)+∫[c,x] (x-t)ⁿ/n! · f⁽ⁿ⁺¹⁾(t) dt`，

其中积分是本库从 Darboux 下和定义的 `riemannIntegral`。

> **Entry**: analysis.mvt.taylor-integral-remainder
-/
theorem integral_remainder {f : ℝ → ℝ} {n : ℕ} {c x : ℝ}
    (hcx : c < x) (hf : ContDiff ℝ (n + 1) f) :
    f x = polynomial f n c x +
      riemannIntegral
        (fun t => (x - t) ^ n / (n.factorial : ℝ) * iteratedDeriv (n + 1) f t) c x := by
  have hmath := taylor_integral_remainder (f := f) (x := x) (x₀ := c) (n := n)
    hf.contDiffOn
  have hpoly : taylorWithinEval f n (uIcc c x) c x = polynomial f n c x := by
    exact taylorWithinEval_eq_polynomial hcx.ne (hf.of_le (by norm_cast; omega))
  have hs : UniqueDiffOn ℝ (uIcc c x) := uniqueDiffOn_uIcc hcx.ne
  have hinter :
      (∫ t in c..x,
        ((x - t) ^ n / (n.factorial : ℝ)) *
          iteratedDerivWithin (n + 1) f (uIcc c x) t) =
      ∫ t in c..x,
        ((x - t) ^ n / (n.factorial : ℝ)) * iteratedDeriv (n + 1) f t := by
    apply intervalIntegral.integral_congr_uIoo
    intro t ht
    change (x - t) ^ n / (n.factorial : ℝ) *
        iteratedDerivWithin (n + 1) f (uIcc c x) t =
      (x - t) ^ n / (n.factorial : ℝ) * iteratedDeriv (n + 1) f t
    rw [iteratedDerivWithin_eq_iteratedDeriv hs hf.contDiffAt
      (uIoo_subset_uIcc_self ht)]
  have hderivCont : Continuous (iteratedDeriv (n + 1) f) :=
    hf.continuous_iteratedDeriv (n + 1) (by norm_cast)
  have hintCont : Continuous
      (fun t => (x - t) ^ n / (n.factorial : ℝ) * iteratedDeriv (n + 1) f t) :=
    (((continuous_const.sub continuous_id).pow n).div_const _).mul hderivCont
  have hbridge : riemannIntegral
      (fun t => (x - t) ^ n / (n.factorial : ℝ) * iteratedDeriv (n + 1) f t) c x =
      ∫ t in c..x,
        ((x - t) ^ n / (n.factorial : ℝ)) * iteratedDeriv (n + 1) f t := by
    rw [riemannIntegral_eq_interval hcx hintCont.continuousOn,
      ← intervalIntegral.integral_of_le hcx.le]
  rw [hpoly] at hmath
  simp only [smul_eq_mul] at hmath
  rw [hinter, ← hbridge] at hmath
  linarith

/-- **指数函数实例**：由于指数函数的任意阶导数仍为自身，其积分余项简化为
`∫[c,x] (x-t)ⁿ/n! · exp(t) dt`。 -/
theorem exp_integral_remainder {n : ℕ} {c x : ℝ} (hcx : c < x) :
    Real.exp x = polynomial Real.exp n c x +
      riemannIntegral
        (fun t => (x - t) ^ n / (n.factorial : ℝ) * Real.exp t) c x := by
  have hiter : iteratedDeriv (n + 1) Real.exp = Real.exp := by
    funext t
    have ht := congrFun (iteratedDeriv_exp_const_mul (n + 1) 1) t
    simpa using ht
  simpa [hiter] using integral_remainder (f := Real.exp) (n := n) hcx Real.contDiff_exp

end SandronesLibrary.Analysis.TaylorSeries
