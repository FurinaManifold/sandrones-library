---
id: real-analysis.measure-derivative.lebesgue-decomposition
family: real-analysis.measure-derivative
variant: tao
kind: theorem
state: verified
title: Lebesgue 分解
summary: σ-有限测度关于 SFinite 测度的 Lebesgue 分解 μ = μ.singularPart ν + ν.withDensity (μ.rnDeriv ν)：存在性、奇异部分与密度的唯一性，以及 rnDeriv 可测、singularPart 的零点刻画
premises: [real-analysis.measure-derivative.absolute-continuity, real-analysis.measure-derivative.mutually-singular]
mathlib: [Measure.HaveLebesgueDecomposition, Measure.haveLebesgueDecomposition_of_sigmaFinite, Measure.singularPart, Measure.rnDeriv, Measure.haveLebesgueDecomposition_add, Measure.mutuallySingular_singularPart, Measure.singularPart_le, Measure.withDensity_rnDeriv_le, Measure.measurable_rnDeriv, Measure.eq_singularPart, Measure.eq_rnDeriv, Measure.MutuallySingular.haveLebesgueDecomposition, Measure.singularPart_eq_zero, Measure.singularPart_eq_zero_of_ac, Measure.singularPart_self, Measure.singularPart_eq_self, Measure.haveLebesgueDecomposition_withDensity]
provenance:
  source_type: book
  ref: "folland-real-analysis-1999"
---

# real-analysis.measure-derivative.lebesgue-decomposition

- **家族**: `real-analysis.measure-derivative`
- **变体**: tao
- **状态**: verified
- **一句话**: 把任意（σ-有限意义下的）测度 `μ` 唯一地拆成关于 `ν` 奇异的部分
  `μ.singularPart ν` 与关于 `ν` 绝对连续、由密度 `μ.rnDeriv ν` 给出的部分之和。

## 直觉

测度之间的“相对大小”有两种极端。一种是**绝对连续**（`μ ≪ ν`）：`ν`-零集全是 `μ`-零集，
于是 `μ` 完全由 `ν` 的密度加权决定；另一种是**互相奇异**（`μ ⟂ₘ ν`）：存在一个 `ν`-零集，
`μ` 的全部质量都落在它的补上，`μ` 与 `ν` “住在不同的地方”。

Folland《Real Analysis》第二版 §3.2 的 Lebesgue 分解定理断言这两种极端足够描述一般情形：
任何测度 `μ` 都能唯一地写成“奇异部分 + 绝对连续部分”。其中绝对连续部分由 Radon–Nikodym
导数 `rnDeriv` 作为密度给出。因此本 Entry 是 Radon–Nikodym 定理（下一 Entry，讨论导数存在性）
的框架性前奏：这里给出分解的**存在与唯一**，以及 `singularPart`、`rnDeriv` 两个正式对象的基本刻画。

## 陈述（教材记号）

设 `(X, M)` 为可测空间，`μ`、`ν` 为 `X` 上的测度，`ν` σ-有限、`μ` 具有 σ-有限性质
（Lean 中为 `SFinite`）。

1. **存在性**：`μ` 关于 `ν` 有 Lebesgue 分解，即存在测度 `s` 与可测函数 `f` 使
   `μ = s + ν.withDensity f`，其中 `s ⟂ₘ ν`。
2. **主等式**：`μ = μ.singularPart ν + ν.withDensity (μ.rnDeriv ν)`，且
   `μ.singularPart ν ⟂ₘ ν`。
3. **两项都受 `μ` 控制**：`μ.singularPart ν ≤ μ`、`ν.withDensity (μ.rnDeriv ν) ≤ μ`。
4. **唯一性**：若 `s ⟂ₘ ν`、`f` 可测且 `μ = s + ν.withDensity f`，则 `s = μ.singularPart ν`
   且（在 σ-有限 `ν` 下）`f =ᵐ[ν] μ.rnDeriv ν`。
5. **退化情形**：`μ ⟂ₘ ν` 时分解取 `s = μ`、`f = 0`；`μ ≪ ν` 时奇异部分为零。
6. **零点刻画**：`μ.singularPart ν = 0 ↔ μ ≪ ν`；`μ.singularPart ν = μ ↔ μ ⟂ₘ ν`。
7. **可测性**：`μ.rnDeriv ν` 总是可测函数。

## 本库 Lean 承载

