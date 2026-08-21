/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

open Filter Topology
open scoped Filter Topology

/-!
# Analysis / Continuity —— 连续函数基础条目（第五章）

本文件当前条目（引理清单，§3.11：一次一条，逐条编译）：

* **analysis.continuity.definition**（点连续 ↔ 序列连续）。
* **analysis.continuity.const**（常函数连续）。
* **analysis.continuity.identity**（恒等/坐标投影连续）。
* **analysis.continuity.add**（连续函数之和连续）。
* **analysis.continuity.mul**（连续函数之积连续）。
* **analysis.continuity.div**（连续函数之商连续，分母非零）。
* **analysis.continuity.comp**（复合连续）。
* **analysis.continuity.intermediate-value**（介值定理）。
* **analysis.continuity.max-min**（最值定理）。
* **analysis.continuity.uniform**（一致连续及其 ⟹ 连续）。
* **analysis.continuity.inverse**（反函数连续：严格单调函数 f 的反函数在值域上连续，教材 ε-δ 证明）。
-/

namespace SandronesLibrary

namespace Analysis.Continuity

/-- 常函数连续。 
> **Entry**: analysis.continuity.const
-/
lemma continuous_const_real (c : ℝ) : Continuous fun _ : ℝ => c :=
  continuous_const

/-- 恒等函数连续。 
> **Entry**: analysis.continuity.identity
-/
lemma continuous_id_real : Continuous (id : ℝ → ℝ) :=
  continuous_id

/-- 连续函数之和连续。 
> **Entry**: analysis.continuity.add
-/
lemma continuous_add {f g : ℝ → ℝ} (hf : Continuous f) (hg : Continuous g) :
    Continuous (fun x => f x + g x) :=
  hf.add hg

/-- 连续函数之积连续。 
> **Entry**: analysis.continuity.mul
-/
lemma continuous_mul {f g : ℝ → ℝ} (hf : Continuous f) (hg : Continuous g) :
    Continuous (fun x => f x * g x) :=
  hf.mul hg

/-- 连续函数之商连续（分母处处非零）。 
> **Entry**: analysis.continuity.div
-/
lemma continuous_div {f g : ℝ → ℝ} (hf : Continuous f) (hg : Continuous g)
    (h0 : ∀ x, g x ≠ 0) : Continuous (fun x => f x / g x) :=
  hf.div hg h0

/-- 复合连续：连续函数复合仍连续。 
> **Entry**: analysis.continuity.comp
-/
lemma continuous_comp {f : ℝ → ℝ} {g : ℝ → ℝ} (hg : Continuous g) (hf : Continuous f) :
    Continuous (fun x => g (f x)) :=
  hg.comp hf

/-- 点连续的复合。 
> **Entry**: analysis.continuity.comp
-/
lemma continuousAt_comp {f : ℝ → ℝ} {g : ℝ → ℝ} {x : ℝ}
    (hg : ContinuousAt g (f x)) (hf : ContinuousAt f x) :
    ContinuousAt (fun y => g (f y)) x :=
  hg.comp hf

/-- 连续函数在某区间上的限制连续。 
> **Entry**: analysis.continuity.definition
-/
lemma continuousOn_Icc {f : ℝ → ℝ} (hf : Continuous f) {a b : ℝ} :
    ContinuousOn f (Set.Icc a b) :=
  hf.continuousOn

/-- 介值定理：闭区间上连续函数 f 在端点值之间取遍所有中间值。
  即 f(a) ≤ y ≤ f(b)（或反向）时，存在 x ∈ [a,b] 使 f x = y。 
> **Entry**: analysis.continuity.intermediate-value
-/
theorem intermediate_value {f : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hf : ContinuousOn f (Set.Icc a b)) {y : ℝ} (h : y ∈ Set.Icc (f a) (f b)) :
    ∃ x ∈ Set.Icc a b, f x = y := by
  have hsub : Set.Icc (f a) (f b) ⊆ f '' Set.Icc a b := intermediate_value_Icc hab hf
  have hyimg : y ∈ f '' Set.Icc a b := hsub h
  rcases hyimg with ⟨x, hx, hfx⟩
  exact ⟨x, hx, hfx⟩

/-- 最值定理（最大值）：闭区间上连续函数必取到最大值。
  证明：把 f 限制到紧集 Icc a b，其值域也是紧集（连续像紧），
  紧集含上确界，故存在 x 使 f x 为最大。 
