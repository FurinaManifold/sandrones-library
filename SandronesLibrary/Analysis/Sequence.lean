/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

open Filter Topology

/-!
# Analysis / Sequence —— 数列极限基础条目

本文件当前条目：

* **analysis.sequence.definition**（收敛的定义/ε-N 判据）：`Tendsto u atTop (𝓝 l)`
  ⟺ 对每个 ε>0 存在 N，使得从第 N 项起 |u n − l| < ε。
* **analysis.sequence.unique**（极限唯一）：同一个序列若有极限则极限唯一。
* **analysis.sequence.bounded**（收敛必有界）：收敛序列的值域既有上界也有下界。
* **analysis.sequence.squeeze**（夹逼定理）：两边夹住且同趋于 l，中间也趋于 l。
* **analysis.sequence.monotone-convergence**（单调有界收敛）：单调递增且值域有上界
  的序列收敛，且极限恰为其值域的上确界。
* **analysis.sequence.subsequence**（子序列）：收敛序列的任何子列收敛到同一极限。
* **analysis.sequence.bolzano-weierstrass**（波尔查诺-魏尔斯特拉斯）：有界实数列必有收敛子列。
* **analysis.sequence.cauchy**（Cauchy 收敛准则/完备性）：实数列收敛 ⟺ 是 Cauchy 列。
* **analysis.sequence.liminf-limsup**（上/下极限）：liminf ≤ limsup，且相等 ⟺ 收敛。
-/

namespace SandronesLibrary

namespace Analysis.Sequence

/--
> **Entry**: analysis.sequence.definition
> **一句话**: 数列收敛的 ε-N 判据——"最终会靠近极限"用"每个 ε 都最终满足"来刻画。
> **直觉**: "aₙ → l" 意思是：无论你要多近（ε），"从某一项往后全都落进 l 的 ε-邻域"。
>   它把"无限过程的最终结果"翻译成"有限次逼近的承诺"，是分析的基石。
> **依赖**: 无
> **mathlib**: `Metric.tendsto_atTop`, `Tendsto`, `𝓝`, `atTop`
-/
theorem tendsto_iff_epsilon_N {u : ℕ → ℝ} {l : ℝ} :
    Tendsto u atTop (𝓝 l) ↔ ∀ ε > 0, ∃ N : ℕ, ∀ n ≥ N, |u n - l| < ε := by
  -- 思路：度量空间里"趋于 l"就是"距离趋于 0"；距离在实轴上就是绝对值。
  simpa [Real.dist_eq] using Metric.tendsto_atTop (u := u) (a := l)

/--
> **Entry**: analysis.sequence.unique
> **一句话**: 数列若有极限，极限唯一。
> **直觉**: 序列不可能同时"最终被 a 逮住"又"最终被 b(≠a) 逮住"——
>   取 ε 小于二者距离的一半，从足够大的 n 起会既是 a 的邻点又是 b 的邻点，矛盾。
> **依赖**: 无
> **mathlib**: `tendsto_nhds_unique`, `Tendsto`
-/
theorem seq_limit_unique {u : ℕ → ℝ} {a b : ℝ}
    (ha : Tendsto u atTop (𝓝 a)) (hb : Tendsto u atTop (𝓝 b)) : a = b := by
  -- 思路：极限唯一是 Hausdorff 空间的基本事实（通用引理直接可用）。
  exact tendsto_nhds_unique (f := u) ha hb

/-- 收敛序列的值域有上界（辅助：ε=1 的尾部界 + 前缀自动被滤掉）。
  `IsBoundedUnder` 是"最终在某界之下"的滤子语言，`bddAbove_range` 把它
  翻译回值域的有界性。 -/
theorem convergent_bddAbove {u : ℕ → ℝ} {l : ℝ} (h : Tendsto u atTop (𝓝 l)) :
    BddAbove (Set.range u) := by
  have hε : ∀ ε > 0, ∃ N : ℕ, ∀ n ≥ N, |u n - l| < ε := by
    simpa [Real.dist_eq] using Metric.tendsto_atTop.mp h
  rcases hε 1 zero_lt_one with ⟨N, hN⟩
  have hev : ∀ᶠ n in atTop, u n ≤ l + 1 := by
    rw [eventually_atTop]
    refine ⟨N, ?_⟩
    intro n hn
    have hpos : u n - l < 1 := (abs_lt.mp (hN n hn)).2
    linarith
  exact (isBoundedUnder_of_eventually_le (f := atTop) (u := u) (a := l + 1) hev).bddAbove_range

