---
id: real-analysis.monotone-function
family: real-analysis.monotone
variant: tao
kind: theorem
state: verified
title: 单调函数：间断结构、a.e. 可导性与 Stieltjes 测度桥
summary: 单调函数 Monotone f 的教材量词展开、左右极限与跳跃点至多可数、Lebesgue-a.e. 可导性，以及通往 Lebesgue–Stieltjes 测度 StieltjesFunction.measure 的区间测度桥
premises: [real-analysis.calculus.ftc, real-analysis.measure.def]
mathlib: [Monotone, MonotoneOn, Monotone.monotoneOn, Function.leftLim, Function.rightLim, Monotone.leftLim_le, Monotone.le_rightLim, Monotone.leftLim_le_rightLim, Monotone.leftLim_eq_sSup, Monotone.rightLim_eq_sInf, Monotone.rightLim, Monotone.continuousAt_iff_leftLim_eq_rightLim, ContinuousWithinAt.leftLim_eq, ContinuousWithinAt.rightLim_eq, Monotone.countable_not_continuousAt, Monotone.ae_hasDerivAt, Monotone.ae_differentiableAt, HasDerivAt, DifferentiableAt, Monotone.stieltjesFunction, Monotone.stieltjesFunction_eq, StieltjesFunction, StieltjesFunction.measure, StieltjesFunction.measure_Ioc, StieltjesFunction.measure_Icc, StieltjesFunction.measure_Ioo, StieltjesFunction.measure_Ico, StieltjesFunction.measure_singleton, StieltjesFunction.instIsLocallyFiniteMeasure, IsLocallyFiniteMeasure, Measure.rnDeriv, volume, ENNReal.ofReal, ENNReal.toReal, eVariationOn, BoundedVariationOn, MonotoneOn.eVariationOn_eq, MonotoneOn.locallyBoundedVariationOn, MonotoneOn.boundedVariationOn]
provenance:
  source_type: book
  ref: "folland-real-analysis-1999"
---

# real-analysis.monotone-function

- **家族**: `real-analysis.monotone`
- **变体**: tao
- **状态**: verified
- **一句话**: 单调函数 `f : ℝ → ℝ` 的单侧极限给出它的间断结构（跳跃点至多可数）、它在
  Lebesgue-a.e. 处可导，并且它的右连续化 `x ↦ f(x⁺)` 定义一个局部有限的 Borel 测度
  `μ_f`——即 Folland §3.5 的 Lebesgue–Stieltjes 测度，其区间测度由 `f` 的左右极限表出。

## 直觉

单调函数是实分析里“最规矩”的一类函数：它没有振荡，因此所有“坏行为”都被压到单侧极限里。
在每一点 `x`，`f` 都有左极限 `f(x⁻) = Function.leftLim f x` 与右极限
`f(x⁺) = Function.rightLim f x`，且夹逼

```
f(x⁻) ≤ f(x) ≤ f(x⁺)
```

成立。于是“`f` 在 `x` 连续”等价于两个单侧极限都等于 `f(x)`；“`f` 在 `x` 间断”等价于
跳跃量 `f(x⁺) − f(x⁻) > 0`。跳跃是“质量”：每个跳跃点吃掉的增量是正的，而总的增量被
`f(b) − f(a)` 控制，所以跳跃点至多可数。这是 Folland §3.5 处理单调函数时的第一条结构性事实。

第二条结构性事实是 a.e. 可导：单调函数在 Lebesgue-几乎处处可导（Lebesgue 1910）。
Mathlib 的证明路线（`Mathlib/Analysis/Calculus/Monotone.lean`）把它归约到测度微分：
右连续化 `g = hf.stieltjesFunction` 定义一个 Lebesgue–Stieltjes 测度 `μ_g`，
`μ_g` 关于 Lebesgue 的 Radon–Nikodym 导数 `dμ_g/dx` 就是 `g` 的 a.e. 导数
（Vitali 覆盖 + `VitaliFamily.ae_tendsto_rnDeriv`），再用 `(y−x)²` 平移与夹逼把结论搬回 `f`。
所以“单调函数 a.e. 可导”与“Stieltjes 测度的 RN 导数”在 Lean 里是**同一个对象**：
本 Entry 的核心就是把这件事写成可复用的公开接口，供 RA-F2（Radon–Nikodym）与
RA-F6（FTC 的 a.e. 版本）对接。

