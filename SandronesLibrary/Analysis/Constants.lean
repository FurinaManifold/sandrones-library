/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

/-!
# Analysis / Constants —— 重要数学常数

本模块首先整理自然常数 `e` 的教材层接口。这里把 `e` 定义为 `exp 1`，
随后登记它的正性、数值范围和与自然对数的反函数关系。`e` 的无理性需要
级数或积分的额外算术估计，留在后续批次，不由本模块的微积分性质直接推出。
-/

namespace SandronesLibrary
namespace Analysis.Constants

/-- 自然常数 `e` 的定义：指数函数在 `1` 点的值。 -/
noncomputable def e : ℝ := Real.exp 1

/-- `e` 展开为指数函数在 `1` 点的值。
> **Entry**: analysis.constants.e-definition
-/
theorem e_eq_exp_one : e = Real.exp 1 := by
  rfl

/-- 自然常数 `e` 为正。 -/
theorem e_pos : 0 < e := by
  rw [e_eq_exp_one]
  exact Real.exp_pos 1

/-- 自然常数 `e` 严格大于 `2`。 -/
theorem e_gt_two : 2 < e := by
  rw [e_eq_exp_one]
  exact Real.exp_one_gt_two

/-- 自然常数 `e` 严格小于 `3`。 -/
theorem e_lt_three : e < 3 := by
  rw [e_eq_exp_one]
  exact Real.exp_one_lt_three

/-- 自然对数在 `e` 点的值为 `1`。 -/
theorem log_e : Real.log e = 1 := by
  rw [e_eq_exp_one]
  exact Real.log_exp 1

/-! ### 圆周率 `π` 的基本接口 -/

/-- 圆周率 `π` 的教材层命名接口。 -/
noncomputable def pi : ℝ := Real.pi

/-- 本库的 `π` 接口就是 Mathlib 的实圆周率。
> **Entry**: analysis.constants.pi-definition
-/
theorem pi_eq_real_pi : pi = Real.pi := by
  rfl

/-- 圆周率为正。 -/
theorem pi_pos : 0 < pi := by
  rw [pi_eq_real_pi]
  exact Real.pi_pos

/-- 圆周率非零。 -/
theorem pi_ne_zero : pi ≠ 0 := by
  rw [pi_eq_real_pi]
  exact Real.pi_ne_zero

/-- `sin π = 0`。 -/
theorem sin_pi : Real.sin pi = 0 := by
  rw [pi_eq_real_pi]
  exact Real.sin_pi

/-- `cos π = -1`。 -/
theorem cos_pi : Real.cos pi = -1 := by
  rw [pi_eq_real_pi]
  exact Real.cos_pi

/-- 周期量 `2π` 为正。 -/
theorem two_pi_pos : 0 < 2 * pi := by
  rw [pi_eq_real_pi]
  exact Real.two_pi_pos

/-! ### 初等函数的常用特殊值 -/

/-- 指数函数在零点的值。 -/
theorem exp_zero : Real.exp 0 = 1 := by
  exact Real.exp_zero

/-- 指数函数在一点的值就是自然常数 `e`。 -/
theorem exp_one : Real.exp 1 = e := by
  rfl

/-- 自然对数在 `1` 点的值。 -/
theorem log_one : Real.log 1 = 0 := by
  exact Real.log_one

/-- 正弦函数在零点的值。 -/
theorem sin_zero : Real.sin 0 = 0 := by
  exact Real.sin_zero

/-- 余弦函数在零点的值。 -/
theorem cos_zero : Real.cos 0 = 1 := by
  exact Real.cos_zero

/-- 正弦函数在 `π/2` 点的值。
> **Entry**: analysis.constants.special-values
-/
theorem sin_pi_div_two : Real.sin (Real.pi / 2) = 1 := by
  exact Real.sin_pi_div_two

/-- 余弦函数在 `π/2` 点的值。 -/
theorem cos_pi_div_two : Real.cos (Real.pi / 2) = 0 := by
  exact Real.cos_pi_div_two

/-- 正弦函数在 `π` 点的值。 -/
theorem sin_pi_value : Real.sin Real.pi = 0 := by
  exact Real.sin_pi

/-- 余弦函数在 `π` 点的值。 -/
theorem cos_pi_value : Real.cos Real.pi = -1 := by
  exact Real.cos_pi

/-! ### 非完全幂的整数根无理性 -/

/-- 若实数的正整数次幂是整数，但该整数不是整数的同次幂，则该实数无理。
> **Entry**: analysis.constants.nth-root-irrational
-/
theorem irrational_nth_root_of_not_perfect {x : ℝ} {n : ℕ} {m : ℤ}
    (hpow : x ^ n = (m : ℝ))
    (hnot : ¬ ∃ z : ℤ, (z : ℝ) ^ n = (m : ℝ))
    (hnpos : 0 < n) : Irrational x := by
  apply irrational_nrt_of_notint_nrt n m hpow ?_ hnpos
  rintro ⟨z, hz⟩
  apply hnot
  refine ⟨z, ?_⟩
  rw [← hz]
  exact hpow

end Analysis.Constants
end SandronesLibrary
