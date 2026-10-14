/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

/-!
# RealAnalysis / BoundedVariation —— 有界变差与 Jordan 分解（Folland RA-F5 §3.5）

本文件当前条目（引理清单）：

* **real-analysis.bounded-variation**（有界变差：教材“变差 = 分割加和的上确界”定义的 Lean 承载与
  量词展开、全变差函数 `variationOnFromTo` 的基本性质、Jordan 分解“BV = 增 − 增”
  （Folland §3.5 Theorem 3.27 的教材强度内容）、BV ⟹ a.e. 可导的接口，以及“单调 ⟹ BV”的接口）✅。

> **语言说明**：Folland §3.5 用分割 `a = x₀ < x₁ < ⋯ < xₙ = b` 上的加和
> `S_P = ∑ᵢ |F(xᵢ) - F(xᵢ₋₁)|` 的上确界定义全变差。Mathlib 的 `eVariationOn f s` 与之逐字对应
> （对严格单调序列取上确界，见 `eVariationOn.eVariationOn_eq_strictMonoOn`），故本库直接把它作为
> **正式公开承载**，不另造同构 `def`。变差取 `ℝ≥0∞` 值是为了容纳无穷变差；全变差函数
> `V_f(x) = Var_{[a,x]} f` 则取 `ℝ` 值（`variationOnFromTo`），与教材的实值 `T_F` 一致。

### Mathlib 角色（本文件）

* `eVariationOn` / `BoundedVariationOn` / `LocallyBoundedVariationOn`：**正式公开承载**
  （课程定义直接采用）。
* `variationOnFromTo`：全变差函数 `V_f(x) = Var_{[a,x]} f` 的**正式公开承载**（`ℝ` 值）。
* `eVariationOn.eVariationOn_eq_strictMonoOn`、`eVariationOn.eq_biSup_inter_Icc`：
  **教材量词展开**（“变差 = 分割加和的上确界”）。
* `LocallyBoundedVariationOn.exists_monotoneOn_sub_monotoneOn'` / `..._sub_monotoneOn`：
  Jordan 分解的**私有证明后端**，本文件把它们提升为教材命题（Folland Theorem 3.27）。
* `MonotoneOn.eVariationOn_eq` / `MonotoneOn.locallyBoundedVariationOn`：
  “单调 ⟹ BV”的**私有证明后端**。
* `BoundedVariationOn.ae_differentiableAt_of_mem_uIcc`：BV ⟹ a.e. 可导的**桥**（a.e. 结论，
  依赖 `volume`）。

### 诚实边界（本条目）

* a.e. 结论一律写成 `∀ᵐ x, …`，**不是**逐点结论；零测例外集可以非空。
* 不含 FTC 的 a.e. 版本（RA-F6），也不含 Lebesgue 微分定理本身（RA-F4）。
-/

namespace SandronesLibrary

namespace RealAnalysis.BoundedVariation

open Set Filter MeasureTheory
open scoped NNReal ENNReal Topology MeasureTheory

variable {α : Type*} [LinearOrder α] {E : Type*} [PseudoEMetricSpace E]

/-! ## 1. 定义层与教材量词展开 -/

