---
id: real-analysis.measure-derivative.absolute-continuity
family: real-analysis.measure-derivative
variant: tao
kind: theorem
state: verified
title: 测度的绝对连续
summary: 测度绝对连续 μ ≪ ν 的教材量词展开、可测集形式、代数性质、a.e. 滤子桥与密度测度方向
premises: []
mathlib: [Measure.AbsolutelyContinuous, Measure.AbsolutelyContinuous.mk, Measure.absolutelyContinuous_of_le, Measure.absolutelyContinuous_of_eq, Measure.AbsolutelyContinuous.zero, Measure.AbsolutelyContinuous.smul_right, Measure.absolutelyContinuous_smul, Measure.absolutelyContinuous_zero_iff, Measure.ae_le_iff_absolutelyContinuous, Measure.AbsolutelyContinuous.ae_eq, Measure.AbsolutelyContinuous.null_mono, Measure.AbsolutelyContinuous.pos_mono, MeasureTheory.withDensity_absolutelyContinuous]
provenance:
  source_type: book
  ref: "folland-real-analysis-1999"
---

# real-analysis.measure-derivative.absolute-continuity

- **家族**: `real-analysis.measure-derivative`
- **变体**: tao
- **状态**: verified
- **一句话**: 测度 `μ` 关于 `ν` 绝对连续（记 `μ ≪ ν`）等价于“`ν` 的零测集都是 `μ` 的零测集”，
  这条量词与几乎处处滤子单调性 `ae μ ≤ ae ν` 等价，并给出密度测度 `μ.withDensity f ≪ μ` 的方向。

## 直觉

绝对连续回答的问题是：“`ν` 认为可以忽略的集合，`μ` 是否也认为可以忽略？”Folland《Real
Analysis》第二版 §3.2 把两个测度的比较化归为**零测集比较**：只要 `ν(E) = 0` 蕴含 `μ(E) = 0`，
就记 `μ ≪ ν`。它比“`μ ≤ ν`”弱（后者逐集比较大小），但正是 Radon–Nikodym 定理中“`μ` 可以被
`ν` 的密度函数“重建”所要求的唯一前提。

绝对连续还有一个等价的滤子表述：`ν`-几乎处处成立的性质必 `μ`-几乎处处成立。它把测度层的
比较翻译成“可忽略性”层的包含关系，是后续 a.e. 唯一性论证的常用语言。反方向（密度测度一侧）
`μ.withDensity f ≪ μ` 是 Radon–Nikodym 定理“⟸”方向的入口。

## 陈述（教材记号）

设 `(X, M)` 为可测空间，`μ, ν` 为 `X` 上的测度。

1. **定义（Folland §3.2）**：`μ ≪ ν :⟺ ∀ E, ν(E) = 0 → μ(E) = 0`。
2. **可测集形式**：等价于“每个可测零测集 `E`（`ν(E) = 0`）满足 `μ(E) = 0`”。
3. **更大测度**：`μ ≤ ν ⟹ μ ≪ ν`；特别地 `μ = ν ⟹ μ ≪ ν`。
4. **自反与零测度**：`μ ≪ μ`；`0 ≪ ν`。
5. **传递性**：`μ₁ ≪ μ₂`、`μ₂ ≪ μ₃` 蕴含 `μ₁ ≪ μ₃`。
6. **加法**：`μ₁ ≪ ν₁`、`μ₂ ≪ ν₂` 蕴含 `μ₁ + μ₂ ≪ ν₁ + ν₂`；固定一端也有 `add_left`／`add_right`。
7. **标量**：`c ≠ 0` 时 `μ ≪ c • μ`；`μ ≪ ν` 时 `μ ≪ c • ν`。
8. **零测度刻画**：`μ ≪ 0 ↔ μ = 0`。
9. **a.e. 滤子桥**：`μ ≪ ν ↔ ae μ ≤ ae ν`。
10. **零集／正集单调性**：`μ ≪ ν` 时 `ν(E) = 0 ⟹ μ(E) = 0`，且 `0 < μ(E) ⟹ 0 < ν(E)`。
11. **密度测度方向**：任意 `f : X → [0, +∞]` 有 `μ.withDensity f ≪ μ`。

## 本库 Lean 承载

- **正式公开承载**：`MeasureTheory.Measure.AbsolutelyContinuous μ ν : Prop`（记号 `μ ≪ ν`，
  来自 `open scoped MeasureTheory`）。Mathlib 的定义与教材量词逐字一致，故直接复用。
- **术语说明**：本文件把该谓词称为 `MeasureDerivative` 家族下的“绝对连续”，不新造同构 `def`。
- **本库桥／教材展开**：
  - `absolutelyContinuous_iff`：`Iff.rfl` 形式的量词展开；
  - `absolutelyContinuous_iff_measurable`：只对可测集陈述的等价形式（用 `Measure.AbsolutelyContinuous.mk`）；
  - `absolutelyContinuous_iff_ae_le`：绝对连续 ↔ `ae μ ≤ ae ν` 的滤子桥；
  - `withDensity_absolutelyContinuous`：密度测度方向的入口。

## Lean 对照

以下签名逐字来自 `SandronesLibrary/RealAnalysis/MeasureDerivativeAbsoluteContinuity.lean`
（`α : Type*`，`[MeasurableSpace α]`，命名空间 `SandronesLibrary.RealAnalysis.MeasureDerivative`）：

