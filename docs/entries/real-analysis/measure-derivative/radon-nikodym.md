---
id: real-analysis.measure-derivative.radon-nikodym
family: real-analysis.measure-derivative
variant: tao
kind: theorem
state: verified
title: Radon–Nikodym 定理与测度导数
summary: 绝对连续测度 μ ≪ ν 的 Radon–Nikodym 导数 dμ/dν 的存在唯一性、由密度构造测度、积分换测度、链式与互逆边界，以及有符号测度桥
premises: [real-analysis.measure-derivative.absolute-continuity, real-analysis.measure-derivative.mutually-singular, real-analysis.measure-derivative.lebesgue-decomposition]
mathlib: [Measure.rnDeriv, Measure.withDensity, Measure.withDensityᵥ, Measure.HaveLebesgueDecomposition, Measure.real, Measure.withDensity_rnDeriv_eq, Measure.absolutelyContinuous_iff_withDensity_rnDeriv_eq, Measure.rnDeriv_pos, Measure.rnDeriv_self, Measure.rnDeriv_withDensity, Measure.rnDeriv_withDensity_left, Measure.rnDeriv_withDensity_right, Measure.inv_rnDeriv, Measure.rnDeriv_mul_rnDeriv, Measure.setLIntegral_rnDeriv, Measure.lintegral_rnDeriv, Measure.setIntegral_toReal_rnDeriv, Measure.integral_toReal_rnDeriv, Measure.rnDeriv_lt_top, Measure.rnDeriv_ne_top, SignedMeasure.absolutelyContinuous_iff_withDensityᵥ_rnDeriv_eq]
provenance:
  source_type: book
  ref: "folland-real-analysis-1999"
---

# real-analysis.measure-derivative.radon-nikodym

- **家族**: `real-analysis.measure-derivative`
- **变体**: tao
- **状态**: verified
- **一句话**: 在 `σ`-有限（更一般地存在 Lebesgue 分解）假设下，`μ ≪ ν` 等价于存在 `ν`-a.e.
  唯一的密度 `dμ/dν` 使 `ν.withDensity (μ.rnDeriv ν) = μ`，并给出积分换测度、乘密度链式
  `rnDeriv_mul_rnDeriv` 与互逆边界 `inv_rnDeriv`。

## 直觉

绝对连续（见前提 Entry）回答的是“`ν` 忽略的集合 `μ` 是否也忽略”。Radon–Nikodym 定理
回答的是更强的定量问题：**能不能用一个密度函数把 `μ` 写成关于 `ν` 的加权测度？**
Folland《Real Analysis》第二版 §3.2 的答案是：只要 `μ ≪ ν` 且两个测度都足够“驯良”
（`σ`-有限），就存在一个非负可测函数 `f = dμ/dν`，使得

`μ(E) = ∫_E f dν`

对一切可测 `E` 成立；这个 `f` 在 `ν`-a.e. 意义下唯一。函数 `f` 就叫 `μ` 关于 `ν` 的
**Radon–Nikodym 导数**（测度导数）。

直观上，`f` 是“逐点的质量比”。教材把存在性定理写成“存在密度”，Mathlib 则把密度直接实现为
`Measure.rnDeriv`，并把定理陈述为**测度等式** `ν.withDensity (μ.rnDeriv ν) = μ`。本 Entry
的 Lean 内容就是把这套承载与教材语言对齐，并补上唯一性/正性、链式、互逆、积分换测度这些
实际使用中反复出现的边界。

## 陈述（教材记号）

设 `(X, M)` 为可测空间，`μ, ν` 为 `X` 上的测度，且存在 Lebesgue 分解假设
（`σ`-有限时自动成立）。

1. **存在性（RN 定理）**：`μ ≪ ν ⟹` 存在非负可测 `f` 使 `ν.withDensity f = μ`。
2. **iff 形式**：`μ ≪ ν ⟺ ν.withDensity (μ.rnDeriv ν) = μ`；反方向即密度测度绝对连续。
3. **`μ`-a.e. 唯一性**：若 `ν.withDensity f = μ = ν.withDensity g`，则 `f = g` 在 `ν`-a.e.
   意义下成立（由 `rnDeriv_withDensity` 给出：密度测度的导数还原密度）。