- **谓词 `HaveLebesgueDecomposition`**：`Measure.HaveLebesgueDecomposition μ ν : Prop` 是
  “`μ` 关于 `ν` 可作 Lebesgue 分解”的正式谓词，直接对应教材的存在性断言。
- **奇异部分 `singularPart`**：`Measure.singularPart μ ν : Measure α`，类型就是普通测度，
  教材中的 `s`。
- **Radon–Nikodym 导数 `rnDeriv`**：`Measure.rnDeriv μ ν : α → ℝ≥0∞`，教材中的密度 `f`；
  其可测性由 `Measure.measurable_rnDeriv` 保证。
- **`Measure.eq_singularPart` / `Measure.eq_rnDeriv`**：分解唯一性（测度唯一、密度 a.e. 唯一）
  的后端。
- 本 Entry 的所有公开声明均为对上述 Mathlib 承载的教材化重述，不重造定义。

## Lean 对照

以下签名逐字来自 `SandronesLibrary/RealAnalysis/MeasureDerivativeLebesgueDecomposition.lean`
（`α : Type*`，`[MeasurableSpace α]`；命名空间
`SandronesLibrary.RealAnalysis.MeasureDerivative`）：

```lean
theorem haveLebesgueDecomposition_of_sigmaFinite (μ ν : Measure α) [SFinite μ] [SigmaFinite ν] :
    μ.HaveLebesgueDecomposition ν

theorem haveLebesgueDecomposition_add (μ ν : Measure α) [μ.HaveLebesgueDecomposition ν] :
    μ = μ.singularPart ν + ν.withDensity (μ.rnDeriv ν)

theorem mutuallySingular_singularPart (μ ν : Measure α) : μ.singularPart ν ⟂ₘ ν

theorem singularPart_le (μ ν : Measure α) : μ.singularPart ν ≤ μ

theorem withDensity_rnDeriv_le (μ ν : Measure α) : ν.withDensity (μ.rnDeriv ν) ≤ μ

theorem haveLebesgueDecomposition_spec (μ ν : Measure α) [μ.HaveLebesgueDecomposition ν] :
    Measurable (μ.rnDeriv ν) ∧ μ.singularPart ν ⟂ₘ ν ∧
      μ = μ.singularPart ν + ν.withDensity (μ.rnDeriv ν)

theorem singularPart_unique {μ ν s : Measure α} {f : α → ℝ≥0∞} (hf : Measurable f)
    (hs : s ⟂ₘ ν) (hμ : μ = s + ν.withDensity f) : s = μ.singularPart ν

theorem rnDeriv_unique {μ ν : Measure α} [SigmaFinite ν] {s : Measure α} {f : α → ℝ≥0∞}
    (hf : Measurable f) (hs : s ⟂ₘ ν) (hμ : μ = s + ν.withDensity f) :
    f =ᵐ[ν] μ.rnDeriv ν

theorem mutuallySingular_haveLebesgueDecomposition {μ ν : Measure α} (h : μ ⟂ₘ ν) :
    μ.HaveLebesgueDecomposition ν

theorem singularPart_eq_zero_iff (μ ν : Measure α) [μ.HaveLebesgueDecomposition ν] :
    μ.singularPart ν = 0 ↔ μ ≪ ν

theorem singularPart_eq_zero_of_absolutelyContinuous {μ ν : Measure α} (h : μ ≪ ν) :
    μ.singularPart ν = 0

theorem singularPart_self (μ : Measure α) : μ.singularPart μ = 0

theorem singularPart_eq_self_iff {μ ν : Measure α} : μ.singularPart ν = μ ↔ μ ⟂ₘ ν

theorem measurable_rnDeriv (μ ν : Measure α) : Measurable (μ.rnDeriv ν)

theorem haveLebesgueDecomposition_withDensity (μ : Measure α) {f : α → ℝ≥0∞}
    (hf : Measurable f) : (μ.withDensity f).HaveLebesgueDecomposition μ
```

## 证明思路

- **`haveLebesgueDecomposition_of_sigmaFinite`**：教材存在性定理的 σ-有限形式，直接引用
  Mathlib 的 `Measure.haveLebesgueDecomposition_of_sigmaFinite`（其证明经由 σ-有限分解把问题
  归约到有限测度情形，属私有证明后端）。
