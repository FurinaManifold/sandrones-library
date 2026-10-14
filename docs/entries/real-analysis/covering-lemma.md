---
id: real-analysis.covering-lemma
family: real-analysis.covering
variant: tao
kind: theorem
state: verified
title: 一维 Vitali 覆盖引理
summary: ℝ 上开区间族的 τ-放大不交子族（τ > 3）、其测度形式，以及 Mathlib VitaliFamily 抽象覆盖接口的桥
premises: [real-analysis.measure.def, real-analysis.measure.sigma-algebra]
mathlib: [Vitali.exists_disjoint_subfamily_covering_enlargement_ball, Set.PairwiseDisjoint.countable_of_nonempty_interior, MeasureTheory.measure_iUnion_le, MeasureTheory.measure_biUnion, MeasureTheory.lintegral_iUnion, Real.volume_Ioo, Real.volume_ball, ENNReal.ofReal_mul, IsUnifLocDoublingMeasure.vitaliFamily, VitaliFamily.FineSubfamilyOn.measure_le_tsum, VitaliFamily.measure_le_of_frequently_le]
provenance:
  source_type: book
  ref: "folland-real-analysis-1999"
---

# real-analysis.covering-lemma

- **家族**: `real-analysis.covering`
- **变体**: tao
- **状态**: verified
- **一句话**: 半径一致有界的开区间族中总能抽出两两不交的子族，使原族每个区间都落在选中
  区间的 `τ`-放大（`τ > 3`）之内；于是原并集的 Lebesgue 测度被 `τ` 倍的不交子族总测度控制。
  这条引理是 Hardy–Littlewood 极大函数弱型 `(1,1)` 估计的前置。

## 直觉

覆盖引理回答的问题是："一族互相重叠的区间，能不能挑出一部分两两不交的，让它们的'放大版'
仍然盖住原来那族？"答案是可以，而且放大倍数只需一个绝对常数。它的用途是**把重叠信息换成
不交信息**：重叠的区间无法直接相加测度，一旦抽出不交子族，测度就可以逐项相加（或换成积分
逐项相加），"坏集有多大" 立刻变成一个可计算的级数。

Folland《Real Analysis》第二版 §3.4 用这条引理（他称作 simple Vitali lemma）把极大函数的
分布函数 `m({Hf > α})` 压到 `‖f‖₁/α` 的量级；本库的 `real-analysis.maximal-function` 正是
它的第一个使用者。引理本身不依赖 `f` 的任何正则性，只需要区间半径一致有界——而在弱型估计里
"半径有界"恰恰来自 `f ∈ L¹`。

## 陈述（教材记号）

设 `{I_a}_{a ∈ t}` 是 ℝ 上的一族开区间，且存在常数 `R` 使每个区间的半长（半径）都 `≤ R`。
任取 `τ > 3`。则存在子族 `u ⊆ t`，满足

1. **不交**：`u` 中任意两个区间不相交；
2. **放大覆盖**：`t` 中每个区间 `I_a` 都包含在某个 `I_b`（`b ∈ u`）的 `τ`-放大之内，即
   `I_a ⊆ B(c_b, τ·r_b)`，其中 `c_b`、`r_b` 是 `I_b` 的中点与半长。

**测度形式**：在上面的不交子族与放大覆盖之下，
`m(⋃_{a ∈ t} I_a) ≤ τ · Σ_{b ∈ u} m(I_b)`。
（`u` 至多可数：可分空间中两两不交的非空开集族至多可数，所以右边的级数有意义。）

**常数口径（重要）**：Folland 在 ℝⁿ 上用球陈述、放大常数取 `3ⁿ`。本库在 ℝ 上用开区间陈述，
走 Mathlib `Vitali.exists_disjoint_subfamily_covering_enlargement_ball` 的 `τ > 3` 口径，
下游 `real-analysis.maximal-function` 取 `τ = 4`，故其弱型不等式右端系数是 `4` 而不是 `3`。
**本库不声称复刻 Folland 的常数。**

## 本库 Lean 承载

- **区间的正式承载**：本库 `SandronesLibrary.RealAnalysis.Covering.OpenInterval`，字段
  `l u : ℝ` 与 `lt : l < u`。教材里 "含某点的开区间" 是一个量词域，`OpenInterval` 就是这个
  量词域的具体承载；`OpenInterval.toSet` 给出对应集合 `(l, u)`。
- **几何换算**：`OpenInterval.center`（中点）、`OpenInterval.radius`（半长）、
  `OpenInterval.ball_center_radius : ball I.center I.radius = I.toSet`。最后一条是本文件把
  "区间族" 交给 Mathlib **球族**覆盖定理的桥：区间与开球在 ℝ 上逐字相同。
- **主引理**：`exists_disjoint_interval_subfamily_covering_enlargement`。
- **测度形式**：`volume_iUnion_le_mul_tsum`。
- **抽象覆盖接口的桥**：`vitaliFamilyVolume`（`volume` 上的 `VitaliFamily`）、
  `measure_le_of_frequently_le_vitali`、`fineSubfamilyOn_measure_le_tsum`。这三条把覆盖引理
  "几乎处处不交覆盖" 的一面暴露出来，供 RA-F4（Lebesgue 点与微分定理）使用；
  **本窗不交付 Lebesgue 微分定理**。

### 公开签名中的 Mathlib 对象四类归属

