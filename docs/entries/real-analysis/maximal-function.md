---
id: real-analysis.maximal-function
family: real-analysis.maximal
variant: tao
kind: theorem
state: verified
title: Hardy–Littlewood 极大函数与弱型 (1,1) 估计
summary: ℝ 上非中心极大函数的教材定义、对任意 f 的开集原像／下半连续／Borel 可测性、弱型 (1,1) 测度估计（常数 4）以及通向 Lebesgue 微分定理的坏集控制骨架
premises: [real-analysis.measure.def, real-analysis.measure.lintegral]
mathlib: [MeasureTheory.lintegral, ENNReal, lt_iSup_iff, ENNReal.ofReal, ENNReal.ofReal_le_ofReal, lintegral_mono, lintegral_mono_set, lintegral_congr_ae, lintegral_iUnion, lintegral_const, MeasureTheory.Integrable.lintegral_lt_top, Integrable.abs, ENNReal.tsum_mul_left, ENNReal.tsum_le_tsum, ENNReal.lt_div_iff_mul_lt, ENNReal.div_eq_inv_mul, ENNReal.div_mul_cancel, ENNReal.inv_mul_cancel, ENNReal.mul_lt_mul_right, ENNReal.toReal_mul, ENNReal.toReal_lt_toReal, ENNReal.coe_toReal, ENNReal.toReal_ofReal, ENNReal.ofReal_ne_zero_iff, ENNReal.ofReal_ne_top, ENNReal.coe_ne_top, ENNReal.coe_eq_zero, ENNReal.mul_ne_top, ENNReal.inv_ne_zero, ENNReal.inv_ne_top, Real.volume_Ioo, Measure.restrict_apply_univ, Measure.restrict_le_self, MeasureTheory.measure_mono, Set.PairwiseDisjoint.countable_of_nonempty_interior, Set.mem_iUnion₂, measurable_of_Ioi, LowerSemicontinuous, lowerSemicontinuous_iff_isOpen_preimage, Measurable.aemeasurable, MeasureTheory.ae_mono, Filter.EventuallyEq.filter_mono, IsOpen.measurableSet, isOpen_iUnion, div_lt_div_of_pos_right, div_eq_div_iff, abs_of_nonneg, le_abs_self]
provenance:
  source_type: book
  ref: "folland-real-analysis-1999"
---

# real-analysis.maximal-function

- **家族**: `real-analysis.maximal`
- **变体**: tao
- **状态**: verified
- **一句话**: 对含 `x` 的开区间取平均 `(1/|I|)∫_I |f|` 的上确界 `Hf(x)`，其水平集
  `{c < Hf}` 对**任意**（不必可测的）`f` 都是开集，从而 `Hf` 下半连续、Borel 可测；
  并且 `f ∈ L¹` 时坏集满足**测度不等式** `|{Hf > c}| ≤ 4·c⁻¹·∫|f|`（弱型 `(1,1)`，常数 4）。

## 直觉

极大函数要回答的问题是："函数 `f` 在点 `x` 附近到底有多大？"单点取值 `f(x)` 对 `L¹` 函数
没有意义（可以随便改一个点而不改变积分），于是教材改用**含 `x` 的区间上的平均**；再把所有
含 `x` 的区间取上确界，就得到与 `f` 的 a.e. 类相容的"局部大小" `Hf(x)`。

这条定义是整个测度微分理论的枢纽。Folland《Real Analysis》第二版 §3.4 用它把
"`f` 的平均在 `x` 处收敛到 `f(x)`"（Lebesgue 微分定理，Theorem 3.21）化归为对极大函数的
估计：先用连续函数（或简单函数）证 a.e. 收敛，再用**弱型 `(1,1)` 估计**把差函数的坏集
`{H(f-g) > ε}` 压到 `O(‖f-g‖₁)`，最后用连续／简单函数在 `L¹` 中的稠密性取极限。本 Entry
交付的正是这条路线中除"a.e. 收敛"以外的全部环节：**定义、可测性、弱型估计、坏集控制**。

有意思的是可测性几乎不需要假设：`{c < Hf}` 可以写成"那些平均已经超过 `c` 的开区间的并"，
而任意并保持开性——所以**即使 `f` 完全不可测，`Hf` 也是下半连续的**。这是教材论证中
最漂亮的一步，本 Entry 逐字承载它。