## 陈述（教材记号）

设 `f : ℝ → ℝ` 单调（`x ≤ y ⟹ f x ≤ f y`），记 `f(x⁻) = Function.leftLim f x`、
`f(x⁺) = Function.rightLim f x`。

1. **定义**：`Monotone f :⟺ ∀ x y, x ≤ y → f x ≤ f y`；集合形式
   `MonotoneOn f s :⟺ ∀ x ∈ s, ∀ y ∈ s, x ≤ y → f x ≤ f y`。
2. **夹逼**：`f(x⁻) ≤ f(x) ≤ f(x⁺)`；特别地跳跃量非负：`f(x⁻) ≤ f(x⁺)`。
3. **连续判据**：`f` 在 `x` 连续 `⟺ f(x⁻) = f(x) ∧ f(x⁺) = f(x)`。
4. **间断点可数**：`{x | f 在 x 不连续}` 至多可数；等价地，跳跃点集
   `{x | f(x⁻) < f(x⁺)}` 至多可数。
5. **a.e. 可导**：`f` 在 Lebesgue-a.e. 处可导，且
   `f'(x) = (dμ_f/dvolume)(x)`（a.e.），其中 `μ_f` 是 `f` 的右连续化所定的
   Lebesgue–Stieltjes 测度，`dμ_f/dvolume` 取值于 `[0, +∞]`，取 `toReal` 后与实导数相等。
6. **Stieltjes 测度**：`μ_f` 是 `ℝ` 上局部有限的 Borel 测度，且
   `μ_f((a,b]) = f(b⁺) − f(a⁺)`、`μ_f([a,b]) = f(b⁺) − f(a⁻)`、
   `μ_f((a,b)) = f(b⁻) − f(a⁺)`、`μ_f([a,b)) = f(b⁻) − f(a⁻)`、
   `μ_f({a}) = f(a⁺) − f(a⁻)`；当 `f` 本身右连续时第一式退化为教材字面的 `f(b) − f(a)`。
7. **与有界变差的接口**：`f` 在 `[a,b]` 上的全变差等于 `f(b) − f(a)`；因此
   `f` 在每个闭区间上有界变差。

## 本库 Lean 承载

**（1）语义一致的正式公开承载（直接复用 Mathlib）**

- `Monotone f`（`f : ℝ → ℝ`）：Mathlib 的定义体就是教材量词，本库不另造同构 `def`。
- `MonotoneOn f s`：集合上的单调。
- `Function.leftLim f x` / `Function.rightLim f x`：左右极限。
- `Monotone.countable_not_continuousAt`：间断点至多可数（第二可数值域空间上的一般形式）。
- `Monotone.ae_hasDerivAt` / `Monotone.ae_differentiableAt`：a.e. 可导性的正式承载。
- `Monotone.stieltjesFunction`、`StieltjesFunction`、`StieltjesFunction.measure`：
  Lebesgue–Stieltjes 测度的正式承载。
- `BoundedVariationOn` / `eVariationOn` / `MonotoneOn.eVariationOn_eq`：有界变差侧的正式承载。

**（2）本库的教材展开／等价刻画**

- `monotone_iff_forall_le`、`monotoneOn_iff_forall_le`：`Iff.rfl` 形式的教材量词展开。
- `monotone_iff_monotoneOn_univ`：`Monotone f ↔ MonotoneOn f univ`。
- `continuousAt_iff_leftLim_eq_self_and_rightLim_eq_self`：把 Mathlib 的
  `Monotone.continuousAt_iff_leftLim_eq_rightLim`（只断言 `f(x⁻) = f(x⁺)`）补成教材含函数值的形式。
- `leftLim_le_self`、`self_le_rightLim`、`leftLim_le_rightLim_self`：教材夹逼
  `f(x⁻) ≤ f(x) ≤ f(x⁺)` 与跳跃非负。
- `countable_not_continuousAt_real`、`countable_jumpPoints`：把 Mathlib 的一般定理特化到
  `ℝ → ℝ` 并改写为跳跃点形式。
- `ae_hasDerivAt_volume`、`ae_differentiableAt_volume`：把 a.e. 滤子的测度写成显式 `volume`
  的教材陈述（Mathlib 版本由实例隐式给出测度）。

**（3）本库的桥（语义差异处才自建）**

