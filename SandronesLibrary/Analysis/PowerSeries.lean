/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Analysis.Series.CauchyProduct
import Mathlib.Analysis.Calculus.SmoothSeries

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

/-- 幂级数在一点的自然顺序和，就是其项列作为一般实数级数的教材和。 -/
theorem hasSumAt_iff_seriesHasSum {a : ℕ → ℝ} {c x s : ℝ} :
    HasSumAt a c x s ↔ Analysis.Series.SeriesHasSum (term a c x) s :=
  Iff.rfl

/-- 幂级数在一点收敛，就是其项列作为一般实数级数按自然顺序收敛。 -/
theorem convergesAt_iff_seriesConvergent {a : ℕ → ℝ} {c x : ℝ} :
    ConvergesAt a c x ↔ Analysis.Series.SeriesConvergent (term a c x) :=
  Iff.rfl

/-- 幂级数在一点绝对收敛，与其项列的一般级数教材绝对收敛完全等价。 -/
theorem absolutelyConvergesAt_iff_seriesAbsolutelyConvergent
    {a : ℕ → ℝ} {c x : ℝ} :
    AbsolutelyConvergesAt a c x ↔
      Analysis.Series.SeriesAbsolutelyConvergent (term a c x) := by
  rw [AbsolutelyConvergesAt,
    Analysis.Series.seriesAbsolutelyConvergent_iff_summable_abs]

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
    (h : AbsolutelyConvergesAt a c x) : ConvergesAt a c x := by
  rw [convergesAt_iff_seriesConvergent]
  exact Analysis.Series.seriesConvergent_of_seriesAbsolutelyConvergent
    (absolutelyConvergesAt_iff_seriesAbsolutelyConvergent.mp h)

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

/-! ## 有限收敛半径的端点分类 -/

/-- 有限收敛半径对应的实数值。

当扩展非负实数半径不是 `∞` 时，`toReal` 不丢失信息，因而可以在实轴上写出
`c-R` 与 `c+R` 两个端点。

> **Entry**: analysis.power-series.endpoints
-/
noncomputable def finiteRadius (a : ℕ → ℝ) (c : ℝ) : ℝ :=
  (radius a c).toReal

/-- 有限收敛区间的左端点 `c-R`。 -/
noncomputable def leftEndpoint (a : ℕ → ℝ) (c : ℝ) : ℝ := c - finiteRadius a c

/-- 有限收敛区间的右端点 `c+R`。 -/
noncomputable def rightEndpoint (a : ℕ → ℝ) (c : ℝ) : ℝ := c + finiteRadius a c

/-- 若半径有限，则每个收敛点到中心的距离不超过实数半径。 -/
theorem abs_le_finiteRadius_of_convergesAt {a : ℕ → ℝ} {c x : ℝ}
    (hfin : radius a c ≠ ⊤) (hx : ConvergesAt a c x) :
    |x - c| ≤ finiteRadius a c := by
  have h := distance_le_radius_of_convergesAt hx
  rw [← ENNReal.ofReal_toReal hfin] at h
  exact (ENNReal.ofReal_le_ofReal_iff ENNReal.toReal_nonneg).mp h

/-- 若到中心的距离严格小于有限半径，则该点绝对收敛。 -/
theorem absolutelyConvergesAt_of_abs_lt_finiteRadius {a : ℕ → ℝ} {c x : ℝ}
    (hfin : radius a c ≠ ⊤) (hx : |x - c| < finiteRadius a c) :
    AbsolutelyConvergesAt a c x := by
  have hRpos : 0 < finiteRadius a c := (abs_nonneg _).trans_lt hx
  apply absolutelyConvergesAt_of_lt_radius
  rw [← ENNReal.ofReal_toReal hfin]
  exact (ENNReal.ofReal_lt_ofReal_iff hRpos).2 hx

/-- 若到中心的距离严格大于有限半径，则该点不收敛。 -/
theorem not_convergesAt_of_finiteRadius_lt_abs {a : ℕ → ℝ} {c x : ℝ}
    (hfin : radius a c ≠ ⊤) (hx : finiteRadius a c < |x - c|) :
    ¬ ConvergesAt a c x := by
  apply not_convergesAt_of_radius_lt
  rw [← ENNReal.ofReal_toReal hfin]
  exact (ENNReal.ofReal_lt_ofReal_iff (ENNReal.toReal_nonneg.trans_lt hx)).2 hx

