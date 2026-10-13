---
id: real-analysis.signed-measure.variation
family: real-analysis.signed-measure
variant: tao
kind: theorem
state: verified
title: 正／负／全变差
summary: 有符号测度的正变差 ν⁺、负变差 ν⁻ 与全变差 |ν|：展开、有限性、与 sup-over-partitions 定义的桥
premises: [real-analysis.signed-measure.definition]
mathlib: [SignedMeasure.totalVariation, SignedMeasure.toJordanDecomposition, SignedMeasure.totalVariation_eq_variation, SignedMeasure.totalVariation_zero, SignedMeasure.totalVariation_neg, SignedMeasure.null_of_totalVariation_zero, SignedMeasure.norm_le_totalVariation, SignedMeasure.enorm_le_totalVariation, VectorMeasure.variation, JordanDecomposition, measure_lt_top, measure_union, Measure.real, measureReal_def]
provenance:
  source_type: book
  ref: "folland-real-analysis-1999"
---

# real-analysis.signed-measure.variation

- **家族**: `real-analysis.signed-measure`
- **变体**: tao
- **状态**: verified
- **一句话**: 有符号测度 ν 分解为两个互相奇异的正测度 ν⁺ − ν⁻，其和 |ν| = ν⁺ + ν⁻
  既等于逐点绝对值上确界（sup over partitions），又逐点控制 |ν(E)| 与 ‖ν(E)‖。

## 直觉

有符号测度可以取负值，不能直接当作“大小”。Folland《Real Analysis》第二版 §3.1 的做法是
用 Hahn 分解把空间分成正集 `P` 与负集 `Pᶜ`，再令

- ν⁺(E) = ν(E ∩ P)（正变差），
- ν⁻(E) = −ν(E ∩ Pᶜ)（负变差），

这样 ν⁺、ν⁻ 都是普通（非负）测度，且 ν = ν⁺ − ν⁻、ν⁺ ⟂ₘ ν⁻。于是“全变差”定义为
`|ν| = ν⁺ + ν⁻`，它是一个普通测度；教材同时给出等价的极值定义

`|ν|(E) = sup { Σ_j |ν(E_j)| : (E_j) 是 E 的可测分划 }`。

这两个定义一个便于代数运算（测度加、控制不等式），一个显式揭示“变差 = 振幅的累加”，
本 Entry 的 Lean 内容就是桥梁：它们相等，且 |ν| 逐点控制 ν。

## 陈述（教材记号）

设 ν 是测度空间 (X, M) 上的（有限、实值）有符号测度。

1. **Jordan 分解与正／负变差**：存在互相奇异的测度 ν⁺、ν⁻，ν = ν⁺ − ν⁻；ν⁺ ⟂ₘ ν⁻。
2. **全变差 = ν⁺ + ν⁻**：`|ν| = ν⁺ + ν⁻`，逐点 `|ν|(E) = ν⁺(E) + ν⁻(E)`。
3. **sup-over-partitions 定义**：`|ν|(E) = sup { Σ_j |ν(E_j)| }`，两种定义给出同一测度。
4. **逐点控制**：`|ν(E)| ≤ |ν|(E)`。
5. **可加性**：不交可测 `A`、`B` 满足 `|ν|(A ∪ B) = |ν|(A) + |ν|(B)`。
6. **有限性**：ν 实值 ⇒ `|ν|` 是有限测度，`|ν|(univ) < ∞`。

## 本库 Lean 承载

- **ν⁺ / ν⁻ 的正式承载**：`s.toJordanDecomposition.posPart` 与
  `s.toJordanDecomposition.negPart`，类型均为 `Measure α`（Mathlib 的
  `MeasureTheory.JordanDecomposition` 结构字段）。其互奇异由结构字段
  `s.toJordanDecomposition.mutuallySingular : posPart ⟂ₘ negPart` 给出。
- **|ν| 的正式承载**：`SignedMeasure.totalVariation (s) : Measure α`，定义上就是
  `posPart + negPart`。它已注册为 `IsFiniteMeasure`，因此可以直接进入既有正测度主线
  （如 `Measure.real` / `toReal` 运算）。
- **sup-over-partitions 版本**：`VectorMeasure.variation`，即
  `SignedMeasure.variation : Measure α`；它按分划上确界定义。

## Lean 对照

以下签名逐字来自 `SandronesLibrary/RealAnalysis/SignedMeasureVariation.lean`
（`α : Type*`，`[MeasurableSpace α]`，`s : SignedMeasure α`；命名空间
`SandronesLibrary.RealAnalysis.SignedMeasure`）：

```lean
theorem totalVariation_eq_posPart_add_negPart (s : SignedMeasure α) :
    s.totalVariation = s.toJordanDecomposition.posPart + s.toJordanDecomposition.negPart

theorem totalVariation_apply (s : SignedMeasure α) (i : Set α) :
    s.totalVariation i =
      s.toJordanDecomposition.posPart i + s.toJordanDecomposition.negPart i

theorem totalVariation_eq_variation (s : SignedMeasure α) :
    s.totalVariation = s.variation

theorem abs_apply_le_totalVariation (s : SignedMeasure α) (i : Set α) :
    |s i| ≤ (s.totalVariation i).toReal

theorem enorm_apply_le_totalVariation (s : SignedMeasure α) (i : Set α) :
    ‖s i‖ₑ ≤ s.totalVariation i

theorem totalVariation_union (s : SignedMeasure α) {A B : Set α} (h : Disjoint A B)
    (hA : MeasurableSet A) (_hB : MeasurableSet B) :
    s.totalVariation (A ∪ B) = s.totalVariation A + s.totalVariation B

theorem posPart_mutuallySingular_negPart (s : SignedMeasure α) :
    s.toJordanDecomposition.posPart ⟂ₘ s.toJordanDecomposition.negPart
```