## 陈述（教材记号）

设 `f : ℝ → ℝ`，`x ∈ ℝ`。**非中心 Hardy–Littlewood 极大函数**定义为

`Hf(x) = sup { (1/|I|) ∫_I |f| : I 是含 x 的开区间 }`，

取值于 `[0, +∞]`（允许 `+∞`）。教材在 ℝⁿ 上对含 `x` 的方体（或球）取上确界；本 Entry
把量词域落在一维开区间上。

本 Entry 交付的命题（`c : ℝ≥0` 为阈值，`E_c = {x | c < Hf(x)}`）：

1. **非负**：`Hf(x) ≥ 0`。
2. **单调**：逐点 `|f| ≤ |g|` 时 `Hf ≤ Hg`；特别地 `0 ≤ f ≤ g` 时 `Hf ≤ Hg`。
3. **常函数**：`H(常函数 a)(x) = |a|`（对每个 `x`，与 `x` 无关）。
4. **a.e. 相容**：`f = g` a.e. 时 `Hf = Hg`（甚至逐点相等，见下）。
5. **可测性边界（无 `f` 的正则性假设）**：对每个 `c ∈ [0, +∞]`，`{c < Hf}` 是**开集**；
   于是 `Hf` **下半连续**、Borel **可测**、a.e. 可测。
6. **弱型 `(1,1)` 估计**：若 `f ∈ L¹`（`Integrable f volume`）且 `c > 0`，则

   `|{x | c < Hf(x)}| ≤ 4 · c⁻¹ · ∫_ℝ |f|`（`volume` 为 Lebesgue 测度，右端为 `lintegral`）。

7. **坏集控制骨架**：若 `f - g ∈ L¹`，则 `|{x | c < H(f-g)(x)}| ≤ 4 · c⁻¹ · ∫_ℝ |f-g|`。

## 本库 Lean 承载

- **正式公开承载**：本库 `SandronesLibrary.RealAnalysis.MaximalFunction.maximalFunction`：

  ```lean
  noncomputable def maximalFunction (f : ℝ → ℝ) (x : ℝ) : ℝ≥0∞ :=
    ⨆ (I : OpenInterval) (_ : x ∈ I.toSet),
      (volume I.toSet)⁻¹ * ∫⁻ y in I.toSet, ENNReal.ofReal |f y|
  ```

  值域取 `ℝ≥0∞`（教材的 `[0, +∞]`），被积函数取 `ENNReal.ofReal |f y|`（教材的 `|f|`），
  量词域取**含 `x` 的开区间**（冻结结构 `SandronesLibrary.RealAnalysis.Covering.OpenInterval`，
  其 `toSet` 为 `Ioo l u`）。Mathlib **没有** `maximalFunction`，故这里必须自建；`⨆` 是
  教材 "sup" 的逐字承载，`ℝ≥0∞` 的 `CompleteLinearOrder` 让它对任意指标集有定义。
- **展开／刻画**：`isOpen_lt_maximalFunction` 给出水平集的**开区间并**展开
  `{c < Hf} = ⋃ (I) (_ : c < (1/|I|)∫_I |f|), I.toSet`；这是教材 "`Hf` 下半连续" 的证明，
  也是本 Entry 唯一需要的可测性刻画。
- **必要桥**：
  - `lintegral_abs_congr_ae`：`f =ᵐ g` 时每个区间的 `lintegral` 相等（区间是有限测度集，
    `volume.restrict I` 上的 a.e. 相等由 `ae_mono Measure.restrict_le_self` 得到）；
  - `maximalFunction_congr_of_ae_eq` / `maximalFunction_congr_ae`：a.e. 相等传递到 `Hf`；
  - `maximalFunction_mono_of_nonneg`：把教材的 `f ≤ g ⟹ Hf ≤ Hg` 在非负情形下恢复
    （实值函数上 `f ≤ g` 本身**不**蕴含 `|f| ≤ |g|`，见"应用与陷阱"）。