```lean
theorem absolutelyContinuous_iff (μ ν : Measure α) :
    μ ≪ ν ↔ ∀ s : Set α, ν s = 0 → μ s = 0

theorem absolutelyContinuous_iff_measurable (μ ν : Measure α) :
    μ ≪ ν ↔ ∀ s : Set α, MeasurableSet s → ν s = 0 → μ s = 0

theorem absolutelyContinuous_of_le (h : μ ≤ ν) : μ ≪ ν

theorem absolutelyContinuous_trans (h₁ : μ ≪ ν) (h₂ : ν ≪ ν') : μ ≪ ν'

theorem absolutelyContinuous_add (h₁ : μ ≪ ν) (h₂ : ν₁ ≪ ν₂) : μ + ν₁ ≪ ν + ν₂

theorem absolutelyContinuous_zero_iff : μ ≪ 0 ↔ μ = 0

theorem absolutelyContinuous_iff_ae_le : μ ≪ ν ↔ ae μ ≤ ae ν

theorem absolutelyContinuous_null_mono (h : μ ≪ ν) {t : Set α} (ht : ν t = 0) : μ t = 0

theorem absolutelyContinuous_pos_mono (h : μ ≪ ν) {t : Set α} (ht : 0 < μ t) : 0 < ν t

theorem withDensity_absolutelyContinuous (μ : Measure α) (f : α → ℝ≥0∞) :
    μ.withDensity f ≪ μ
```

其余：`absolutelyContinuous_of_eq`、`absolutelyContinuous_refl`、`absolutelyContinuous_zero`、
`absolutelyContinuous_add_left`、`absolutelyContinuous_add_right`、`absolutelyContinuous_smul`、
`absolutelyContinuous_smul_right`、`absolutelyContinuous_ae_eq`。

## 证明思路

- `absolutelyContinuous_iff`：Mathlib 的定义体本身就是该 `∀` 量词，故证明是 `Iff.rfl`。
- `absolutelyContinuous_iff_measurable`：正向由 `h hs`（忽略可测性假设）得到；反向用
  `Measure.AbsolutelyContinuous.mk`，它接受“可测集版”量词并构造谓词。
- 代数性质（`of_le`、`of_eq`、`refl`、`zero`、`trans`、`add*`、`smul*`、`zero_iff`）：
  教材中都是逐集定义的直接推论，本库引用 Mathlib 已证版本，属私有证明后端。
- `absolutelyContinuous_iff_ae_le`：取 Mathlib `Measure.ae_le_iff_absolutelyContinuous`
  （其内容是 `ae μ ≤ ae ν ↔ μ ≪ ν`）的对称形式。
- `absolutelyContinuous_null_mono`／`pos_mono`：`null_mono` 就是定义的一次应用；
  `pos_mono` 是其逆否形式（`0 < μ t` 与 `μ t ≠ 0` 互推）。
- `withDensity_absolutelyContinuous`：`μ.withDensity f` 在 `ν`-零测集上为零，由
  `lintegral_withDensity` 与零测集上积分为零得到；本库引用 Mathlib 结论。

## 依赖（人话版）

- 库内前提：无（本 Entry 是 RA-F2 家族的定义入口）。
- Mathlib：`Measure.AbsolutelyContinuous` 及其 `.mk/.refl/.zero/.trans/.add*/.smul*`、
  `Measure.absolutelyContinuous_of_le/_of_eq/_zero_iff/_smul`、
  `Measure.ae_le_iff_absolutelyContinuous`、`MeasureTheory.withDensity_absolutelyContinuous`。
  这些在 handoff 中归为“语义一致的正式承载／私有证明后端”。

## 应用与陷阱

- **`≪` 不是 `≤`**：`μ ≤ ν ⟹ μ ≪ ν`，反之不成立。取 `μ = 2 • volume`、`ν = volume`：
  则 `μ ≪ ν` 成立（`ν s = 0` 时 `μ s = 2 · 0 = 0`），但 `μ ≤ ν` 不成立——任何满足
  `ν s > 0` 的 `s` 上都有 `μ s = 2 ν s > ν s`。把两者对调，`(volume, 2 • volume)` 给出
  `μ ≪ ν` 而 `μ ≥ ν` 不成立（此时 `μ ≤ ν` 反而成立）。所以 `≪` 既不蕴含 `≤` 也不蕴含 `≥`。
  本 Entry 的 `absolutelyContinuous_of_le` 只是单向桥。
- **零测度方向**：`0 ≪ ν` 恒成立，但 `ν ≪ 0` 只在 `ν = 0` 时成立，见
  `absolutelyContinuous_zero_iff`。
- **非可测集**：Mathlib 的 `Measure` 在不可测集上取外测度，所以定义量词 `ν s = 0 → μ s = 0`
  对**所有** `s` 陈述较教材对可测集陈述严格；`absolutelyContinuous_iff_measurable` 说明两者等价。
- **`ae` 桥的方向**：`absolutelyContinuous_iff_ae_le` 陈述为 `μ ≪ ν ↔ ae μ ≤ ae ν`，
  与 Mathlib 原定理方向相反，故证明用 `.symm`。
- **边界**：本 Entry 只到“由密度构造的测度绝对连续”这一方向；Radon–Nikodym 的反方向
  （存在密度 `f` 使 `ν.withDensity f = μ`）在 `real-analysis.measure-derivative.radon-nikodym`。
