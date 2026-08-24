/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib.NumberTheory.DiophantineApproximation.ContinuedFractions

/-!
# Continued fractions and rational approximation

This file gives textbook-facing interfaces for

* the convergents of the simple continued fraction of a real number;
* best rational approximation, both globally by denominator and in a finite candidate set;
* Legendre's sufficient criterion for a rational number to be a convergent.

Mathlib currently proves Legendre's criterion, but it does not yet provide the usual theorem that
every continued-fraction convergent is a best approximation.  The declarations below deliberately
keep these two facts separate rather than claiming that missing converse direction.

## Current entries

* `number-theory.elementary.continued-fraction-convergent`
* `number-theory.elementary.continued-fraction-recursion`
* `number-theory.elementary.best-rational-approximation`
* `number-theory.elementary.finite-best-approximation`
* `number-theory.elementary.legendre-criterion`
-/

namespace SandronesLibrary.NumberTheory.Elementary

/-- The `n`th rational convergent of the simple continued fraction of `ξ`.

This is the elementary rational-valued interface; Mathlib's generalized continued-fraction
representation is kept behind the definition.

> **Entry**: number-theory.elementary.continued-fraction-convergent -/
noncomputable def continuedFractionConvergent (ξ : ℝ) (n : ℕ) : ℚ :=
  Real.convergent ξ n

/-- The zeroth convergent is the integer part of the real number. -/
@[simp]
theorem continuedFractionConvergent_zero (ξ : ℝ) :
    continuedFractionConvergent ξ 0 = (⌊ξ⌋ : ℤ) := by
  exact Real.convergent_zero ξ

/-- Removing the integer part and taking a reciprocal gives the recursive continued-fraction
step.

> **Entry**: number-theory.elementary.continued-fraction-recursion -/
@[simp]
theorem continuedFractionConvergent_succ (ξ : ℝ) (n : ℕ) :
    continuedFractionConvergent ξ (n + 1) =
      (⌊ξ⌋ : ℤ) + (continuedFractionConvergent (Int.fract ξ)⁻¹ n)⁻¹ := by
  exact Real.convergent_succ ξ n

/-- The absolute error made when `q` is used to approximate `ξ`. -/
def rationalApproximationError (ξ : ℝ) (q : ℚ) : ℝ :=
  |ξ - (q : ℝ)|

/-- A rational number is a best approximation to `ξ` if no rational with a denominator at most
as large has smaller approximation error.

The comparison allows equality, so ties are permitted.  This is the standard denominator-bounded
notion; it is intentionally defined independently of continued fractions because the theorem that
convergents satisfy it is not currently available in Mathlib.

> **Entry**: number-theory.elementary.best-rational-approximation -/
def IsBestRationalApproximation (ξ : ℝ) (q : ℚ) : Prop :=
  ∀ r : ℚ, r.den ≤ q.den →
    rationalApproximationError ξ q ≤ rationalApproximationError ξ r

/-- An exact rational representation is automatically a best rational approximation. -/
theorem exact_rational_isBestApproximation (q : ℚ) :
    IsBestRationalApproximation (q : ℝ) q := by
  intro r _
  simp [rationalApproximationError]

/-- `q` minimizes the approximation error among the finite candidate set `s`. -/
def IsBestApproximationIn (ξ : ℝ) (s : Finset ℚ) (q : ℚ) : Prop :=
  q ∈ s ∧ ∀ r ∈ s, rationalApproximationError ξ q ≤ rationalApproximationError ξ r

/-- Every nonempty finite set of rational candidates contains a best approximation.

> **Entry**: number-theory.elementary.finite-best-approximation -/
theorem exists_bestApproximationIn (ξ : ℝ) {s : Finset ℚ} (hs : s.Nonempty) :
    ∃ q, IsBestApproximationIn ξ s q := by
  obtain ⟨q, hqs, hq⟩ := s.exists_min_image (rationalApproximationError ξ) hs
  exact ⟨q, hqs, hq⟩

/-- Legendre's quantitative hypothesis: the error is strictly below
`1 / (2 * denominator²)`. -/
def IsLegendreApproximation (ξ : ℝ) (q : ℚ) : Prop :=
  rationalApproximationError ξ q < 1 / (2 * (q.den : ℝ) ^ 2)

/-- **Legendre's criterion.** A rational approximation satisfying the sharp textbook threshold
`| ξ - q | < 1 / (2 q.den²)` occurs among the continued-fraction convergents of `ξ`.

This is a sufficient criterion, not the presently unavailable statement that every convergent is
a best rational approximation.

> **Entry**: number-theory.elementary.legendre-criterion -/
theorem legendreApproximation_is_convergent {ξ : ℝ} {q : ℚ}
    (hq : IsLegendreApproximation ξ q) :
    ∃ n, q = continuedFractionConvergent ξ n := by
  exact Real.exists_rat_eq_convergent hq

end SandronesLibrary.NumberTheory.Elementary
