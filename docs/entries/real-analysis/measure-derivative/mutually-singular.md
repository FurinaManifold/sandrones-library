---
id: real-analysis.measure-derivative.mutually-singular
family: real-analysis.measure-derivative
variant: tao
kind: theorem
state: verified
title: 互奇异测度
summary: 互奇异测度 μ ⟂ₘ ν 的教材量词展开、零测度／加法／标量倍／单调性等基本性质，与 Disjoint 及 a.e. 滤子的桥，以及互奇异与绝对连续相遇时测度为零
premises: [real-analysis.measure-derivative.absolute-continuity]
mathlib: [Measure.MutuallySingular, Measure.MutuallySingular.zero_left, Measure.MutuallySingular.symm, Measure.MutuallySingular.smul, Measure.MutuallySingular.add_left, Measure.MutuallySingular.self_iff, Measure.eq_zero_of_absolutelyContinuous_of_mutuallySingular, Measure.mutuallySingular_iff_disjoint, Measure.mutuallySingular_iff_disjoint_ae, Measure.MutuallySingular.withDensity, Measure.MutuallySingular.measurableSet_nullSet]
provenance:
  source_type: book
  ref: "folland-real-analysis-1999"
---

# real-analysis.measure-derivative.mutually-singular

- **家族**: `real-analysis.measure-derivative`
- **变体**: tao
- **状态**: verified
- **一句话**: 测度 `μ` 与 `ν` 互奇异（记 `μ ⟂ₘ ν`）当且仅当存在可测集 `s` 使 `μ(s) = 0`
  且 `ν(sᶜ) = 0`，它给出零测度、加法、标量倍、单调性等基本性质，并与 `Measure` 格不相交、
  几乎处处滤子不相交等价；当它与绝对连续相遇时两端测度只能为零。

## 直觉

绝对连续问的是“`ν` 忽略的集合 `μ` 是否也忽略”；互奇异问的是**相反**的问题：
“`μ` 与 `ν` 能否把质量放在两个互相补全的地方，彼此不再重叠？”Folland《Real Analysis》
第二版 §3.2 的定义是：存在一个可测集 `s`，使 `μ` 集中在 `sᶜ` 上（`μ(s) = 0`）、
`ν` 集中在 `s` 上（`ν(sᶜ) = 0`）。直观上，`μ` 把全部质量堆在 `sᶜ`，`ν` 把全部质量
堆在 `s`，两测度“生活在不相交的区域”。

互奇异是 Lebesgue 分解定理的骨架：任何 `σ`-有限测度 `μ` 可唯一写成 “关于 `ν` 绝对连续的部分
+ 关于 `ν` 互奇异的部分”。本 Entry 只做互奇异谓词本身及其基本性质，不含分解定理与
Radon–Nikodym（后续 Entry）。互奇异还有一个漂亮的等价表述：测度作为 `Measure α` 格中的
元素**不相交**（下确界为 `0`），以及在 `ae` 滤子层“两个几乎处处滤子不相交”。

## 陈述（教材记号）

设 `(X, M)` 为可测空间，`μ, ν, ν₁, ν₂` 为 `X` 上的测度。

1. **定义（Folland §3.2）**：`μ ⟂ₘ ν :⟺ ∃ s, s 可测 ∧ μ(s) = 0 ∧ ν(sᶜ) = 0`。
2. **对称性**：`μ ⟂ₘ ν ↔ ν ⟂ₘ μ`。
3. **零测度**：`0 ⟂ₘ ν`、`μ ⟂ₘ 0`；且 `μ ⟂ₘ μ ↔ μ = 0`。
4. **加法**：`ν₁ ⟂ₘ μ`、`ν₂ ⟂ₘ μ ⟹ ν₁ + ν₂ ⟂ₘ μ`；右端同理。
5. **标量倍**：`ν ⟂ₘ μ`、`r ∈ [0, +∞] ⟹ r • ν ⟂ₘ μ`。
6. **单调性**：`μ₁ ⟂ₘ ν₁`、`μ₂ ≤ μ₁`、`ν₂ ≤ ν₁` ⟹ `μ₂ ⟂ₘ ν₂`。
7. **密度保持**：`μ ⟂ₘ ν ⟹ μ.withDensity f ⟂ₘ ν`（任意 `f : X → [0, +∞]`）。
8. **与不相交的桥**：`μ ⟂ₘ ν ↔ Disjoint μ ν`（`Measure α` 格中的不相交）；
   同样 `μ ⟂ₘ ν ↔ Disjoint (ae μ) (ae ν)`（`ae` 滤子不相交）。