- `leftLim_stieltjesFunction`：`leftLim (↑hf.stieltjesFunction) a = leftLim f a`
  （右连续化的左极限等于原函数的左极限）。Mathlib 没有这条；它是把
  `StieltjesFunction.measure_*` 的区间公式翻译回 `f` 自身的关键一步。
- `stieltjesFunction_eq_self`：`f` 右连续时 `hf.stieltjesFunction = ⟨f, hf, hrc⟩`，
  即右连续化不再改变 `f`；这是教材字面公式 `μ_f((a,b]) = f(b) − f(a)` 成立的充分条件。
- `stieltjesFunction_measure_Ioc / _Icc / _Ioo / _Ico / _singleton`、
  `stieltjesFunction_measure_Ioc_of_rightContinuous`：把 Stieltjes 测度的区间公式
  从 `StieltjesFunction` 载体翻译到单调函数 `f` 的左右极限。
- `monotone_eVariationOn_Icc`、`monotoneOn_boundedVariationOn_Icc`、
  `monotone_boundedVariationOn_Icc`：与同批有界变差条目的公开接口。

**（4）私有证明后端（未成为课程公开概念）**

- `Monotone.leftLim_eq_sSup` / `Monotone.rightLim_eq_sInf` / `Monotone.rightLim`：
  `leftLim_stieltjesFunction` 的证明用它们把左右极限化为 `sSup`/`sInf` 再夹逼，
  没有出现在本库任何公开声明的类型中。
- `Monotone.monotoneOn`、`Set.Countable.mono`、`csSup_le`、`le_csSup`、
  `ENNReal.ofReal_lt_top`：证明后端。
- `StieltjesFunction.instIsLocallyFiniteMeasure` 通过
  `stieltjesFunction_measure_isLocallyFinite` 成为教材命题，故此处不算纯后端。

## Lean 对照

以下签名逐字来自 `SandronesLibrary/RealAnalysis/MonotoneFunction.lean`
（`f : ℝ → ℝ`，命名空间 `SandronesLibrary.RealAnalysis.MonotoneFunction`）：

```lean
theorem monotone_iff_forall_le : Monotone f ↔ ∀ x y, x ≤ y → f x ≤ f y

theorem monotoneOn_iff_forall_le {s : Set ℝ} :
    MonotoneOn f s ↔ ∀ x ∈ s, ∀ y ∈ s, x ≤ y → f x ≤ f y

theorem monotone_iff_monotoneOn_univ : Monotone f ↔ MonotoneOn f univ

theorem leftLim_le_self (hf : Monotone f) (x : ℝ) : Function.leftLim f x ≤ f x

theorem self_le_rightLim (hf : Monotone f) (x : ℝ) : f x ≤ Function.rightLim f x

theorem leftLim_le_rightLim_self (hf : Monotone f) (x : ℝ) :
    Function.leftLim f x ≤ Function.rightLim f x

theorem continuousAt_iff_leftLim_eq_self_and_rightLim_eq_self (hf : Monotone f) (x : ℝ) :
    ContinuousAt f x ↔ Function.leftLim f x = f x ∧ Function.rightLim f x = f x

theorem countable_not_continuousAt_real (hf : Monotone f) :
    {x : ℝ | ¬ ContinuousAt f x}.Countable

theorem countable_jumpPoints (hf : Monotone f) :
    {x : ℝ | Function.leftLim f x < Function.rightLim f x}.Countable

theorem ae_hasDerivAt_volume (hf : Monotone f) :
    ∀ᵐ x ∂(volume : Measure ℝ),
      HasDerivAt f (hf.stieltjesFunction.measure.rnDeriv volume x).toReal x

theorem ae_differentiableAt_volume (hf : Monotone f) :
    ∀ᵐ x ∂(volume : Measure ℝ), DifferentiableAt ℝ f x

theorem stieltjesFunction_measure_isLocallyFinite (hf : Monotone f) :
    IsLocallyFiniteMeasure hf.stieltjesFunction.measure

theorem leftLim_stieltjesFunction (hf : Monotone f) (a : ℝ) :
    Function.leftLim (hf.stieltjesFunction : ℝ → ℝ) a = Function.leftLim f a

theorem stieltjesFunction_eq_self (hf : Monotone f)
    (hrc : ∀ x, ContinuousWithinAt f (Ici x) x) : hf.stieltjesFunction = ⟨f, hf, hrc⟩

theorem stieltjesFunction_measure_Ioc (hf : Monotone f) (a b : ℝ) :
    hf.stieltjesFunction.measure (Ioc a b) =
      ENNReal.ofReal (Function.rightLim f b - Function.rightLim f a)

theorem stieltjesFunction_measure_Icc (hf : Monotone f) (a b : ℝ) :
    hf.stieltjesFunction.measure (Icc a b) =
      ENNReal.ofReal (Function.rightLim f b - Function.leftLim f a)

theorem stieltjesFunction_measure_Ioo (hf : Monotone f) (a b : ℝ) :
    hf.stieltjesFunction.measure (Ioo a b) =
      ENNReal.ofReal (Function.leftLim f b - Function.rightLim f a)

theorem stieltjesFunction_measure_Ico (hf : Monotone f) (a b : ℝ) :
    hf.stieltjesFunction.measure (Ico a b) =
      ENNReal.ofReal (Function.leftLim f b - Function.leftLim f a)

theorem stieltjesFunction_measure_singleton (hf : Monotone f) (a : ℝ) :
    hf.stieltjesFunction.measure {a} =
      ENNReal.ofReal (Function.rightLim f a - Function.leftLim f a)

theorem stieltjesFunction_measure_Ioc_of_rightContinuous (hf : Monotone f)
    (hrc : ∀ x, ContinuousWithinAt f (Ici x) x) (a b : ℝ) :
    hf.stieltjesFunction.measure (Ioc a b) = ENNReal.ofReal (f b - f a)

theorem monotone_eVariationOn_Icc (hf : Monotone f) {a b : ℝ} (hab : a ≤ b) :
    eVariationOn f (Icc a b) = ENNReal.ofReal (f b - f a)

theorem monotoneOn_boundedVariationOn_Icc {a b : ℝ} (hab : a ≤ b)
    (hf : MonotoneOn f (Icc a b)) : BoundedVariationOn f (Icc a b)

theorem monotone_boundedVariationOn_Icc (hf : Monotone f) {a b : ℝ} (hab : a ≤ b) :
    BoundedVariationOn f (Icc a b)
```

