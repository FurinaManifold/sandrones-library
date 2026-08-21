/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib
import SandronesLibrary.Analysis.Continuity

/-!
# RealAnalysis / Riemann —— 黎曼积分与 Lebesgue 判据（数学分析第二学期 R5.5）

本文件当前条目（引理清单，§0 铁律4：一次一条，逐条编译）：

* **real-analysis.riemann.def**（黎曼积分定义：达布分划/上下和/黎曼可积/均匀分划/积分值）✅。
* **real-analysis.riemann.cont-integrable**（连续 ⟹ 黎曼可积，均匀分划 + 一致连续）✅。
* **real-analysis.riemann.eq-lebesgue**（黎曼可积时数值 = Lebesgue 积分）：部分完成——
  已定义 riemannIntegral 值 + 连续 ⟹ Lebesgue 可积；数值相等的夹逼证明（D3-D5）待续。
* **real-analysis.riemann.lebesgue-criterion**（黎曼可积 ⟺ 几乎处处连续）：待续。

> **语言说明**：mathlib **没有**黎曼积分定义，全部自建。这是锻炼"论文定理自证"能力
> （Playbook §4.1）的实战。用 `sSup`/`sInf`（区间上下确界）、`Finset` 求和、`volume`。
-/

namespace SandronesLibrary

namespace RealAnalysis.Riemann

open MeasureTheory
open SandronesLibrary.Analysis.Continuity
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

/-- **黎曼积分值**：下积分的上确界（教材定义）。当 f 黎曼可积时，
  它等于上积分的下确界，即黎曼积分。 -/
noncomputable def riemannIntegral (f : ℝ → ℝ) (a b : ℝ) : ℝ :=
  sSup { x : ℝ | ∃ P : DarbouxPartition a b, x = lowerSum f P }

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
lemma step_sum {a b : ℝ} {n : ℕ} (_hab : a < b) (hpos : 0 < n) :
    ∑ i ∈ Finset.range n, ((b - a) / (n : ℝ)) = b - a := by
  rw [Finset.sum_const]
  -- s.card • d = n • d
  have hcard : (Finset.range n).card = n := Finset.card_range n
  rw [hcard]
  -- n • ((b-a)/n) = b-a（n ≠ 0）
  have hn : (n : ℝ) ≠ 0 := by exact_mod_cast (ne_of_gt hpos)
  -- nsmul_eq_mul
  rw [nsmul_eq_mul]
  field_simp [hn]

lemma uniform_x_mem {a b : ℝ} {n : ℕ} (hab : a < b) (hpos : 0 < n)
    (i : ℕ) (hi : i ≤ n) :
    a + (i : ℝ) * ((b - a) / (n : ℝ)) ∈ Set.Icc a b := by
  constructor
  · -- a ≤ a + i·d（d ≥ 0）
    have hd : 0 ≤ (b - a) / (n : ℝ) := by
      exact div_nonneg (le_of_lt (sub_pos.mpr hab)) (Nat.cast_nonneg n)
    nlinarith
  · -- a + i·d ≤ a + n·d = b
    have hd : 0 ≤ (b - a) / (n : ℝ) := by
      exact div_nonneg (le_of_lt (sub_pos.mpr hab)) (Nat.cast_nonneg n)
    have hile : (i : ℝ) ≤ (n : ℝ) := by exact_mod_cast hi
    have : a + (i : ℝ) * ((b - a) / (n : ℝ)) ≤ a + (n : ℝ) * ((b - a) / (n : ℝ)) := by
      nlinarith
    have : a + (n : ℝ) * ((b - a) / (n : ℝ)) = b := by
      have hn : (n : ℝ) ≠ 0 := by exact_mod_cast (ne_of_gt hpos)
      field_simp [hn]
      ring
    linarith

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


