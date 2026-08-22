/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.RealAnalysis.Lp
import Mathlib.MeasureTheory.Integral.MeanInequalities
import Mathlib.MeasureTheory.Function.L1Space.Integrable

/-!
# Hölder 不等式

若 `p,q` 是共轭指数，即 `p,q>1` 且 `1/p+1/q=1`，则函数乘积的 `L¹` 大小不超过
两个函数各自的 `Lᵖ`、`Lᑫ` 大小之积。本模块同时给出范数形式、非负实函数形式，
以及抽象的 `Lᵖ · Lᑫ ⊆ L¹` 可积性结论。
-/

namespace SandronesLibrary.RealAnalysis.Lp

open MeasureTheory

variable {α E 𝕜 : Type*} [MeasurableSpace α] (μ : Measure α)

/-- **Hölder 不等式（范数形式）**：共轭指数下，范数乘积的积分不超过两个幂积分
所定义的 `Lᵖ` 与 `Lᑫ` 半范数之积。

> **Entry**: real-analysis.lp.holder
-/
theorem holder_norm {E : Type*} [NormedAddCommGroup E]
    {f g : α → E} {p q : ℝ} (hpq : p.HolderConjugate q)
    (hf : MemLp f (ENNReal.ofReal p) μ) (hg : MemLp g (ENNReal.ofReal q) μ) :
    ∫ x, ‖f x‖ * ‖g x‖ ∂μ ≤
      (∫ x, ‖f x‖ ^ p ∂μ) ^ (1 / p) * (∫ x, ‖g x‖ ^ q ∂μ) ^ (1 / q) := by
  exact integral_mul_norm_le_Lp_mul_Lq hpq hf hg

/-- **Hölder 不等式（非负实函数形式）**：几乎处处非负时可去掉绝对值。 -/
theorem holder_nonneg {f g : α → ℝ} {p q : ℝ} (hpq : p.HolderConjugate q)
    (hf0 : 0 ≤ᵐ[μ] f) (hg0 : 0 ≤ᵐ[μ] g)
    (hf : MemLp f (ENNReal.ofReal p) μ) (hg : MemLp g (ENNReal.ofReal q) μ) :
    ∫ x, f x * g x ∂μ ≤
      (∫ x, f x ^ p ∂μ) ^ (1 / p) * (∫ x, g x ^ q ∂μ) ^ (1 / q) := by
  exact integral_mul_le_Lp_mul_Lq_of_nonneg hpq hf0 hg0 hf hg

/-- **`Lᵖ · Lᑫ ⊆ L¹`**：对满足 `HolderTriple p q 1` 的扩展实指数，两个函数
的逐点乘积可积。该接口也覆盖端点指数 `1` 与 `∞`。 -/
theorem holder_product_integrable [NormedRing 𝕜] {p q : ENNReal}
    [ENNReal.HolderTriple p q 1] {f g : α → 𝕜}
    (hf : MemLp f p μ) (hg : MemLp g q μ) : Integrable (f * g) μ := by
  exact hf.integrable_mul hg

end SandronesLibrary.RealAnalysis.Lp
