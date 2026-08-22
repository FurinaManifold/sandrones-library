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

/-! ## 收敛半径 -/

open scoped ENNReal

/-- 若幂级数在 `x` 处收敛，则它在任何严格靠近中心的点 `y` 处绝对收敛。

这是幂级数理论的核心比较引理：已知 `aₙ(x-c)ⁿ` 的部分和为 Cauchy 列，而比值
`|(y-c)/(x-c)|<1` 提供几何衰减，故较内侧级数绝对可和。 -/
theorem absolutelyConvergesAt_of_lt_of_convergesAt {a : ℕ → ℝ} {c x y : ℝ}
    (hyx : |y - c| < |x - c|) (hx : ConvergesAt a c x) :
    AbsolutelyConvergesAt a c y := by
  rcases hx with ⟨s, hs⟩
  change Tendsto (fun N => ∑ n ∈ Finset.range N, a n * (x - c) ^ n)
    atTop (𝓝 s) at hs
  have hCauchy : CauchySeq
      (fun N => ∑ n ∈ Finset.range N, a n * (x - c) ^ n) := hs.cauchySeq
  have hsum : Summable (fun n => a n * (y - c) ^ n) :=
    summable_powerSeries_of_norm_lt hCauchy (by simpa [Real.norm_eq_abs] using hyx)
  change Summable (fun n => |a n * (y - c) ^ n|)
  exact hsum.abs

/-- 可容许半径集合：某个收敛点到中心的距离以下的所有扩展非负实数。

显式取向下闭包后，上确界可直接表达“半径内”性质。 -/
def admissibleRadii (a : ℕ → ℝ) (c : ℝ) : Set ℝ≥0∞ :=
  {r | ∃ x, ConvergesAt a c x ∧ r ≤ ENNReal.ofReal |x - c|}

/-- 幂级数的收敛半径，值域为 `ℝ≥0∞`，因而允许半径为 `∞`。

> **Entry**: analysis.power-series.radius
-/
noncomputable def radius (a : ℕ → ℝ) (c : ℝ) : ℝ≥0∞ :=
  sSup (admissibleRadii a c)

/-- 任一收敛点到中心的距离都不超过收敛半径。 -/
theorem distance_le_radius_of_convergesAt {a : ℕ → ℝ} {c x : ℝ}
    (hx : ConvergesAt a c x) :
    ENNReal.ofReal |x - c| ≤ radius a c := by
  exact le_sSup ⟨x, hx, le_rfl⟩

/-- **半径内绝对收敛**：若点到中心的距离严格小于收敛半径，则幂级数绝对收敛。 -/
theorem absolutelyConvergesAt_of_lt_radius {a : ℕ → ℝ} {c x : ℝ}
    (hx : ENNReal.ofReal |x - c| < radius a c) :
    AbsolutelyConvergesAt a c x := by
  rcases lt_sSup_iff.mp hx with ⟨r, ⟨y, hy, hry⟩, hxr⟩
  have hxyE : ENNReal.ofReal |x - c| < ENNReal.ofReal |y - c| := hxr.trans_le hry
  have hypos : 0 < |y - c| := by
    rw [← ENNReal.ofReal_pos]
    exact lt_of_le_of_lt bot_le hxyE
  have hxy : |x - c| < |y - c| :=
    (ENNReal.ofReal_lt_ofReal_iff hypos).mp hxyE
  exact absolutelyConvergesAt_of_lt_of_convergesAt hxy hy

/-- **半径外发散**：若点到中心的距离严格大于收敛半径，则自然顺序部分和不收敛。 -/
theorem not_convergesAt_of_radius_lt {a : ℕ → ℝ} {c x : ℝ}
    (hx : radius a c < ENNReal.ofReal |x - c|) :
    ¬ ConvergesAt a c x := by
  intro hconv
  exact (not_le_of_gt hx) (distance_le_radius_of_convergesAt hconv)

/-- 收敛点集形式的半径内绝对收敛结论。 -/
theorem mem_absoluteConvergenceSet_of_lt_radius {a : ℕ → ℝ} {c x : ℝ}
    (hx : ENNReal.ofReal |x - c| < radius a c) :
    x ∈ absoluteConvergenceSet a c :=
  absolutelyConvergesAt_of_lt_radius hx

/-- 收敛点集形式的半径外发散结论。 -/
theorem not_mem_convergenceSet_of_radius_lt {a : ℕ → ℝ} {c x : ℝ}
    (hx : radius a c < ENNReal.ofReal |x - c|) :
    x ∉ convergenceSet a c :=
  not_convergesAt_of_radius_lt hx

end SandronesLibrary.Analysis.PowerSeries