/-- **教材量词展开（变差 = 分割加和的上确界）**：`eVariationOn f s` 等于所有“严格单调分割”
`u 0 < u 1 < ⋯ < u n`（各分点落在 `s` 中）上 `∑ edist (f (u (i+1))) (f (u i))` 的上确界。
这正是 Folland §3.5 用分割定义全变差的量词：教材把分割写成 `a = x₀ < ⋯ < xₙ = b`，
Lean 把它编码为 `ℕ → α` 上的严格单调序列（长度 `n` 用 `Iic n` 限制）。
> **Entry**: real-analysis.bounded-variation
-/
theorem eVariationOn_eq_sup_over_partitions (f : α → E) (s : Set α) :
    eVariationOn f s =
      ⨆ p : (n : ℕ) × { u : ℕ → α // StrictMonoOn u (Iic n) ∧ ∀ i ∈ Iic n, u i ∈ s },
        ∑ i ∈ Finset.range p.1, edist (f (p.2.1 (i + 1))) (f (p.2.1 i)) :=
  eVariationOn.eVariationOn_eq_strictMonoOn f s

/-- **变差的区间分解**：`eVariationOn f s` 是所有 `s` 中端点 `x ≤ y` 上
`eVariationOn f (s ∩ Icc x y)` 的上确界。这把教材“`[a,b]` 上的变差由各子区间的变差决定”
这一用法固定成一条可引用的量词展开。
> **Entry**: real-analysis.bounded-variation
-/
theorem eVariationOn_eq_biSup_inter_Icc {f : α → E} {s : Set α} :
    eVariationOn f s =
      ⨆ p ∈ {p : α × α | p.1 ∈ s ∧ p.2 ∈ s ∧ p.1 ≤ p.2},
        eVariationOn f (s ∩ Icc p.1 p.2) :=
  eVariationOn.eq_biSup_inter_Icc

/-- **有界变差的定义展开**：`BoundedVariationOn f s` 就是“`s` 上的全变差有限”。Mathlib 的定义
本身即为该命题，故为 `Iff.rfl`。
> **Entry**: real-analysis.bounded-variation
-/
theorem boundedVariationOn_iff_variation_ne_top {f : α → E} {s : Set α} :
    BoundedVariationOn f s ↔ eVariationOn f s ≠ ∞ :=
  Iff.rfl

/-- **有界变差的 `ℝ` 值形式**：全变差有限等价于 `eVariationOn f s < ∞`，因此教材可以把它写成
一个实数（`(eVariationOn f s).toReal`），这正是全变差函数 `V_f` 取值在 `ℝ` 的依据。
> **Entry**: real-analysis.bounded-variation
-/
theorem boundedVariationOn_iff_variation_lt_top {f : α → E} {s : Set α} :
    BoundedVariationOn f s ↔ eVariationOn f s < ∞ :=
  ⟨fun h => lt_of_le_of_ne le_top h, fun h => ne_of_lt h⟩

/-! ## 2. 全变差函数 `variationOnFromTo` 的基本性质 -/

/-- **全变差的可加性（教材的区间加性）**：`V_f(a,b) + V_f(b,c) = V_f(a,c)`（端点都在 `s` 中，
且 `f` 在 `s` 上局部有界变差）。教材把 `T_F` 定义成“从固定起点累计的变差”时，
正是这条加性使 `V_f(a,·)` 成为一个可用的“分布函数”。
> **Entry**: real-analysis.bounded-variation
-/
theorem variationOnFromTo_add {f : α → E} {s : Set α} {a b c : α}
    (h : LocallyBoundedVariationOn f s) (ha : a ∈ s) (hb : b ∈ s) (hc : c ∈ s) :
    variationOnFromTo f s a b + variationOnFromTo f s b c = variationOnFromTo f s a c :=
  variationOnFromTo.add h ha hb hc

/-- **全变差函数 `x ↦ V_f(a,x)` 单调不减**：这是教材把 `T_F` 称为“全变差函数”的原因，
也是 Jordan 分解中 `p`（上行部分）单调性的来源。
> **Entry**: real-analysis.bounded-variation
-/
theorem variationOnFromTo_monotoneOn {f : α → E} {s : Set α} {a : α}
    (h : LocallyBoundedVariationOn f s) (ha : a ∈ s) :
    MonotoneOn (variationOnFromTo f s a) s :=
  variationOnFromTo.monotoneOn h ha

/-- **全变差函数 `x ↦ V_f(x,b)` 单调不增**：左端点向右移动只会减少剩余区间的变差。
> **Entry**: real-analysis.bounded-variation
-/
theorem variationOnFromTo_antitoneOn {f : α → E} {s : Set α} {b : α}
    (h : LocallyBoundedVariationOn f s) (hb : b ∈ s) :
    AntitoneOn (fun a => variationOnFromTo f s a b) s :=
  variationOnFromTo.antitoneOn h hb

/-- **`V_f(x,x) = 0`**：空区间的全变差为零。这是 `variationOnFromTo` 作为“从 `x` 出发的累计变差”
的基点，也是上面 `|f y - f x| ≤ V_f(x,y)` 中减掉 `V_f(x,x)` 的依据。
> **Entry**: real-analysis.bounded-variation
-/
theorem variationOnFromTo_self (f : α → E) (s : Set α) (a : α) :
    variationOnFromTo f s a a = 0 :=
  variationOnFromTo.self f s a

/-- **教材形式的不等式 `|f(y) - f(x)| ≤ V_f(x,y)`**（实值情形，`x ≤ y`，端点属于 `s`）：
全变差控制函数增量。它是“BV ⟹ 有界”“BV ⟹ 一致有界振幅”等教材推论的公共出发点。
> **Entry**: real-analysis.bounded-variation
-/
theorem abs_sub_le_variationOnFromTo {f : α → ℝ} {s : Set α} {x y : α}
    (h : LocallyBoundedVariationOn f s) (hx : x ∈ s) (hy : y ∈ s) (hxy : x ≤ y) :
    |f y - f x| ≤ variationOnFromTo f s x y := by
  have h' := variationOnFromTo.abs_sub_le_sub_of_le (a := x) (b := x) (c := y) h hx hx hy hxy
  simpa [variationOnFromTo.self] using h'

/-- **教材形式的不等式（相对形式）**：`|f(c) - f(b)| ≤ V_f(a,c) - V_f(a,b)`（`b ≤ c`）。
这是 Folland §3.5 中 `|F(y) - F(x)| ≤ T_F(y) - T_F(x)` 的 Lean 对照。
> **Entry**: real-analysis.bounded-variation
-/
theorem abs_sub_le_variationOnFromTo_sub {f : α → ℝ} {s : Set α} {a b c : α}
    (h : LocallyBoundedVariationOn f s) (ha : a ∈ s) (hb : b ∈ s) (hc : c ∈ s) (hbc : b ≤ c) :
    |f c - f b| ≤ variationOnFromTo f s a c - variationOnFromTo f s a b :=
  variationOnFromTo.abs_sub_le_sub_of_le h ha hb hc hbc

/-! ## 3. Jordan 分解：BV = 增 − 增（Folland §3.5 Theorem 3.27） -/

/-- **有界变差 ⟹ 局部有界变差**：若 `f` 在 `s` 上的全变差有限，则它在每个 `s ∩ [a,b]` 上
（`a, b ∈ s`）的全变差也有限——因为子集的变差不超过全集的变差（`eVariationOn.mono`）。
教材在区间上通常不再区分这两个概念；这条引理就是把 Jordan 分解的假设从“局部”接到“有界”上。
> **Entry**: real-analysis.bounded-variation
-/
theorem locallyBoundedVariationOn_of_boundedVariationOn {f : α → E} {s : Set α}
    (h : BoundedVariationOn f s) : LocallyBoundedVariationOn f s :=
  fun _ _ _ _ => h.mono Set.inter_subset_left

/-- **Jordan 分解（加强形式，Folland §3.5 Theorem 3.27 的教材强度内容）**：局部有界变差的实值
函数 `f` 可写成两个单调不减函数之差 `f = p - q`，并且 `p, q` 在任意两点 `x, y ∈ s` 上的**增量之和
恰等于全变差** `V_f(x,y)`：
`(p y - p x) + (q y - q x) = variationOnFromTo f s x y`。
后半句是“BV = 增 − 增”分解的定量加强：这对单调函数不是任意的，而是把上行与下行的运动分开记账，
两者增量之和正好复原全变差。
> **Entry**: real-analysis.bounded-variation
-/
theorem exists_monotoneOn_sub_monotoneOn_variation {f : α → ℝ} {s : Set α}
    (h : LocallyBoundedVariationOn f s) :
    ∃ p q : α → ℝ, MonotoneOn p s ∧ MonotoneOn q s ∧ f = p - q ∧
      ∀ x ∈ s, ∀ y ∈ s, p y - p x + (q y - q x) = variationOnFromTo f s x y :=
  LocallyBoundedVariationOn.exists_monotoneOn_sub_monotoneOn' h

/-- **Jordan 分解（教材形式）**：局部有界变差 ⟹ `f = p - q`，其中 `p, q` 在 `s` 上单调不减。
这就是 Folland §3.5 的“有界变差函数是两个单调函数之差”。
> **Entry**: real-analysis.bounded-variation
-/
theorem exists_monotoneOn_sub_monotoneOn {f : α → ℝ} {s : Set α}
    (h : LocallyBoundedVariationOn f s) :
    ∃ p q : α → ℝ, MonotoneOn p s ∧ MonotoneOn q s ∧ f = p - q :=
  LocallyBoundedVariationOn.exists_monotoneOn_sub_monotoneOn h

/-- **区间上的 Jordan 分解（Folland §3.5 Theorem 3.27）**：若实值函数 `f` 在 `uIcc a b` 上有界
变差，则存在在 `uIcc a b` 上单调不减的 `p, q` 使 `f = p - q`。这是教材定理在 `ℝ` 的闭区间上
的逐字形式（`uIcc a b` 在 `a ≤ b` 时就是 `Icc a b`，且对端点顺序对称）。
> **Entry**: real-analysis.bounded-variation
-/
theorem boundedVariationOn_exists_monotoneOn_sub_monotoneOn_uIcc {f : ℝ → ℝ} {a b : ℝ}
    (h : BoundedVariationOn f (uIcc a b)) :
    ∃ p q : ℝ → ℝ, MonotoneOn p (uIcc a b) ∧ MonotoneOn q (uIcc a b) ∧ f = p - q :=
  LocallyBoundedVariationOn.exists_monotoneOn_sub_monotoneOn
    (locallyBoundedVariationOn_of_boundedVariationOn h)

/-- **区间上的 Jordan 分解（带全变差恒等式）**：上一条的加强形式，额外给出
`(p y - p x) + (q y - q x) = V_f(x,y)`（`x, y ∈ uIcc a b`）。
> **Entry**: real-analysis.bounded-variation
-/
theorem boundedVariationOn_exists_monotoneOn_sub_monotoneOn_variation_uIcc {f : ℝ → ℝ} {a b : ℝ}
    (h : BoundedVariationOn f (uIcc a b)) :
    ∃ p q : ℝ → ℝ, MonotoneOn p (uIcc a b) ∧ MonotoneOn q (uIcc a b) ∧ f = p - q ∧
      ∀ x ∈ uIcc a b, ∀ y ∈ uIcc a b,
        p y - p x + (q y - q x) = variationOnFromTo f (uIcc a b) x y :=
  LocallyBoundedVariationOn.exists_monotoneOn_sub_monotoneOn'
    (locallyBoundedVariationOn_of_boundedVariationOn h)

/-! ## 4. 与 a.e. 导数的接口 -/

/-- **BV ⟹ 几乎处处可导（区间形式）**：若 `f : ℝ → V`（`V` 为有限维实赋范空间）在 `uIcc a b` 上
有界变差，则 `f` 在 `uIcc a b` 上**几乎处处**（关于 `volume`）可导：
`∀ᵐ x, x ∈ uIcc a b → DifferentiableAt ℝ f x`。
> **诚实边界**：这是 a.e. 结论，**不是**逐点结论——零测例外集可以非空。本条目不含 Lebesgue
> 微分定理本身（RA-F4），也不含 FTC 的 a.e. 版本（RA-F6）。
> **Entry**: real-analysis.bounded-variation
-/
theorem boundedVariationOn_ae_differentiableAt_uIcc {V : Type*} [NormedAddCommGroup V]
    [NormedSpace ℝ V] [FiniteDimensional ℝ V] {f : ℝ → V} {a b : ℝ}
    (h : BoundedVariationOn f (uIcc a b)) :
    ∀ᵐ x : ℝ, x ∈ uIcc a b → DifferentiableAt ℝ f x :=
  h.ae_differentiableAt_of_mem_uIcc

/-- **BV ⟹ 几乎处处可导（全直线形式）**：若 `f` 在 `univ` 上局部有界变差，则 `f` 在 `ℝ` 上
几乎处处（关于 `volume`）可导。
> **诚实边界**：a.e. 结论，不是逐点结论。
> **Entry**: real-analysis.bounded-variation
-/
theorem locallyBoundedVariationOn_ae_differentiableAt {V : Type*} [NormedAddCommGroup V]
    [NormedSpace ℝ V] [FiniteDimensional ℝ V] {f : ℝ → V}
    (h : LocallyBoundedVariationOn f univ) :
    ∀ᵐ x : ℝ, DifferentiableAt ℝ f x :=
  h.ae_differentiableAt

/-! ## 5. 与单调函数的接口（同批 `real-analysis.monotone-function`） -/

/-- **单调函数的变差等于增量**：`eVariationOn f (s ∩ Icc a b) = f b - f a`（实值、`a, b ∈ s`）。
教材证明是对分割做 telescoping：`∑ᵢ (f(xᵢ₊₁) - f(xᵢ)) = f(b) - f(a)`，且每一项非负，故上确界
恰为 `f(b) - f(a)`。这条也是“单调 ⟹ BV”与 Jordan 分解 `q` 侧的定量基础。
> **Entry**: real-analysis.bounded-variation
-/
theorem monotoneOn_eVariationOn_eq {f : α → ℝ} {s : Set α} {a b : α} (hf : MonotoneOn f s)
    (ha : a ∈ s) (hb : b ∈ s) :
    eVariationOn f (s ∩ Icc a b) = ENNReal.ofReal (f b - f a) :=
  hf.eVariationOn_eq ha hb

/-- **单调 ⟹ 局部有界变差**（教材“单调函数在每个闭区间上有界变差”的一般形式）。
> **Entry**: real-analysis.bounded-variation
-/
theorem monotoneOn_locallyBoundedVariationOn {f : α → ℝ} {s : Set α} (hf : MonotoneOn f s) :
    LocallyBoundedVariationOn f s :=
  hf.locallyBoundedVariationOn

/-- **反单调 ⟹ 局部有界变差**：`AntitoneOn` 情形由序对偶 `αᵒᵈ` 归约到单调情形
（Mathlib 只提供 `MonotoneOn` 版本，这里补上 `AntitoneOn` 版本）。
> **Entry**: real-analysis.bounded-variation
-/
theorem antitoneOn_locallyBoundedVariationOn {f : α → ℝ} {s : Set α} (hf : AntitoneOn f s) :
    LocallyBoundedVariationOn f s := by
  have h : MonotoneOn (f ∘ OrderDual.ofDual) (OrderDual.ofDual ⁻¹' s) :=
    fun a ha b hb hab => hf hb ha hab
  simpa using (h.locallyBoundedVariationOn).ofDual

/-- **单调 ⟹ 有界变差（闭区间上，教材强度）**：`f` 在 `uIcc a b` 上单调不减，则它在 `uIcc a b` 上
有界变差。取 `x = min a b`、`y = max a b`，用 `LocallyBoundedVariationOn` 在该子区间上的有限性，
并注意 `uIcc a b ∩ Icc (min a b) (max a b) = uIcc a b`。
> **Entry**: real-analysis.bounded-variation
-/
theorem monotoneOn_boundedVariationOn_uIcc {f : ℝ → ℝ} {a b : ℝ} (hf : MonotoneOn f (uIcc a b)) :
    BoundedVariationOn f (uIcc a b) := by
  have h := hf.locallyBoundedVariationOn (min a b) (max a b)
    (left_mem_Icc.mpr min_le_max) (right_mem_Icc.mpr min_le_max)
  simpa [Set.Icc_min_max] using h

/-- **反单调 ⟹ 有界变差（闭区间上）**。
> **Entry**: real-analysis.bounded-variation
-/
theorem antitoneOn_boundedVariationOn_uIcc {f : ℝ → ℝ} {a b : ℝ} (hf : AntitoneOn f (uIcc a b)) :
    BoundedVariationOn f (uIcc a b) := by
  have h := (antitoneOn_locallyBoundedVariationOn hf) (min a b) (max a b)
    (left_mem_Icc.mpr min_le_max) (right_mem_Icc.mpr min_le_max)
  simpa [Set.Icc_min_max] using h

/-- **单调且有界 ⟹ 有界变差**：`|f x| ≤ C`（`x ∈ s`）时，`s` 上的全变差不超过 `2C`。
> **Entry**: real-analysis.bounded-variation
-/
theorem monotoneOn_boundedVariationOn_of_abs_le {f : α → ℝ} {s : Set α} {C : ℝ}
    (hf : MonotoneOn f s) (hC : ∀ x ∈ s, |f x| ≤ C) : BoundedVariationOn f s :=
  hf.boundedVariationOn hC

/-! ## 6. 有界变差的两个直接推论 -/

/-- **BV ⟹ 函数值差被全变差控制**：`dist (f x) (f y) ≤ (eVariationOn f s).toReal`（`x, y ∈ s`）。
这是“有界变差函数有界振幅”的定量形式。
> **Entry**: real-analysis.bounded-variation
-/
theorem boundedVariationOn_dist_le {E : Type*} [PseudoMetricSpace E] {f : α → E} {s : Set α}
    (h : BoundedVariationOn f s) {x y : α} (hx : x ∈ s) (hy : y ∈ s) :
    dist (f x) (f y) ≤ (eVariationOn f s).toReal :=
  h.dist_le hx hy

/-- **BV ⟹ 实值函数增量被全变差控制**：`f x - f y ≤ (eVariationOn f s).toReal`。
> **Entry**: real-analysis.bounded-variation
-/
theorem boundedVariationOn_sub_le {f : α → ℝ} {s : Set α} (h : BoundedVariationOn f s)
    {x y : α} (hx : x ∈ s) (hy : y ∈ s) :
    f x - f y ≤ (eVariationOn f s).toReal :=
  h.sub_le hx hy

/-- **有限集上的变差自动有限**：`s` 为有限集时 `eVariationOn f s` 有限。教材中用于说明
“变差只可能被无限多个分点撑大”。
> **Entry**: real-analysis.bounded-variation
-/
theorem boundedVariationOn_of_finite {E : Type*} [PseudoMetricSpace E] (f : α → E) (s : Set α)
    [Finite s] : BoundedVariationOn f s :=
  BoundedVariationOn.of_finite f s

end RealAnalysis.BoundedVariation

end SandronesLibrary
