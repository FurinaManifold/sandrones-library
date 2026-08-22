/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Analysis.Series

/-!
# 实数项级数的 Cauchy 乘积

本文件建立数学分析教材中的级数乘法理论。给定两个级数 `Σaₙ`、`Σbₙ`，其 Cauchy
乘积的第 `n` 项是反对角线 `i+j=n` 上的有限卷积

`cₙ = a₀bₙ + a₁bₙ₋₁ + ⋯ + aₙb₀`。

内容按依赖关系分为三层：

1. 定义 `cauchyProduct`，并证明反对角线公式和有限三角部分和公式；
2. 证明双方绝对收敛时，乘积级数绝对收敛且级数和满足乘法公式；
3. 证明 Mertens 定理：只需一方绝对收敛，另一方按自然顺序收敛。

特别要注意：Mathlib 的 `Summable` 表示无条件可和。为了真正覆盖条件收敛级数，
Mertens 定理对非绝对收敛的一方使用自然顺序部分和的 `Tendsto` 作为接口。
-/

namespace SandronesLibrary.Analysis.Series

/-- **Cauchy 乘积系数**：`a` 与 `b` 的第 `n` 个卷积系数
`cₙ = ∑_{k=0}^n aₖ bₙ₋ₖ`。

> **Entry**: analysis.series.cauchy-product-definition
-/
def cauchyProduct (a b : ℕ → ℝ) (n : ℕ) : ℝ :=
  ∑ k ∈ Finset.range (n + 1), a k * b (n - k)

/-- `range (n+1)` 写法等于在有限反对角线 `i+j=n` 上求和。

这个形式消除了自然数减法，交换两个因子时尤其方便。 -/
theorem cauchyProduct_eq_antidiagonal (a b : ℕ → ℝ) (n : ℕ) :
    cauchyProduct a b n =
      ∑ ij ∈ Finset.HasAntidiagonal.antidiagonal n, a ij.1 * b ij.2 := by
  simpa [cauchyProduct] using
    (Finset.Nat.sum_antidiagonal_eq_sum_range_succ
      (fun i j => a i * b j) n).symm

/-- 前 `N` 个 Cauchy 系数之和等于三角区域 `i+j<N` 上的二重有限和：

`∑_{n<N} cₙ = ∑_{i<N} aᵢ ∑_{j<N-i} bⱼ`。

这是后续把乘积级数部分和与两个原级数部分和比较的基本代数恒等式。 -/
theorem sum_cauchyProduct_eq_triangle (a b : ℕ → ℝ) (N : ℕ) :
    (∑ n ∈ Finset.range N, cauchyProduct a b n) =
      ∑ i ∈ Finset.range N, a i * ∑ j ∈ Finset.range (N - i), b j := by
  simpa [cauchyProduct, Finset.mul_sum] using
    (Finset.sum_range_diag_flip N (fun i j => a i * b j))

/-! ## 绝对收敛级数的乘积 -/

/-- 若两个实数项级数都绝对收敛，则它们的 Cauchy 乘积也绝对收敛。

证明把每条反对角线的绝对值和嵌入整个二维乘积族，再使用两个绝对可和族的乘积可和性。

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

/-- 两个绝对收敛级数的 Cauchy 乘积收敛到两级数和的乘积。

与下一条 `tsum` 等式相比，本条保留 `HasSum`，可直接用于复合其他级数收敛证明。 -/
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

/-- 绝对收敛 Cauchy 乘积公式的 `tsum` 等式形式，适合代数改写和幂级数乘法。 -/
theorem tsum_cauchyProduct_of_absolute {a b : ℕ → ℝ}
    (ha : Summable (fun n => |a n|))
    (hb : Summable (fun n => |b n|)) :
    (∑' n, cauchyProduct a b n) = (∑' n, a n) * ∑' n, b n := by
  exact (hasSum_cauchyProduct_of_absolute ha hb).tsum_eq

/-! ## Mertens 定理 -/

open Filter
open scoped Topology

/-- 收敛实数列在 Mathlib 旧式绝对值接口 `IsCauSeq abs` 下是 Cauchy 列。

这是现代滤子极限接口与 `cauchy_product` 所用旧接口之间的桥梁。证明取极限邻域
`ε/2`，再用三角不等式估计任意尾项与固定第 `N` 项之差。 -/
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

/-- **Mertens 定理（左因子绝对收敛）**：若 `Σ|aₙ|` 收敛，而 `b` 的自然顺序
部分和趋于 `B`，则 Cauchy 乘积的自然顺序部分和趋于 `(Σaₙ)B`。

证明记三个部分和为 `A_N`、`B_N`、`C_N`。直接 Cauchy 乘积估计给出
`A_N B_N - C_N → 0`，而极限乘法给出 `A_N B_N → (Σaₙ)B`，两式相减即得结论。

这里必须使用自然顺序部分和假设，才能包含条件收敛级数；Mathlib 的无条件
`Summable` 不能表达这一层教材结论。

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

/-- **Mertens 定理（右因子绝对收敛）**：右因子绝对收敛时的对称形式。

先交换有限反对角线的两个坐标，把 `cauchyProduct b a` 化为 `cauchyProduct a b`，
再应用左因子版本。 -/
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