theorem continuous_on_riemannIntegrable_lt {f : ℝ → ℝ} {a b : ℝ} (hab : a < b)
    (hf : ContinuousOn f (Set.Icc a b)) : RiemannIntegrable f a b := by
  intro ε hε
  -- ε' = ε/(4(b-a))
  let ε' := ε / (4 * (b - a))
  have hε' : 0 < ε' := by
    unfold ε'
    positivity
  -- 一致连续
  have hK : IsCompact (Set.Icc a b) := isCompact_Icc
  have hne : (Set.Icc a b).Nonempty := ⟨a, ⟨le_rfl, le_of_lt hab⟩⟩
  have huni := continuousOn_compact_uniformContinuousOn (s := Set.Icc a b) hK hne hf
  rcases Metric.uniformContinuousOn_iff.mp huni ε' hε' with ⟨δ, hδ, hδδ⟩
  -- 选 n 使步长 < δ
  rcases exists_nat_gt ((b - a) / δ) with ⟨n, hn⟩
  have hn_pos : 0 < n := by
    have hpos : 0 < (b - a) / δ := div_pos (sub_pos.mpr hab) hδ
    have hcast : 0 < (n : ℝ) := lt_of_lt_of_le hpos (le_of_lt hn)
    exact_mod_cast hcast
  have hstep_lt : (b - a) / (n : ℝ) < δ := by
    have hcast : 0 < (n : ℝ) := by exact_mod_cast hn_pos
    have h1 : b - a < (n : ℝ) * δ := by
      rwa [div_lt_iff₀ hδ] at hn
    exact (div_lt_iff₀' hcast).mpr h1
  let P := uniformPartition a b n hab hn_pos
  refine ⟨P, ?_⟩
  -- 展开成求和
  have hdiff : upperSum f P - lowerSum f P =
      ∑ i ∈ Finset.range n, (P.x (i + 1) - P.x i) *
        (sSup (f '' Set.Icc (P.x i) (P.x (i + 1))) - sInf (f '' Set.Icc (P.x i) (P.x (i + 1)))) := by
    unfold upperSum lowerSum
    rw [← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro i hi
    ring
  -- 逐项 ≤ 步长·2ε'
  have hterm : ∀ i ∈ Finset.range n,
      (P.x (i + 1) - P.x i) *
        (sSup (f '' Set.Icc (P.x i) (P.x (i + 1))) - sInf (f '' Set.Icc (P.x i) (P.x (i + 1)))) ≤
      (P.x (i + 1) - P.x i) * (2 * ε') := by
    intro i hi
    have hi_lt : i < n := Finset.mem_range.mp hi
    have hxi : P.x i ∈ Set.Icc a b := by
      have := uniform_x_mem hab hn_pos i (le_of_lt hi_lt)
      simpa [P, uniformPartition] using this
    have hxi1 : P.x (i + 1) ∈ Set.Icc a b := by
      have := uniform_x_mem hab hn_pos (i + 1) (by omega)
      simpa [P, uniformPartition] using this
    have hwidth_abs : |P.x (i + 1) - P.x i| < δ := by
      have hstep : P.x (i + 1) - P.x i = (b - a) / (n : ℝ) := uniformPartition_step hab hn_pos i hi_lt
      rw [hstep]
      have hnon : 0 ≤ (b - a) / (n : ℝ) := by
        exact div_nonneg (le_of_lt (sub_pos.mpr hab)) (Nat.cast_nonneg n)
      rw [abs_of_nonneg hnon]
      exact hstep_lt
    have hwidth : |P.x i - P.x (i + 1)| < δ := by
      rw [abs_sub_comm]
      exact hwidth_abs
    have hosc0 : ∀ x ∈ Set.Icc a b, ∀ y ∈ Set.Icc a b, |x - y| < δ → |f x - f y| < ε' := hδδ
    have hC2 := C2_subinterval (a := a) (b := b) (ε := ε') (δ := δ)
      (huni := hosc0) (hpq := (P.strict i hi_lt).le) (hp := hxi) (hq := hxi1)
      (hwidth := hwidth) (hε := hε')
    have hosc_bound : sSup (f '' Set.Icc (P.x i) (P.x (i + 1))) -
        sInf (f '' Set.Icc (P.x i) (P.x (i + 1))) ≤ 2 * ε' := hC2
    have hstep_nonneg : 0 ≤ P.x (i + 1) - P.x i := sub_nonneg.mpr (P.strict i hi_lt).le
    exact mul_le_mul_of_nonneg_left hosc_bound hstep_nonneg
  -- 求和 = 2ε'·(b-a) = ε/2
  have hsum_step : (∑ i ∈ Finset.range n,
      (P.x (i + 1) - P.x i) : ℝ) = b - a := by
    have hcong : (∑ i ∈ Finset.range n,
        ((P.x (i + 1) - P.x i) : ℝ)) =
        (∑ i ∈ Finset.range n, ((b - a) / (n : ℝ)) : ℝ) := by
      refine Finset.sum_congr rfl ?_
      intro i hi
      exact uniformPartition_step hab hn_pos i (Finset.mem_range.mp hi)
    exact hcong.trans (step_sum hab hn_pos)
  have hsum : (∑ i ∈ Finset.range n, (P.x (i + 1) - P.x i) * (2 * ε')) = 2 * ε' * (b - a) := by
    calc
      (∑ i ∈ Finset.range n, (P.x (i + 1) - P.x i) * (2 * ε')) =
          (∑ i ∈ Finset.range n, (P.x (i + 1) - P.x i)) * (2 * ε') := by
            exact (Finset.sum_mul _ _ (2 * ε')).symm
      _ = (b - a) * (2 * ε') := by rw [hsum_step]
      _ = 2 * ε' * (b - a) := by ring
  have hsum_val : (∑ i ∈ Finset.range n, (P.x (i + 1) - P.x i) * (2 * ε')) = ε / 2 := by
    rw [hsum]
    unfold ε'
    have hba_ne : b - a ≠ 0 := sub_ne_zero.mpr (ne_of_lt hab).symm
    field_simp [hba_ne]
    ring
  -- 最终: ≤ Σ步长·2ε' = ε/2 < ε
  rw [hdiff]
  have hle : (∑ i ∈ Finset.range n, (P.x (i + 1) - P.x i) *
      (sSup (f '' Set.Icc (P.x i) (P.x (i + 1))) - sInf (f '' Set.Icc (P.x i) (P.x (i + 1))))) ≤
      (∑ i ∈ Finset.range n, (P.x (i + 1) - P.x i) * (2 * ε')) :=
    Finset.sum_le_sum hterm
  have : (∑ i ∈ Finset.range n, (P.x (i + 1) - P.x i) *
      (sSup (f '' Set.Icc (P.x i) (P.x (i + 1))) - sInf (f '' Set.Icc (P.x i) (P.x (i + 1))))) < ε := by
    calc
      _ ≤ (∑ i ∈ Finset.range n, (P.x (i + 1) - P.x i) * (2 * ε')) := hle
      _ = ε / 2 := hsum_val
      _ < ε := by linarith
  exact this


/-- **连续函数 Lebesgue 区间可积**：f 在 [a,b] 连续（a ≤ b）⟹ IntervalIntegrable f volume a b。 -/
theorem continuous_intervalIntegrable {f : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hf : ContinuousOn f (Set.Icc a b)) : IntervalIntegrable f volume a b := by
  have hf' : ContinuousOn f (Set.uIcc a b) := by
    rw [Set.uIcc_of_le hab]
    exact hf
  exact ContinuousOn.intervalIntegrable (μ := volume) hf'
theorem integral_indicator_const_Ioc {a b c : ℝ} (hab : a ≤ b) :
    (∫ x : ℝ, (Set.Ioc a b).indicator (fun _ : ℝ => c) x ∂volume) = c * (b - a) := by
  rw [integral_indicator (hs := measurableSet_Ioc)]
  -- ∫_{Ioc a b} c = (volume.restrict (Ioc a b)).real univ • c
  rw [integral_const]
  -- 证 (volume.restrict (Ioc a b)).real Set.univ = b - a
  have hrestr : (volume.restrict (Set.Ioc a b)).real Set.univ = b - a := by
    rw [measureReal_def, Measure.restrict_apply (s := Set.Ioc a b) (t := Set.univ) (ht := MeasurableSet.univ)]
    -- (volume.restrict (Ioc a b)) univ = volume (univ ∩ Ioc a b) = volume (Ioc a b)
    rw [Set.univ_inter]
    rw [Real.volume_Ioc]
    -- toReal (ofReal (b-a)) = max (b-a) 0
    rw [ENNReal.toReal_ofReal (sub_nonneg.mpr hab)]
  -- 目标: (volume.restrict (Ioc a b)).real univ • c = c·(b-a)
  rw [hrestr]
  -- (b-a) • c = c·(b-a)
  simp [smul_eq_mul, mul_comm]

theorem integral_sum_indicator_Ioc {n : ℕ} {x : ℕ → ℝ} {c : ℕ → ℝ}
    (hstep : ∀ i ∈ Finset.range n, x i ≤ x (i+1)) :
    (∫ t : ℝ, (∑ i ∈ Finset.range n,
        (Set.Ioc (x i) (x (i+1))).indicator (fun _ : ℝ => c i) t) ∂volume) =
      ∑ i ∈ Finset.range n, c i * (x (i+1) - x i) := by
  -- 求和积分
  have hf : ∀ i ∈ Finset.range n, Integrable
      (fun t : ℝ => (Set.Ioc (x i) (x (i+1))).indicator (fun _ : ℝ => c i) t) volume := by
    intro i hi
    -- 用 integrable_indicator_iff + integrableOn_const
    rw [integrable_indicator_iff (hs := measurableSet_Ioc)]
    have hfin : volume (Set.Ioc (x i) (x (i+1))) ≠ ∞ := by
      rw [Real.volume_Ioc]
      exact ENNReal.ofReal_ne_top
    exact integrableOn_const (μ := volume) (s := Set.Ioc (x i) (x (i+1))) (C := c i) (hs := hfin)
  -- ∫(∑) = ∑∫
  have hsum_integral : (∫ t : ℝ, (∑ i ∈ Finset.range n,
      (Set.Ioc (x i) (x (i+1))).indicator (fun _ : ℝ => c i) t) ∂volume) =
      ∑ i ∈ Finset.range n, (∫ t : ℝ,
        (Set.Ioc (x i) (x (i+1))).indicator (fun _ : ℝ => c i) t ∂volume) := by
    exact integral_finset_sum (s := Finset.range n) (f := fun i => fun t : ℝ =>
      (Set.Ioc (x i) (x (i+1))).indicator (fun _ : ℝ => c i) t) (μ := volume) hf
  -- 逐项: ∫(cᵢ·1_{Ioc xᵢ xᵢ₊₁}) = cᵢ·(xᵢ₊₁-xᵢ)
  calc
    (∫ t : ℝ, (∑ i ∈ Finset.range n,
        (Set.Ioc (x i) (x (i+1))).indicator (fun _ : ℝ => c i) t) ∂volume)
        = ∑ i ∈ Finset.range n, (∫ t : ℝ,
            (Set.Ioc (x i) (x (i+1))).indicator (fun _ : ℝ => c i) t ∂volume) := hsum_integral
    _ = ∑ i ∈ Finset.range n, c i * (x (i+1) - x i) := by
      apply Finset.sum_congr rfl
      intro i hi
      -- ∫(cᵢ·1_{Ioc}) = cᵢ·(xᵢ₊₁-xᵢ)（D3a，需 x i ≤ x(i+1)）
      exact integral_indicator_const_Ioc (c := c i) (hstep i hi)

lemma step_le_f_pointwise {f : ℝ → ℝ} {p q : ℝ} (hpq : p ≤ q)
    (hf : ContinuousOn f (Set.Icc p q)) {t : ℝ} (ht : t ∈ Set.Ioc p q) :
    sInf (f '' Set.Icc p q) ≤ f t := by
  have htm : f t ∈ f '' Set.Icc p q := by
    refine ⟨t, ⟨le_of_lt ht.1, ht.2⟩, rfl⟩
  have hK : IsCompact (f '' Set.Icc p q) := IsCompact.image_of_continuousOn isCompact_Icc hf
  exact csInf_le (IsCompact.bddBelow hK) htm

theorem restricted_integral_const_Ioc {p q c : ℝ} (hpq : p ≤ q) :
    (∫ x : ℝ in Set.Ioc p q, c ∂volume) = c * (q - p) := by
  rw [integral_const]
  -- (restrict (Ioc p q)).real univ = volume.real (Ioc p q) = q-p
  have hres : (volume.restrict (Set.Ioc p q)).real Set.univ = volume.real (Set.Ioc p q) := by
    rw [measureReal_def, Measure.restrict_apply (s := Set.Ioc p q) (t := Set.univ) (ht := MeasurableSet.univ)]
    rw [Set.univ_inter]
    rw [measureReal_def]
  have hvol : volume.real (Set.Ioc p q) = q - p := by
    rw [measureReal_def, Real.volume_Ioc, ENNReal.toReal_ofReal (sub_nonneg.mpr hpq)]
  rw [hres, hvol]
  simp [smul_eq_mul, mul_comm]

theorem step_indicator_identity {n : ℕ} {x : ℕ → ℝ} {c : ℕ → ℝ} {a b : ℝ}
    (hsub : ∀ i ∈ Finset.range n, Set.Ioc (x i) (x (i+1)) ⊆ Set.Ioc a b) :
    ∀ t : ℝ, (Set.Ioc a b).indicator
        (fun u => ∑ i ∈ Finset.range n,
          (Set.Ioc (x i) (x (i+1))).indicator (fun _ : ℝ => c i) u) t
        = (∑ i ∈ Finset.range n,
          (Set.Ioc (x i) (x (i+1))).indicator (fun _ : ℝ => c i) t) := by
  intro t
  by_cases ht : t ∈ Set.Ioc a b
  · simp [Set.indicator, ht]
  · have hsP : (∑ i ∈ Finset.range n,
        (Set.Ioc (x i) (x (i+1))).indicator (fun _ : ℝ => c i) t) = 0 := by
      apply Finset.sum_eq_zero
      intro i hi
      have hsubi := hsub i hi
      have htnot : t ∉ Set.Ioc (x i) (x (i+1)) := fun hti => ht (hsubi hti)
      exact Set.indicator_of_notMem htnot (fun _ : ℝ => c i)
    simpa [Set.indicator, ht] using hsP.symm

theorem lower_sum_le_interval {f sP : ℝ → ℝ} {s : Set ℝ}
    (hs : MeasurableSet s)
    (hsP : ∀ t, s.indicator sP t = sP t)
    (hf_mono : ∀ t, s.indicator sP t ≤ s.indicator f t)
    (hisP : Integrable (s.indicator sP) volume)
    (hif : Integrable (s.indicator f) volume) :
    (∫ t : ℝ, sP t ∂volume) ≤ (∫ t : ℝ in s, f t ∂volume) := by
  have h1ae : sP =ᵐ[volume] (s.indicator sP) := by
    filter_upwards [ae_of_all volume hsP] with t ht
    exact ht.symm
  have h1 : (∫ t : ℝ, sP t ∂volume) = (∫ t : ℝ, s.indicator sP t ∂volume) :=
    integral_congr_ae h1ae
  have h2 : (∫ t : ℝ, s.indicator sP t ∂volume) ≤ (∫ t : ℝ, s.indicator f t ∂volume) :=
    integral_mono hisP hif hf_mono
  have h3 : (∫ t : ℝ, s.indicator f t ∂volume) = (∫ t : ℝ in s, f t ∂volume) :=
    integral_indicator hs
  calc
    (∫ t : ℝ, sP t ∂volume) = (∫ t : ℝ, s.indicator sP t ∂volume) := h1
    _ ≤ (∫ t : ℝ, s.indicator f t ∂volume) := h2
    _ = (∫ t : ℝ in s, f t ∂volume) := h3

theorem continuous_indicator_integrable {f : ℝ → ℝ} {a b : ℝ} (_hab : a ≤ b)
    (hf : ContinuousOn f (Set.Icc a b)) :
    Integrable ((Set.Ioc a b).indicator f) volume := by
  -- integrable_indicator_iff: Integrable (s.indicator f) ↔ IntegrableOn f s
  rw [integrable_indicator_iff (hs := measurableSet_Ioc)]
  -- IntegrableOn f (Ioc a b)：从 Icc 限制（Ioc ⊆ Icc）
  have hcc : IntegrableOn f (Set.Icc a b) volume := ContinuousOn.integrableOn_Icc hf
  -- Ioc a b ⊆ Icc a b
  exact hcc.mono_set (Set.Ioc_subset_Icc_self)

lemma partition_cover {n : ℕ} {x : ℕ → ℝ} {a b : ℝ} {t : ℝ}
    (x0 : x 0 = a) (xN : x n = b) (hx : ∀ i, i < n → x i < x (i+1))
    (ht : t ∈ Set.Ioc a b) :
    ∃ i, i < n ∧ x i < t ∧ t ≤ x (i+1) := by
  -- 用 Nat.find: 最小 i 使 t ≤ x i
  let p : ℕ → Prop := fun i => t ≤ x i
  have hex : ∃ i, p i := by
    refine ⟨n, ?_⟩
    change t ≤ x n
    rw [xN]
    exact ht.2
  let j := Nat.find hex
  have hpj : p j := Nat.find_spec hex
  -- j ≠ 0（x 0 = a < t）
  have hj0 : j ≠ 0 := by
    intro hj
    have h0 : p 0 := by simpa [hj, j] using hpj
    change t ≤ x 0 at h0
    have : t ≤ a := by simpa [x0] using h0
    linarith [this, ht.1]
  -- j ≤ n（最小性 + p n）
  have hjn : j ≤ n := Nat.find_min' hex (by
    change t ≤ x n
    rw [xN]
    exact ht.2)
  -- i = j-1 < n
  let i := j - 1
  have hi_lt : i < n := by
    dsimp [i]
    omega
  -- x i < t（find_min：i < j ⟹ ¬p i）
  have hxi : x i < t := by
    dsimp [i]
    have hnj : i < j := by dsimp [i]; omega
    have hnotp : ¬p i := Nat.find_min hex hnj
    -- ¬p i : ¬(t ≤ x i) ⟹ x i < t
    exact lt_of_not_ge hnotp
  -- t ≤ x (i+1)：j = i+1，p j
  have hxj : t ≤ x (i+1) := by
    have : i + 1 = j := by dsimp [i]; omega
    simpa [this] using hpj
  refine ⟨i, hi_lt, hxi, hxj⟩

theorem step_eval_at {n i : ℕ} {x : ℕ → ℝ} {c : ℕ → ℝ} {t : ℝ} (hi : i < n)
    (ht : t ∈ Set.Ioc (x i) (x (i+1)))
    (hdisj : ∀ j, j < n → j ≠ i → t ∉ Set.Ioc (x j) (x (j+1))) :
    (∑ j ∈ Finset.range n,
      (Set.Ioc (x j) (x (j+1))).indicator (fun _ : ℝ => c j) t) = c i := by
  rw [Finset.sum_eq_single]
  · -- j = i 项
    rw [Set.indicator_of_mem ht]
  · -- j ≠ i 项为 0
    intro j hj hji
    have hnot : t ∉ Set.Ioc (x j) (x (j+1)) := hdisj j (Finset.mem_range.mp hj) hji
    exact Set.indicator_of_notMem hnot (fun _ : ℝ => c j)
  · -- i ∉ range n → 项为 0（不可能，因 hi）
    intro hi_not
    exact False.elim (hi_not (Finset.mem_range.mpr hi))

end RealAnalysis.Riemann

end SandronesLibrary