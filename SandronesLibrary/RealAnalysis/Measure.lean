/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

/-!
# RealAnalysis / Measure —— 测度论基础（数学分析第二学期 R1）

本文件当前条目（引理清单，§0 铁律4：一次一条，逐条编译）：

* **real-analysis.measure.sigma-algebra**（σ-代数公理：空/全集/补/可数并/有限交并可测）✅。
* **real-analysis.measure.def**（测度公理：空集零测/可数可加/单调性/有限可加）✅。
* **real-analysis.measure.outer**（外测度次可加性）✅。
* **real-analysis.measure.caratheodory**（Carathéodory 定理：可测集构成 σ-代数/判据）✅。

> **语言说明**：实分析阶段（§Phase5）mathlib 的 `MeasurableSpace`/`MeasurableSet`/
> `Measure` 等**教材结构可直接出现在签名**（测度积分是 mathlib 的核心库）。
-/

namespace SandronesLibrary

namespace RealAnalysis.Measure

open MeasureTheory

/-- **σ-代数公理：空集可测**。 
> **Entry**: real-analysis.measure.sigma-algebra
-/
theorem meas_measurable_empty {X : Type*} [MeasurableSpace X] : MeasurableSet (∅ : Set X) := by
  exact MeasurableSet.empty

/-- **σ-代数公理：全集可测**。 
> **Entry**: real-analysis.measure.sigma-algebra
-/
theorem meas_measurable_univ {X : Type*} [MeasurableSpace X] : MeasurableSet (Set.univ : Set X) := by
  exact MeasurableSet.univ

/-- **σ-代数公理：补集可测**。 
> **Entry**: real-analysis.measure.sigma-algebra
-/
theorem meas_measurable_compl {X : Type*} [MeasurableSpace X] {s : Set X}
    (hs : MeasurableSet s) : MeasurableSet sᶜ := by
  exact hs.compl

/-- **σ-代数公理：可数并可测**。 
> **Entry**: real-analysis.measure.sigma-algebra
-/
theorem meas_measurable_iUnion {X : Type*} {ι : Type*} [MeasurableSpace X] [Countable ι]
    {f : ι → Set X} (h : ∀ i : ι, MeasurableSet (f i)) : MeasurableSet (⋃ i, f i) := by
  exact MeasurableSet.iUnion h

/-- **σ-代数公理：有限交可测**。 
> **Entry**: real-analysis.measure.sigma-algebra
-/
theorem meas_measurable_inter {X : Type*} [MeasurableSpace X] {s t : Set X}
    (hs : MeasurableSet s) (ht : MeasurableSet t) : MeasurableSet (s ∩ t) := by
  exact hs.inter ht

/-- **σ-代数公理：有限并可测**。 
> **Entry**: real-analysis.measure.sigma-algebra
-/
theorem meas_measurable_union {X : Type*} [MeasurableSpace X] {s t : Set X}
    (hs : MeasurableSet s) (ht : MeasurableSet t) : MeasurableSet (s ∪ t) := by
  exact hs.union ht

/-- **测度公理：空集零测**：μ(∅) = 0。 
> **Entry**: real-analysis.measure.def
-/
theorem meas_measure_empty {X : Type*} [MeasurableSpace X] (μ : Measure X) : μ ∅ = 0 := by
  exact measure_empty

/-- **测度公理：可数可加性**：可数个两两不交的可测集的并的测度 = 各测度之和。 
> **Entry**: real-analysis.measure.def
-/
theorem meas_measure_sUnion {X : Type*} [MeasurableSpace X] (μ : Measure X)
    {S : Set (Set X)} (hs : S.Countable) (hd : S.Pairwise Disjoint)
    (hmeas : ∀ s ∈ S, MeasurableSet s) : μ (⋃₀ S) = ∑' s : S, μ s := by
  exact measure_sUnion (μ := μ) hs hd hmeas

/-- **测度单调性**：s ⊆ t ⟹ μ(s) ≤ μ(t)。 
> **Entry**: real-analysis.measure.def
-/
theorem meas_measure_mono {X : Type*} [MeasurableSpace X] (μ : Measure X) {s t : Set X}
    (hst : s ⊆ t) : μ s ≤ μ t := by
  exact measure_mono hst

/-- **测度有限可加性**：不相交可测集的并的测度 = 测度之和。 
> **Entry**: real-analysis.measure.def
-/
theorem meas_measure_union {X : Type*} [MeasurableSpace X] (μ : Measure X)
    {s₁ s₂ : Set X} (hd : Disjoint s₁ s₂) (hmeas : MeasurableSet s₂) :
    μ (s₁ ∪ s₂) = μ s₁ + μ s₂ := by
  exact measure_union hd hmeas

/-- **外测度次可加性**：外测度满足可数次可加——可数并的测度不超过各测度之和。 
> **Entry**: real-analysis.measure.outer
-/
theorem meas_outer_measure_iUnion_le {X : Type*} {ι : Type*} [Countable ι]
    (m : OuterMeasure X) {s : ι → Set X} : m (⋃ i, s i) ≤ ∑' i, m (s i) := by
  exact measure_iUnion_le s

/-- **Carathéodory 判据**：s 可测 ⟺ 对一切 t，m(t) = m(t∩s) + m(t\s)。
  这是外测度限制成测度的核心判据。 
> **Entry**: real-analysis.measure.caratheodory
-/
theorem meas_caratheodory_iff {X : Type*} {m : OuterMeasure X} {s : Set X} :
    MeasurableSet[m.caratheodory] s ↔ ∀ t : Set X, m t = m (t ∩ s) + m (t \ s) := by
  exact m.isCaratheodory_iff

end RealAnalysis.Measure

end SandronesLibrary