/-- **有限半径的精确收敛分类**。

一个点收敛，当且仅当它严格位于开区间 `(c-R,c+R)` 内，或者它恰为两个端点之一
且该端点级数本身收敛。半径定理决定整个开区间与区间外部，却不会替我们决定端点；
左右端点必须分别代入原级数判定。 -/
theorem convergesAt_iff_interior_or_endpoints {a : ℕ → ℝ} {c x : ℝ}
    (hfin : radius a c ≠ ⊤) :
    ConvergesAt a c x ↔
      |x - c| < finiteRadius a c ∨
      (x = leftEndpoint a c ∧ ConvergesAt a c (leftEndpoint a c)) ∨
      (x = rightEndpoint a c ∧ ConvergesAt a c (rightEndpoint a c)) := by
  constructor
  · intro hx
    have hle := abs_le_finiteRadius_of_convergesAt hfin hx
    rcases lt_or_eq_of_le hle with hlt | heq
    · exact Or.inl hlt
    · rcases (abs_eq ENNReal.toReal_nonneg).mp heq with hpos | hneg
      · have hxeq : x = rightEndpoint a c := by
          dsimp [rightEndpoint, finiteRadius]
          linarith
        exact Or.inr (Or.inr ⟨hxeq, hxeq ▸ hx⟩)
      · have hxeq : x = leftEndpoint a c := by
          dsimp [leftEndpoint, finiteRadius]
          linarith
        exact Or.inr (Or.inl ⟨hxeq, hxeq ▸ hx⟩)
  · rintro (hlt | ⟨rfl, hx⟩ | ⟨rfl, hx⟩)
    · exact absolutelyConvergesAt_imp_convergesAt
        (absolutelyConvergesAt_of_abs_lt_finiteRadius hfin hlt)
    · exact hx
    · exact hx

/-- 有限半径下绝对收敛点的对应分类；端点是否绝对收敛同样需要分别判定。 -/
theorem absolutelyConvergesAt_iff_interior_or_endpoints {a : ℕ → ℝ} {c x : ℝ}
    (hfin : radius a c ≠ ⊤) :
    AbsolutelyConvergesAt a c x ↔
      |x - c| < finiteRadius a c ∨
      (x = leftEndpoint a c ∧ AbsolutelyConvergesAt a c (leftEndpoint a c)) ∨
      (x = rightEndpoint a c ∧ AbsolutelyConvergesAt a c (rightEndpoint a c)) := by
  constructor
  · intro hx
    have hconv := absolutelyConvergesAt_imp_convergesAt hx
    have hle := abs_le_finiteRadius_of_convergesAt hfin hconv
    rcases lt_or_eq_of_le hle with hlt | heq
    · exact Or.inl hlt
    · rcases (abs_eq ENNReal.toReal_nonneg).mp heq with hpos | hneg
      · have hxeq : x = rightEndpoint a c := by
          dsimp [rightEndpoint, finiteRadius]
          linarith
        exact Or.inr (Or.inr ⟨hxeq, hxeq ▸ hx⟩)
      · have hxeq : x = leftEndpoint a c := by
          dsimp [leftEndpoint, finiteRadius]
          linarith
        exact Or.inr (Or.inl ⟨hxeq, hxeq ▸ hx⟩)
  · rintro (hlt | ⟨rfl, hx⟩ | ⟨rfl, hx⟩)
    · exact absolutelyConvergesAt_of_abs_lt_finiteRadius hfin hlt
    · exact hx
    · exact hx

/-! ## 收敛区间内的逐项运算 -/

/-- 两个幂级数逐项相加后的系数。

> **Entry**: analysis.power-series.operations
-/
def addCoeffs (a b : ℕ → ℝ) : ℕ → ℝ := fun n => a n + b n

/-- 两个幂级数相乘后的系数，即原系数列的 Cauchy 乘积。 -/
def mulCoeffs (a b : ℕ → ℝ) : ℕ → ℝ :=
  SandronesLibrary.Analysis.Series.cauchyProduct a b

/-- 形式求导后的系数：`bₙ=(n+1)aₙ₊₁`。 -/
def derivativeCoeffs (a : ℕ → ℝ) : ℕ → ℝ :=
  fun n => (n + 1 : ℝ) * a (n + 1)

