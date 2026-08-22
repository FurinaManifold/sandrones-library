/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.RealAnalysis.RiemannPartsSubstitution

/-!
# 初等函数的 Riemann 定积分公式

本模块集中给出数学分析教材最常用的数值积分结果：自然数幂、指数、正弦和余弦。
前四个公式直接使用 `riemannIntegral_eq_sub_of_hasDerivAt`，即 Newton–Leibniz 公式；
最后一个线性余弦例题使用上一模块的换元公式，展示复合函数积分的标准计算路线。

所有结论都是本库自建 `riemannIntegral` 的公式，而不是只停留在 Mathlib 区间积分。
-/

namespace SandronesLibrary.RealAnalysis.Riemann

/-- **幂函数积分**：对任意自然数 `n`，
`∫ₐᵇ xⁿ dx = bⁿ⁺¹/(n+1)-aⁿ⁺¹/(n+1)`。

分母 `n+1` 自动非零，原函数取 `x ↦ x^(n+1)/(n+1)`。

> **Entry**: analysis.integral.examples
-/
theorem riemannIntegral_pow {a b : ℝ} (n : ℕ) (hab : a < b) :
    riemannIntegral (fun x : ℝ => x ^ n) a b =
      b ^ (n + 1) / (n + 1) - a ^ (n + 1) / (n + 1) := by
  apply riemannIntegral_eq_sub_of_hasDerivAt hab (continuousOn_pow n)
  intro x hx
  have hn : (n + 1 : ℝ) ≠ 0 := by positivity
  simpa [Nat.add_sub_cancel, hn] using
    (hasDerivAt_pow (n + 1) x).div_const (n + 1 : ℝ)

/-- **指数函数积分**：`∫ₐᵇ eˣ dx=eᵇ-eᵃ`。 -/
theorem riemannIntegral_exp {a b : ℝ} (hab : a < b) :
    riemannIntegral Real.exp a b = Real.exp b - Real.exp a := by
  exact riemannIntegral_eq_sub_of_hasDerivAt hab Real.continuous_exp.continuousOn
    (fun x _ => Real.hasDerivAt_exp x)

/-- **余弦函数积分**：`∫ₐᵇ cos x dx=sin b-sin a`。 -/
theorem riemannIntegral_cos {a b : ℝ} (hab : a < b) :
    riemannIntegral Real.cos a b = Real.sin b - Real.sin a := by
  exact riemannIntegral_eq_sub_of_hasDerivAt hab Real.continuous_cos.continuousOn
    (fun x _ => Real.hasDerivAt_sin x)

/-- **正弦函数积分**：`∫ₐᵇ sin x dx=cos a-cos b`，原函数为 `-cos`。 -/
theorem riemannIntegral_sin {a b : ℝ} (hab : a < b) :
    riemannIntegral Real.sin a b = Real.cos a - Real.cos b := by
  have h := riemannIntegral_eq_sub_of_hasDerivAt
    (F := fun x => -Real.cos x) hab Real.continuous_sin.continuousOn
    (fun x _ => (Real.hasDerivAt_cos x).neg.congr_deriv (neg_neg _))
  linarith

/-- **线性三角换元例**：当 `c>0` 时，令 `t=cx+d`，得到
`∫ₐᵇ c cos(cx+d) dx=sin(cb+d)-sin(ca+d)`。 -/
theorem riemannIntegral_const_mul_cos_affine {a b c d : ℝ}
    (hab : a < b) (hc : 0 < c) :
    riemannIntegral (fun x => Real.cos (c * x + d) * c) a b =
      Real.sin (c * b + d) - Real.sin (c * a + d) := by
  have hφab : c * a + d < c * b + d := by
    simpa [add_comm] using add_lt_add_right (mul_lt_mul_of_pos_left hab hc) d
  have hsubst := riemannIntegral_comp_mul_deriv
    (φ := fun x : ℝ => c * x + d) (φ' := fun _ : ℝ => c)
    (g := Real.cos) hab hφab
    ((continuousOn_const.mul continuousOn_id).add continuousOn_const)
    continuousOn_const
    (fun x _ => by simpa using ((hasDerivAt_id x).const_mul c).add_const d)
    Real.continuous_cos
  rw [riemannIntegral_cos hφab] at hsubst
  simpa [Function.comp_def] using hsubst

end SandronesLibrary.RealAnalysis.Riemann