## 证明思路

- `monotone_iff_forall_le`、`monotoneOn_iff_forall_le`：Mathlib 的定义体本身就是该 `∀` 量词，
  故证明是 `Iff.rfl`（与 `absolutelyContinuous_iff` 同一手法）。
- `monotone_iff_monotoneOn_univ`：正向用 `Monotone.monotoneOn univ`；反向在 `univ` 上取
  `mem_univ` 消去隶属假设。
- `leftLim_le_self` / `self_le_rightLim` / `leftLim_le_rightLim_self`：分别把
  `Monotone.leftLim_le` / `Monotone.le_rightLim` / `Monotone.leftLim_le_rightLim` 的
  `x ≤ y` 前提取成 `le_rfl`。
- `continuousAt_iff_leftLim_eq_self_and_rightLim_eq_self`：正向用
  `ContinuousAt.continuousWithinAt` 把连续降到 `Iic x`／`Ici x` 上，再用
  `ContinuousWithinAt.leftLim_eq` / `.rightLim_eq`；反向把 `f(x⁻) = f(x) = f(x⁺)` 串成
  `f(x⁻) = f(x⁺)`，套 Mathlib 的 `Monotone.continuousAt_iff_leftLim_eq_rightLim`。
  这一步用不到夹逼引理，但夹逼给出了该判据的教材含义。
- `countable_jumpPoints`：跳跃点（严格不等式）必是间断点——若连续则由
  `continuousAt_iff_leftLim_eq_rightLim` 得 `f(x⁻) = f(x⁺)`，与 `ne_of_lt` 矛盾；
  再用 `Set.Countable.mono` 归约到 `countable_not_continuousAt_real`。
- `ae_hasDerivAt_volume`：直接取 Mathlib `Monotone.ae_hasDerivAt`（其 a.e. 滤子的测度是
  实例给出的 `volume`），本库只把测度写成显式；`ae_differentiableAt_volume` 再用
  `HasDerivAt.differentiableAt`。
- `stieltjesFunction_measure_isLocallyFinite`：类型类搜索命中
  `StieltjesFunction.instIsLocallyFiniteMeasure`。