/-- 取常数项为零的形式原函数系数：`b₀=0`、`bₙ₊₁=aₙ/(n+1)`。 -/
noncomputable def integralCoeffs (a : ℕ → ℝ) : ℕ → ℝ
  | 0 => 0
  | n + 1 => a n / (n + 1 : ℝ)

/-- 把控制列向右移动一位；用于匹配原函数与其导数的下标。 -/
def shiftedMajorant (u : ℕ → ℝ) : ℕ → ℝ
  | 0 => 0
  | n + 1 => u n

/-- 对积分系数再形式求导会恢复原系数。 -/
theorem derivativeCoeffs_integralCoeffs (a : ℕ → ℝ) :
    derivativeCoeffs (integralCoeffs a) = a := by
  funext n
  simp only [derivativeCoeffs, integralCoeffs]
  field_simp

/-- 在控制列前补一个零不改变可和性。 -/
theorem summable_shiftedMajorant {u : ℕ → ℝ} (hu : Summable u) :
    Summable (shiftedMajorant u) := by
  apply (summable_nat_add_iff 1).mp
  simpa [shiftedMajorant] using hu

/-- 原级数项受 `uₙ` 控制时，积分级数各项的导数受右移后的控制列支配。 -/
theorem integralCoeffs_derivative_bound {a u : ℕ → ℝ} {c R : ℝ}
    (hbound : ∀ (n : ℕ) y, |y - c| < R →
      ‖a n * (y - c) ^ n‖ ≤ u n) :
    ∀ (n : ℕ) y, |y - c| < R →
      ‖(n : ℝ) * integralCoeffs a n * (y - c) ^ (n - 1)‖ ≤ shiftedMajorant u n := by
  intro n y hy
  cases n with
  | zero => simp [integralCoeffs, shiftedMajorant]
  | succ n =>
      have hcoeff : ((n + 1 : ℕ) : ℝ) * integralCoeffs a (n + 1) = a n := by
        simp only [integralCoeffs]
        field_simp
        norm_num [Nat.cast_add, Nat.cast_one]
        ring
      rw [Nat.succ_sub_one, hcoeff]
      simpa [shiftedMajorant] using hbound n y hy

/-- **逐项加法**：两个幂级数在同一点绝对收敛时，逐项和的值等于和函数之和。 -/
theorem sum_add_of_absolutelyConvergesAt {a b : ℕ → ℝ} {c x : ℝ}
    (ha : AbsolutelyConvergesAt a c x)
    (hb : AbsolutelyConvergesAt b c x) :
    sum (addCoeffs a b) c x = sum a c x + sum b c x := by
  have haS : Summable (term a c x) := by
    apply Summable.of_norm
    simpa [AbsolutelyConvergesAt, Real.norm_eq_abs] using ha
  have hbS : Summable (term b c x) := by
    apply Summable.of_norm
    simpa [AbsolutelyConvergesAt, Real.norm_eq_abs] using hb
  have hterm : term (addCoeffs a b) c x = fun n => term a c x n + term b c x n := by
    funext n
    simp [term, addCoeffs, add_mul]
  simp only [sum, hterm]
  exact haS.tsum_add hbS

/-- **逐项乘法**：两个幂级数在同一点绝对收敛时，Cauchy 乘积的值等于两和值之积。 -/
theorem sum_mul_of_absolutelyConvergesAt {a b : ℕ → ℝ} {c x : ℝ}
    (ha : AbsolutelyConvergesAt a c x)
    (hb : AbsolutelyConvergesAt b c x) :
    sum (mulCoeffs a b) c x = sum a c x * sum b c x := by
  let z := x - c
  have hprod := SandronesLibrary.Analysis.Series.tsum_cauchyProduct_of_absolute ha hb
  have hterm : term (mulCoeffs a b) c x =
      SandronesLibrary.Analysis.Series.cauchyProduct (term a c x) (term b c x) := by
    funext n
    change SandronesLibrary.Analysis.Series.cauchyProduct a b n * z ^ n =
      SandronesLibrary.Analysis.Series.cauchyProduct
        (fun k => a k * z ^ k) (fun k => b k * z ^ k) n
    exact (SandronesLibrary.Analysis.Series.cauchyProduct_mul_pow a b z n).symm
  simpa only [sum, hterm] using hprod

/-- **一致控制下逐项求导**。

