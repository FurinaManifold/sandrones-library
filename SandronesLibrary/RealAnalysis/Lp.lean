/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.RealAnalysis.ProductMeasure
import Mathlib.MeasureTheory.Function.LpSpace.Basic

/-!
# `Lᵖ` 空间：定义、几乎处处等价类与范数

教材常把 `Lᵖ` 暂写成满足 `∫ ‖f‖ᵖ < ∞` 的函数集合，但严格来说，几乎处处相等的
函数必须视为同一个元素，否则“范数为零推出函数为零”不成立。Mathlib 因而分两层：

* `MemLp f p μ` 是普通函数满足可测性和有限 `p`-范数的命题；
* `MeasureTheory.Lp E p μ` 是把函数按 `μ`-几乎处处相等取商后，再限制到有限
  `eLpNorm` 的真正赋范空间。

本文件固定这两层之间的教材接口。Hölder、Minkowski 和完备性将在后续独立条目中建立。
-/

namespace SandronesLibrary.RealAnalysis.Lp

open MeasureTheory
open scoped ENNReal

variable {α E : Type*} [MeasurableSpace α] [NormedAddCommGroup E]
variable (μ : Measure α) (p : ℝ≥0∞)

/-- 本库的教材记号：`LpSpace E p μ` 就是 Mathlib 的 `MeasureTheory.Lp E p μ`。

> **Entry**: real-analysis.lp.basic
-/
abbrev LpSpace (E : Type*) [NormedAddCommGroup E] (p : ℝ≥0∞) (μ : Measure α) :=
  MeasureTheory.Lp E p μ

/-- 普通函数属于 `Lᵖ` 的判据：它几乎处处强可测，并且扩展实数值 `p`-半范数有限。 -/
theorem memLp_iff (f : α → E) :
    MemLp f p μ ↔ AEStronglyMeasurable f μ ∧ eLpNorm f p μ < ∞ := by
  rfl

/-- 把一个满足 `MemLp` 的普通函数送入按几乎处处相等取商后的 `Lᵖ` 空间。 -/
noncomputable def ofFunction (f : α → E) (hf : MemLp f p μ) : LpSpace E p μ :=
  hf.toLp f

/-- `ofFunction` 所选出的代表元与原函数几乎处处相等。 -/
theorem ofFunction_ae_eq (f : α → E) (hf : MemLp f p μ) :
    ofFunction μ p f hf =ᵐ[μ] f := by
  exact hf.coeFn_toLp

/-- 两个普通函数给出同一个 `Lᵖ` 元素，当且仅当它们几乎处处相等。

这条定理明确表达了 `Lᵖ` 的商空间本质，而不是把 `Lᵖ` 误认为逐点函数空间。
-/
theorem ofFunction_eq_iff {f g : α → E} (hf : MemLp f p μ) (hg : MemLp g p μ) :
    ofFunction μ p f hf = ofFunction μ p g hg ↔ f =ᵐ[μ] g := by
  exact MemLp.toLp_eq_toLp_iff hf hg

/-- 从普通函数构造的 `Lᵖ` 元素，其实数范数是 `eLpNorm` 的有限实数值。 -/
theorem norm_ofFunction (f : α → E) (hf : MemLp f p μ) :
    ‖ofFunction μ p f hf‖ = ENNReal.toReal (eLpNorm f p μ) := by
  exact MeasureTheory.Lp.norm_toLp f hf

/-- `Lᵖ` 加法由代表元逐点相加给出，但等式只能在几乎处处意义下陈述。 -/
theorem add_ae_eq (f g : LpSpace E p μ) :
    ⇑(f + g) =ᵐ[μ] fun x => f x + g x := by
  exact MeasureTheory.Lp.coeFn_add f g

/-- `Lᵖ` 元素等于零，当且仅当它的任意函数代表几乎处处为零。 -/
theorem zero_iff_ae_zero (f : LpSpace E p μ) :
    f = 0 ↔ f =ᵐ[μ] (0 : α → E) := by
  exact MeasureTheory.Lp.eq_zero_iff_ae_eq_zero

end SandronesLibrary.RealAnalysis.Lp