- `leftLim_stieltjesFunction`：把 `⇑hf.stieltjesFunction` 用 `change` 化成
  `Function.rightLim f`，再用 `Monotone.leftLim_eq_sSup hf.rightLim` 与 `hf.leftLim_eq_sSup`
  把目标化为两个 `sSup` 的等式；两个方向都用 `csSup_le`：
  - `≤`：对 `y < a`，取 `z ∈ (y, a)`（`exists_between`），
    `f(y⁺) ≤ f z ≤ f(a⁻)`；
  - `≥`：对 `y < a`，`f y ≤ f(y⁺) ≤ sSup (f(·⁺) '' Iio a)`。
- `stieltjesFunction_eq_self`：`StieltjesFunction.ext` 后逐点用
  `ContinuousWithinAt.rightLim_eq`（`f(x⁺) = f(x)`）。
- 五个区间测度公式：`StieltjesFunction.measure_Ioc` 等给出对 `StieltjesFunction` 自身的公式，
  再用 `Monotone.stieltjesFunction_eq`（`g x = f(x⁺)`）与 `leftLim_stieltjesFunction`
  把 `g` 的左右极限换回 `f` 的左右极限。
- `monotone_eVariationOn_Icc`：`MonotoneOn.eVariationOn_eq` 在 `s = univ`、
  端点 `a ≤ b` 时给出 `eVariationOn f (univ ∩ Icc a b) = ofReal (f b - f a)`，`simpa` 消去 `univ ∩`。
- `monotoneOn_boundedVariationOn_Icc`：`BoundedVariationOn f s` 即 `eVariationOn f s ≠ ∞`；
  由上式右端 `ENNReal.ofReal_lt_top` 得有限。
- `monotone_boundedVariationOn_Icc`：`hf.monotoneOn (Icc a b)` 后用上一条。

## 依赖（人话版）

- 库内前提：`real-analysis.calculus.ftc`（RA-F5 与既有 Riemann/FTC 接口的坐标）、
  `real-analysis.measure.def`（测度与 a.e. 语言）。本 Entry 不引用库内新定理，
  全部结论建立在 Mathlib 承载之上。
- Mathlib：`Monotone` 及其 `.leftLim_le/.le_rightLim/.leftLim_le_rightLim/.leftLim_eq_sSup/
  .rightLim_eq_sInf/.rightLim/.monotoneOn/.continuousAt_iff_leftLim_eq_rightLim/
  .countable_not_continuousAt/.ae_hasDerivAt/.ae_differentiableAt/.stieltjesFunction/
  .stieltjesFunction_eq`；`ContinuousWithinAt.leftLim_eq/.rightLim_eq`；
  `StieltjesFunction.measure/.measure_Ioc/.measure_Icc/.measure_Ioo/.measure_Ico/
  .measure_singleton/.instIsLocallyFiniteMeasure`；`Measure.rnDeriv`；
  `MonotoneOn.eVariationOn_eq`；`BoundedVariationOn`、`eVariationOn`。
- 文献：Folland, *Real Analysis*, 2nd ed., §3.5（单调函数、Lebesgue–Stieltjes 测度）。

## 应用与陷阱

- **a.e. 不是逐点**：`ae_hasDerivAt_volume` / `ae_differentiableAt_volume` 都是
  `∀ᵐ x ∂volume` 形式的几乎处处命题。单调函数的不可导点集可以是**稠密**的：取
  `f x = ∑_{q_n < x} 2^{-n}`（`q_n` 枚举有理数），它在每个跳跃点（即每个有理点）不可导，
  而跳跃点集稠密；但该集合是至多可数的，故仍是零测集。所以把这两条读成“单调函数处处可导”
  是错的，自然语言陈述必须带“几乎处处”。
- **跳跃可数依赖第二可数**：`Monotone.countable_not_continuousAt` 的假设里有
  `SecondCountableTopology β`；本库只把它特化到 `β = ℝ`。一般拓扑空间上没有这条结论。
- **Stieltjes 测度是右连续化的测度**：`Monotone.stieltjesFunction` 的定义体是
  `x ↦ f(x⁺)`，不是 `f` 本身。所以 `μ_f((a,b]) = f(b⁺) − f(a⁺)`，只有在 `f` 右连续时才等于
  `f(b) − f(a)`（`stieltjesFunction_measure_Ioc_of_rightContinuous`）。把教材里默认右连续的
  公式无条件搬到任意单调函数上是常见错误。