4. **正性**：`μ ≪ ν ⟹ dμ/dν > 0` 在 `μ`-a.e. 意义下成立。
5. **自导数**：`dμ/dμ = 1` 在 `μ`-a.e. 意义下成立（`μ` 需 `σ`-有限）。
6. **密度测度**：`d(ν.withDensity f)/dν = f` 在 `ν`-a.e. 意义下成立。
7. **乘密度链式**：`d(μ.withDensity f)/dν = f · dμ/dν`（`ν`-a.e.）。
8. **右端换密度**：`dμ/d(ν.withDensity f) = f⁻¹ · dμ/dν`（`ν`-a.e.，`f ≠ 0`）。
9. **互逆**：`(dμ/dν)⁻¹ = dν/dμ` 在 `μ`-a.e. 意义下成立。
10. **链式法则**：`(dμ/dν)(dν/dκ) = dμ/dκ` 在 `κ`-a.e. 意义下成立。
11. **积分换测度（lintegral）**：`∫⁻_E dμ/dν dν = μ(E)`。
12. **积分换测度（Bochner）**：`∫_E (dμ/dν).toReal dν = μ.real(E)`。
13. **a.e. 有限性**：`σ`-有限 `μ` 时 `dμ/dν < ⊤`（即 `≠ ⊤`）在 `ν`-a.e. 意义下成立。
14. **有符号测度桥**：`s ≪ᵥ μ.toENNRealVectorMeasure ⟺ μ.withDensityᵥ (s.rnDeriv μ) = s`。

**等式类型务必分清**：第 1、2 条是**测度相等**（`Measure α` 上的等式）；第 3–10 条是
**a.e. 等式**（`=ᵐ[ν]`）；第 11–13 条是 `ℝ≥0∞` / `ℝ` 中的（积分）等式。

## 本库 Lean 承载

- **正式公开承载**：`Measure.rnDeriv`（记号 `μ.rnDeriv ν`）与 `Measure.withDensity`、
  `Measure.withDensityᵥ`。Mathlib 已把 RN 定理证明为
  `Measure.withDensity_rnDeriv_eq`，本库直接复用，不新造导数结构。
- **存在性／iff**：`radonNikodym`、`absolutelyContinuous_iff_withDensity_rnDeriv_eq`。
- **唯一性载体**：`rnDeriv_withDensity`（密度测度的导数还原密度），是“`ν`-a.e. 唯一”的实际内容。
- **链式与互逆**：`rnDeriv_mul_rnDeriv`、`inv_rnDeriv`、`rnDeriv_withDensity_left/right`。
- **积分换测度**：`setLIntegral_rnDeriv`、`lintegral_rnDeriv`（`ℝ≥0∞`）；
  `setIntegral_toReal_rnDeriv`、`integral_toReal_rnDeriv`（`ℝ`，靠 `toReal`）。
- **有符号测度桥**：`signedMeasure_absolutelyContinuous_iff_withDensityᵥ_rnDeriv_eq`。

## Lean 对照

以下签名逐字来自 `SandronesLibrary/RealAnalysis/MeasureDerivativeRadonNikodym.lean`
（`α : Type*`，`[MeasurableSpace α]`，命名空间
`SandronesLibrary.RealAnalysis.MeasureDerivative`）：

