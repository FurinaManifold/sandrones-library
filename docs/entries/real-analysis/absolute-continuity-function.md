---
id: real-analysis.absolute-continuity-function
family: real-analysis.absolute-continuity
variant: tao
kind: theorem
state: verified
title: 绝对连续函数
summary: 绝对连续函数的教材 ε-δ 定义与 Lean 承载、Lipschitz ⟹ AC ⟹ BV ⟹ 几乎处处可导这条链、AC ⟹ 一致连续、代数封闭性，以及「变上限积分是 AC」这一 RA-F6 入口桥
premises: [real-analysis.calculus.ftc, real-analysis.measure.def, real-analysis.bounded-variation]
mathlib: [AbsolutelyContinuousOnInterval, AbsolutelyContinuousOnInterval.totalLengthFilter, AbsolutelyContinuousOnInterval.disjWithin, absolutelyContinuousOnInterval_iff, LipschitzOnWith.absolutelyContinuousOnInterval, ContDiffOn.absolutelyContinuousOnInterval, AbsolutelyContinuousOnInterval.boundedVariationOn, AbsolutelyContinuousOnInterval.ae_differentiableAt, AbsolutelyContinuousOnInterval.uniformContinuousOn, AbsolutelyContinuousOnInterval.continuousOn, AbsolutelyContinuousOnInterval.exists_bound, AbsolutelyContinuousOnInterval.add, AbsolutelyContinuousOnInterval.sub, AbsolutelyContinuousOnInterval.neg, AbsolutelyContinuousOnInterval.const_mul, AbsolutelyContinuousOnInterval.const_smul, AbsolutelyContinuousOnInterval.mul, AbsolutelyContinuousOnInterval.smul, AbsolutelyContinuousOnInterval.symm, AbsolutelyContinuousOnInterval.mono, LipschitzOnWith.dist_le_mul, IntervalIntegrable.absolutelyContinuousOnInterval_intervalIntegral]
provenance:
  source_type: book
  ref: "folland-real-analysis-1999"
---

# real-analysis.absolute-continuity-function

- **家族**: `real-analysis.absolute-continuity`
- **变体**: tao
- **状态**: verified
- **一句话**: `f` 在 `[a,b]` 上绝对连续，当且仅当“任意有限个两两不交区间的总长度趋于 0 时，
  对应的振幅和也趋于 0”；这个类比一致连续更强、比 Lipschitz 更弱，并且满足
  `Lipschitz ⟹ AC ⟹ BV ⟹ 几乎处处可导`。

## 直觉

一致连续只控制**单个**小区间上的振幅：`|x - y| < δ ⟹ |f(x) - f(y)| < ε`。但积分、变差、
Newton–Leibniz 公式关心的是**许多小区间合起来**的总振幅：把 `[a,b]` 切成一千段，
每段振幅都 `< ε`，一千段加起来可以到 `1000ε`——这不够用。

绝对连续正是补上这一点的条件（Folland §3.6）：不管切多少段，只要这些段**总长度**小，
它们的**振幅总和**就小。换句话说，AC 是“把一致连续性对整个有限不交区间族一致地加强”。
这个加强刚好够用：它让 `f` 成为其导数的积分（`∫ f' = f(b) - f(a)`），
也就是 RA-F6 要交付的 Newton–Leibniz 表示；而它又没有强到要求 `f` **处处**可微——
AC 只保证**几乎处处**可导。例如 `x ↦ max x 0` 在 `[-1,1]` 上是区间可积函数 `1_{[0,∞)}`
的变上限积分，因而绝对连续，却在 `x = 0` 处不可导（左导 `0`、右导 `1`）。

AC 在函数空间里的位置可以排成一条链：

```text
C¹  ⟹  Lipschitz  ⟹  绝对连续  ⟹  有界变差  ⟹  几乎处处可导
                    ⟹  一致连续  ⟹  连续
```

链上每个箭头都**严格**：`x ↦ √x` 在 `[0,1]` 上 AC 但不 Lipschitz；Cantor 函数有界变差
但不 AC（它在 Cantor 集补集的每一段上增量恰等于该段长度，而这些段的总长度为 `1`，
于是取有限多段即可让“总长度小”与“振幅和接近 `1`”同时出现，违反 AC 的 ε-δ 条件）；
`x ↦ x sin(1/x)` 连续但不有界变差。
本条目交付这条链上除 `C¹` 之外的全部箭头，以及“变上限积分是 AC”这一 RA-F6 入口。

