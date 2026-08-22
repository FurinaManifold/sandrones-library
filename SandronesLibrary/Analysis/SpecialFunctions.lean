/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors.
-/
import Mathlib

/-!
# Analysis / SpecialFunctions —— 初等特殊函数第一批

本模块把指数函数与三角函数的基础性质整理成教材层接口。证明直接复用
Mathlib 对实函数的标准构造，但定理陈述保持数学分析教材中的记号：正值、加法公式、
连续性和一阶导数。后续重要极限、反函数和 Riemann 积分例子以这些结果为前置。
-/

namespace SandronesLibrary
namespace Analysis.SpecialFunctions

/-- 指数函数在实轴上处处为正。
-/
theorem exp_pos (x : ℝ) : 0 < Real.exp x := by
  exact Real.exp_pos x

/-- 指数函数把加法变成乘法，是后续极限与微分计算的基本恒等式。
-/
theorem exp_add (x y : ℝ) : Real.exp (x + y) = Real.exp x * Real.exp y := by
  exact Real.exp_add x y

/-- 实指数函数在整个实轴上连续。
-/
theorem continuous_exp : Continuous (Real.exp : ℝ → ℝ) := by
  exact Real.continuous_exp

/-- 指数函数的导数仍为指数函数本身。
-/
theorem deriv_exp (x : ℝ) : deriv Real.exp x = Real.exp x := by
  exact (Real.hasDerivAt_exp x).deriv

/-- 正弦函数在整个实轴上连续。
-/
theorem continuous_sin : Continuous (Real.sin : ℝ → ℝ) := by
  exact Real.continuous_sin

/-- 余弦函数在整个实轴上连续。
-/
theorem continuous_cos : Continuous (Real.cos : ℝ → ℝ) := by
  exact Real.continuous_cos

/-- 正弦函数的导数是余弦函数。
-/
theorem deriv_sin (x : ℝ) : deriv Real.sin x = Real.cos x := by
  exact (Real.hasDerivAt_sin x).deriv

/-- 余弦函数的导数是负的正弦函数。
> **Entry**: analysis.special-functions.basic
-/
theorem deriv_cos (x : ℝ) : deriv Real.cos x = -Real.sin x := by
  exact (Real.hasDerivAt_cos x).deriv

end Analysis.SpecialFunctions
end SandronesLibrary
