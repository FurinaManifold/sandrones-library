/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Analysis.PowerSeries
import SandronesLibrary.Analysis.MVT
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Series

/-!
# 完整 Taylor 展开

本文件把有限阶 Taylor 公式与无穷幂级数展开放在同一个教材接口中：

1. 对任意充分光滑的实函数定义任意中心、任意阶 Taylor 多项式；
2. 给出任意阶 Lagrange 精确余项和统一绝对值估计；
3. 给出 `exp`、`sin`、`cos` 在全体实数上的完整无穷级数展开；
4. 给出三者任意阶截断误差，其中指数函数还保留任意展开中心的精确余项。

有限阶公式不依赖无穷级数；无穷展开则使用已经建立的幂级数与 Mathlib 的全局收敛结果。
-/

namespace SandronesLibrary.Analysis.TaylorSeries

open Set
open scoped Topology

/-- 函数 `f` 在中心 `c` 的 `n` 阶 Taylor 多项式在 `x` 处的值：
`Σ_{k=0}^n f⁽ᵏ⁾(c)(x-c)ᵏ/k!`。

> **Entry**: analysis.series.taylor
-/
noncomputable def polynomial (f : ℝ → ℝ) (n : ℕ) (c x : ℝ) : ℝ :=
  ∑ k ∈ Finset.range (n + 1), iteratedDeriv k f c * (x - c) ^ k / (k.factorial : ℝ)

/-- Taylor 多项式在展开中心的值等于函数值。 -/
theorem polynomial_self (f : ℝ → ℝ) (n : ℕ) (c : ℝ) :
    polynomial f n c c = f c := by
  rw [polynomial, Finset.sum_eq_single 0]
  · simp
  · intro k hk hk0
    simp [hk0]
  · simp

/-- 在非退化无序区间上，Mathlib 的区间内 Taylor 多项式等于全局迭代导数写成的教材公式。 -/
theorem taylorWithinEval_eq_polynomial {f : ℝ → ℝ} {n : ℕ} {c x : ℝ}
    (hcx : c ≠ x) (hf : ContDiff ℝ n f) :
    taylorWithinEval f n (uIcc c x) c x = polynomial f n c x := by
  rw [taylor_within_apply]
  simp only [polynomial]
  apply Finset.sum_congr rfl
  intro k hk
  have hkn : k ≤ n := Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
  have hkord : (k : WithTop ℕ∞) ≤ (n : WithTop ℕ∞) := by exact_mod_cast hkn
  have hderiv : iteratedDerivWithin k f (uIcc c x) c = iteratedDeriv k f c := by
    simp only [iteratedDerivWithin_eq_iteratedFDerivWithin, iteratedDeriv_eq_iteratedFDeriv]
    rw [iteratedFDerivWithin_eq_iteratedFDeriv (n := k) (uniqueDiffOn_uIcc hcx)
      (hf.of_le hkord).contDiffAt (by simp)]
  rw [hderiv]
  simp only [smul_eq_mul]
  ring

/-- **任意阶 Taylor–Lagrange 公式**。

若 `f` 具有连续的 `n+1` 阶导数且 `c≠x`，则在 `c` 与 `x` 之间存在 `ξ`，使
`f(x)=Pₙ(x)+f⁽ⁿ⁺¹⁾(ξ)(x-c)ⁿ⁺¹/(n+1)!`。 -/
theorem lagrange_remainder {f : ℝ → ℝ} {n : ℕ} {c x : ℝ}
    (hcx : c ≠ x) (hf : ContDiff ℝ (n + 1) f) :
    ∃ ξ ∈ uIoo c x,
      f x = polynomial f n c x +
        iteratedDeriv (n + 1) f ξ * (x - c) ^ (n + 1) / ((n + 1).factorial : ℝ) := by
  rcases taylor_mean_remainder_lagrange_iteratedDeriv hcx hf.contDiffOn with ⟨ξ, hξ, hrem⟩
  refine ⟨ξ, hξ, ?_⟩
  rw [← taylorWithinEval_eq_polynomial hcx hf.of_succ]
  linarith