/-- 收敛序列的值域有下界（镜像：ε=1 得尾部在 l−1 之上）。 -/
theorem convergent_bddBelow {u : ℕ → ℝ} {l : ℝ} (h : Tendsto u atTop (𝓝 l)) :
    BddBelow (Set.range u) := by
  have hε : ∀ ε > 0, ∃ N : ℕ, ∀ n ≥ N, |u n - l| < ε := by
    simpa [Real.dist_eq] using Metric.tendsto_atTop.mp h
  rcases hε 1 zero_lt_one with ⟨N, hN⟩
  have hev : ∀ᶠ n in atTop, l - 1 ≤ u n := by
    rw [eventually_atTop]
    refine ⟨N, ?_⟩
    intro n hn
    have hneg : -(1) < u n - l := (abs_lt.mp (hN n hn)).1
    linarith
  exact (isBoundedUnder_of_eventually_ge (f := atTop) (u := u) (a := l - 1) hev).bddBelow_range

/--
> **Entry**: analysis.sequence.bounded
> **一句话**: 收敛的数列必有界（值域既有上界又有下界）。
> **直觉**: 从第 N 项起全落在 (l−1, l+1) 里；前面只有有限多项，自然会"展不开"。
>   反过来不成立（有界不一定收敛，如 (−1)ⁿ）。这是"收敛→有界"的单向道。
> **依赖**: 无
> **mathlib**: `IsBoundedUnder`, `Metric.tendsto_atTop`, `BddAbove/BddBelow`
-/
theorem convergent_bounded {u : ℕ → ℝ} {l : ℝ} (h : Tendsto u atTop (𝓝 l)) :
    BddAbove (Set.range u) ∧ BddBelow (Set.range u) := by
  exact ⟨convergent_bddAbove h, convergent_bddBelow h⟩

/--
> **Entry**: analysis.sequence.squeeze
> **一句话**: 夹逼定理：aₙ ≤ bₙ ≤ cₙ 且 aₙ、cₙ 同趋于 l，则 bₙ 也趋于 l。
> **直觉**: 被两边挤住的东西无处可去。"挤住"=逐点不等式，"无处可去"
>   =两边都趋向同一处。
> **依赖**: `analysis.sequence.definition`（ε-N 判据的理解）
> **mathlib**: `tendsto_of_tendsto_of_tendsto_of_le_of_le`
-/
theorem squeeze_theorem {a b c : ℕ → ℝ} {l : ℝ}
    (hle₁ : ∀ n, a n ≤ b n) (hle₂ : ∀ n, b n ≤ c n)
    (ha : Tendsto a atTop (𝓝 l)) (hc : Tendsto c atTop (𝓝 l)) :
    Tendsto b atTop (𝓝 l) := by
  -- 思路：把两个逐点不等式升成函数间的 ≤（Pi 阶即逐点），再套通用夹逼引理。
  exact tendsto_of_tendsto_of_tendsto_of_le_of_le ha hc hle₁ hle₂

/--
> **Entry**: analysis.sequence.monotone-convergence
> **一句话**: 单调有界收敛定理：单调递增且值域有上界的序列必收敛，
>   且极限就是值域的上确界。
> **直觉**: 一路不回头地往上走，又被天花板挡着——那它只能越走越贴近天花板本身。
>   （本题的"天花板"=sSup。ℚ 里没有这个性质，完备性在这里第一回发威。）
> **依赖**: `analysis.real.sup`
> **mathlib**: `tendsto_atTop_ciSup`, `Real.isLUB_sSup`
-/
theorem monotone_convergence {u : ℕ → ℝ} (hu : Monotone u)
    (hb : BddAbove (Set.range u)) :
    Tendsto u atTop (𝓝 (sSup (Set.range u))) ∧ IsLUB (Set.range u) (sSup (Set.range u)) := by
  -- 思路：单调递增+有界 → sup 存在（确界原理），且单调序列收敛到 sup。
  constructor
  · rw [← (Real.isLUB_sSup (Set.range_nonempty u) hb).ciSup_eq]
    exact tendsto_atTop_ciSup hu hb
  · exact Real.isLUB_sSup (Set.range_nonempty u) hb