- **`haveLebesgueDecomposition_add` / `mutuallySingular_singularPart` / `singularPart_le` /
  `withDensity_rnDeriv_le`**：分别引用同名的 Mathlib 后端；它们刻画分解主等式与两项的奇异、
  受控性质。
- **`haveLebesgueDecomposition_spec`**：把 Radon–Nikodym 导数可测、奇异、分解等式三个后端
  用 `∧` 组装成教材一句话陈述。
- **`singularPart_unique`**：直接使用 `Measure.eq_singularPart`；其数学内容是
  “两个与 `ν` 奇异的测度之差仍与 `ν` 奇异，同时又是绝对连续的，故为零”。
- **`rnDeriv_unique`**：直接使用 `Measure.eq_rnDeriv`，在 `SigmaFinite ν` 下把密度差的
  a.e. 唯一性给出。
- **`mutuallySingular_haveLebesgueDecomposition`**：互相奇异时取 `s = μ`、`f = 0` 的退化分解，
  引用 `Measure.MutuallySingular.haveLebesgueDecomposition`。
- **`singularPart_eq_zero_iff` / `singularPart_eq_zero_of_absolutelyContinuous` /
  `singularPart_self` / `singularPart_eq_self_iff`**：引用 Mathlib 的 `Measure.singularPart_eq_zero`、
  `Measure.singularPart_eq_zero_of_ac`、`Measure.singularPart_self`、`Measure.singularPart_eq_self`；
  它们把绝对连续与互相奇异翻译成 `singularPart` 的零点／全测度条件。
- **`measurable_rnDeriv` / `haveLebesgueDecomposition_withDensity`**：引用同名的 Mathlib 后端；
  后者说明密度测度自身给出一个平凡分解。

## 依赖（人话版）

- 库内前提：`real-analysis.measure-derivative.absolute-continuity`（`μ ≪ ν` 与 a.e. 滤子桥）、
  `real-analysis.measure-derivative.mutually-singular`（`μ ⟂ₘ ν` 的定义与基本性质）。
- Mathlib：`Measure.HaveLebesgueDecomposition`、`Measure.singularPart`、`Measure.rnDeriv`、
  `Measure.haveLebesgueDecomposition_of_sigmaFinite`、`Measure.haveLebesgueDecomposition_add`、
  `Measure.mutuallySingular_singularPart`、`Measure.singularPart_le`、
  `Measure.withDensity_rnDeriv_le`、`Measure.measurable_rnDeriv`、`Measure.eq_singularPart`、
  `Measure.eq_rnDeriv`、`Measure.MutuallySingular.haveLebesgueDecomposition`、
  `Measure.singularPart_eq_zero`、`Measure.singularPart_eq_zero_of_ac`、
  `Measure.singularPart_self`、`Measure.singularPart_eq_self`、
  `Measure.haveLebesgueDecomposition_withDensity`。
  Lebesgue 分解的存在性（σ-有限情形）是主定理的私有证明后端。

## 应用与陷阱

- **唯一性分两层**：奇异部分作为**测度**唯一（`singularPart_unique`），而密度只作为
  `ν`-a.e. 函数唯一（`rnDeriv_unique`），需要 σ-有限 `ν`。不要把 `rnDeriv_unique` 误读为
  逐点等式。
- **假设不能省**：存在性 `haveLebesgueDecomposition_of_sigmaFinite` 需要 `[SFinite μ]` 与
  `[SigmaFinite ν]`；不满足时 `HaveLebesgueDecomposition` 可能失败，Mathlib 在无实例处让
  `singularPart`、`rnDeriv` 退化为默认值，因此涉及分解主等式的引理通常显式要求
  `[μ.HaveLebesgueDecomposition ν]`。
- **`singularPart` 的零点刻画需要分解实例**：`singularPart_eq_zero_iff` 带
  `[μ.HaveLebesgueDecomposition ν]`；而单方向 `singularPart_eq_zero_of_absolutelyContinuous`
  与 `singularPart_eq_self_iff` 不需要。
- **边界（诚实说明）**：本 Entry **不做** Radon–Nikodym 导数的存在性（绝对连续测度的密度
  构造与 `ν.withDensity (μ.rnDeriv ν) = μ` 在 `μ ≪ ν` 下的等价形式），那是下一 Entry
  `real-analysis.measure-derivative.radon-nikodym` 的内容；这里只做分解的存在、唯一以及
  `singularPart`／`rnDeriv` 的基本刻画。
