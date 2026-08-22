/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Analysis.Series.CauchyProduct

/-!
# 实幂级数：定义与收敛点集

本文件建立一元实幂级数的教材接口。系数为 `a : ℕ → ℝ`、中心为 `c` 时，在 `x` 处的
第 `n` 项为 `a n * (x-c)^n`，前 `N` 项部分和只包含次数 `<N` 的项。

普通收敛使用自然顺序部分和的 `Tendsto` 表示，从而允许条件收敛；绝对收敛使用
`Summable |term|`。后续的收敛半径、端点判定、逐项运算都建立在这些接口上。
-/

namespace SandronesLibrary.Analysis.PowerSeries

open Filter
open scoped Topology

/-- 系数为 `a`、中心为 `c` 的幂级数在 `x` 处的第 `n` 项：`aₙ(x-c)ⁿ`。

> **Entry**: analysis.power-series.definition
-/
def term (a : ℕ → ℝ) (c x : ℝ) (n : ℕ) : ℝ := a n * (x - c) ^ n

/-- 幂级数的前 `N` 项部分和，即次数 `<N` 的所有项之和。 -/
def partialSum (a : ℕ → ℝ) (c x : ℝ) (N : ℕ) : ℝ :=
  ∑ n ∈ Finset.range N, term a c x n

/-- 幂级数在 `x` 处按自然顺序收敛到 `s`。 -/
def HasSumAt (a : ℕ → ℝ) (c x s : ℝ) : Prop :=
  Tendsto (partialSum a c x) atTop (𝓝 s)

/-- 幂级数在 `x` 处按自然顺序收敛。 -/
def ConvergesAt (a : ℕ → ℝ) (c x : ℝ) : Prop :=
  ∃ s, HasSumAt a c x s

/-- 幂级数在 `x` 处绝对收敛。 -/
def AbsolutelyConvergesAt (a : ℕ → ℝ) (c x : ℝ) : Prop :=
  Summable (fun n => |term a c x n|)

/-- 幂级数的收敛点集。 -/
def convergenceSet (a : ℕ → ℝ) (c : ℝ) : Set ℝ :=
  {x | ConvergesAt a c x}

/-- 幂级数的绝对收敛点集。 -/
def absoluteConvergenceSet (a : ℕ → ℝ) (c : ℝ) : Set ℝ :=
  {x | AbsolutelyConvergesAt a c x}

/-- 幂级数和函数，以 Mathlib 的 `tsum` 表示；在绝对收敛点处等于自然部分和极限。 -/
noncomputable def sum (a : ℕ → ℝ) (c x : ℝ) : ℝ :=
  ∑' n, term a c x n

/-- 绝对收敛点处，自然顺序部分和趋于 `sum a c x`。 -/
theorem absolutelyConvergesAt_imp_hasSumAt {a : ℕ → ℝ} {c x : ℝ}
    (h : AbsolutelyConvergesAt a c x) : HasSumAt a c x (sum a c x) := by
  change Summable (fun n => |term a c x n|) at h
  have hs : Summable (term a c x) := by
    apply Summable.of_norm
    simpa [Real.norm_eq_abs] using h
  exact hs.tendsto_sum_tsum_nat

/-- 绝对收敛蕴含按自然顺序收敛。 -/
theorem absolutelyConvergesAt_imp_convergesAt {a : ℕ → ℝ} {c x : ℝ}
    (h : AbsolutelyConvergesAt a c x) : ConvergesAt a c x :=
  ⟨sum a c x, absolutelyConvergesAt_imp_hasSumAt h⟩

/-- 任意幂级数在中心 `c` 处绝对收敛，因为除常数项外所有项均为零。 -/
theorem center_absolutelyConvergesAt (a : ℕ → ℝ) (c : ℝ) :
    AbsolutelyConvergesAt a c c := by
  apply summable_of_ne_finset_zero (s := {0})
  intro n hn
  have hn0 : n ≠ 0 := by simpa using hn
  simp [term, hn0]

theorem center_mem_absoluteConvergenceSet (a : ℕ → ℝ) (c : ℝ) :
    c ∈ absoluteConvergenceSet a c := center_absolutelyConvergesAt a c

theorem center_mem_convergenceSet (a : ℕ → ℝ) (c : ℝ) :
    c ∈ convergenceSet a c :=
  absolutelyConvergesAt_imp_convergesAt (center_absolutelyConvergesAt a c)

/-- 幂级数在中心处的和等于常数项 `a₀`。 -/
theorem sum_at_center (a : ℕ → ℝ) (c : ℝ) : sum a c c = a 0 := by
  rw [sum]
  have hterm : term a c c = fun n => if n = 0 then a 0 else 0 := by
    funext n
    by_cases hn : n = 0
    · subst n
      simp [term]
    · simp [term, hn]
  rw [hterm]
  simp

end SandronesLibrary.Analysis.PowerSeries