/--
> **Entry**: analysis.sequence.subsequence
> **一句话**: 子序列定义与主干定理——收敛序列的任何子列都收敛到同一极限。
> **直觉**: "子列" = 跳着取但绝不回头的取法（下标函数 φ 严格递增）。
>   主干已经收敛，局部主义跳着取值自然只更"追得上"。
> **依赖**: 无
> **mathlib**: `StrictMono.tendsto_atTop`, `Filter.Tendsto.comp`

子序列判定：v 是 u 的子列 ⟺ 存在严格递增的取法 φ，使 v = u ∘ φ。
-/
def IsSubsequenceOf (u : ℕ → ℝ) (v : ℕ → ℝ) : Prop :=
  ∃ φ : ℕ → ℕ, StrictMono φ ∧ v = u ∘ φ

/-- 收敛序列的任何子列收敛到同一极限（φ 严格递增 ⇒ φ→atTop，复合得证）。 -/
theorem subsequence_of_convergent {u : ℕ → ℝ} {l : ℝ}
    (hu : Tendsto u atTop (𝓝 l)) {v : ℕ → ℝ} (hsub : IsSubsequenceOf u v) :
    Tendsto v atTop (𝓝 l) := by
  rcases hsub with ⟨φ, hφ, rfl⟩
  exact hu.comp (StrictMono.tendsto_atTop hφ)

/-- 辅助：有上界又有下界的序列，整体落入某个对称闭区间 [−M, M]。 -/
lemma sequence_bounded_in_interval {u : ℕ → ℝ}
    (hb : BddAbove (Set.range u)) (hbdl : BddBelow (Set.range u)) :
    ∃ a b : ℝ, ∀ n : ℕ, u n ∈ Set.Icc a b := by
  rcases hb with ⟨b₀, hb₀⟩
  rcases hbdl with ⟨a₀, ha₀⟩
  let M : ℝ := max |a₀| |b₀|
  refine ⟨-M, M, ?_⟩
  intro n
  constructor
  · dsimp [M]
    calc
      -max |a₀| |b₀| ≤ -|a₀| := neg_le_neg (le_max_left |a₀| |b₀|)
      _ ≤ a₀ := neg_abs_le a₀
      _ ≤ u n := ha₀ ⟨n, rfl⟩
  · dsimp [M]
    calc
      u n ≤ b₀ := hb₀ ⟨n, rfl⟩
      _ ≤ |b₀| := le_abs_self b₀
      _ ≤ max |a₀| |b₀| := le_max_right |a₀| |b₀|

/--
> **Entry**: analysis.sequence.bolzano-weierstrass
> **一句话**: 波尔查诺-魏尔斯特拉斯定理：有界实数列必有收敛的子列。
> **直觉**: 有界 ⟹ 全值藏在一个闭区间里；闭区间紧，紧集中的序列必含收敛子列
>   （子列极限也在区间里）。
> **依赖**: `analysis.sequence.bounded`, `analysis.sequence.subsequence`
> **mathlib**: `CompactIccSpace.isCompact_Icc`, `IsCompact.isSeqCompact`

闭区间版本：值全在 [a, b] 的序列有收敛子列，且极限仍在 [a, b] 内。
-/
theorem bolzano_weierstrass_interval {u : ℕ → ℝ} {a b : ℝ}
    (h : ∀ n : ℕ, u n ∈ Set.Icc a b) :
    ∃ φ : ℕ → ℕ, StrictMono φ ∧ ∃ l : ℝ, l ∈ Set.Icc a b ∧ Tendsto (u ∘ φ) atTop (𝓝 l) := by
  have hIcc : IsCompact (Set.Icc a b) := CompactIccSpace.isCompact_Icc
  rcases hIcc.isSeqCompact h with ⟨l, hl, φ, hφ, hlim⟩
  exact ⟨φ, hφ, l, hl, hlim⟩

/-- 有界版本：把有界翻译进闭区间，再套闭区间版本。 -/
theorem bolzano_weierstrass {u : ℕ → ℝ}
    (hb : BddAbove (Set.range u)) (hbdl : BddBelow (Set.range u)) :
    ∃ φ : ℕ → ℕ, StrictMono φ ∧ ∃ l : ℝ, Tendsto (u ∘ φ) atTop (𝓝 l) := by
  rcases sequence_bounded_in_interval hb hbdl with ⟨a, b, h⟩
  rcases bolzano_weierstrass_interval h with ⟨φ, hφ, l, _, hl⟩
  exact ⟨φ, hφ, l, hl⟩

