/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.RealAnalysis.Riemann

/-!
# Riemann 积分的代数与序性质

本模块处理闭区间连续函数的教材型 Riemann 积分性质。核心策略不是重新展开
Darboux 上下和，而是调用 `riemannIntegral_eq_interval`：该定理已经证明自建
Riemann 积分值与 Mathlib 区间积分值相等，因此可在区间积分侧完成代数运算，
再把结论转回 `riemannIntegral`。

这里仍然得到的是本库自建 Riemann 积分的定理；Mathlib 只承担等值桥梁之后的
积分计算，不提供 Riemann 积分定义。
-/

namespace SandronesLibrary.RealAnalysis.Riemann

open MeasureTheory
open scoped ENNReal Interval BigOperators

/-- 常值函数在非退化闭区间上黎曼可积。
> **Entry**: real-analysis.riemann.algebra
-/
theorem riemannIntegrable_const_lt {a b c : ℝ} (hab : a < b) :
    RiemannIntegrable (fun _ : ℝ => c) a b := by
  exact continuous_on_riemannIntegrable_lt hab continuousOn_const

/-- 常值函数的黎曼积分等于常数乘区间长度。 -/
theorem riemannIntegral_const {a b c : ℝ} (hab : a < b) :
    riemannIntegral (fun _ : ℝ => c) a b = c * (b - a) := by
  rw [riemannIntegral_eq_interval hab continuousOn_const]
  rw [integral_const]
  simp [hab.le, mul_comm]

/-- 连续函数之和的黎曼积分满足线性。 -/
theorem riemannIntegral_add {f g : ℝ → ℝ} {a b : ℝ} (hab : a < b)
    (hf : ContinuousOn f (Set.Icc a b)) (hg : ContinuousOn g (Set.Icc a b)) :
    riemannIntegral (fun x => f x + g x) a b =
      riemannIntegral f a b + riemannIntegral g a b := by
  rw [riemannIntegral_eq_interval (f := fun x => f x + g x) hab (hf.add hg),
    riemannIntegral_eq_interval hab hf, riemannIntegral_eq_interval hab hg]
  have hfi := continuous_intervalIntegrable hab.le hf
  have hgi := continuous_intervalIntegrable hab.le hg
  simpa only [intervalIntegral.integral_of_le hab.le] using
    intervalIntegral.integral_add hfi hgi

/-- 连续函数之差的黎曼积分满足线性。 -/
theorem riemannIntegral_sub {f g : ℝ → ℝ} {a b : ℝ} (hab : a < b)
    (hf : ContinuousOn f (Set.Icc a b)) (hg : ContinuousOn g (Set.Icc a b)) :
    riemannIntegral (fun x => f x - g x) a b =
      riemannIntegral f a b - riemannIntegral g a b := by
  rw [riemannIntegral_eq_interval (f := fun x => f x - g x) hab (hf.sub hg),
    riemannIntegral_eq_interval hab hf, riemannIntegral_eq_interval hab hg]
  have hfi := continuous_intervalIntegrable hab.le hf
  have hgi := continuous_intervalIntegrable hab.le hg
  simpa only [intervalIntegral.integral_of_le hab.le] using
    intervalIntegral.integral_sub hfi hgi

/-- 连续函数乘常数后，常数可提出黎曼积分号。 -/
theorem riemannIntegral_const_mul {f : ℝ → ℝ} {a b c : ℝ} (hab : a < b)
    (hf : ContinuousOn f (Set.Icc a b)) :
    riemannIntegral (fun x => c * f x) a b = c * riemannIntegral f a b := by
  rw [riemannIntegral_eq_interval (f := fun x => c * f x) hab (continuousOn_const.mul hf),
    riemannIntegral_eq_interval hab hf]
  simpa only [intervalIntegral.integral_of_le hab.le] using
    intervalIntegral.integral_const_mul c f (a := a) (b := b) (μ := volume)

/-- 区间上非负的连续函数具有非负黎曼积分。 -/
theorem riemannIntegral_nonneg {f : ℝ → ℝ} {a b : ℝ} (hab : a < b)
    (hf : ContinuousOn f (Set.Icc a b)) (h0 : ∀ x ∈ Set.Icc a b, 0 ≤ f x) :
    0 ≤ riemannIntegral f a b := by
  rw [riemannIntegral_eq_interval hab hf, ← intervalIntegral.integral_of_le hab.le]
  exact intervalIntegral.integral_nonneg hab.le h0

/-- 连续函数逐点有序时，其黎曼积分保持该顺序。 -/
theorem riemannIntegral_mono {f g : ℝ → ℝ} {a b : ℝ} (hab : a < b)
    (hf : ContinuousOn f (Set.Icc a b)) (hg : ContinuousOn g (Set.Icc a b))
    (hfg : ∀ x ∈ Set.Icc a b, f x ≤ g x) :
    riemannIntegral f a b ≤ riemannIntegral g a b := by
  rw [riemannIntegral_eq_interval hab hf, riemannIntegral_eq_interval hab hg,
    ← intervalIntegral.integral_of_le hab.le, ← intervalIntegral.integral_of_le hab.le]
  exact intervalIntegral.integral_mono_on hab.le
    (continuous_intervalIntegrable hab.le hf) (continuous_intervalIntegrable hab.le hg) hfg

/-- 连续函数黎曼积分的绝对值不超过其绝对值函数的黎曼积分。 -/
theorem abs_riemannIntegral_le_riemannIntegral_abs {f : ℝ → ℝ} {a b : ℝ} (hab : a < b)
    (hf : ContinuousOn f (Set.Icc a b)) :
    |riemannIntegral f a b| ≤ riemannIntegral (fun x => |f x|) a b := by
  rw [riemannIntegral_eq_interval hab hf,
    riemannIntegral_eq_interval hab hf.abs,
    ← intervalIntegral.integral_of_le hab.le, ← intervalIntegral.integral_of_le hab.le]
  exact intervalIntegral.abs_integral_le_integral_abs hab.le

/-- 连续函数的黎曼积分对相邻区间可加。 -/
theorem riemannIntegral_add_adjacent {f : ℝ → ℝ} {a b c : ℝ}
    (hab : a < b) (hbc : b < c) (hf : ContinuousOn f (Set.Icc a c)) :
    riemannIntegral f a b + riemannIntegral f b c = riemannIntegral f a c := by
  have hac : a < c := hab.trans hbc
  have hfab : ContinuousOn f (Set.Icc a b) :=
    hf.mono (Set.Icc_subset_Icc_right hbc.le)
  have hfbc : ContinuousOn f (Set.Icc b c) :=
    hf.mono (Set.Icc_subset_Icc_left hab.le)
  rw [riemannIntegral_eq_interval hab hfab, riemannIntegral_eq_interval hbc hfbc,
    riemannIntegral_eq_interval hac hf,
    ← intervalIntegral.integral_of_le hab.le, ← intervalIntegral.integral_of_le hbc.le,
    ← intervalIntegral.integral_of_le hac.le]
  exact intervalIntegral.integral_add_adjacent_intervals
    (continuous_intervalIntegrable hab.le hfab) (continuous_intervalIntegrable hbc.le hfbc)

end SandronesLibrary.RealAnalysis.Riemann