其余结论：`totalVariation_univ_lt_top (s) : s.totalVariation Set.univ < ∞`；
`totalVariation_zero : (0 : SignedMeasure α).totalVariation = 0`；
`totalVariation_neg (s) : (-s).totalVariation = s.totalVariation`；
`null_of_totalVariation_zero (s) {i} (h : s.totalVariation i = 0) : s i = 0`。

## 证明思路

- **`totalVariation_eq_posPart_add_negPart` / `totalVariation_apply`**：两者都是定义等式
  （Mathlib 直接把 `totalVariation` 定义为 `posPart + negPart`，测度加法按点取值），
  用 `rfl` 即可，无需数学论证。
- **`totalVariation_eq_variation`**：全变差的两种定义给出同一个测度；本库直接引用 Mathlib
  已证的 `SignedMeasure.totalVariation_eq_variation`（其证明用 Jordan 分解的规范性与
  `toJordanDecomposition_spec`，把 `|ν|(E)` 与分划上确界夹逼）。
- **`abs_apply_le_totalVariation`**：由 `SignedMeasure.norm_le_totalVariation` 得
  `‖s i‖ ≤ |ν|.real i`；`Real.norm_eq_abs` 把 `‖·‖` 改写为 `|·|`，
  `measureReal_def` 把 `|ν|.real i` 展开为 `(|ν| i).toReal`。
- **`enorm_apply_le_totalVariation`**：`enorm` 形式的同一不等式，直接引用
  `SignedMeasure.enorm_le_totalVariation`，避免 `toReal` 转换。
- **`totalVariation_univ_lt_top`**：`s.totalVariation` 带 `IsFiniteMeasure` 实例，
  `measure_lt_top` 给出全集有限。这是通往既有正测度有限性主线的门。
- **`totalVariation_zero` / `totalVariation_neg`**：分别引用
  `SignedMeasure.totalVariation_zero`、`SignedMeasure.totalVariation_neg`。
- **`null_of_totalVariation_zero`**：若 `|ν|(i) = 0`，则由逐点控制 `|ν(i)| ≤ 0` 推出
  `ν(i) = 0`；本库引用 `SignedMeasure.null_of_totalVariation_zero`。
- **`totalVariation_union`**：`|ν|` 是测度，直接调用正测度的有限可加性
  `measure_union h hB`（该版本只要求不交与其中一个集合可测）。
- **`posPart_mutuallySingular_negPart`**：Jordan 分解的结构字段
  `s.toJordanDecomposition.mutuallySingular`，对应 Hahn 分解中 ν⁺ 集中在 `P`、
  ν⁻ 集中在 `Pᶜ` 而 `P ⊥ Pᶜ`。

## 依赖（人话版）

- 库内前提：`real-analysis.signed-measure.definition`（有符号测度载体、正／负／零集与
  Hahn 分解存在性）。Jordan 分解的存在唯一性由 Mathlib 的
  `SignedMeasure.toJordanDecomposition` 及其 `spec` 提供，属于私有证明后端。
- Mathlib：`SignedMeasure.totalVariation`、`SignedMeasure.toJordanDecomposition`、
  `VectorMeasure.variation`、`JordanDecomposition`、`measure_lt_top`、`measure_union`、
  `Measure.real` / `measureReal_def`。

## 应用与陷阱

- **|ν| 是有限测度**（ν 实值），所以 `|ν|(E) < ∞` 对一切 `E` 成立；这与一般正测度
  （如 ℝ 上的 Lebesgue 测度）不同，任何 `toReal` 转换都不会遇到 `⊤`。
- **值域转换**：`|ν|(i)` 是 `ℝ≥0∞`，而 `|s i|` 是 `ℝ`。`abs_apply_le_totalVariation`
  右侧必须是 `(|ν| i).toReal`；`enorm_apply_le_totalVariation` 是同一事实在 `ℝ≥0∞`
  中的干净形式。两者不可混用类型。
- **两种全变差定义都真实存在**：`s.totalVariation`（Jordan 和）与 `s.variation`
  （sup over partitions）在 Mathlib 中是分别定义的测度，等价性是定理而非定义展开，
  故本 Entry 专门给出桥 `totalVariation_eq_variation`。
- **`null_of_totalVariation_zero` 是最粗的控制**：它只说明 `|ν|(i) = 0 ⇒ ν(i) = 0`；
  `|ν|(i) = 0` 时 ν 在所有可测子集上为零是 `null_of_totalVariation_zero` 的逐子集应用。
- **边界**：本 Entry 只做变差与 Jordan 分解本身，不含绝对连续性与 Radon–Nikodym
  （RA-F2 的后续内容），也不讨论复值测度或取值于一般 Banach 空间的向量测度。