| Mathlib 名 | 归属 | 说明 |
|---|---|---|
| `Vitali.exists_disjoint_subfamily_covering_enlargement_ball` | **私有证明后端** | 主引理的证明引擎（Zorn 式抽象覆盖定理），本库只做区间↔球的换算，不重证组合核心 |
| `Set.PairwiseDisjoint.countable_of_nonempty_interior` | **私有证明后端** | 测度形式中 `u` 至多可数 |
| `MeasureTheory.measure_iUnion_le`、`MeasureTheory.measure_biUnion`、`MeasureTheory.lintegral_iUnion` | **私有证明后端** | 测度／积分的可数可加 |
| `IsUnifLocDoublingMeasure.vitaliFamily` | **桥侧接口**（构造后端） | `volume` 上 Vitali 族的构造 |
| `VitaliFamily`、`VitaliFamily.FineSubfamilyOn.measure_le_tsum`、`VitaliFamily.measure_le_of_frequently_le` | **桥侧接口** | 覆盖引理 a.e. 一面的通道，供 RA-F4 |

没有超出课程层级的公开泄漏：`OpenInterval` 是本库自有的初等载体，公开签名里其余对象都是
测度论课程本身的概念。

## Lean 对照

教材 "区间 = 以中点为心、半长为半径的开球" 在 Lean 里是

```lean
theorem OpenInterval.ball_center_radius (I : OpenInterval) :
    ball I.center I.radius = I.toSet
```

主引理与教材逐字对应：

```lean
theorem exists_disjoint_interval_subfamily_covering_enlargement
    (t : Set ι) (I : ι → OpenInterval) (R : ℝ) (hR : ∀ a ∈ t, (I a).radius ≤ R)
    {τ : ℝ} (hτ : 3 < τ) :
    ∃ u ⊆ t, u.PairwiseDisjoint (fun a => (I a).toSet) ∧
      ∀ a ∈ t, ∃ b ∈ u, (I a).toSet ⊆ ball (I b).center (τ * (I b).radius)
```

`hR` 就是教材的 "半径一致有界"，`hτ` 就是 "`τ > 3`"，结论的两支分别对应 "不交" 与 "放大覆盖"。
测度形式：

```lean
theorem volume_iUnion_le_mul_tsum
    (t : Set ι) (I : ι → OpenInterval) (u : Set ι) (_hut : u ⊆ t)
    (hdisj : u.PairwiseDisjoint fun a => (I a).toSet)
    (hcov : ∀ a ∈ t, ∃ b ∈ u, (I a).toSet ⊆ ball (I b).center (τ * (I b).radius))
    (hτ : 0 ≤ τ) :
    volume (⋃ a ∈ t, (I a).toSet) ≤ ENNReal.ofReal τ * ∑' b : u, volume ((I b).toSet)
```

## 证明思路

1. 把每个区间 `I_a` 换成开球 `ball (I a).center (I a).radius`；由 `ball_center_radius` 二者
   相等，半径有界性原样搬运。
2. 对球族套 Mathlib 的 `Vitali.exists_disjoint_subfamily_covering_enlargement_ball`（其证明是
   Zorn 式的：取极大的 "好" 不交族，若还有元素不与它相交，就能再塞一个进去，矛盾）。它给出
   不交子族 `u` 与 `τ`-放大覆盖。
3. 把球换回区间，得主引理。
4. 测度形式：`⋃_{a ∈ t} I_a ⊆ ⋃_{b ∈ u} ball(c_b, τ r_b)`（放大覆盖），故
   `m(⋃_{a∈t} I_a) ≤ m(⋃_{b∈u} ball(c_b, τ r_b)) ≤ Σ_{b∈u} m(ball(c_b, τ r_b))`
   （可数次可加）；再用 `m(ball(c, τr)) = τ · m(ball(c,r)) = τ · m(I_b)` 与 `u` 至多可数
   （不交非空开集族在可分空间中至多可数）把级数写成 `τ · Σ_{b∈u} m(I_b)`。

## 依赖（人话版）

- **库内前提**：`real-analysis.measure.def`（测度的可数可加性／单调性）、
  `real-analysis.measure.sigma-algebra`（可测集运算）。测度形式用到可数次可加与区间可测。
- **下游使用者**：`real-analysis.maximal-function`（Hardy–Littlewood 极大函数弱型 `(1,1)`
  估计的坏集控制）；`real-analysis.covering-lemma` 是 RA-F3 的**冻结前置**。
- **预留接口**：RA-F4（Lebesgue 点与微分定理）会用 `vitaliFamilyVolume` 与
  `measure_le_of_frequently_le_vitali`，但本窗不交付该定理。
- **数学库后端**：`Vitali.exists_disjoint_subfamily_covering_enlargement_ball` 等（见上表）。

## 应用与陷阱

- **放大常数不是 3**：本库口径是任意 `τ > 3`（下游取 `τ = 4`）。把 `τ` 写成 `3` 会直接
  编译失败（`hτ : 3 < τ` 无法满足），也不要在文档里声称得到了 Folland 的 `3ⁿ`。
- **半径必须有界**：`hR` 是引理的本质假设。在极大函数的应用里它不是免费的，而是由
  `f ∈ L¹` 推出（`∫_I |f| > c·|I|` 蕴含 `|I| < ‖f‖₁/c`）；没有 `L¹` 就没有一致有界半径。
- **`u` 的可数性来自拓扑**：不是从覆盖引理本身来的，而是 "两两不交的非空开集族在可分空间中
  至多可数"。写测度形式时这一步不能省，否则 `tsum` 无意义。
- **`⋃ b ∈ u` 与 `⋃ b : u`**：Lean 里两者靠 `Set.iUnion_subtype` 换算，`tsum` 的指标是子类型
  `u`，混用会导致类型不匹配。
- **不要把 a.e. 覆盖说成逐点覆盖**：`VitaliFamily.covering` 的结论是
  `μ (s \ ⋃ p ∈ t, p.2) = 0`，即**几乎处处**覆盖；本文件只暴露接口，不在此处交付任何 a.e.
  微分定理。
