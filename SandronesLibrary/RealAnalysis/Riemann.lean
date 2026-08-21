/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

/-!
# RealAnalysis / Riemann —— 黎曼积分与 Lebesgue 判据（数学分析第二学期 R5.5）

本文件当前条目（引理清单，§0 铁律4：一次一条，逐条编译）：

* **real-analysis.riemann.def**（黎曼积分定义：达布分划/上下和/黎曼可积/均匀分划）。
* **real-analysis.riemann.eq-lebesgue**（黎曼可积时数值 = Lebesgue 积分）。
* **real-analysis.riemann.lebesgue-criterion**（黎曼可积 ⟺ 几乎处处连续）。

> **语言说明**：mathlib **没有**黎曼积分定义，全部自建。这是锻炼"论文定理自证"能力
> （Playbook §4.1）的实战。用 `sSup`/`sInf`（区间上下确界）、`Finset` 求和、`volume`。
-/

namespace SandronesLibrary

namespace RealAnalysis.Riemann

open MeasureTheory
open scoped ENNReal Interval BigOperators

/-- **达布分划**：区间 [a,b] 的一个分划是点列 a = x₀ < x₁ < ... < xₙ = b。 -/
structure DarbouxPartition (a b : ℝ) where
  n : ℕ
  x : ℕ → ℝ
  x0 : x 0 = a
  xN : x n = b
  strict : ∀ i, i < n → x i < x (i + 1)

/-- **达布下和**：Σᵢ (xᵢ₊₁ − xᵢ) · inf f on [xᵢ, xᵢ₊₁]。 -/
noncomputable def lowerSum (f : ℝ → ℝ) {a b : ℝ} (P : DarbouxPartition a b) : ℝ :=
  ∑ i ∈ Finset.range P.n, (P.x (i + 1) - P.x i) * sInf (f '' Set.Icc (P.x i) (P.x (i + 1)))

/-- **达布上和**：Σᵢ (xᵢ₊₁ − xᵢ) · sup f on [xᵢ, xᵢ₊₁]。 -/
noncomputable def upperSum (f : ℝ → ℝ) {a b : ℝ} (P : DarbouxPartition a b) : ℝ :=
  ∑ i ∈ Finset.range P.n, (P.x (i + 1) - P.x i) * sSup (f '' Set.Icc (P.x i) (P.x (i + 1)))

/-- **黎曼可积**：上下和可任意逼近（上积分 = 下积分）。
  教材定义：∀ ε > 0，存在分划使上和 − 下和 < ε。 
> **Entry**: real-analysis.riemann.def
-/
def RiemannIntegrable (f : ℝ → ℝ) (a b : ℝ) : Prop :=
  ∀ ε > 0, ∃ P : DarbouxPartition a b, upperSum f P - lowerSum f P < ε

/-- **均匀分划**：将 [a,b] 等分为 n 段（xᵢ = a + i·(b−a)/n）。
  用于"连续 ⟹ 可积"中控制上下和之差。 -/
noncomputable def uniformPartition (a b : ℝ) (n : ℕ) (hab : a < b) (hpos : 0 < n) :
    DarbouxPartition a b where
  n := n
  x := fun i => a + (i : ℝ) * ((b - a) / (n : ℝ))
  x0 := by simp
  xN := by
    field_simp
    ring
  strict := by
    intro i hi
    have hd : 0 < (b - a) / (n : ℝ) := by
      exact div_pos (sub_pos.mpr hab) (Nat.cast_pos.mpr hpos)
    have : (i : ℝ) < (i + 1 : ℕ) := by exact_mod_cast Nat.lt_succ_self i
    nlinarith

/-- **均匀分划的步长**：相邻两点距离 = (b−a)/n（等分性质）。 -/
theorem uniformPartition_step {a b : ℝ} {n : ℕ} (hab : a < b) (hpos : 0 < n)
    (i : ℕ) (_hi : i < n) :
    (uniformPartition a b n hab hpos).x (i + 1) - (uniformPartition a b n hab hpos).x i =
      (b - a) / (n : ℝ) := by
  simp [uniformPartition]
  ring

end RealAnalysis.Riemann

end SandronesLibrary