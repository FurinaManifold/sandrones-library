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

end Analysis.Sequence

end SandronesLibrary