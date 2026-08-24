import Mathlib.NumberTheory.Pell

/-!
# Pell's equation

This file exposes Pell's equation in elementary integer coordinates.  Mathlib's quadratic-ring and
unitary-element representation is used only inside proofs.

Mathlib proves existence and classification for `x² - d y² = 1`.  It explicitly leaves the
connection with the continued fraction of `√d` and the negative equation `x² - d y² = -1` for
future work; this file does not claim either extension.

## Current entries

* `number-theory.elementary.pell-equation`
* `number-theory.elementary.pell-composition`
* `number-theory.elementary.pell-positive-existence`
* `number-theory.elementary.pell-fundamental-solution`
-/

namespace SandronesLibrary.NumberTheory.Elementary

/-- An integer solution of the positive Pell equation `x² - d y² = 1`.

> **Entry**: number-theory.elementary.pell-equation -/
structure PellSolution (d : ℤ) where
  x : ℤ
  y : ℤ
  equation : x ^ 2 - d * y ^ 2 = 1

/-- The trivial Pell solution `(1, 0)`. -/
def PellSolution.one (d : ℤ) : PellSolution d :=
  ⟨1, 0, by ring⟩

/-- The Brahmagupta composition of two solutions of the same Pell equation.

> **Entry**: number-theory.elementary.pell-composition -/
def PellSolution.comp (a b : PellSolution d) : PellSolution d where
  x := a.x * b.x + d * (a.y * b.y)
  y := a.x * b.y + a.y * b.x
  equation := by
    calc
      (a.x * b.x + d * (a.y * b.y)) ^ 2 -
          d * (a.x * b.y + a.y * b.x) ^ 2 =
        (a.x ^ 2 - d * a.y ^ 2) * (b.x ^ 2 - d * b.y ^ 2) := by ring
      _ = 1 := by rw [a.equation, b.equation, one_mul]

/-- The first coordinate of a composed Pell solution. -/
@[simp]
theorem pell_comp_x (a b : PellSolution d) :
    (a.comp b).x = a.x * b.x + d * (a.y * b.y) := by
  rfl

/-- The second coordinate of a composed Pell solution. -/
@[simp]
theorem pell_comp_y (a b : PellSolution d) :
    (a.comp b).y = a.x * b.y + a.y * b.x := by
  rfl

/-- If `d` is positive and not a square, the positive Pell equation has a solution with
`x > 1` and `y > 0`.

> **Entry**: number-theory.elementary.pell-positive-existence -/
theorem exists_positive_pellSolution {d : ℤ} (hd : 0 < d) (hns : ¬IsSquare d) :
    ∃ a : PellSolution d, 1 < a.x ∧ 0 < a.y := by
  obtain ⟨a, hax, hay⟩ := Pell.Solution₁.exists_pos_of_not_isSquare hd hns
  exact ⟨⟨a.x, a.y, a.prop⟩, hax, hay⟩

/-- A fundamental Pell solution is positive and has the smallest first coordinate among all
solutions with first coordinate greater than one. -/
def IsFundamentalPellSolution (a : PellSolution d) : Prop :=
  1 < a.x ∧ 0 < a.y ∧
    ∀ b : PellSolution d, 1 < b.x → a.x ≤ b.x

/-- A positive nonsquare parameter admits a fundamental Pell solution in elementary integer
coordinates.

Mathlib also classifies all packaged solutions as signed integer powers of the fundamental one.
That group-theoretic classification is not restated here because the public `PellSolution`
interface in this entry intentionally consists only of integer coordinates and composition.

> **Entry**: number-theory.elementary.pell-fundamental-solution -/
theorem exists_fundamentalPellSolution {d : ℤ} (hd : 0 < d) (hns : ¬IsSquare d) :
    ∃ a : PellSolution d, IsFundamentalPellSolution a := by
  obtain ⟨a, ha⟩ := Pell.IsFundamental.exists_of_not_isSquare hd hns
  refine ⟨⟨a.x, a.y, a.prop⟩, ha.1, ha.2.1, ?_⟩
  intro b hb
  let b' : Pell.Solution₁ d := Pell.Solution₁.mk b.x b.y b.equation
  have hb' : 1 < b'.x := by simpa [b'] using hb
  simpa [b'] using ha.2.2 hb'

end SandronesLibrary.NumberTheory.Elementary