## 陈述（教材记号）

设 `f : ℝ → X`（`X` 为伪度量空间），`a, b ∈ ℝ`。

1. **定义（Folland §3.6）**：`f` 在 `[a,b]` 上**绝对连续**，若
   `∀ ε > 0, ∃ δ > 0`，使得对 `[a,b]` 中任意有限个两两不交的开区间 `(aᵢ, bᵢ)`（`i < n`），
   只要 `∑ᵢ (bᵢ - aᵢ) < δ` 就有 `∑ᵢ dist (f aᵢ) (f bᵢ) < ε`。
2. **Lipschitz ⟹ AC**：`f` 在 `[a,b]` 上 Lipschitz ⟹ `f` 在 `[a,b]` 上 AC。反之不成立。
3. **`C¹` ⟹ AC**：`f` 在 `[a,b]` 上连续可微 ⟹ AC。
4. **AC ⟹ BV**：`f` 在 `[a,b]` 上 AC ⟹ `f` 在 `[a,b]` 上有界变差。
5. **AC ⟹ 几乎处处可导**：`f : ℝ → ℝ` 在 `[a,b]` 上 AC ⟹ `f` 在 `[a,b]` 上关于 Lebesgue 测度
   **几乎处处**可导。**这是 a.e. 结论，不是逐点结论。**
6. **AC ⟹ 一致连续 ⟹ 连续**；在 `[a,b]` 上还给出 `∃ C, ∀ x ∈ [a,b], ‖f x‖ ≤ C`。
7. **代数封闭性**：AC 对加法、减法、取负、标量乘法、逐点标量积、乘积封闭；限制到子区间仍 AC；
   `uIcc a b` 与 `uIcc b a` 上等价；与 Lipschitz 函数复合仍 AC。
8. **变上限积分是 AC**：`f` 在 `a..b` 上区间可积，`c ∈ [a,b]`，则 `x ↦ ∫_c^x f` 在 `[a,b]` 上 AC。

## 本库 Lean 承载

四类归属如下。

- **正式公开承载**：`AbsolutelyContinuousOnInterval f a b : Prop`（`f : ℝ → X`，
  `[PseudoMetricSpace X]`）。Mathlib 把它定义成：区间族上的振幅和函数
  `E ↦ ∑ i ∈ Finset.range E.1, dist (f (E.2 i).1) (f (E.2 i).2)` 沿滤子
  `totalLengthFilter ⊓ 𝓟 (disjWithin a b)` 趋于 `0`。这与教材量词语义一致，故直接复用，
  不另造同构 `def`。
- **教材量词展开**（本库命名）：
  - `absolutelyContinuousOnInterval_iff_tendsto`：Lean 侧定义展开（`Iff.rfl`），
    把教材的“总长度 → 0 时振幅和 → 0”写成 `Tendsto … (𝓝 0)`。
  - `absolutelyContinuousOnInterval_iff_epsilon_delta`：教材 ε-δ 定义 ↔ Lean filter 定义。
  - `mem_disjWithin_iff`：把“有限个两两不交、端点落在 `uIcc a b` 的区间”展开成
    `∀ i ∈ Finset.range E.1, (E.2 i).1 ∈ uIcc a b ∧ (E.2 i).2 ∈ uIcc a b` 加上
    `Set.PairwiseDisjoint (Finset.range E.1) (fun i => uIoc (E.2 i).1 (E.2 i).2)`。
- **桥**：
  - `intervalIntegrable_absolutelyContinuousOnInterval_intervalIntegral`：变上限积分是 AC。
    这是 **RA-F6 的入口方向**；反方向（AC ⟹ 导数可积 + `∫ f' = f(b) - f(a)`）**本窗不交付**。
- **私有证明后端**（语义一致但未作为课程概念单独引入）：
  - `LipschitzOnWith.absolutelyContinuousOnInterval`、`ContDiffOn.absolutelyContinuousOnInterval`
    （更强正则性 ⟹ AC）；
  - `AbsolutelyContinuousOnInterval.boundedVariationOn`、`...ae_differentiableAt`（链上的后两环）；
  - `...uniformContinuousOn` / `...continuousOn` / `...exists_bound`（连续性强度）；
  - `...add` / `...sub` / `...neg` / `...const_mul` / `...const_smul` / `...mul` / `...smul` /
    `...symm` / `...mono`（代数封闭性）；
  - `LipschitzOnWith.dist_le_mul`（自证的复合引理里逐项控制振幅）。