9. **关键使用者**：`μ ≪ ν` 且 `μ ⟂ₘ ν` ⟹ `μ = 0`。
10. **见证集合**：若 `μ ⟂ₘ ν`，则 `nullSet`（定义中取出的集合）可测、
    `μ(nullSet) = 0` 且 `ν(nullSetᶜ) = 0`。

## 本库 Lean 承载

- **正式公开承载**：`MeasureTheory.Measure.MutuallySingular μ ν : Prop`（记号 `μ ⟂ₘ ν`，
  来自 `open scoped MeasureTheory`）。Mathlib 的定义体就是
  `∃ s, MeasurableSet s ∧ μ s = 0 ∧ ν sᶜ = 0`，与教材逐字一致，故直接复用而不新造 `def`。
- **术语说明**：本文件把该谓词称为 `MeasureDerivative` 家族下的“互奇异”，
  与绝对连续 Entry 互为对称概念。
- **本库桥／教材展开**：
  - `mutuallySingular_iff`：`Iff.rfl` 形式的量词展开；
  - `mutuallySingular_iff_disjoint` / `mutuallySingular_iff_disjoint_ae`：接入测度格与 `ae` 滤子；
  - `mutuallySingular_nullSet_measurable` / `_nullSet_measure` / `_measure_compl_nullSet`：
    见证集合 `h.nullSet` 的两条测度等式；
  - `eq_zero_of_mutuallySingular_of_absolutelyContinuous`：与绝对连续相遇时的关键使用者。

## Lean 对照

以下签名逐字来自 `SandronesLibrary/RealAnalysis/MeasureDerivativeMutuallySingular.lean`
（`α : Type*`，`[MeasurableSpace α]`，命名空间 `SandronesLibrary.RealAnalysis.MeasureDerivative`）：

```lean
theorem mutuallySingular_iff (μ ν : Measure α) :
    μ ⟂ₘ ν ↔ ∃ s : Set α, MeasurableSet s ∧ μ s = 0 ∧ ν sᶜ = 0

theorem mutuallySingular_comm : μ ⟂ₘ ν ↔ ν ⟂ₘ μ

theorem mutuallySingular_symm (h : ν ⟂ₘ μ) : μ ⟂ₘ ν

theorem mutuallySingular_zero_left (μ : Measure α) : (0 : Measure α) ⟂ₘ μ

theorem mutuallySingular_zero_right (μ : Measure α) : μ ⟂ₘ 0

theorem mutuallySingular_add_left (h₁ : ν₁ ⟂ₘ μ) (h₂ : ν₂ ⟂ₘ μ) : ν₁ + ν₂ ⟂ₘ μ

theorem mutuallySingular_add_right (h₁ : μ ⟂ₘ ν₁) (h₂ : μ ⟂ₘ ν₂) : μ ⟂ₘ ν₁ + ν₂

theorem mutuallySingular_smul (r : ℝ≥0∞) (h : ν ⟂ₘ μ) : r • ν ⟂ₘ μ

theorem mutuallySingular_mono (h : μ₁ ⟂ₘ ν₁) (hμ : μ₂ ≤ μ₁) (hν : ν₂ ≤ ν₁) : μ₂ ⟂ₘ ν₂

theorem mutuallySingular_self_iff (μ : Measure α) : μ ⟂ₘ μ ↔ μ = 0

theorem eq_zero_of_mutuallySingular_of_absolutelyContinuous
    (h_ac : μ ≪ ν) (h_ms : μ ⟂ₘ ν) : μ = 0

theorem mutuallySingular_iff_disjoint : μ ⟂ₘ ν ↔ Disjoint μ ν

theorem mutuallySingular_iff_disjoint_ae : μ ⟂ₘ ν ↔ Disjoint (ae μ) (ae ν)

theorem mutuallySingular_nullSet_measurable (h : μ ⟂ₘ ν) : MeasurableSet h.nullSet

theorem mutuallySingular_nullSet_measure (h : μ ⟂ₘ ν) : μ h.nullSet = 0

theorem mutuallySingular_measure_compl_nullSet (h : μ ⟂ₘ ν) : ν h.nullSetᶜ = 0

theorem mutuallySingular_withDensity (h : μ ⟂ₘ ν) (f : α → ℝ≥0∞) :
    μ.withDensity f ⟂ₘ ν
```

## 证明思路

- **`mutuallySingular_iff`**：Mathlib 的定义体本身就是 `∃ s, MeasurableSet s ∧ μ s = 0 ∧ ν sᶜ = 0`，
  故证明是 `Iff.rfl`，无需数学论证。