/-- **Taylor 余项的统一绝对值界**。

若连接 `c` 与 `x` 的闭区间上 `|f⁽ⁿ⁺¹⁾|≤M`，则截断误差不超过
`M|x-c|ⁿ⁺¹/(n+1)!`。定理同时处理退化情形 `x=c`。 -/
theorem remainder_abs_le {f : ℝ → ℝ} {n : ℕ} {c x M : ℝ}
    (hf : ContDiff ℝ (n + 1) f)
    (hM : ∀ y ∈ uIcc c x, |iteratedDeriv (n + 1) f y| ≤ M) :
    |f x - polynomial f n c x| ≤
      M * |x - c| ^ (n + 1) / ((n + 1).factorial : ℝ) := by
  by_cases hcx : c = x
  · subst x
    rw [polynomial_self]
    simp
  · rcases lagrange_remainder (n := n) hcx hf with ⟨ξ, hξ, hrem⟩
    have hξI : ξ ∈ uIcc c x := uIoo_subset_uIcc_self hξ
    have hderiv := hM ξ hξI
    have hfac : 0 < ((n + 1).factorial : ℝ) := by positivity
    rw [hrem]
    simp only [add_sub_cancel_left]
    rw [abs_div, abs_mul, abs_pow, abs_of_pos hfac]
    exact div_le_div_of_nonneg_right
      (mul_le_mul_of_nonneg_right hderiv (pow_nonneg (abs_nonneg _) _)) hfac.le

/-- 指数函数 Taylor 级数的第 `n` 项 `xⁿ/n!`。 -/
noncomputable def expTerm (x : ℝ) (n : ℕ) : ℝ := x ^ n / (n.factorial : ℝ)

/-- 余弦函数 Taylor 级数的第 `n` 个非零项 `(-1)ⁿx²ⁿ/(2n)!`。 -/
noncomputable def cosTerm (x : ℝ) (n : ℕ) : ℝ :=
  (-1 : ℝ) ^ n * x ^ (2 * n) / ((2 * n).factorial : ℝ)

/-- 正弦函数 Taylor 级数的第 `n` 个非零项 `(-1)ⁿx²ⁿ⁺¹/(2n+1)!`。 -/
noncomputable def sinTerm (x : ℝ) (n : ℕ) : ℝ :=
  (-1 : ℝ) ^ n * x ^ (2 * n + 1) / ((2 * n + 1).factorial : ℝ)

/-- 指数 Taylor 级数在每个实数处收敛到 `exp x`。 -/
theorem hasSum_exp (x : ℝ) : HasSum (expTerm x) (Real.exp x) := by
  change HasSum (fun n => x ^ n / (n.factorial : ℝ)) (Real.exp x)
  rw [Real.exp_eq_exp_ℝ]
  exact NormedSpace.expSeries_div_hasSum_exp x

/-- 余弦 Taylor 级数在每个实数处收敛到 `cos x`。 -/
theorem hasSum_cos (x : ℝ) : HasSum (cosTerm x) (Real.cos x) := by
  change HasSum
    (fun n => (-1 : ℝ) ^ n * x ^ (2 * n) / ((2 * n).factorial : ℝ)) (Real.cos x)
  exact Real.hasSum_cos x

/-- 正弦 Taylor 级数在每个实数处收敛到 `sin x`。 -/
theorem hasSum_sin (x : ℝ) : HasSum (sinTerm x) (Real.sin x) := by
  change HasSum
    (fun n => (-1 : ℝ) ^ n * x ^ (2 * n + 1) / ((2 * n + 1).factorial : ℝ))
    (Real.sin x)
  exact Real.hasSum_sin x

/-- 指数函数的完整无穷 Taylor 展开。 -/
theorem exp_eq_tsum (x : ℝ) : Real.exp x = ∑' n, expTerm x n :=
  (hasSum_exp x).tsum_eq.symm