- **上层使用者**：`maximalFunction_weak_type`（弱型 `(1,1)`）真实使用上述承载；
  `maximalFunction_weak_type_sub` 是它在差函数上的推论，供 RA-F4 的稠密性论证使用。
- **私有证明后端**（未成为课程概念，但在此披露）：`lt_iSup_iff`（两次取出见证区间）、
  `ENNReal.lt_div_iff_mul_lt` / `ENNReal.div_eq_inv_mul` / `ENNReal.div_mul_cancel`
  （把 `c < (1/|I|)∫_I` 化为 `c·|I| < ∫_I`）、`Real.volume_Ioo` 与
  `Measure.restrict_apply_univ`（区间测度换算）、`ENNReal.toReal_*` 系列（半径界）、
  `lintegral_iUnion` / `ENNReal.tsum_mul_left` / `ENNReal.tsum_le_tsum` / `lintegral_mono_set`
  （把不交子族的积分合并回全积分）、`measurable_of_Ioi`（由水平集开性得可测）、
  `Set.PairwiseDisjoint.countable_of_nonempty_interior`（不交区间族至多可数）。

### 公开签名中的 Mathlib 对象四类归属

| Mathlib 名 | 归属 | 说明 |
|---|---|---|
| `MeasureTheory.lintegral`（`∫⁻`）、`ENNReal`（`ℝ≥0∞`） | **语义一致的正式公开承载** | 教材的 `(1/|I|)∫_I |f|` 与 `[0,+∞]` 值上确界逐字对应 |
| `Measurable`、`AEMeasurable`、`LowerSemicontinuous` | **语义一致的正式公开承载** | 教材 "`Hf` 下半连续故 Borel 可测" 直接采用 Mathlib 谓词 |
| `lt_iSup_iff` | 私有证明后端 | 从 `c < ⨆` 取出见证指标 |
| `ENNReal.lt_div_iff_mul_lt`、`ENNReal.div_eq_inv_mul`、`ENNReal.div_mul_cancel`、`ENNReal.inv_mul_cancel`、`ENNReal.mul_lt_mul_right` | 私有证明后端 | `ENNReal` 上除法／逆元的换算 |
| `ENNReal.toReal_mul`、`ENNReal.toReal_lt_toReal`、`ENNReal.coe_toReal`、`ENNReal.toReal_ofReal` | 私有证明后端 | 半径界的 `ℝ≥0∞ → ℝ` 换算 |
| `Real.volume_Ioo`、`Measure.restrict_apply_univ`、`Measure.restrict_le_self` | 私有证明后端 | 区间测度与限制测度的 a.e. 单调性 |
| `lintegral_iUnion`、`ENNReal.tsum_mul_left`、`ENNReal.tsum_le_tsum`、`lintegral_mono_set`、`lintegral_mono`、`lintegral_congr_ae` | 私有证明后端 | 不交族积分合并与单调性 |
| `measurable_of_Ioi`、`IsOpen.measurableSet`、`lowerSemicontinuous_iff_isOpen_preimage` | 私有证明后端 | 可测性边界的机械转换 |
| `Set.PairwiseDisjoint.countable_of_nonempty_interior`、`Set.iUnion_subtype`、`Set.mem_iUnion₂` | 私有证明后端 | 子族至多可数、`⋃ b ∈ u` 与 `⋃ b : u` 的换算 |
| `Integrable.abs`、`MeasureTheory.Integrable.lintegral_lt_top` | 私有证明后端 | 由 `f ∈ L¹` 得 `∫⁻ ofReal |f| < ∞`（半径界要用） |
| `div_lt_div_of_pos_right`、`div_eq_div_iff`、`abs_of_nonneg`、`le_abs_self` | 私有证明后端 | 实数的初等算术 |

没有超出课程层级的公开泄漏：公开签名里除本库自建的 `maximalFunction` 外，只出现
`ℝ`、`ℝ≥0`、`ℝ≥0∞`、`Set`、`Measure`、`volume`、`Integrable`、`Measurable`、
`AEMeasurable`、`LowerSemicontinuous`、`lintegral` 这些测度论课程本身的对象。

## Lean 对照

教材定义与 Lean 定义逐字对应（`I ∋ x` ↔ `x ∈ I.toSet`，`1/|I|` ↔ `(volume I.toSet)⁻¹`，
`∫_I |f|` ↔ `∫⁻ y in I.toSet, ENNReal.ofReal |f y|`）：