/--
> **Entry**: analysis.sequence.cauchy
> **一句话**: Cauchy 收敛准则（完备性）：实数列收敛 ⟺ 是 Cauchy 列。
> **直觉**: 收敛 = 大家往同一处跑；Cauchy = 大家相互之间靠拢。
>   "相互不靠拢"则没有公共去处；"虽是 Cauchy 却不收敛"在 ℚ；ℝ 里必有其处。
> **依赖**: `analysis.sequence.subsequence`（语言准备）、`analysis.sequence.bounded`
> **mathlib**: `CauchySeq`, `Metric.cauchySeq_iff`, `cauchySeq_tendsto_of_complete`

收敛 ⟹ Cauchy：极限把两端距离从任意远处居中拉回（双 ε/2 三角不等式）。
-/
theorem convergent_is_cauchy {u : ℕ → ℝ} {l : ℝ} (h : Tendsto u atTop (𝓝 l)) : CauchySeq u := by
  rw [Metric.cauchySeq_iff]
  intro ε hε
  have hε2 : 0 < ε / 2 := div_pos hε (by norm_num)
  rcases Metric.tendsto_atTop.mp h (ε / 2) hε2 with ⟨N, hN⟩
  refine ⟨N, ?_⟩
  intro m hm n hn
  rw [Real.dist_eq]
  have htri : |u m - u n| ≤ |u m - l| + |u n - l| := by
    calc
      |u m - u n| = |(u m - l) + (l - u n)| := by
        rw [show (u m - l) + (l - u n) = u m - u n by ring]
      _ ≤ |u m - l| + |l - u n| := abs_add_le _ _
      _ = |u m - l| + |u n - l| := by rw [abs_sub_comm l (u n)]
  linarith [htri,
    (show |u m - l| < ε / 2 by simpa [Real.dist_eq] using hN m hm),
    (show |u n - l| < ε / 2 by simpa [Real.dist_eq] using hN n hn)]

/-- Cauchy ⟹ 收敛：实数完备性（ℝ 的 CompleteSpace 实例直接给出极限）。 -/
theorem cauchy_seq_convergent {u : ℕ → ℝ} (h : CauchySeq u) : ∃ l : ℝ, Tendsto u atTop (𝓝 l) := by
  exact cauchySeq_tendsto_of_complete h

/--
> **Entry**: analysis.sequence.liminf-limsup
> **一句话**: 上/下极限：有界序列有 liminf ≤ limsup，且两极限相等 ⟺ 收敛到该值。
> **直觉**: limsup = "任何后续都跳不过的最矮天花板"，liminf = "任何后续都跌不破的最高地板"；
>   天花板从不低于地板（liminf ≤ limsup），两者挤成一起便是收敛。
> **依赖**: `analysis.sequence.bounded`（一致性口径：两向有界）
> **mathlib**: `Filter.liminf_le_limsup`, `tendsto_of_liminf_eq_limsup`

有界序列的下极限不超过上极限。
-/
theorem liminf_le_limsup_seq {u : ℕ → ℝ}
    (hU : IsBoundedUnder (· ≤ ·) atTop u) (hL : IsBoundedUnder (· ≥ ·) atTop u) :
    liminf u atTop ≤ limsup u atTop := by
  exact Filter.liminf_le_limsup (f := atTop) (u := u) hU hL

/-- liminf 与 limsup 相等（都 = a）⟹ 序列收敛到 a（两向有界时）。 -/
theorem tendsto_of_liminf_eq_limsup_seq {u : ℕ → ℝ} {a : ℝ}
    (hU : IsBoundedUnder (· ≤ ·) atTop u) (hL : IsBoundedUnder (· ≥ ·) atTop u)
    (hinf : liminf u atTop = a) (hsup : limsup u atTop = a) :
    Tendsto u atTop (𝓝 a) := by
  exact tendsto_of_liminf_eq_limsup (f := atTop) (u := u) (a := a) hinf hsup hU hL

end Analysis.Sequence

end SandronesLibrary