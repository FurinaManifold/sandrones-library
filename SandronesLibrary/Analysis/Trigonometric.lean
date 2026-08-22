/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

/-!
# Analysis / Trigonometric —— 高中教材层三角函数基本性质

本模块先整理三角函数的奇偶性、`2π` 周期性和基本有界性。
和差、倍角、积化和差等恒等式在后续批次中继续纳入。
-/

namespace SandronesLibrary
namespace Analysis.Trigonometric

/-- 正弦函数是奇函数。 -/
theorem sin_neg (x : ℝ) : Real.sin (-x) = -Real.sin x := by
  exact Real.sin_neg x

/-- 余弦函数是偶函数。 -/
theorem cos_neg (x : ℝ) : Real.cos (-x) = Real.cos x := by
  exact Real.cos_neg x

/-- 正弦函数的周期为 `2π`。
> **Entry**: analysis.trigonometric.basic-identities
-/
theorem sin_add_two_pi (x : ℝ) : Real.sin (x + 2 * Real.pi) = Real.sin x := by
  exact Real.sin_add_two_pi x

/-- 余弦函数的周期为 `2π`。 -/
theorem cos_add_two_pi (x : ℝ) : Real.cos (x + 2 * Real.pi) = Real.cos x := by
  exact Real.cos_add_two_pi x

/-- 正弦函数的绝对值不超过 `1`。 -/
theorem sin_bound (x : ℝ) : |Real.sin x| ≤ 1 := by
  exact abs_le.2 ⟨Real.neg_one_le_sin x, Real.sin_le_one x⟩

/-- 余弦函数的绝对值不超过 `1`。 -/
theorem cos_bound (x : ℝ) : |Real.cos x| ≤ 1 := by
  exact abs_le.2 ⟨Real.neg_one_le_cos x, Real.cos_le_one x⟩

end Analysis.Trigonometric
end SandronesLibrary