- **`rnDeriv` 取值 `ℝ≥0∞`**：`hf.stieltjesFunction.measure.rnDeriv volume x` 是
  `ℝ≥0∞` 值，与实值导数之间差一个 `ENNReal.toReal`；`toReal` 在 `∞` 处取 0，故
  `ae_hasDerivAt_volume` 的右端要按 `toReal` 理解（RN 导数的 a.e. 有限性由 `σ`-有限性给出）。
- **单点测度是跳跃量**：`μ_f({a}) = f(a⁺) − f(a⁻) ≥ 0`；这给出“Stieltjes 测度的原子部分
  = 跳跃”的对应，也是把单调函数与有界变差（Jordan 分解）连起来的接口。
- **区间端点约定**：`eVariationOn f (Icc a b)` 的公式在本库要求 `a ≤ b`（教材的区间约定）；
  `a > b` 时 `Icc a b = ∅`、变差为 0，同批 `real-analysis.bounded-variation` 用 `uIcc` 处理
  一般情形。

## 诚实边界

1. **强度分级**：本 Entry 对 Folland §3.5 的交付是
   - *教材强度*：夹逼与连续判据、跳跃点至多可数、五个区间测度公式、单点跳跃公式、
     右连续情形的 `f(b) − f(a)`、区间全变差公式；
   - *bridge*：`leftLim_stieltjesFunction`、`stieltjesFunction_eq_self`、
     `ae_hasDerivAt_volume`（把 a.e. 导数与 Stieltjes 测度的 RN 导数接起来）、
     `monotoneOn_boundedVariationOn_Icc`（通向有界变差）；
   - *foundation*：`monotone_iff_forall_le`、`monotoneOn_iff_forall_le`、
     `monotone_iff_monotoneOn_univ`（纯量词展开）。
2. **a.e. 边界**：`ae_hasDerivAt_volume` 与 `ae_differentiableAt_volume` 是 **a.e. 命题**；
   本 Entry 不证明 Lebesgue 微分定理本身（RA-F4），也不含 FTC 的 a.e. 版本（RA-F6）。
   Mathlib 已证的 `Monotone.ae_hasDerivAt` 是这两条的上游承载。
3. **可数性边界**：「间断点至多可数」是第二可数值域空间上的结论
   （`Monotone.countable_not_continuousAt`），本库只做 `ℝ → ℝ` 特化。
4. **测度与积分类型**：`volume`（`ℝ` 上的 Lebesgue 测度）、`StieltjesFunction.measure`
   （`ℝ` 上局部有限的 Borel 测度）、`Measure.rnDeriv`（取值 `ℝ≥0∞` 的 RN 导数，本库取
   `ENNReal.toReal`）；区间测度取值 `ℝ≥0∞`，用 `ENNReal.ofReal` 嵌入实数增量。
5. **未做**：跳跃量的可和性估计（`∑_x (f(x⁺) − f(x⁻)) ≤ f(b) − f(a)`）未单独立条；
   `StieltjesFunction.length_Ioc` 给出区间长度公式，可作为该估计的入口，但**本库没有验证
   这条推导**。单调函数的不可导点集在零测度之外的更精细结构（如跳跃部分与奇异部分的分解）
   留给 `real-analysis.bounded-variation` 与 RA-F6。
6. **接口重叠披露**：同批 `real-analysis.bounded-variation`（另一 worker 的文件
   `SandronesLibrary/RealAnalysis/BoundedVariation.lean`）已给出 `uIcc` 形式
   `monotoneOn_boundedVariationOn_uIcc`；本文件的 `Icc`（`a ≤ b`）形式是教材区间陈述，
   两者命名空间不同、互不冲突，但数学上后者是前者的特化。
7. **命名空间**：本 Entry 的声明放在库自己的命名空间
   `SandronesLibrary.RealAnalysis.MonotoneFunction` 下，不向 Mathlib 的 `Monotone`
   命名空间注入新名字（避免与 Mathlib 后续版本撞名）；因此下游以
   `SandronesLibrary.RealAnalysis.MonotoneFunction.<name>` 全名或 `open` 后使用，
   不能用 `hf.<name>` 点记法访问本库新增引理。
8. **公理画像**：23 条公开声明全部只依赖 `[propext, Classical.choice, Quot.sound]`，
   无 `sorryAx`；其中 `Classical.choice` 来自 `ℝ` 序结构实例本身
   （Playbook §3.3 的结构性底线），不是本 Entry 的数学内容。
