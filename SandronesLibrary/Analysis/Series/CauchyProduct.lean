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

end SandronesLibrary.Analysis.Series