- **`mutuallySingular_comm` / `mutuallySingular_symm`**：把定义中 `s` 换成 `sᶜ`（可测性、
  补集、两条等式互换即可）。本库直接引用 Mathlib 的 `Measure.MutuallySingular.comm` 与 `.symm`。
- **零测度三则（`zero_left`、`zero_right`、`self_iff`）**：取 `s = ∅` 或 `s = univ`
  即可，`self_iff` 需要把 `μ s = 0 = μ sᶜ` 拼成 `μ = 0`。本库引用 Mathlib 对应结论。
- **加法、标量倍**：见证集合分别取两互异集合的交（`add`）或原集合（`smul`，注意 `r = 0`
  时左边本身为零测度），本库引用 `Measure.MutuallySingular.add_left/add_right/smul`。
- **`mutuallySingular_mono`**：子测度上零集仍是零集，故同一见证集合 `s` 仍然有效；
  本库引用 `Measure.MutuallySingular.mono`。
- **`mutuallySingular_withDensity`**：`μ.withDensity f` 在 `μ` 的零集上仍为零，见证集合不变；
  引用 `Measure.MutuallySingular.withDensity`。
- **两条桥（`iff_disjoint`、`iff_disjoint_ae`）**：数学内容是测度格的交为 `0`
  （以及 `ae` 滤子的不相交）与“存在互补零集”等价；分别引用
  `Measure.mutuallySingular_iff_disjoint`、`Measure.mutuallySingular_iff_disjoint_ae`。
- **关键使用者 `eq_zero_of_mutuallySingular_of_absolutelyContinuous`**：由 `μ ⟂ₘ ν` 取见证
  集合 `s`，`μ s = 0` 且 `ν sᶜ = 0`；绝对连续把 `ν sᶜ = 0` 推成 `μ sᶜ = 0`，与 `μ s = 0`
  合起来给出 `μ = 0`。本库引用
  `Measure.eq_zero_of_absolutelyContinuous_of_mutuallySingular`。
- **见证集合三则**：`h.nullSet` 就是定义中取出的集合，其可测性与两条测度等式由结构给出；
  引用 `h.measurableSet_nullSet`、`h.measure_nullSet`、`h.measure_compl_nullSet`。

## 依赖（人话版）

- 库内前提：`real-analysis.measure-derivative.absolute-continuity`（因为关键使用者
  `eq_zero_of_mutuallySingular_of_absolutelyContinuous` 以 `μ ≪ ν` 为前提）。
- Mathlib：`Measure.MutuallySingular` 及其 `.comm/.symm/.zero_left/.zero_right/.add_left/
  .add_right/.smul/.mono/.self_iff/.withDensity/.nullSet` 与三条 `nullSet` 等式；
  `Measure.mutuallySingular_iff_disjoint`、`Measure.mutuallySingular_iff_disjoint_ae`、
  `Measure.eq_zero_of_absolutelyContinuous_of_mutuallySingular`。这些在 handoff 中归为
  “语义一致的正式承载／桥／私有证明后端”。

## 应用与陷阱

- **`⟂ₘ` 不是 `≪` 的否定**：两个测度可以既不绝对连续、也不互奇异（例如 ℝ 上
  Lebesgue 测度与某个既有绝对连续部分又有奇异部分的测度）。互奇异是一个独立谓词，
  不是绝对连续的补。
- **`μ ⟂ₘ μ ⟹ μ = 0`**：互异性是“强分离”，绝不能与“两个测度都为正”混用；
  `mutuallySingular_self_iff` 说明只有零测度能与自身互奇异。
- **标量 `r = 0`**：`mutuallySingular_smul` 对 `r = 0` 也成立（`0 • ν = 0` 当然互奇异），
  故不要求 `r ≠ 0`；这与绝对连续的 `smul` 需要 `c ≠ 0` 不同。
- **两条 `Disjoint` 顺序**：`Disjoint (ae μ) (ae ν)` 是**滤子**的不相交，不是测度或集合的
  不相交；不要与 `Disjoint μ ν`（测度格下确界为 `0`）写成同一对象，虽然二者都与 `μ ⟂ₘ ν` 等价。
- **见证集合不唯一**：`h.nullSet` 是 Mathlib 用选择从存在性中取出的一个具体见证；
  结论只依赖它的两条测度等式，不依赖唯一性。
- **边界**：本 Entry 只做互奇异谓词与基本性质，不含 Lebesgue 分解定理与
  Radon–Nikodym（RA-F2 后续 Entry），也不讨论复值测度或向量测度的互异性。
