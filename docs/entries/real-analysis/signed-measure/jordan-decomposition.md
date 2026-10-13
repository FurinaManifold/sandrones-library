---
id: real-analysis.signed-measure.jordan-decomposition
family: real-analysis.signed-measure
variant: tao
kind: theorem
state: verified
title: Jordan 分解
summary: 有符号测度唯一分解为两个互奇异有限测度之差 ν = ν⁺ − ν⁻，并给出逐点展开与唯一性
premises: [real-analysis.signed-measure.definition]
mathlib: [MeasureTheory.JordanDecomposition, MeasureTheory.SignedMeasure.toJordanDecomposition, MeasureTheory.JordanDecomposition.toSignedMeasure, MeasureTheory.Measure.toSignedMeasure, MeasureTheory.SignedMeasure.toSignedMeasure_toJordanDecomposition, MeasureTheory.JordanDecomposition.toJordanDecomposition_toSignedMeasure, MeasureTheory.SignedMeasure.toJordanDecomposition_eq, MeasureTheory.SignedMeasure.toJordanDecompositionEquiv, MeasureTheory.JordanDecomposition.toSignedMeasure_injective, MeasureTheory.SignedMeasure.apply_eq_posPart_real_sub_negPart_real, MeasureTheory.IsFiniteMeasure]
provenance:
  source_type: book
  ref: "folland-real-analysis-1999"
---

# real-analysis.signed-measure.jordan-decomposition

- **家族**: `real-analysis.signed-measure`
- **变体**: tao
- **状态**: verified
- **一句话**: 每个有符号测度都唯一地写成两个互奇异有限测度之差 ν = ν⁺ − ν⁻。

## 直觉

有符号测度可以取负值，单个测度无法直接充当它。Jordan 分解定理说：可以把“取正的部分”
和“取负的部分”分别收集成两个**普通（非负）测度** `ν⁺`、`ν⁻`，它们互不重叠（互奇异），
且 `ν = ν⁺ − ν⁻`。这样，有符号测度论的大部分工作都能化归到我们已经熟悉的正测度理论。
`ν⁺` 称为正变差、`ν⁻` 称为负变差。

直观做法来自 Hahn 分解（见依赖 Entry `real-analysis.signed-measure.definition`）：把整个空间
切成正集 `P` 与负集 `Pᶜ`，在 `P` 上取 `ν⁺`、在 `Pᶜ` 上取 `ν⁻`。Hahn 分解只保证“空间的一种
划分”，而 Jordan 分解进一步把结果提炼为两个**测度**，并断言这个提炼由 `ν` 唯一决定。

## 陈述（教材记号）

Folland《Real Analysis》第二版 §3.1 定理 3.1（Jordan decomposition theorem）：
设 `ν` 是 `(X, ℳ)` 上的有符号测度，则存在**唯一**一对互奇异的正测度 `ν⁺`、`ν⁻`，
使得
```
ν = ν⁺ − ν⁻，
```
并且两个测度都是有限的（在 Folland 的有符号测度定义下 `ν` 取实值，故 `ν⁺`、`ν⁻`
自动有限）。唯一性在“一对互奇异测度”的意义下成立。

本库 Lean 承载：

- `MeasureTheory.JordanDecomposition α` 是一个结构，字段为
  `posPart : Measure α`、`negPart : Measure α`、`mutuallySingular : posPart ⟂ₘ negPart`；
  两个部分字段分别带 `IsFiniteMeasure` 实例。它正是教材所说“一对互奇异有限测度”。
- `MeasureTheory.SignedMeasure.toJordanDecomposition : SignedMeasure α → JordanDecomposition α`
  给出存在性：从有符号测度构造出这样一对。
- `MeasureTheory.JordanDecomposition.toSignedMeasure : JordanDecomposition α → SignedMeasure α`
  取出 `posPart.toSignedMeasure - negPart.toSignedMeasure`，即 `ν⁺ − ν⁻`。

本库的公开定理（文件 `SandronesLibrary/RealAnalysis/SignedMeasureJordan.lean`）：

- `jordan_decomposition (s) : s.toJordanDecomposition.toSignedMeasure = s`
  ——存在性：`s = s.toJordanDecomposition.posPart - s.toJordanDecomposition.negPart`。
- `jordan_decomposition_toSignedMeasure (j) : j.toSignedMeasure.toJordanDecomposition = j`
  ——反向伴随。
- `jordan_decomposition_unique (h : s = j.toSignedMeasure) : s.toJordanDecomposition = j`
  ——按有符号测度定位的分解唯一性。
- `jordan_decomposition_iff : s = j.toSignedMeasure ↔ s.toJordanDecomposition = j`
  ——存在性与唯一性的等价刻画。