> **Entry**: analysis.continuity.max-min
-/
theorem exists_isGreatest_on_Icc {f : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hf : ContinuousOn f (Set.Icc a b)) :
    ∃ x ∈ Set.Icc a b, ∀ y ∈ Set.Icc a b, f y ≤ f x := by
  let s : Set ℝ := Set.Icc a b
  have hIcc : IsCompact s := CompactIccSpace.isCompact_Icc
  have hne : s.Nonempty := ⟨a, by simp [s, hab]⟩
  have himg : IsCompact (f '' s) := IsCompact.image_of_continuousOn hIcc hf
  have hneimg : (f '' s).Nonempty := hne.image f
  rcases himg.exists_isGreatest hneimg with ⟨M, hM⟩
  rcases hM.1 with ⟨x, hx, hfx⟩
  refine ⟨x, hx, ?_⟩
  intro y hy
  have hyin : f y ∈ f '' s := ⟨y, hy, rfl⟩
  rw [hfx]
  exact hM.2 hyin

/-- 最值定理（最小值）：闭区间上连续函数必取到最小值。 
> **Entry**: analysis.continuity.max-min
-/
theorem exists_isLeast_on_Icc {f : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hf : ContinuousOn f (Set.Icc a b)) :
    ∃ x ∈ Set.Icc a b, ∀ y ∈ Set.Icc a b, f x ≤ f y := by
  let s : Set ℝ := Set.Icc a b
  have hIcc : IsCompact s := CompactIccSpace.isCompact_Icc
  have hne : s.Nonempty := ⟨a, by simp [s, hab]⟩
  have himg : IsCompact (f '' s) := IsCompact.image_of_continuousOn hIcc hf
  have hneimg : (f '' s).Nonempty := hne.image f
  rcases himg.exists_isLeast hneimg with ⟨m, hm⟩
  rcases hm.1 with ⟨x, hx, hfx⟩
  refine ⟨x, hx, ?_⟩
  intro y hy
  have hyin : f y ∈ f '' s := ⟨y, hy, rfl⟩
  rw [hfx]
  exact hm.2 hyin

/-- 一致连续：存在与点无关的 δ（ε-δ 判据）。
  `Metric.uniformContinuous_iff` 把 `UniformContinuous` 展开成教材的 ε-δ 形式。 
> **Entry**: analysis.continuity.uniform
-/
theorem uniformContinuous_iff_eps_delta {f : ℝ → ℝ} :
    UniformContinuous f ↔
      ∀ ε > 0, ∃ δ > 0, ∀ x y, |x - y| < δ → |f x - f y| < ε := by
  rw [Metric.uniformContinuous_iff]
  constructor
  · intro h ε hε
    rcases h ε hε with ⟨δ, hδ, hδδ⟩
    refine ⟨δ, hδ, ?_⟩
    intro x y hxy
    simpa [Real.dist_eq] using hδδ hxy
  · intro h ε hε
    rcases h ε hε with ⟨δ, hδ, hδδ⟩
    refine ⟨δ, hδ, ?_⟩
    intro a b hab
    simpa [Real.dist_eq] using hδδ a b hab

/-- 一致连续函数必连续（点连续是局部性质，一致连续更强）。 
> **Entry**: analysis.continuity.uniform
-/
theorem continuous_of_uniformContinuous {f : ℝ → ℝ} (hf : UniformContinuous f) :
    Continuous f := by
  rw [continuous_iff_continuousAt]
  intro x
  rw [Metric.continuousAt_iff]
  intro ε hε
  rcases (uniformContinuous_iff_eps_delta.mp hf) ε hε with ⟨δ, hδ, hδδ⟩
  refine ⟨δ, hδ, ?_⟩
  intro y hy
  have : |f y - f x| < ε := hδδ y x (by simpa [Real.dist_eq] using hy)
  simpa [Real.dist_eq, abs_sub_comm] using this

/-- **严格单调函数的反函数**（教材记号）：f 严格递增 ⟹ `mono_inv hf` 是其反函数，
  定义在值域 `Set.range f` 上。 -/
noncomputable def mono_inv {f : ℝ → ℝ} (hf : StrictMono f) : ↑(Set.range f) → ℝ :=
  (StrictMono.orderIso f hf).symm

/-- **反函数严格单调**：严格递增函数的反函数仍严格递增。 
> **Entry**: analysis.continuity.inverse
-/
lemma mono_inv_strictMono {f : ℝ → ℝ} (hf : StrictMono f) : StrictMono (mono_inv hf) := by
  unfold mono_inv
  exact (StrictMono.orderIso f hf).symm.strictMono

/-- **f(反函数(y)) = y**：反函数的定义性质。 
> **Entry**: analysis.continuity.inverse
-/
lemma mono_inv_apply {f : ℝ → ℝ} (hf : StrictMono f) (y : ↑(Set.range f)) :
    f (mono_inv hf y) = y.val := by
  unfold mono_inv
  have hz := OrderIso.apply_symm_apply (StrictMono.orderIso f hf) y
  change ⟨f ((StrictMono.orderIso f hf).symm y), _⟩ = y at hz
  exact congrArg Subtype.val hz