若在开区间 `|y-c|<R` 上，每一项导数
`n aₙ(y-c)ⁿ⁻¹` 都被同一个可和数列 `uₙ` 控制，则幂级数和函数在该区间内可导，
导数正是形式求导系数 `((n+1)aₙ₊₁)` 所定义的幂级数。

证明在开球上使用导数级数的一致 Weierstrass 控制。原级数在中心处自动收敛，故满足
逐项求导定理所需的基点条件；最后把从 `n=1` 开始的导数级数平移为从 `n=0` 开始的
`derivativeCoeffs` 级数。 -/
theorem hasDerivAt_sum_of_summable_derivative_majorant
    {a u : ℕ → ℝ} {c x R : ℝ}
    (hR : 0 < R) (hx : |x - c| < R)
    (hu : Summable u)
    (hbound : ∀ (n : ℕ) y, |y - c| < R →
      ‖(n : ℝ) * a n * (y - c) ^ (n - 1)‖ ≤ u n) :
    HasDerivAt (sum a c) (sum (derivativeCoeffs a) c x) x := by
  let g : ℕ → ℝ → ℝ := fun n y => a n * (y - c) ^ n
  let g' : ℕ → ℝ → ℝ := fun n y => (n : ℝ) * a n * (y - c) ^ (n - 1)
  have hg : ∀ n y, HasDerivAt (g n) (g' n y) y := by
    intro n y
    have hp := ((hasDerivAt_id y).sub_const c).pow n
    simpa [g, g', mul_comm, mul_left_comm, mul_assoc] using hp.const_mul (a n)
  have hg0 : Summable (fun n => g n c) := by
    apply summable_of_ne_finset_zero (s := {0})
    intro n hn
    have hn0 : n ≠ 0 := by simpa using hn
    simp [g, hn0]
  have hball : x ∈ Metric.ball c R := by
    simpa [Metric.mem_ball, Real.dist_eq, abs_sub_comm] using hx
  have hraw : HasDerivAt (fun y => ∑' n, g n y) (∑' n, g' n x) x := by
    apply hasDerivAt_tsum_of_isPreconnected hu Metric.isOpen_ball
      (convex_ball c R).isPreconnected (fun n y _ => hg n y)
    · intro n y hy
      apply hbound n y
      simpa [Metric.mem_ball, Real.dist_eq, abs_sub_comm] using hy
    · exact Metric.mem_ball_self hR
    · exact hg0
    · exact hball
  have hg'S : Summable (fun n => g' n x) := by
    apply Summable.of_norm_bounded hu
    intro n
    exact hbound n x hx
  have hshift : (∑' n, g' n x) = sum (derivativeCoeffs a) c x := by
    have hsplit := hg'S.sum_add_tsum_nat_add 1
    rw [show (∑ n ∈ Finset.range 1, g' n x) = 0 by simp [g']] at hsplit
    have htail : (fun n => g' (n + 1) x) = term (derivativeCoeffs a) c x := by
      funext n
      simp [g', term, derivativeCoeffs, Nat.cast_add]
    simpa [sum, htail] using hsplit.symm
  change HasDerivAt (sum a c) (∑' n, g' n x) x at hraw
  rw [hshift] at hraw
  exact hraw

/-- **逐项积分的原函数形式**。

若原级数各项在 `|y-c|<R` 上由可和列一致控制，则系数
`0,a₀,a₁/2,a₂/3,…` 构成的幂级数可逐项求导，其导数就是原幂级数的和。
因此它给出了以中心 `c` 为零值的逐项积分原函数。 -/
theorem hasDerivAt_sum_integralCoeffs_of_summable_majorant
    {a u : ℕ → ℝ} {c x R : ℝ}
    (hR : 0 < R) (hx : |x - c| < R)
    (hu : Summable u)
    (hbound : ∀ n y, |y - c| < R →
      ‖a n * (y - c) ^ n‖ ≤ u n) :
    HasDerivAt (sum (integralCoeffs a) c) (sum a c x) x := by
  have h := hasDerivAt_sum_of_summable_derivative_majorant
    (a := integralCoeffs a) (u := shiftedMajorant u) (c := c) (x := x) (R := R)
    hR hx (summable_shiftedMajorant hu)
    (integralCoeffs_derivative_bound hbound)
  simpa only [derivativeCoeffs_integralCoeffs] using h

end SandronesLibrary.Analysis.PowerSeries