- `jordan_toSignedMeasure_eq_posPart_sub_negPart (j) :
  j.toSignedMeasure = j.posPart.toSignedMeasure - j.negPart.toSignedMeasure`
  ——教材记号 `ν = ν⁺ − ν⁻` 的结构性陈述。
- `jordan_apply_eq_posPart_real_sub_negPart_real (s) (hi) :
  s i = s.toJordanDecomposition.posPart.real i - s.toJordanDecomposition.negPart.real i`
  ——逐点展开（`i` 可测），把等式落到实数取值上。
- `jordan_posPart_mutuallySingular_negPart (j) : j.posPart ⟂ₘ j.negPart`
  ——互奇异这一条要求。
- `jordan_toSignedMeasure_injective : Function.Injective JordanDecomposition.toSignedMeasure`
  与 `jordan_decomposition_unique' : j₁ = j₂ ↔ j₁.toSignedMeasure = j₂.toSignedMeasure`
  ——“唯一一对”：分解由有符号测度唯一决定。
- `jordan_decomposition_equiv : SignedMeasure α ≃ JordanDecomposition α`
  ——存在性与唯一性打包成典范等价。
- `jordan_exists_hahnDecomposition (s) : ∃ P, IsPositiveSet s P ∧ IsNegativeSet s Pᶜ`
  —— Jordan 分解与课程正／负集定义的桥（Hahn 分解存在性）。

## 证明思路

存在性（`jordan_decomposition`）：由 Hahn 分解取正集 `P`、负集 `Pᶜ`，用 `s` 在 `P`
上的限制构造 `ν⁺`、在 `Pᶜ` 上的限制构造 `ν⁻`；在可测集 `i` 上把 `i` 拆成
`i ∩ P` 与 `i ∩ Pᶜ`，两块分别在正集、负集上取号，即得 `s i = ν⁺ i − ν⁻ i`。
Mathlib 已给出该构造与其性质，本库以 `jordan_decomposition` 命名公开。

唯一性（`jordan_decomposition_unique'`）：若两个 Jordan 分解给出同一个有符号测度，
它们各自诱导空间的一个 Hahn 划分；利用有符号测度在“正负划分的对称差”上的取值为零，
可证两个 `posPart` 相等，进而 `negPart` 相等。Mathlib 以
`JordanDecomposition.toSignedMeasure_injective` 封装这一论证，本库据此给出等价形式。
`jordan_decomposition_iff` 的两个方向分别来自
`SignedMeasure.toJordanDecomposition_eq` 与 `jordan_decomposition` 的逆。

逐点形式（`jordan_apply_eq_posPart_real_sub_negPart_real`）是存在性等式在可测集上取
实数值的直接展开，也是教材 `ν = ν⁺ − ν⁻` 最常用的使用形式。

## 依赖（人话版）

- **库内前提**：`real-analysis.signed-measure.definition`
  （有符号测度载体、正／负／零集定义、Hahn 分解存在性 `exists_hahnDecomposition`）。
- **Mathlib**：`JordanDecomposition` 结构及 `posPart`/`negPart`/`mutuallySingular` 字段；
  `Measure.toSignedMeasure`；`SignedMeasure.toJordanDecomposition` 与
  `JordanDecomposition.toSignedMeasure`；以及互逆性、单射性、等价与逐点展开等定理
  （见 front matter `mathlib` 字段）。

## 应用与陷阱

- 教材记号 `ν = ν⁺ − ν⁻` 中的差是**有符号测度**的差，并非两个正测度直接相减；
  在 Lean 中由 `JordanDecomposition.toSignedMeasure` 统一承载。
- 逐点等式 `jordan_apply_eq_posPart_real_sub_negPart_real` 只在 `i` **可测**时成立，
  因为 `Measure.real`/有符号测度只在可测集上有意义。
- `JordanDecomposition` 要求两个部分都是**有限测度**（`IsFiniteMeasure`）。这正是教材中
  “`ν⁺`、`ν⁻` 有限”的条件；处理非有限变差时需要额外的域外工具，不在本 Entry。
- 唯一性只在“一对互奇异测度”的范围内成立；丢掉互奇异性后差分解不唯一。

## 边界

本 Entry **只做** Jordan 分解的存在性、唯一性、逐点展开，以及它与课程正／负集定义的桥。
以下内容**不属于**本 Entry，也未在本库任何意义上宣称已完成：

- RA-F2 的**绝对连续**理论；
- **互奇异测度的一般理论**（本 Entry 只用 `JordanDecomposition` 结构内已有的互奇异字段）；
- **Lebesgue 分解定理**；
- **Radon–Nikodym 定理**。

此外，本项目中的 `JordanDecomposition` 要求 `posPart`、`negPart` 都是有限测度；不覆盖
无限变差情形。上述边界是刻意的范围声明，不代表这些主题已实现。