```lean
noncomputable def maximalFunction (f : ℝ → ℝ) (x : ℝ) : ℝ≥0∞ :=
  ⨆ (I : OpenInterval) (_ : x ∈ I.toSet),
    (volume I.toSet)⁻¹ * ∫⁻ y in I.toSet, ENNReal.ofReal |f y|
```

可测性边界（**没有** `f` 可测的假设）：

```lean
theorem isOpen_lt_maximalFunction (f : ℝ → ℝ) (c : ℝ≥0∞) :
    IsOpen {x : ℝ | c < maximalFunction f x}

theorem lowerSemicontinuous_maximalFunction (f : ℝ → ℝ) :
    LowerSemicontinuous (maximalFunction f)

theorem measurable_maximalFunction (f : ℝ → ℝ) : Measurable (maximalFunction f)

theorem aemeasurable_maximalFunction (f : ℝ → ℝ) : AEMeasurable (maximalFunction f) volume
```

弱型 `(1,1)` 估计（测度不等式，不是逐点结论）：

```lean
theorem maximalFunction_weak_type (f : ℝ → ℝ) (hf : Integrable f volume)
    (c : ℝ≥0) (hc : 0 < c) :
    volume {x : ℝ | (c : ℝ≥0∞) < maximalFunction f x} ≤
      4 * (c : ℝ≥0∞)⁻¹ * ∫⁻ y, ENNReal.ofReal |f y|
```

坏集控制骨架：

```lean
theorem maximalFunction_weak_type_sub {f g : ℝ → ℝ}
    (h : Integrable (fun y => f y - g y) volume) (c : ℝ≥0) (hc : 0 < c) :
    volume {x : ℝ | (c : ℝ≥0∞) < maximalFunction (fun y => f y - g y) x} ≤
      4 * (c : ℝ≥0∞)⁻¹ * ∫⁻ y, ENNReal.ofReal |f y - g y|
```

两条中间步骤（`hR` 与"逐项换积分"）也公开，便于审核：

```lean
theorem radius_le_of_lt_average {f : ℝ → ℝ} (hf : Integrable f volume) {c : ℝ≥0} (hc : 0 < c)
    {I : OpenInterval}
    (havg : (c : ℝ≥0∞) < (volume I.toSet)⁻¹ * ∫⁻ y in I.toSet, ENNReal.ofReal |f y|) :
    I.radius ≤ (∫⁻ y, ENNReal.ofReal |f y|).toReal / (2 * (c : ℝ))

theorem volume_le_inv_mul_lintegral_of_lt_average {f : ℝ → ℝ} {c : ℝ≥0} (hc : 0 < c)
    {I : OpenInterval}
    (havg : (c : ℝ≥0∞) < (volume I.toSet)⁻¹ * ∫⁻ y in I.toSet, ENNReal.ofReal |f y|) :
    volume I.toSet ≤ (c : ℝ≥0∞)⁻¹ * ∫⁻ y in I.toSet, ENNReal.ofReal |f y|
```

## 证明思路

**（一）可测性边界**（`isOpen_lt_maximalFunction`）。关键是集合恒等式

`{x | c < Hf(x)} = ⋃ (I : OpenInterval) (_ : c < (1/|I|)∫_I |f|), I.toSet`。

- `⊆`：由 `c < ⨆` 用两次 `lt_iSup_iff` 取出见证区间 `I` 与 `x ∈ I.toSet`，以及
  `c < (1/|I|)∫_I |f|`，于是 `x` 落在右边以 `I` 为指标的那一项里。
- `⊇`：若 `x ∈ I.toSet` 且该区间的平均已超过 `c`，则由 `le_iSup_of_le` 把这项平均值放回
  上确界，得 `c < Hf(x)`。

右边是开区间的**任意并**，由 `isOpen_iUnion` 与 `OpenInterval.isOpen_toSet` 得开性。
再用 `IsOpen.measurableSet`、`lowerSemicontinuous_iff_isOpen_preimage`（`LowerSemicontinuous`
的定义就是"每个 `Ioi c` 的原像开"）与 `measurable_of_Ioi`（`ℝ≥0∞` 第二可数）得到
Borel 可测与 a.e. 可测。**全程不需要 `f` 可测。**

