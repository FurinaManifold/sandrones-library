---
id: real-analysis.bounded-variation
family: real-analysis.bounded-variation
variant: tao
kind: theorem
state: verified
title: 有界变差与 Jordan 分解
summary: 有界变差的教材定义（变差 = 分割加和的上确界）、全变差函数 V_f 的基本性质、Jordan 分解「BV = 增 − 增」（Folland §3.5 Theorem 3.27 的教材强度内容）以及 BV ⟹ 几乎处处可导的接口
premises: [real-analysis.measure.def, real-analysis.signed-measure.variation]
mathlib: [eVariationOn, BoundedVariationOn, LocallyBoundedVariationOn, eVariationOn.eVariationOn_eq_strictMonoOn, eVariationOn.eq_biSup_inter_Icc, variationOnFromTo, variationOnFromTo.add, variationOnFromTo.monotoneOn, variationOnFromTo.antitoneOn, variationOnFromTo.self, variationOnFromTo.abs_sub_le_sub_of_le, LocallyBoundedVariationOn.exists_monotoneOn_sub_monotoneOn', LocallyBoundedVariationOn.exists_monotoneOn_sub_monotoneOn, BoundedVariationOn.ae_differentiableAt_of_mem_uIcc, LocallyBoundedVariationOn.ae_differentiableAt, MonotoneOn.eVariationOn_eq, MonotoneOn.locallyBoundedVariationOn, MonotoneOn.boundedVariationOn, LocallyBoundedVariationOn.ofDual, BoundedVariationOn.dist_le, BoundedVariationOn.sub_le, BoundedVariationOn.of_finite, BoundedVariationOn.mono, Set.Icc_min_max]
provenance:
  source_type: book
  ref: "folland-real-analysis-1999"
---

# real-analysis.bounded-variation

- **家族**: `real-analysis.bounded-variation`
- **变体**: tao
- **状态**: verified
- **一句话**: 全变差 `T_F` 是分割加和的上确界；`T_F` 有限（“有界变差”）当且仅当 `F` 可以写成
  两个单调不减函数之差（Jordan 分解，Folland §3.5 Theorem 3.27），而这条分解又给出
  “有界变差 ⟹ 几乎处处可导”的入口。

## 直觉

单调函数是最“规矩”的函数：它只朝一个方向走，所以在任何区间上的总位移就是终点减起点。
**有界变差**放宽的正是这一点：函数可以来回振荡，只要振荡的**总路程**有限。Folland §3.5 把
`[a,b]` 上的总路程写成

```text
T_F(a,b) = sup { ∑ᵢ |F(xᵢ) - F(xᵢ₋₁)| : a = x₀ < x₁ < ⋯ < xₙ = b }
```

上确界取遍 `[a,b]` 的所有有限分割。这样定义出来的量对振荡次数不敏感、只对“总振幅”敏感，
因此比“单调”宽得多，又比“连续”强得多（连续函数可以有无限变差，例如
`x ↦ x sin(1/x)` 在 `[0,1]` 上）。

Jordan 分解回答的问题是：**有界变差究竟比单调宽多少？** 答案是“宽一个减法”：
`F` 有界变差 ⟺ `F = p - q`，`p, q` 都单调不减。直观上把 `F` 的上行运动累进 `p`、
下行运动累进 `q`，两者的增量之和恰好复原总路程。这条分解把变差论的大部分问题
（可导性、可积性、极限交换）一次性化归到单调函数——而单调函数的理论（同批
`real-analysis.monotone-function`）已经由 Vitali 覆盖定理处理得很干净。本条目正是这条
化归的入口，也是 RA-F5 中 `real-analysis.absolute-continuity-function` 的直接前置：
AC ⟹ BV，再套本条的 a.e. 可导接口。

## 陈述（教材记号）

设 `F : ℝ → ℝ`，`a < b`。

1. **定义（Folland §3.5）**：`T_F(a,b) = sup_P ∑ᵢ |F(xᵢ) - F(xᵢ₋₁)|`，`P` 取遍 `[a,b]` 的有限分割。
   当 `T_F(a,b) < ∞` 时称 `F` 在 `[a,b]` 上**有界变差**，记 `F ∈ BV[a,b]`。
2. **全变差函数**：固定起点 `a`，`x ↦ T_F(a,x)` 单调不减；固定终点 `b`，`x ↦ T_F(x,b)` 单调不增；
   `T_F(x,x) = 0`。
3. **区间加性**：`T_F(a,b) + T_F(b,c) = T_F(a,c)`。
4. **增量被变差控制**：`|F(y) - F(x)| ≤ T_F(x,y)`；更一般地
   `|F(y) - F(x)| ≤ T_F(a,y) - T_F(a,x)`（`x ≤ y`）。
5. **Jordan 分解（Theorem 3.27）**：`F` 在 `[a,b]` 上有界变差 ⟺ 存在单调不减的 `p, q` 使
   `F = p - q`。更强的定量形式是
   `(p(y) - p(x)) + (q(y) - q(x)) = T_F(x,y)`——两个单调函数的增量之和恰是全变差。
6. **单调 ⟹ BV**：`F` 单调（增或减）⟹ `F` 在 `[a,b]` 上有界变差；并且
   `T_F(a,b) = |F(b) - F(a)|`（单调时上确界被端点取到）。
7. **BV ⟹ 几乎处处可导**：`F` 有界变差 ⟹ `F` 在 `[a,b]` 上关于 Lebesgue 测度**几乎处处**可导。
   **这是 a.e. 结论，不是逐点结论。**

## 本库 Lean 承载

四类归属如下。

- **正式公开承载**：
  - `eVariationOn f s : ℝ≥0∞`——集合 `s` 上的全变差。取 `ℝ≥0∞` 值是为了让“变差为无穷”
    成为一个正常的取值，从而不必在定义里预先假设有限性；教材里的 `T_F` 就是它在
    `s = Icc a b` 且有限时的 `toReal`。
  - `BoundedVariationOn f s : Prop`——`eVariationOn f s ≠ ∞`，即“有界变差”。
  - `LocallyBoundedVariationOn f s : Prop`——对任意 `a, b ∈ s`，`f` 在 `s ∩ Icc a b` 上有界变差。
    这是“在 `s` 的每个紧子区间上有界变差”，也是 Jordan 分解在 Mathlib 中的自然假设。
  - `variationOnFromTo f s a b : ℝ`——全变差函数 `V_f(a,b)`，教材的实值 `T_F`。
- **教材量词展开**（本库命名）：
  - `eVariationOn_eq_sup_over_partitions`：`eVariationOn f s` = 严格单调序列上的上确界
    `⨆ p, ∑ i ∈ Finset.range p.1, edist (f (p.2.1 (i+1))) (f (p.2.1 i))`。这就是教材的
    “分割加和的上确界”，其中分割被编码成 `ℕ → α` 上的 `StrictMonoOn` 序列。
  - `eVariationOn_eq_biSup_inter_Icc`：`eVariationOn f s` 也是所有 `s` 中端点 `x ≤ y` 上
    `eVariationOn f (s ∩ Icc x y)` 的上确界。
  - `boundedVariationOn_iff_variation_ne_top` / `boundedVariationOn_iff_variation_lt_top`：
    “有界变差 ⟺ 全变差有限”的两种写法（后者给出 `ℝ` 值形式的依据）。
- **桥**：
  - `boundedVariationOn_ae_differentiableAt_uIcc` / `locallyBoundedVariationOn_ae_differentiableAt`：
    BV ⟹ a.e. 可导。它们把 Mathlib 的结论接到本库的教材陈述上；a.e. 所依赖的测度是
    `volume`，结论形式是 `∀ᵐ x, …`。
- **私有证明后端**（语义一致但未作为课程概念单独引入）：
  - `LocallyBoundedVariationOn.exists_monotoneOn_sub_monotoneOn'` / `..._sub_monotoneOn`（Jordan 分解）、
    `MonotoneOn.eVariationOn_eq` / `MonotoneOn.locallyBoundedVariationOn` / `MonotoneOn.boundedVariationOn`
    （单调 ⟹ BV）、`variationOnFromTo.add` 等 `variationOnFromTo` 系列、
    `BoundedVariationOn.dist_le` / `.sub_le` / `.of_finite` / `.mono`、
    `LocallyBoundedVariationOn.ofDual`（反单调情形的序对偶归约）。

## Lean 对照

以下签名逐字来自 `SandronesLibrary/RealAnalysis/BoundedVariation.lean`
（`α` 为线性序、`E` 为伪 EMetric 空间；命名空间 `SandronesLibrary.RealAnalysis.BoundedVariation`）：

```lean
theorem eVariationOn_eq_sup_over_partitions (f : α → E) (s : Set α) :
    eVariationOn f s =
      ⨆ p : (n : ℕ) × { u : ℕ → α // StrictMonoOn u (Iic n) ∧ ∀ i ∈ Iic n, u i ∈ s },
        ∑ i ∈ Finset.range p.1, edist (f (p.2.1 (i + 1))) (f (p.2.1 i))

theorem eVariationOn_eq_biSup_inter_Icc {f : α → E} {s : Set α} :
    eVariationOn f s = ⨆ p ∈ {p : α × α | p.1 ∈ s ∧ p.2 ∈ s ∧ p.1 ≤ p.2},
      eVariationOn f (s ∩ Icc p.1 p.2)

theorem boundedVariationOn_iff_variation_ne_top {f : α → E} {s : Set α} :
    BoundedVariationOn f s ↔ eVariationOn f s ≠ ∞

theorem boundedVariationOn_iff_variation_lt_top {f : α → E} {s : Set α} :
    BoundedVariationOn f s ↔ eVariationOn f s < ∞

theorem variationOnFromTo_add {f : α → E} {s : Set α} {a b c : α}
    (h : LocallyBoundedVariationOn f s) (ha : a ∈ s) (hb : b ∈ s) (hc : c ∈ s) :
    variationOnFromTo f s a b + variationOnFromTo f s b c = variationOnFromTo f s a c

theorem variationOnFromTo_monotoneOn {f : α → E} {s : Set α} {a : α}
    (h : LocallyBoundedVariationOn f s) (ha : a ∈ s) :
    MonotoneOn (variationOnFromTo f s a) s

theorem variationOnFromTo_antitoneOn {f : α → E} {s : Set α} {b : α}
    (h : LocallyBoundedVariationOn f s) (hb : b ∈ s) :
    AntitoneOn (fun a => variationOnFromTo f s a b) s

theorem variationOnFromTo_self (f : α → E) (s : Set α) (a : α) :
    variationOnFromTo f s a a = 0

theorem abs_sub_le_variationOnFromTo {f : α → ℝ} {s : Set α} {x y : α}
    (h : LocallyBoundedVariationOn f s) (hx : x ∈ s) (hy : y ∈ s) (hxy : x ≤ y) :
    |f y - f x| ≤ variationOnFromTo f s x y

theorem abs_sub_le_variationOnFromTo_sub {f : α → ℝ} {s : Set α} {a b c : α}
    (h : LocallyBoundedVariationOn f s) (ha : a ∈ s) (hb : b ∈ s) (hc : c ∈ s) (hbc : b ≤ c) :
    |f c - f b| ≤ variationOnFromTo f s a c - variationOnFromTo f s a b

theorem locallyBoundedVariationOn_of_boundedVariationOn {f : α → E} {s : Set α}
    (h : BoundedVariationOn f s) : LocallyBoundedVariationOn f s

theorem exists_monotoneOn_sub_monotoneOn_variation {f : α → ℝ} {s : Set α}
    (h : LocallyBoundedVariationOn f s) :
    ∃ p q : α → ℝ, MonotoneOn p s ∧ MonotoneOn q s ∧ f = p - q ∧
      ∀ x ∈ s, ∀ y ∈ s, p y - p x + (q y - q x) = variationOnFromTo f s x y

theorem exists_monotoneOn_sub_monotoneOn {f : α → ℝ} {s : Set α}
    (h : LocallyBoundedVariationOn f s) :
    ∃ p q : α → ℝ, MonotoneOn p s ∧ MonotoneOn q s ∧ f = p - q

theorem boundedVariationOn_exists_monotoneOn_sub_monotoneOn_uIcc {f : ℝ → ℝ} {a b : ℝ}
    (h : BoundedVariationOn f (uIcc a b)) :
    ∃ p q : ℝ → ℝ, MonotoneOn p (uIcc a b) ∧ MonotoneOn q (uIcc a b) ∧ f = p - q

theorem boundedVariationOn_ae_differentiableAt_uIcc {V : Type*} [NormedAddCommGroup V]
    [NormedSpace ℝ V] [FiniteDimensional ℝ V] {f : ℝ → V} {a b : ℝ}
    (h : BoundedVariationOn f (uIcc a b)) :
    ∀ᵐ x : ℝ, x ∈ uIcc a b → DifferentiableAt ℝ f x

theorem monotoneOn_eVariationOn_eq {f : α → ℝ} {s : Set α} {a b : α} (hf : MonotoneOn f s)
    (ha : a ∈ s) (hb : b ∈ s) :
    eVariationOn f (s ∩ Icc a b) = ENNReal.ofReal (f b - f a)

theorem monotoneOn_locallyBoundedVariationOn {f : α → ℝ} {s : Set α} (hf : MonotoneOn f s) :
    LocallyBoundedVariationOn f s

theorem antitoneOn_locallyBoundedVariationOn {f : α → ℝ} {s : Set α} (hf : AntitoneOn f s) :
    LocallyBoundedVariationOn f s

theorem monotoneOn_boundedVariationOn_uIcc {f : ℝ → ℝ} {a b : ℝ}
    (hf : MonotoneOn f (uIcc a b)) : BoundedVariationOn f (uIcc a b)

theorem antitoneOn_boundedVariationOn_uIcc {f : ℝ → ℝ} {a b : ℝ}
    (hf : AntitoneOn f (uIcc a b)) : BoundedVariationOn f (uIcc a b)

theorem monotoneOn_boundedVariationOn_of_abs_le {f : α → ℝ} {s : Set α} {C : ℝ}
    (hf : MonotoneOn f s) (hC : ∀ x ∈ s, |f x| ≤ C) : BoundedVariationOn f s

theorem boundedVariationOn_dist_le {E : Type*} [PseudoMetricSpace E] {f : α → E} {s : Set α}
    (h : BoundedVariationOn f s) {x y : α} (hx : x ∈ s) (hy : y ∈ s) :
    dist (f x) (f y) ≤ (eVariationOn f s).toReal

theorem boundedVariationOn_sub_le {f : α → ℝ} {s : Set α} (h : BoundedVariationOn f s)
    {x y : α} (hx : x ∈ s) (hy : y ∈ s) :
    f x - f y ≤ (eVariationOn f s).toReal

theorem boundedVariationOn_of_finite {E : Type*} [PseudoMetricSpace E] (f : α → E) (s : Set α)
    [Finite s] : BoundedVariationOn f s
```

## 证明思路

- **量词展开**：`eVariationOn` 的定义体本身就是“对 `ℕ × {u // Monotone u ∧ u 落在 s}` 取上确界”，
  而 `eVariationOn.eVariationOn_eq_strictMonoOn` 证明可以换成严格单调序列而不改变上确界；
  两者都是 `Iff.rfl` 或一次转述，故本库只做命名与叙述。
- **全变差函数的性质**：`variationOnFromTo` 在 `a ≤ b` 时是 `(eVariationOn f (s ∩ Icc a b)).toReal`、
  否则取负号；可加性来自 `eVariationOn.Icc_add_Icc`（把 `[a,c]` 切成 `[a,b] ∪ [b,c]`，
  再对不交并取加性），单调性来自 `eVariationOn.mono`，`V(x,x) = 0` 来自空区间变差为零。
- **`|f y - f x| ≤ V(x,y)`**：从相对形式
  `|f c - f b| ≤ V(a,c) - V(a,b)` 取 `a = b = x`、`c = y`，再用 `V(x,x) = 0` 消去。
  相对形式本身是“把 `[a,c]` 上的分割先走 `[a,b]` 再走 `[b,c]`”的直接推论。
- **Jordan 分解**：本库直接引用 Mathlib 的 `exists_monotoneOn_sub_monotoneOn'`（及其弱化版）。
  该证明的骨架是：把 `p` 取成“上行累计”、`q` 取成“下行累计”，用变差的可加性证明两者单调，
  并用 `(p y - p x) + (q y - q x) = V(x,y)` 把增量之和钉成全变差。本库在此之上补了
  `boundedVariationOn ⟹ locallyBoundedVariationOn`，从而把教材的“`[a,b]` 上有界变差”假设
  接到 Mathlib 的“局部有界变差”假设上，得到 `uIcc a b` 上的教材定理。
- **单调 ⟹ BV**：核心是 telescoping
  `∑ᵢ (f(xᵢ₊₁) - f(xᵢ)) = f(b) - f(a)`，且单调时每一项非负，故分割加和被端点增量控制；
  上确界因此恰为 `f(b) - f(a)`（`MonotoneOn.eVariationOn_eq`）。区间形式取
  `x = min a b`、`y = max a b`，用 `uIcc a b ∩ Icc (min a b) (max a b) = uIcc a b` 化简。
  反单调情形用序对偶 `αᵒᵈ` 归约到单调情形（Mathlib 未直接提供 `AntitoneOn` 版本）。
- **BV ⟹ a.e. 可导**：本库只做接口转述，不重证。证明本身依赖覆盖论证（RA-F3 的
  `real-analysis.covering-lemma`）与单调函数的 a.e. 可导性（同批 `real-analysis.monotone-function`），
  最终结论是 `∀ᵐ x, x ∈ uIcc a b → DifferentiableAt ℝ f x`。

## 依赖（人话版）

- **库内前提**：
  - `real-analysis.measure.def`：全变差的 a.e. 结论要对 `volume` 陈述，测度与 a.e. 的语言由此提供。
  - `real-analysis.signed-measure.variation`：同一个“变差 = sup over partitions”模式先在有符号
    测度上出现过（`|ν|(E) = sup ∑ |ν(Eᵢ)|`）；本条目是它在函数侧的同构对应，两条 Entry 共享
    “分割上确界”这一量词母题。
- **Mathlib**：`eVariationOn` / `BoundedVariationOn` / `LocallyBoundedVariationOn` /
  `variationOnFromTo` 为正式承载；`eVariationOn.eVariationOn_eq_strictMonoOn`、
  `eVariationOn.eq_biSup_inter_Icc` 为量词展开；
  `LocallyBoundedVariationOn.exists_monotoneOn_sub_monotoneOn'`、
  `MonotoneOn.eVariationOn_eq`、`MonotoneOn.locallyBoundedVariationOn` 为私有证明后端；
  `BoundedVariationOn.ae_differentiableAt_of_mem_uIcc` 为桥。

## 应用与陷阱

- **a.e. 不是逐点**：`boundedVariationOn_ae_differentiableAt_uIcc` 的结论是
  `∀ᵐ x, x ∈ uIcc a b → DifferentiableAt ℝ f x`。零测例外集可以非空——事实上
  Cantor 函数在 Cantor 集（零测）上不可导，而它是有界变差的。自然语言叙述中不得把它写成
  “处处可导”。
- **`BoundedVariationOn` 与 `LocallyBoundedVariationOn` 不是同一个东西**：前者要求整个 `s` 上
  变差有限，后者只要求每个 `s ∩ [a,b]` 上有限。在 `s = uIcc a b` 这类紧区间上两者等价
  （本库给出 `locallyBoundedVariationOn_of_boundedVariationOn` 这一方向），但在无界集合上
  区别实质存在：`f = id` 在 `univ` 上局部有界变差，却不是 `BoundedVariationOn`。
- **`ℝ≥0∞` 值 vs `ℝ` 值**：`eVariationOn` 取 `ℝ≥0∞`，`variationOnFromTo` 取 `ℝ`。后者的定义
  在 `a > b` 时取 `-(eVariationOn f (s ∩ Icc b a)).toReal`（带符号），所以引用
  `variationOnFromTo` 的可加性/单调性时必须带 `LocallyBoundedVariationOn` 假设，
  否则 `toReal` 会在 `∞` 处退化成 `0` 而结论失真。
- **Jordan 分解不唯一**：`p, q` 可以同时加上同一个单调函数。本库的加强版只保证“增量之和
  等于全变差”，不声称分解唯一；教材用的规范选取是 `p = (T_F + F)/2`、`q = (T_F - F)/2`，
  本条目不交付这一具体公式（Mathlib 的存在性证明不显式给出它）。
- **边界**：本条目不含 FTC 的 a.e. 版本（RA-F6），也不含 Lebesgue 微分定理本身（RA-F4）。
  BV ⟹ a.e. 可导在这里是**接口**，其证明骨架不在本文件内。