/-- **反函数保序**：g y₁ < g y₂ ⟺ y₁ < y₂。 
> **Entry**: analysis.continuity.inverse
-/
lemma mono_inv_lt_iff {f : ℝ → ℝ} (hf : StrictMono f) (y1 y2 : ↑(Set.range f)) :
    mono_inv hf y1 < mono_inv hf y2 ↔ y1 < y2 := by
  unfold mono_inv
  exact OrderIso.lt_iff_lt (StrictMono.orderIso f hf).symm

/-- **反函数在特殊点的取值**：g(⟨f t, _⟩) = t。 
> **Entry**: analysis.continuity.inverse
-/
lemma mono_inv_sub_apply {f : ℝ → ℝ} (hf : StrictMono f) (t : ℝ) :
    mono_inv hf ⟨f t, ⟨t, rfl⟩⟩ = t := by
  unfold mono_inv
  exact OrderIso.symm_apply_apply (StrictMono.orderIso f hf) t

/-- **反函数连续**（教材 ε-δ）：严格单调函数 f 的反函数在值域上连续。
  对 y₀ = f(x₀)，取 δ = min(y₀ − f(x₀−ε), f(x₀+ε) − y₀)，由 f 严格单调与 g 保序，
  |y − y₀| < δ ⟹ x₀−ε < g y < x₀+ε。 
> **Entry**: analysis.continuity.inverse
-/
theorem inverse_continuous {f : ℝ → ℝ} (hf : StrictMono f) : Continuous (mono_inv hf) := by
  rw [Metric.continuous_iff]
  intro y₀ ε hε
  let x₀ := mono_inv hf y₀
  have hfx0 : f x₀ = y₀.val := by dsimp [x₀]; exact mono_inv_apply hf y₀
  have hlt_left : f (x₀ - ε) < y₀.val := by
    have : f (x₀ - ε) < f x₀ := hf (by linarith)
    rwa [hfx0] at this
  have hlt_right : y₀.val < f (x₀ + ε) := by
    have : f x₀ < f (x₀ + ε) := hf (by linarith)
    rwa [hfx0] at this
  let δ := min (y₀.val - f (x₀ - ε)) (f (x₀ + ε) - y₀.val)
  have hδpos : 0 < δ := by
    dsimp [δ]; exact lt_min (sub_pos.mpr hlt_left) (sub_pos.mpr hlt_right)
  refine ⟨δ, hδpos, ?_⟩
  intro y hy
  have hdy : |y.val - y₀.val| < δ := by
    simpa [Subtype.dist_eq, Real.dist_eq] using hy
  have hgl : x₀ - ε < mono_inv hf y := by
    have hyv : f (x₀ - ε) < y.val := by
      have hd_le : |y.val - y₀.val| < y₀.val - f (x₀ - ε) := by
        have : δ ≤ y₀.val - f (x₀ - ε) := by dsimp [δ]; exact min_le_left (y₀.val - f (x₀ - ε)) (f (x₀ + ε) - y₀.val)
        linarith
      have habs := abs_lt.mp hd_le
      linarith
    have hyl := mono_inv_lt_iff hf (y1 := (⟨f (x₀ - ε), ⟨x₀ - ε, rfl⟩⟩ : ↑(Set.range f))) (y2 := y)
    have : mono_inv hf ⟨f (x₀ - ε), ⟨x₀ - ε, rfl⟩⟩ < mono_inv hf y := (hyl).mpr hyv
    simpa [mono_inv_sub_apply hf (x₀ - ε)] using this
  have hgr : mono_inv hf y < x₀ + ε := by
    have hyv : y.val < f (x₀ + ε) := by
      have hd_le : |y.val - y₀.val| < f (x₀ + ε) - y₀.val := by
        have : δ ≤ f (x₀ + ε) - y₀.val := by dsimp [δ]; exact min_le_right (y₀.val - f (x₀ - ε)) (f (x₀ + ε) - y₀.val)
        linarith
      have habs := abs_lt.mp hd_le
      linarith
    have hyr := mono_inv_lt_iff hf (y1 := y) (y2 := (⟨f (x₀ + ε), ⟨x₀ + ε, rfl⟩⟩ : ↑(Set.range f)))
    have : mono_inv hf y < mono_inv hf ⟨f (x₀ + ε), ⟨x₀ + ε, rfl⟩⟩ := (hyr).mpr hyv
    simpa [mono_inv_sub_apply hf (x₀ + ε)] using this
  have : |mono_inv hf y - x₀| < ε := by
    rw [abs_lt]
    constructor <;> linarith
  simpa [Real.dist_eq]

end Analysis.Continuity

end SandronesLibrary