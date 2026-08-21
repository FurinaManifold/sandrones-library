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
* ~~**analysis.continuity.inverse**（严格单调连续 ⟹ 反函数连续）~~：转正批扫描确认，
  mathlib 用 `StrictMono.orderIso` + `OrderIso.toHomeomorph`，但需 `OrderTopology ↑(Set.range f)`
  子类型实例（当前环境缺失），留待专门处理。
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

end Analysis.Continuity

end SandronesLibrary