## Lean 对照

以下签名逐字来自 `SandronesLibrary/RealAnalysis/AbsoluteContinuityFunction.lean`
（命名空间 `SandronesLibrary.RealAnalysis.AbsoluteContinuityFunction`）：

```lean
theorem absolutelyContinuousOnInterval_iff_tendsto (f : ℝ → X) (a b : ℝ) :
    AbsolutelyContinuousOnInterval f a b ↔
      Tendsto (fun E : ℕ × (ℕ → ℝ × ℝ) =>
          ∑ i ∈ Finset.range E.1, dist (f (E.2 i).1) (f (E.2 i).2))
        (AbsolutelyContinuousOnInterval.totalLengthFilter (X := ℝ) ⊓
          𝓟 (AbsolutelyContinuousOnInterval.disjWithin a b)) (𝓝 0)

theorem absolutelyContinuousOnInterval_iff_epsilon_delta (f : ℝ → X) (a b : ℝ) :
    AbsolutelyContinuousOnInterval f a b ↔
      ∀ ε > (0 : ℝ), ∃ δ > (0 : ℝ), ∀ E,
        E ∈ AbsolutelyContinuousOnInterval.disjWithin a b →
        ∑ i ∈ Finset.range E.1, dist (E.2 i).1 (E.2 i).2 < δ →
        ∑ i ∈ Finset.range E.1, dist (f (E.2 i).1) (f (E.2 i).2) < ε

theorem mem_disjWithin_iff {a b : ℝ} {E : ℕ × (ℕ → ℝ × ℝ)} :
    E ∈ AbsolutelyContinuousOnInterval.disjWithin a b ↔
      (∀ i ∈ Finset.range E.1, (E.2 i).1 ∈ uIcc a b ∧ (E.2 i).2 ∈ uIcc a b) ∧
        Set.PairwiseDisjoint (Finset.range E.1) (fun i => uIoc (E.2 i).1 (E.2 i).2)

theorem lipschitzOnWith_absolutelyContinuousOnInterval {f : ℝ → X} {a b : ℝ} {K : ℝ≥0}
    (h : LipschitzOnWith K f (uIcc a b)) : AbsolutelyContinuousOnInterval f a b

theorem contDiffOn_one_absolutelyContinuousOnInterval {E : Type*} [NormedAddCommGroup E]
    [NormedSpace ℝ E] {f : ℝ → E} {a b : ℝ} (h : ContDiffOn ℝ 1 f (uIcc a b)) :
    AbsolutelyContinuousOnInterval f a b

theorem absolutelyContinuousOnInterval_boundedVariationOn {f : ℝ → F} {a b : ℝ}
    (h : AbsolutelyContinuousOnInterval f a b) : BoundedVariationOn f (uIcc a b)

theorem absolutelyContinuousOnInterval_ae_differentiableAt {f : ℝ → ℝ} {a b : ℝ}
    (h : AbsolutelyContinuousOnInterval f a b) :
    ∀ᵐ x : ℝ, x ∈ uIcc a b → DifferentiableAt ℝ f x

theorem lipschitzOnWith_ae_differentiableAt {f : ℝ → ℝ} {a b : ℝ} {K : ℝ≥0}
    (h : LipschitzOnWith K f (uIcc a b)) :
    AbsolutelyContinuousOnInterval f a b ∧ BoundedVariationOn f (uIcc a b) ∧
      ∀ᵐ x : ℝ, x ∈ uIcc a b → DifferentiableAt ℝ f x

theorem absolutelyContinuousOnInterval_uniformContinuousOn {f : ℝ → F} {a b : ℝ}
    (h : AbsolutelyContinuousOnInterval f a b) : UniformContinuousOn f (uIcc a b)

theorem absolutelyContinuousOnInterval_continuousOn {f : ℝ → F} {a b : ℝ}
    (h : AbsolutelyContinuousOnInterval f a b) : ContinuousOn f (uIcc a b)

theorem absolutelyContinuousOnInterval_exists_bound {f : ℝ → F} {a b : ℝ}
    (h : AbsolutelyContinuousOnInterval f a b) : ∃ C : ℝ, ∀ x ∈ uIcc a b, ‖f x‖ ≤ C

theorem absolutelyContinuousOnInterval_add {f g : ℝ → F} {a b : ℝ}
    (hf : AbsolutelyContinuousOnInterval f a b) (hg : AbsolutelyContinuousOnInterval g a b) :
    AbsolutelyContinuousOnInterval (f + g) a b

theorem absolutelyContinuousOnInterval_mul {f g : ℝ → ℝ} {a b : ℝ}
    (hf : AbsolutelyContinuousOnInterval f a b) (hg : AbsolutelyContinuousOnInterval g a b) :
    AbsolutelyContinuousOnInterval (f * g) a b

theorem lipschitzOnWith_comp_absolutelyContinuousOnInterval {f g : ℝ → ℝ} {a b : ℝ} {K : ℝ≥0}
    (hf : AbsolutelyContinuousOnInterval f a b) (hg : LipschitzOnWith K g (uIcc a b))
    (hmaps : MapsTo f (uIcc a b) (uIcc a b)) :
    AbsolutelyContinuousOnInterval (g ∘ f) a b

theorem intervalIntegrable_absolutelyContinuousOnInterval_intervalIntegral {f : ℝ → ℝ} {a b c : ℝ}
    (h : IntervalIntegrable f volume a b) (hc : c ∈ uIcc a b) :
    AbsolutelyContinuousOnInterval (fun x => ∫ v in c..x, f v) a b
```