/-- 余弦函数的完整无穷 Taylor 展开。 -/
theorem cos_eq_tsum (x : ℝ) : Real.cos x = ∑' n, cosTerm x n :=
  (hasSum_cos x).tsum_eq.symm

/-- 正弦函数的完整无穷 Taylor 展开。 -/
theorem sin_eq_tsum (x : ℝ) : Real.sin x = ∑' n, sinTerm x n :=
  (hasSum_sin x).tsum_eq.symm

/-- 指数函数在任意中心 `c` 的任意阶 Lagrange 精确余项。 -/
theorem exp_lagrange_remainder {n : ℕ} {c x : ℝ} (hcx : c ≠ x) :
    ∃ ξ ∈ uIoo c x,
      Real.exp x = polynomial Real.exp n c x +
        Real.exp ξ * (x - c) ^ (n + 1) / ((n + 1).factorial : ℝ) := by
  rcases lagrange_remainder (n := n) hcx Real.contDiff_exp with ⟨ξ, hξ, hrem⟩
  refine ⟨ξ, hξ, ?_⟩
  have hexp : iteratedDeriv (n + 1) Real.exp ξ = Real.exp ξ := by
    have h := congrFun (iteratedDeriv_exp_const_mul (n + 1) 1) ξ
    simpa using h
  simpa [hexp] using hrem

/-- 正弦函数在零点截断到任意阶后的误差不超过 `|x|ⁿ⁺¹/(n+1)!`。 -/
theorem sin_remainder_abs_le (n : ℕ) (x : ℝ) :
    |Real.sin x - polynomial Real.sin n 0 x| ≤
      |x| ^ (n + 1) / ((n + 1).factorial : ℝ) := by
  have h := remainder_abs_le (f := Real.sin) (n := n) (c := 0) (x := x) (M := 1)
    Real.contDiff_sin (fun y _ => Real.abs_iteratedDeriv_sin_le_one (n + 1) y)
  simpa using h

/-- 余弦函数在零点截断到任意阶后的误差不超过 `|x|ⁿ⁺¹/(n+1)!`。 -/
theorem cos_remainder_abs_le (n : ℕ) (x : ℝ) :
    |Real.cos x - polynomial Real.cos n 0 x| ≤
      |x| ^ (n + 1) / ((n + 1).factorial : ℝ) := by
  have h := remainder_abs_le (f := Real.cos) (n := n) (c := 0) (x := x) (M := 1)
    Real.contDiff_cos (fun y _ => Real.abs_iteratedDeriv_cos_le_one (n + 1) y)
  simpa using h

/-- 指数函数在零点截断到任意阶后的全局误差界。区间内的余项导数由 `exp |x|` 控制。 -/
theorem exp_remainder_abs_le (n : ℕ) (x : ℝ) :
    |Real.exp x - polynomial Real.exp n 0 x| ≤
      Real.exp |x| * |x| ^ (n + 1) / ((n + 1).factorial : ℝ) := by
  have h := remainder_abs_le (f := Real.exp) (n := n) (c := 0) (x := x)
    (M := Real.exp |x|) Real.contDiff_exp (by
      intro y hy
      have hiter : iteratedDeriv (n + 1) Real.exp y = Real.exp y := by
        have hi := congrFun (iteratedDeriv_exp_const_mul (n + 1) 1) y
        simpa using hi
      rw [hiter, abs_of_pos (Real.exp_pos y)]
      apply Real.exp_le_exp.mpr
      rcases le_total 0 x with hx | hx
      · rw [uIcc_of_le hx] at hy
        calc
          y ≤ x := hy.2
          _ = |x| := (abs_of_nonneg hx).symm
      · rw [uIcc_comm, uIcc_of_le hx] at hy
        exact hy.2.trans (abs_nonneg x))
  simpa using h

end SandronesLibrary.Analysis.TaylorSeries