**（二）弱型 `(1,1)`：覆盖引理 → 坏集 → 测度控制**（`maximalFunction_weak_type`）。
设 `E = {x | c < Hf(x)}`，`f ∈ L¹`，`c > 0`。

1. **取出见证区间**：对每个 `x ∈ E`，用 `lt_iSup_iff` 两次取出开区间 `I x ∋ x` 使
   `c < (1/|I x|)∫_{I x} |f|`；用 `Classical.choose` 配合 `if h : x ∈ E then … else ⟨0,1,…⟩`
   把它补成全函数 `sel : ℝ → OpenInterval`（`x ∉ E` 的分支取值任意，半径 0 的区间即可）。
2. **半径一致有界**（`radius_le_of_lt_average`）：由 `c < (1/|I|)∫_I |f|` 经
   `ENNReal.lt_div_iff_mul_lt` 得 `c·|I| < ∫_I |f|`；用 `Real.volume_Ioo` 把 `|I|` 写成
   `ofReal (u - l)`，用 `lintegral_mono_set` 把 `∫_I |f|` 控制到全积分 `∫_ℝ |f| < ∞`
   （这一步**正是** `f ∈ L¹` 的用处），取 `toReal` 并用 `u - l = 2·radius` 换算，得
   `radius (sel x) ≤ R`，其中 `R = (∫_ℝ |f|).toReal / (2c)`。
3. **覆盖引理**：对 `E` 与 `sel` 套冻结的
   `exists_disjoint_interval_subfamily_covering_enlargement`（取 `τ = 4 > 3`），得到不交子族
   `u ⊆ E`，使每个 `sel x` 都落在某个 `sel b`（`b ∈ u`）的 4-放大球内。于是
   `E ⊆ ⋃ b ∈ u, ball (sel b).center (4 · radius (sel b))`。
4. **坏集测度控制**：由 `volume_iUnion_le_mul_tsum`（覆盖引理的测度形式）得
   `|E| ≤ ofReal 4 · Σ'_{b : u} |sel b|`。这里 `u` 至多可数来自"可分空间中两两不交的非空
   开集族至多可数"（`Set.PairwiseDisjoint.countable_of_nonempty_interior`），故 `tsum` 有意义。
5. **逐项换积分**（`volume_le_inv_mul_lintegral_of_lt_average`）：对每个 `b ∈ u`，把
   `c < (1/|sel b|)∫_{sel b} |f|` 两边左乘 `c⁻¹`（`c ≠ 0, c ≠ ∞`）得
   `|sel b| ≤ c⁻¹ ∫_{sel b} |f|`。
6. **合并回全积分**：用 `ENNReal.tsum_le_tsum` 逐项代入，`ENNReal.tsum_mul_left` 提出 `c⁻¹`，
   `lintegral_iUnion`（`u` 可数、区间两两不交、每个区间可测）把
   `Σ'_{b : u} ∫_{sel b} |f|` 合并成 `∫_{⋃ b : u, sel b} |f|`，最后 `lintegral_mono_set`
   控制到 `∫_ℝ |f|`。合成即得 `|E| ≤ 4 · c⁻¹ · ∫_ℝ |f|`。

**（三）通向 a.e. 结论的骨架**（本窗只交付骨架，不交付 a.e. 定理）。
`maximalFunction_weak_type_sub` 把上面的估计用在差函数 `f - g` 上。Lebesgue 微分定理
（Folland Theorem 3.21）的标准证明是：

1. 对连续函数（或简单函数）类直接证明平均收敛到函数值；
2. 对一般 `f ∈ L¹` 与 `ε > 0`，取连续 `g` 使 `‖f - g‖₁ < ε`，则坏集
   `{x | limsup |平均(f) - f(x)| > ε}` 被 `{H(f-g) > ε/2}` 与 `{|g - f| > ε/2}` 的并控制，
   前者的测度由本 Entry 的弱型估计压到 `O(ε)`；
3. 令 `ε → 0`，得 a.e. 收敛。