其余：`absolutelyContinuousOnInterval_sub`、`absolutelyContinuousOnInterval_neg`、
`absolutelyContinuousOnInterval_const_mul`、`absolutelyContinuousOnInterval_const_smul`、
`absolutelyContinuousOnInterval_smul`、`absolutelyContinuousOnInterval_symm`、
`absolutelyContinuousOnInterval_mono`。

## 证明思路

- **ε-δ 展开**：Mathlib 的定义是滤子 `Tendsto`，`absolutelyContinuousOnInterval_iff` 用
  `Metric.tendsto_nhds` 与 `hasBasis_totalLengthFilter` 把它翻译成 ε-δ 量词。
  教材读者只需记住右边那一行。
- **Lipschitz ⟹ AC**：取 `δ = ε/(K+1)`，逐项用 `dist (f x) (f y) ≤ K · dist x y`，
  总振幅和 ≤ `K · 总长度 < K · ε/(K+1) < ε`。
- **`C¹` ⟹ AC**：`C¹` 函数在紧区间上 Lipschitz（中值定理），再套上一条。
- **AC ⟹ BV**：把 `[a,b]` 按长度 `< δ` 切成 `n+1` 段（`δ` 取 AC 定义中对 `ε = 1` 的那一个），
  每段变差 `< 1`，总变差 `< n+1 < ∞`。
- **AC ⟹ a.e. 可导**：`AC ⟹ BV` 之后套 `BoundedVariationOn.ae_differentiableAt_of_mem_uIcc`
  （见 `real-analysis.bounded-variation`）。本库只做接口转述，不重证覆盖论证。
- **AC ⟹ 一致连续**：AC 定义里的 ε-δ 对**所有**有限不交区间族一致成立；取只含一个区间的族
  （长度 `< δ`）即得一致连续。反过来不成立（一致连续不必有界变差）。
- **代数封闭性**：加法/减法/取负是三角不等式逐项相加；乘积先把两个因子用 AC ⟹ 有界
  控制住，再把 `∑ dist (f g) (f' g')` 拆成 `C · ∑ dist g + D · ∑ dist f`；
  数乘用 `dist (c • x) (c • y) ≤ ‖c‖ · dist x y`。
- **与 Lipschitz 复合（本库自证，Mathlib 无此引理）**：取 AC 定义中对 `ε/(K+1)` 的 `δ`，
  逐项用 `dist (g x) (g y) ≤ K · dist x y`（`LipschitzOnWith.dist_le_mul`），再做算术
  `K · (ε/(K+1)) ≤ (K+1) · (ε/(K+1)) = ε`。注意 `K` 可以是 `0`，所以中间一步只能用 `≤`
  再用 `K < K+1` 抬成严格不等号。
- **变上限积分是 AC**：把区间族上的振幅和用 `∫_{uIoc}` 的 `lintegral` 控制
  （`tendsto_setLIntegral_zero`），再用 `tendsto_volume_restrict_totalLengthFilter_disjWithin_nhds_zero`
  把“总长度 → 0”转成“测度 → 0”。

