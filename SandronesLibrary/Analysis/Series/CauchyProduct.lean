/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Analysis.Series

/-!
# Cauchy products of real series

This module introduces the Cauchy product in the familiar textbook form.  Its
`n`-th coefficient is the finite convolution along `i + j = n`.  The main
finite identity rewrites the first `N` coefficients as the triangular double
sum over `i + j < N`; this is the algebraic starting point for the convergence
theorems proved in subsequent entries.
-/

namespace SandronesLibrary.Analysis.Series

/-- The `n`-th coefficient of the Cauchy product of `a` and `b`.

> **Entry**: analysis.series.cauchy-product-definition
-/
def cauchyProduct (a b : ℕ → ℝ) (n : ℕ) : ℝ :=
  ∑ k ∈ Finset.range (n + 1), a k * b (n - k)

/-- The range formula is the usual finite-antidiagonal formula. -/
theorem cauchyProduct_eq_antidiagonal (a b : ℕ → ℝ) (n : ℕ) :
    cauchyProduct a b n =
      ∑ ij ∈ Finset.HasAntidiagonal.antidiagonal n, a ij.1 * b ij.2 := by
  simpa [cauchyProduct] using
    (Finset.Nat.sum_antidiagonal_eq_sum_range_succ
      (fun i j => a i * b j) n).symm

/-- The first `N` Cauchy coefficients form the triangular double sum
`i + j < N`. -/
theorem sum_cauchyProduct_eq_triangle (a b : ℕ → ℝ) (N : ℕ) :
    (∑ n ∈ Finset.range N, cauchyProduct a b n) =
      ∑ i ∈ Finset.range N, a i * ∑ j ∈ Finset.range (N - i), b j := by
  simpa [cauchyProduct, Finset.mul_sum] using
    (Finset.sum_range_diag_flip N (fun i j => a i * b j))

/-! ## Absolutely convergent products -/

/-- Two absolutely convergent real series have an absolutely convergent
Cauchy product.

> **Entry**: analysis.series.cauchy-product-absolute
-/
theorem cauchyProduct_summable_absolute {a b : ℕ → ℝ}
    (ha : Summable (fun n => |a n|))
    (hb : Summable (fun n => |b n|)) :
    Summable (fun n => |cauchyProduct a b n|) := by
  simpa [cauchyProduct, Real.norm_eq_abs] using
    (summable_norm_sum_mul_range_of_summable_norm
      (f := a) (g := b)
      (by simpa [Real.norm_eq_abs] using ha)
      (by simpa [Real.norm_eq_abs] using hb))