```lean
theorem radonNikodym {μ ν : Measure α} [μ.HaveLebesgueDecomposition ν] (h : μ ≪ ν) :
    ν.withDensity (μ.rnDeriv ν) = μ

theorem absolutelyContinuous_iff_withDensity_rnDeriv_eq {μ ν : Measure α}
    [μ.HaveLebesgueDecomposition ν] :
    μ ≪ ν ↔ ν.withDensity (μ.rnDeriv ν) = μ

theorem rnDeriv_pos {μ ν : Measure α} [μ.HaveLebesgueDecomposition ν] (h : μ ≪ ν) :
    ∀ᵐ x ∂μ, 0 < μ.rnDeriv ν x

theorem rnDeriv_self (μ : Measure α) [SigmaFinite μ] :
    μ.rnDeriv μ =ᵐ[μ] fun _ => 1

theorem rnDeriv_withDensity (ν : Measure α) [SigmaFinite ν] {f : α → ℝ≥0∞}
    (hf : Measurable f) :
    (ν.withDensity f).rnDeriv ν =ᵐ[ν] f

theorem rnDeriv_withDensity_left {μ ν : Measure α} [SigmaFinite μ] [SigmaFinite ν]
    {f : α → ℝ≥0∞} (hf : AEMeasurable f ν) (hfin : ∀ᵐ x ∂μ, f x ≠ ⊤) :
    (μ.withDensity f).rnDeriv ν =ᵐ[ν] fun x => f x * μ.rnDeriv ν x

theorem rnDeriv_withDensity_right (μ ν : Measure α) [SigmaFinite μ] [SigmaFinite ν]
    {f : α → ℝ≥0∞} (hf : AEMeasurable f ν) (hne : ∀ᵐ x ∂ν, f x ≠ 0)
    (hfin : ∀ᵐ x ∂ν, f x ≠ ⊤) :
    μ.rnDeriv (ν.withDensity f) =ᵐ[ν] fun x => (f x)⁻¹ * μ.rnDeriv ν x

theorem inv_rnDeriv {μ ν : Measure α} [SigmaFinite μ] [SigmaFinite ν] (h : μ ≪ ν) :
    (μ.rnDeriv ν)⁻¹ =ᵐ[μ] ν.rnDeriv μ

theorem rnDeriv_mul_rnDeriv {μ ν κ : Measure α} [SigmaFinite μ] [SigmaFinite ν] [SigmaFinite κ]
    (h : μ ≪ ν) :
    μ.rnDeriv ν * ν.rnDeriv κ =ᵐ[κ] μ.rnDeriv κ

theorem setLIntegral_rnDeriv {μ ν : Measure α} [μ.HaveLebesgueDecomposition ν] [SFinite ν]
    (h : μ ≪ ν) (s : Set α) :
    ∫⁻ x in s, μ.rnDeriv ν x ∂ν = μ s

theorem lintegral_rnDeriv {μ ν : Measure α} [μ.HaveLebesgueDecomposition ν] (h : μ ≪ ν) :
    ∫⁻ x, μ.rnDeriv ν x ∂ν = μ Set.univ

theorem setIntegral_toReal_rnDeriv {μ ν : Measure α} [SigmaFinite μ] [SigmaFinite ν]
    (h : μ ≪ ν) (s : Set α) :
    ∫ x in s, (μ.rnDeriv ν x).toReal ∂ν = μ.real s

theorem integral_toReal_rnDeriv {μ ν : Measure α} [SigmaFinite μ] [SigmaFinite ν]
    (h : μ ≪ ν) :
    ∫ x, (μ.rnDeriv ν x).toReal ∂ν = μ.real Set.univ

theorem rnDeriv_lt_top (μ ν : Measure α) [SigmaFinite μ] :
    ∀ᵐ x ∂ν, μ.rnDeriv ν x < ⊤

theorem rnDeriv_ne_top (μ ν : Measure α) [SigmaFinite μ] :
    ∀ᵐ x ∂ν, μ.rnDeriv ν x ≠ ⊤

theorem signedMeasure_absolutelyContinuous_iff_withDensityᵥ_rnDeriv_eq (s : SignedMeasure α)
    (μ : Measure α) [SigmaFinite μ] :
    s ≪ᵥ μ.toENNRealVectorMeasure ↔ μ.withDensityᵥ (s.rnDeriv μ) = s
```

## 证明思路

- `radonNikodym`／`absolutelyContinuous_iff_withDensity_rnDeriv_eq`：直接引用 Mathlib
  `Measure.withDensity_rnDeriv_eq` 与 `Measure.absolutelyContinuous_iff_withDensity_rnDeriv_eq`。
  它们的证明属于私有后端（Lebesgue 分解 + `lintegral` 稠密论证），本库不展开，只作教材命名。
- `rnDeriv_pos`：引用 `Measure.rnDeriv_pos`。数学上由 `μ ≪ ν` 与 RN 等式推出导数不能在
  `μ`-正集上取 `0`。
- `rnDeriv_self`：引用 `Measure.rnDeriv_self`；由 `μ.withDensity 1 = μ` 与密度还原。
- `rnDeriv_withDensity`：引用 `Measure.rnDeriv_withDensity`；这是“密度测度的导数 = 原密度”，
  即唯一性的实质内容（两次换密度得到同一个测度则密度 `ν`-a.e. 相等）。
- `rnDeriv_withDensity_left/right`：引用同名 Mathlib 定理，属乘密度链式；`left` 假设 `f`
  在 `μ`-a.e. 有限，`right` 要求 `f` 在 `ν`-a.e. 非零且有限，才能取逆 `f⁻¹`。
- `inv_rnDeriv`：引用 `Measure.inv_rnDeriv`；由链式 `dμ/dν · dν/dμ = 1`（`μ`-a.e.）取逆。
- `rnDeriv_mul_rnDeriv`：引用 `Measure.rnDeriv_mul_rnDeriv`；教材链式法则的 a.e. 形式。
- `setLIntegral_rnDeriv`／`lintegral_rnDeriv`：引用 Mathlib 同名结论；对 `μ ≪ ν` 用 RN 等式
  把 `μ s` 展开为 `∫⁻_s dμ/dν dν`。
- `setIntegral_toReal_rnDeriv`／`integral_toReal_rnDeriv`：`toReal` 版本，引用 Mathlib 同名结论；
  前提升级为 `SigmaFinite μ`、`SigmaFinite ν`（需要 `μ.real` 与 a.e. 有限性）。
- `rnDeriv_lt_top`／`rnDeriv_ne_top`：引用 `Measure.rnDeriv_lt_top`／`Measure.rnDeriv_ne_top`，
  在 `σ`-有限 `μ` 下给出导数的 a.e. 有限性。