第 2 步所需的"坏集测度控制"就是本 Entry 交付的 `maximalFunction_weak_type_sub`；
第 1、3 步（Lebesgue 点、a.e. 收敛本身）属于 RA-F4，**不在本 Entry 范围内**。

## 依赖（人话版）

- **库内前提**：`real-analysis.measure.def`（测度、可数可加、单调性）、
  `real-analysis.measure.lintegral`（`∫⁻` 的定义与单调性）。此外本 Entry 直接使用
  同批冻结的 `real-analysis.covering-lemma`（`OpenInterval`、`exists_disjoint_interval_subfamily_covering_enlargement`、
  `volume_iUnion_le_mul_tsum`）——它是 RA-F3 的前置接口，本 Entry 是它的第一个下游使用者。
- **下游使用者**：`real-analysis.maximal-function` 的弱型估计与坏集控制是 RA-F4
  （Lebesgue 点与 Lebesgue 微分定理）的前置；RA-F6（FTC 的 a.e. 版本）间接依赖 RA-F4。
- **数学库后端**：见"四类归属"表；覆盖组合核心来自 Mathlib 的
  `Vitali.exists_disjoint_subfamily_covering_enlargement_ball`（经冻结覆盖引理间接使用）。

## 诚实边界与应用陷阱

- **一维，不是 ℝⁿ**：本 Entry 的量词域是 ℝ 上的开区间。教材在 ℝⁿ 上对球／方体取上确界，
  其覆盖常数 `3ⁿ` 依赖欧氏几何；本库没有也不声称有 ℝⁿ 版本。
- **弱型常数是 4，不是 `3ⁿ`**：证明走 Mathlib Vitali 覆盖引理的 `τ > 3` 口径并取 `τ = 4`；
  `n = 1` 时 Folland 给 3，本库给 4。**本库不声称复刻 Folland 的常数**，也不声称最优性。
  与 Folland Theorem 3.18 相比，本 Entry 的强度是"同形状、常数略差"。
- **弱型估计是测度不等式**：结论形状是 `volume {…} ≤ 4·c⁻¹·∫⁻|f|`，**不是**逐点不等式，
  也**不是** a.e. 等式。自然语言不得写成"`Hf ≤ 4c⁻¹‖f‖₁` 逐点成立"之类的结论。
- **a.e. 微分定理未交付**：Lebesgue 点与 Lebesgue 微分定理（RA-F4）、FTC 的 a.e. 版本
  （RA-F6）都不在本 Entry 范围内。`maximalFunction_weak_type_sub` 只是那条证明路线里的
  **坏集控制一环**，本身不是 a.e. 收敛结论。
- **`f ≤ g` 不足以推出 `Hf ≤ Hg`**：实值函数的逐点 `f ≤ g` **不**蕴含 `|f| ≤ |g|`
  （`f = -5, g = 1` 即反例），故本库的 `maximalFunction_mono` 假设逐点 `|f| ≤ |g|`，
  教材的 `f ≤ g` 形式在非负情形由 `maximalFunction_mono_of_nonneg` 恢复。
  直接照抄教材的 `f ≤ g` 会得到一条**假命题**。
- **积分类型与测度**：右端是 `lintegral`（`ℝ≥0∞` 值）`∫⁻ y, ENNReal.ofReal |f y|`，
  不是 Bochner 积分；测度是 Lebesgue `volume`（σ-有限、非空开集正测度）。可积性假设
  `Integrable f volume` 只用于保证 `∫⁻ ofReal |f| ≠ ∞`（半径一致有界），不用于被积函数的可测性
  ——事实上可测性部分对**任意** `f` 成立。
- **`ℝ≥0` 是 scoped 记号**：Lean 文件必须 `open scoped NNReal`（`ℝ≥0∞` 则需要
  `open scoped ENNReal`），否则 `(c : ℝ≥0)` 会被解析成对 `ℝ` 使用 `≥`，报出与数学无关的
  `LE Type` 类型类错误。
- **`⋃ b ∈ u` 与 `⋃ b : u`**：`tsum` 的指标是子类型 `u`，两者靠 `Set.iUnion_subtype` 换算，
  混用会导致类型不匹配（覆盖引理文件已记录同一坑）。
