/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

/-!
# RealAnalysis / Riemann —— 黎曼积分与 Lebesgue 判据（数学分析第二学期 R5.5）

本文件当前条目（引理清单，§0 铁律4：一次一条，逐条编译）：

* **real-analysis.riemann.def**（黎曼积分定义：达布分划/上下和/黎曼可积/均匀分划）。
* **real-analysis.riemann.eq-lebesgue**（黎曼可积时数值 = Lebesgue 积分）。
* **real-analysis.riemann.lebesgue-criterion**（黎曼可积 ⟺ 几乎处处连续）。

> **语言说明**：mathlib **没有**黎曼积分定义，全部自建。这是锻炼"论文定理自证"能力
> （Playbook §4.1）的实战。用 `sSup`/`sInf`（区间上下确界）、`Finset` 求和、`volume`。
-/

namespace SandronesLibrary

namespace RealAnalysis.Riemann

open MeasureTheory
open scoped ENNReal Interval BigOperators

/-- **达布分划**：区间 [a,b] 的一个分划是点列 a = x₀ < x₁ < ... < xₙ = b。 -/
structure DarbouxPartition (a b : ℝ) where
  n : ℕ
  x : ℕ → ℝ
  x0 : x 0 = a
  xN : x n = b
  strict : ∀ i, i < n → x i < x (i + 1)

/-- **达布下和**：Σᵢ (xᵢ₊₁ − xᵢ) · inf f on [xᵢ, xᵢ₊₁]。 -/
noncomputable def lowerSum (f : ℝ → ℝ) {a b : ℝ} (P : DarbouxPartition a b) : ℝ :=
  ∑ i ∈ Finset.range P.n, (P.x (i + 1) - P.x i) * sInf (f '' Set.Icc (P.x i) (P.x (i + 1)))

/-- **达布上和**：Σᵢ (xᵢ₊₁ − xᵢ) · sup f on [xᵢ, xᵢ₊₁]。 -/
noncomputable def upperSum (f : ℝ → ℝ) {a b : ℝ} (P : DarbouxPartition a b) : ℝ :=
  ∑ i ∈ Finset.range P.n, (P.x (i + 1) - P.x i) * sSup (f '' Set.Icc (P.x i) (P.x (i + 1)))

/-- **黎曼可积**：上下和可任意逼近（上积分 = 下积分）。
  教材定义：∀ ε > 0，存在分划使上和 − 下和 < ε。 
> **Entry**: real-analysis.riemann.def
-/
def RiemannIntegrable (f : ℝ → ℝ) (a b : ℝ) : Prop :=
  ∀ ε > 0, ∃ P : DarbouxPartition a b, upperSum f P - lowerSum f P < ε

/-- **均匀分划**：将 [a,b] 等分为 n 段（xᵢ = a + i·(b−a)/n）。
  用于"连续 ⟹ 可积"中控制上下和之差。 -/
noncomputable def uniformPartition (a b : ℝ) (n : ℕ) (hab : a < b) (hpos : 0 < n) :
    DarbouxPartition a b where
  n := n
  x := fun i => a + (i : ℝ) * ((b - a) / (n : ℝ))
  x0 := by simp
  xN := by
    field_simp
    ring
  strict := by
    intro i hi
    have hd : 0 < (b - a) / (n : ℝ) := by
      exact div_pos (sub_pos.mpr hab) (Nat.cast_pos.mpr hpos)
    have : (i : ℝ) < (i + 1 : ℕ) := by exact_mod_cast Nat.lt_succ_self i
    nlinarith

/-- **均匀分划的步长**：相邻两点距离 = (b−a)/n（等分性质）。 -/
theorem uniformPartition_step {a b : ℝ} {n : ℕ} (hab : a < b) (hpos : 0 < n)
    (i : ℕ) (_hi : i < n) :
    (uniformPartition a b n hab hpos).x (i + 1) - (uniformPartition a b n hab hpos).x i =
      (b - a) / (n : ℝ) := by
  simp [uniformPartition]
  ring


/-- **区间宽度引理**：x, y ∈ [p,q]（p ≤ q）⟹ |x - y| ≤ q - p。 -/
lemma interval_width {p q x y : ℝ} (_hpq : p ≤ q)
    (hx : x ∈ Set.Icc p q) (hy : y ∈ Set.Icc p q) :
    |x - y| ≤ q - p := by
  rw [abs_le]
  constructor
  · have : p - q ≤ x - y := by linarith [hx.1, hy.2]
    simpa using this
  · have : x - y ≤ q - p := by linarith [hx.2, hy.1]
    exact this

lemma b3_osc {f : ℝ → ℝ} {I : Set ℝ} (hI : I.Nonempty)
    {ε : ℝ} (hε : 0 < ε)
    (hosc : ∀ x ∈ I, ∀ y ∈ I, |f x - f y| ≤ ε) :
    sSup (f '' I) ≤ sInf (f '' I) + 2 * ε := by
  have hinf_approx : ∀ δ > 0, ∃ y ∈ I, f y < sInf (f '' I) + δ := by
    intro δ hδ
    by_contra h
    push Not at h
    have : sInf (f '' I) + δ ≤ sInf (f '' I) := by
      apply le_csInf
      · exact Set.image_nonempty.mpr hI
      · intro w hw
        rcases hw with ⟨y, hy, rfl⟩
        exact h y hy
    nlinarith
  apply csSup_le
  · exact Set.image_nonempty.mpr hI
  · intro m hm
    rcases hm with ⟨z, hz, rfl⟩
    rcases hinf_approx (ε / 2) (by positivity) with ⟨y, hy, hfy⟩
    have hzy : |f z - f y| ≤ ε := hosc z hz y hy
    have hfzy : f z ≤ f y + ε := by linarith [abs_le.mp hzy]
    nlinarith

-- C2: 子区间振荡（C1 + 一致连续 + B3）
lemma C2_subinterval {f : ℝ → ℝ} {a b : ℝ} {ε δ : ℝ}
    (huni : ∀ x ∈ Set.Icc a b, ∀ y ∈ Set.Icc a b, |x - y| < δ → |f x - f y| < ε)
    {p q : ℝ} (hpq : p ≤ q) (hp : p ∈ Set.Icc a b) (hq : q ∈ Set.Icc a b)
    (hwidth : |p - q| < δ) (hε : 0 < ε) :
    sSup (f '' Set.Icc p q) - sInf (f '' Set.Icc p q) ≤ 2 * ε := by
  have hosc : ∀ x ∈ Set.Icc p q, ∀ y ∈ Set.Icc p q, |f x - f y| ≤ ε := by
    intro x hx y hy
    have hxy : |x - y| ≤ q - p := interval_width hpq hx hy
    -- q - p ≤ |p - q|（p ≤ q）
    have hqp : q - p ≤ |p - q| := by
      simpa [abs_of_nonpos (sub_nonpos.mpr hpq)]
    have hxy_lt : |x - y| < δ := lt_of_le_of_lt (le_trans hxy hqp) hwidth
    have hx_ab : x ∈ Set.Icc a b := Set.Icc_subset_Icc hp.1 hq.2 hx
    have hy_ab : y ∈ Set.Icc a b := Set.Icc_subset_Icc hp.1 hq.2 hy
    exact le_of_lt (huni x hx_ab y hy_ab hxy_lt)
  have hI : (Set.Icc p q).Nonempty := ⟨p, ⟨le_rfl, hpq⟩⟩
  have hB3 := b3_osc hI (by linarith) hosc
  linarith

end RealAnalysis.Riemann

end SandronesLibrary