/-- The Cauchy product of two absolutely convergent real series sums to the
product of their sums. -/
theorem hasSum_cauchyProduct_of_absolute {a b : ℕ → ℝ}
    (ha : Summable (fun n => |a n|))
    (hb : Summable (fun n => |b n|)) :
    HasSum (cauchyProduct a b) ((∑' n, a n) * ∑' n, b n) := by
  change HasSum
    (fun n => ∑ k ∈ Finset.range (n + 1), a k * b (n - k))
    ((∑' n, a n) * ∑' n, b n)
  exact hasSum_sum_range_mul_of_summable_norm
    (f := a) (g := b)
    (by simpa [Real.norm_eq_abs] using ha)
    (by simpa [Real.norm_eq_abs] using hb)

/-- `tsum` form of the absolutely convergent Cauchy product formula. -/
theorem tsum_cauchyProduct_of_absolute {a b : ℕ → ℝ}
    (ha : Summable (fun n => |a n|))
    (hb : Summable (fun n => |b n|)) :
    (∑' n, cauchyProduct a b n) = (∑' n, a n) * ∑' n, b n := by
  exact (hasSum_cauchyProduct_of_absolute ha hb).tsum_eq

/-! ## Mertens' theorem -/

open Filter
open scoped Topology

/-- A convergent real sequence is Cauchy in the legacy absolute-value interface
used by Mathlib's direct Cauchy-product estimate. -/
lemma isCauSeq_abs_of_tendsto {u : ℕ → ℝ} {l : ℝ}
    (hu : Tendsto u atTop (𝓝 l)) : IsCauSeq abs u := by
  intro ε hε
  have hhalf : 0 < ε / 2 := half_pos hε
  rcases Metric.tendsto_atTop.mp hu (ε / 2) hhalf with ⟨N, hN⟩
  refine ⟨N, fun j hj => ?_⟩
  have hj' := hN j hj
  have hN' := hN N le_rfl
  rw [Real.dist_eq] at hj' hN'
  calc
    |u j - u N| ≤ |u j - l| + |l - u N| := abs_sub_le _ _ _
    _ = |u j - l| + |u N - l| := by rw [abs_sub_comm l]
    _ < ε / 2 + ε / 2 := add_lt_add hj' hN'
    _ = ε := add_halves ε

/-- Mertens' theorem: if `a` is absolutely summable and the natural partial
sums of `b` tend to `B`, then their Cauchy product tends to `(∑ aₙ)B`.

The natural-partial-sum hypothesis is essential here: it includes conditionally
convergent real series, which Mathlib's unconditional `Summable` predicate does
not represent.

> **Entry**: analysis.series.mertens
-/
theorem tendsto_sum_cauchyProduct_of_left_absolute {a b : ℕ → ℝ} {B : ℝ}
    (ha : Summable (fun n => |a n|))
    (hb : Tendsto (fun N => ∑ n ∈ Finset.range N, b n) atTop (𝓝 B)) :
    Tendsto (fun N => ∑ n ∈ Finset.range N, cauchyProduct a b n)
      atTop (𝓝 ((∑' n, a n) * B)) := by
  have ha' : Summable a := summable_of_absolute ha
  let pA : ℕ → ℝ := fun N => ∑ n ∈ Finset.range N, a n
  let pB : ℕ → ℝ := fun N => ∑ n ∈ Finset.range N, b n
  let pC : ℕ → ℝ := fun N => ∑ n ∈ Finset.range N, cauchyProduct a b n
  have hA : Tendsto pA atTop (𝓝 (∑' n, a n)) := ha'.tendsto_sum_tsum_nat
  have hB : Tendsto pB atTop (𝓝 B) := hb
  have hAbsA : IsCauSeq abs (fun N => ∑ n ∈ Finset.range N, |a n|) :=
    isCauSeq_abs_of_tendsto ha.tendsto_sum_tsum_nat
  have hCauB : IsCauSeq abs pB := isCauSeq_abs_of_tendsto hB
  have hdiff : Tendsto (fun N => pA N * pB N - pC N) atTop (𝓝 0) := by
    rw [Metric.tendsto_atTop]
    intro ε hε
    rcases cauchy_product hAbsA hCauB ε hε with ⟨N, hN⟩
    refine ⟨N, fun n hn => ?_⟩
    simpa [pA, pB, pC, cauchyProduct, Real.dist_eq] using hN n hn
  have hprod : Tendsto (fun N => pA N * pB N) atTop
      (𝓝 ((∑' n, a n) * B)) := hA.mul hB
  have hC : Tendsto pC atTop (𝓝 ((∑' n, a n) * B)) := by
    simpa only [sub_zero, sub_sub_cancel] using hprod.sub hdiff
  simpa [pC] using hC

/-- Symmetric Mertens theorem with the right factor absolutely summable. -/
theorem tendsto_sum_cauchyProduct_of_right_absolute {a b : ℕ → ℝ} {A : ℝ}
    (ha : Tendsto (fun N => ∑ n ∈ Finset.range N, a n) atTop (𝓝 A))
    (hb : Summable (fun n => |b n|)) :
    Tendsto (fun N => ∑ n ∈ Finset.range N, cauchyProduct a b n)
      atTop (𝓝 (A * ∑' n, b n)) := by
  have h := tendsto_sum_cauchyProduct_of_left_absolute (a := b) (b := a) hb ha
  have heq : cauchyProduct b a = cauchyProduct a b := by
    funext n
    rw [cauchyProduct_eq_antidiagonal, cauchyProduct_eq_antidiagonal]
    rw [← Finset.Nat.sum_antidiagonal_swap]
    simp only [Prod.swap, mul_comm]
  simpa [heq, mul_comm] using h

end SandronesLibrary.Analysis.Series