## 依赖（人话版）

- **库内前提**：
  - `real-analysis.calculus.ftc`：AC 这个概念的用途就是修复 Riemann/FTC 里“可微 ⟹ 积分”的缺口；
    已有的 FTC 条目是 AC 的动机来源，也是 RA-F6 要接上的目标。
  - `real-analysis.measure.def`：AC 的定义本身不用测度，但 AC ⟹ a.e. 可导、
    以及变上限积分桥都要对 `volume` 陈述。
  - `real-analysis.bounded-variation`：**同批（RA-F5）同时交付的前置**。`AC ⟹ BV` 的结论用的是
    该条目的 `BoundedVariationOn f (uIcc a b)`，`AC ⟹ a.e. 可导` 则进一步引用该条目的
    `BoundedVariationOn.ae_differentiableAt_of_mem_uIcc`。两条 Entry 是同一批的两半，
    本条目的链式定理 `lipschitzOnWith_ae_differentiableAt` 是它们组装的直接证据。
- **Mathlib**：`AbsolutelyContinuousOnInterval` 为正式承载；
  `absolutelyContinuousOnInterval_iff` 为量词展开；
  `LipschitzOnWith.absolutelyContinuousOnInterval`、`AbsolutelyContinuousOnInterval.boundedVariationOn`、
  `...ae_differentiableAt`、`...uniformContinuousOn`、`...add` 系列为私有证明后端；
  `IntervalIntegrable.absolutelyContinuousOnInterval_intervalIntegral` 为桥。

## 应用与陷阱

- **a.e. 不是逐点**：`absolutelyContinuousOnInterval_ae_differentiableAt` 的结论是
  `∀ᵐ x, x ∈ uIcc a b → DifferentiableAt ℝ f x`。零测例外集可以非空；要举“AC 但并非处处可微”
  的例子，用 `x ↦ max x 0` 在 `[-1,1]` 上：它是区间可积函数 `1_{[0,∞)}` 的变上限积分，
  因而绝对连续，但在 `x = 0` 处不可导（左导 `0`、右导 `1`）。反过来，a.e. 可导（甚至导数
  a.e. 为 `0`）也推不出 AC：Cantor 函数在 `[0,1]` 上几乎处处可导、导数几乎处处为 `0`，
  却不是常数，因而**不是**绝对连续（AC 函数的导数若 a.e. 为 `0`，它就只能是常数）。
  自然语言叙述中不得把 a.e. 结论写成“处处可导”。
- **AC 是区间上的谓词，不是全局谓词**：`AbsolutelyContinuousOnInterval f a b` 只谈 `uIcc a b`。
  一个函数可以在 `[0,1]` 上 AC、在 `[1,2]` 上不 AC；要谈“`f` 绝对连续”必须先给区间。
  本库不引入全局谓词，也不声称两者等价。
- **AC 严格强于一致连续**：一致连续只控制单个小区间，AC 控制任意有限不交族的总振幅。
  教材中的反例是 Cantor 函数：它一致连续（紧区间上连续），但不绝对连续。
  本条目只交付“AC ⟹ 一致连续”这一个方向。
- **AC 与 Lipschitz 不可逆**：`x ↦ √x` 在 `[0,1]` 上 AC（其导数的积分收敛），
  但在 `0` 附近不是 Lipschitz。本条目只交付“Lipschitz ⟹ AC”。
- **`uIcc` 而不是 `Icc`**：Mathlib 的谓词定义在 `uIcc a b` 上，`a > b` 时自动取 `uIcc b a`，
  所以它对端点顺序对称（`absolutelyContinuousOnInterval_symm`）。写教材陈述时
  `uIcc a b` 与 `Icc a b`（在 `a ≤ b` 时）可以互换。
- **边界（RA-F6 未交付）**：本条目**不含** AC ⟹ 导数可积、也**不含**
  `∫ x in a..b, deriv f x = f b - f a`。Mathlib 里确实有
  `AbsolutelyContinuousOnInterval.intervalIntegrable_deriv` 与 `...integral_deriv_eq_sub`，
  但它们属于 **RA-F6（FTC 的 a.e. 版本与 Newton–Leibniz 表示）**，本窗只交付 AC 一侧，
  故不在本文件公开。本条目也不含 Lebesgue 微分定理本身（RA-F4）。