- `signedMeasure_absolutelyContinuous_iff_withDensityᵥ_rnDeriv_eq`：引用
  `SignedMeasure.absolutelyContinuous_iff_withDensityᵥ_rnDeriv_eq`，把 RN 桥接到 RA-F1 的
  向量测度绝对连续 `≪ᵥ` 与 `withDensityᵥ`。

## 依赖（人话版）

- 库内前提：
  - `real-analysis.measure-derivative.absolute-continuity`（`μ ≪ ν` 的教材定义、量词展开与
    密度测度方向）；
  - `real-analysis.measure-derivative.mutually-singular`（互奇异 `⟂ₘ`，Lebesgue 分解的另一半）；
  - `real-analysis.measure-derivative.lebesgue-decomposition`（Lebesgue 分解，RN 定理的
    存在性前提 `μ.HaveLebesgueDecomposition ν` 的教材来源）。
- Mathlib：`Measure.rnDeriv`、`Measure.withDensity`、`Measure.withDensityᵥ`、
  `Measure.HaveLebesgueDecomposition`、`Measure.real`，以及上文 Lean 对照中引用的
  `Measure.withDensity_rnDeriv_eq`、`Measure.absolutelyContinuous_iff_withDensity_rnDeriv_eq`、
  `Measure.rnDeriv_pos/_self/_withDensity/_withDensity_left/_withDensity_right`、
  `Measure.inv_rnDeriv`、`Measure.rnDeriv_mul_rnDeriv`、`Measure.setLIntegral_rnDeriv`、
  `Measure.lintegral_rnDeriv`、`Measure.setIntegral_toReal_rnDeriv`、
  `Measure.integral_toReal_rnDeriv`、`Measure.rnDeriv_lt_top`、`Measure.rnDeriv_ne_top`、
  `SignedMeasure.absolutelyContinuous_iff_withDensityᵥ_rnDeriv_eq`。这些在 handoff 中归为
  “语义一致的正式承载／私有证明后端／桥”。

## 应用与陷阱

- **`σ`-有限假设不可省**：`SigmaFinite`（更一般地 `HaveLebesgueDecomposition`）是 RN 定理的
  实质前提。链式 `rnDeriv_mul_rnDeriv`、互逆 `inv_rnDeriv`、密度链式
  `rnDeriv_withDensity_left/right`、`toReal` 积分换测度都显式要求两个或三个测度 `σ`-有限。
  没有它，`rnDeriv` 仍被定义（Mathlib 取 `0` 之类退化值），但上面的等式不再成立。
- **测度相等 vs. a.e. 相等**：`radonNikodym`／`absolutelyContinuous_iff_withDensity_rnDeriv_eq`
  是 `Measure α` 上的**相等**；而 `rnDeriv_self`、`rnDeriv_withDensity`、`inv_rnDeriv`、
  `rnDeriv_mul_rnDeriv` 是 `=ᵐ[·]` 的 **a.e. 相等**。把后者当成处处相等是错误的，
  因为 `rnDeriv` 只由 `ν`-零集外决定。
- **`rnDeriv` 取值 `ℝ≥0∞`**：导数是扩展非负实数，可能取 `⊤`。要进入 Bochner 积分
  （`∫ ... ∂ν`）必须先 `toReal`，并把 `μ s` 换成 `μ.real s`；`rnDeriv_lt_top`／
  `rnDeriv_ne_top` 给出 `σ`-有限下 `ν`-a.e. 有限，保证 `toReal` 不会把无穷当有限处理。
- **正性只在 `μ`-a.e. 成立**：`rnDeriv_pos` 是 `∀ᵐ x ∂μ`，不是 `∀ᵐ x ∂ν`；在 `μ`-零集上
  导数无约束。与之相对，`rnDeriv_ne_top` 是关于 `ν` 的 a.e. 陈述。
- **唯一性是 a.e. 唯一**：`rnDeriv_withDensity` 只说 `ν.withDensity f` 的导数 `ν`-a.e. 等于 `f`；
  两个密度若只在 `ν`-零集上不同，会给出同一个测度，故不能期望逐点唯一。
- **有符号测度只给桥**：`signedMeasure_absolutelyContinuous_iff_withDensityᵥ_rnDeriv_eq`
  把 RN 定理接到 RA-F1 的 `SignedMeasure`／向量测度框架（`≪ᵥ` / `withDensityᵥ`），
  本 Entry **不展开**该桥的证明，也不处理复测度或取值于一般 Banach 空间的向量测度。
- **边界**：本 Entry 属于 RA-F2（Folland §3.2），只做 RN 定理与测度导数本身；
  不涉及 RA-F3–RA-F6 的后续内容（如条件期望、Lebesgue 分解的唯一性细节等）。
