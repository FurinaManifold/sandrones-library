---
id: real-analysis.signed-measure.definition
family: real-analysis.signed-measure
variant: tao
kind: definition
state: verified
title: 有符号测度与正／负／零集
summary: 有符号测度作为实值 σ-可加集函数（载体、可加性、下连续、由有限正测度构造）以及正集、负集、零集的课程量词定义与 Mathlib 桥
premises: []
mathlib: [MeasureTheory.SignedMeasure, MeasureTheory.VectorMeasure, VectorMeasure.of_union, VectorMeasure.of_sdiff, VectorMeasure.of_compl, VectorMeasure.m_iUnion, VectorMeasure.of_biUnion_finset, VectorMeasure.tendsto_vectorMeasure_iUnion_atTop_nat, VectorMeasure.restrict_le_restrict_iff, Measure.toSignedMeasure_apply_measurable, Measure.toSignedMeasure_add, Measure.toSignedMeasure_zero, SignedMeasure.exists_compl_positive_negative]
provenance:
  source_type: book
  ref: "folland-real-analysis-1999"
---

# 陈述与动机

测度要求非负，但很多构造（如两个测度之差、分布密度、Riemann–Stieltjes 型对象）天然带号。
教材（Folland, *Real Analysis*, 2nd ed., §3.1）把**有符号测度**定义为定义在可测空间
`(X, M)` 上、取值于实直线、满足

- `ν(∅) = 0`；
- 对两两不交的可测集列 `E₁, E₂, …`，`ν(⋃ Eₙ) = Σ ν(Eₙ)`（右端无条件收敛）

的集函数。本库在实分析阶段只处理**有限（实值）**有符号测度，把“取值可能为 ±∞”的扩展情形留给
后续批次；这与 Mathlib 的载体语义一致。

正集、负集、零集是描述有符号测度局部符号的核心名词：

- **正集** `P`：`P` 可测，且任意可测 `E ⊆ P` 满足 `ν(E) ≥ 0`；
- **负集** `N`：`N` 可测，且任意可测 `E ⊆ N` 满足 `ν(E) ≤ 0`；
- **零集** `Z`：`Z` 可测，且任意可测 `E ⊆ Z` 满足 `ν(E) = 0`。

它们是后续 Jordan 分解（`real-analysis.signed-measure.jordan-decomposition`）与正／负变差
（`real-analysis.signed-measure.variation`）的教材入口。

# Lean 对照与证明

**正式承载**：`MeasureTheory.SignedMeasure α`，它在 Mathlib 中就是
`VectorMeasure α ℝ`（实值向量测度），其 structure 字段精确对应教材公理：

| 教材要求 | Lean 字段/定理 |
|---|---|
| 集函数 `ν : M → ℝ` | `VectorMeasure.measureOf'`（经 `FunLike` 写作 `s E`） |
| `ν(∅) = 0` | `VectorMeasure.empty'`，本库 `signedMeasure_empty` |
| 非可测集取零 | `VectorMeasure.not_measurable'`，本库 `signedMeasure_not_measurable` |
| 不交可数可加 | `VectorMeasure.m_iUnion'`，本库 `signedMeasure_iUnion` |

展开性质（本文件公开）：有限可加 `signedMeasure_union`、差集 `signedMeasure_sdiff`、
补集 `signedMeasure_compl`、有限并 `signedMeasure_iUnion_finset`、下连续
`signedMeasure_tendsto_iUnion`。证明都是把 Mathlib `VectorMeasure` 的对应展开后端
（`of_union`、`of_sdiff`、`of_compl`、`of_biUnion_finset`、
`tendsto_vectorMeasure_iUnion_atTop_nat`）按教材记号陈述，没有引入更强假设。

**正测度 → 有符号测度的桥**：`μ.toSignedMeasure`（`Measure.toSignedMeasure`）把有限正测度
（`[IsFiniteMeasure μ]`，这正是“有限”量词）送入有符号测度；`measure_toSignedMeasure_apply_measurable`
给出可测集上的值 `(μ.toSignedMeasure) E = μ.real E = (μ E).toReal`；
`measure_toSignedMeasure_add`、`measure_toSignedMeasure_zero` 说明该对应与加法、零元相容。
这是接入既有 R4 正测度／积分主线的入口，本 Entry 不改动那条主线。

**正／负／零集的课程量词定义**：`IsPositiveSet`、`IsNegativeSet`、`IsNullSet` 显式写出
`MeasurableSet i ∧ ∀ j, MeasurableSet j → j ⊆ i → …`，即教材量词。Mathlib 侧用限制序
`0 ≤[i] s`、`s ≤[i] 0`（`VectorMeasure.restrict` 上的逐点序）表达同一概念，但**没有**具名
“正集/负集”谓词。因此本库给出方向清楚的双向桥：

- `isPositiveSet_iff_zero_le_restrict (hi : MeasurableSet i) : IsPositiveSet s i ↔ 0 ≤[i] s`；
- `isNegativeSet_iff_restrict_le_zero`；
- `isNullSet_iff_isPositiveSet_and_isNegativeSet`。

桥的左侧是课程量词，右侧是 Mathlib 接口；两个方向都由 `VectorMeasure.restrict_le_restrict_iff`
给出，量词逐字对应，语义一致。

**真实使用者**：`IsPositiveSet.mono`/`IsNegativeSet.mono`/`IsNullSet.mono`（可测子集封闭）、
`IsPositiveSet.iUnion`/`IsNegativeSet.iUnion`（可数个正／负集之并仍正／负；证明先把
`k ∩ f n` 用 `disjointed` 不交化，再用可数可加性与级数非负／非正性，是课程定义的真实使用者）、
`exists_hahnDecomposition : ∃ P, IsPositiveSet s P ∧ IsNegativeSet s Pᶜ`（Hahn 分解存在性，
由 Mathlib `SignedMeasure.exists_compl_positive_negative` 经上述桥得到）。

# 依赖与边界

- **依赖**：无库内 Entry 前提；Mathlib 的 `MeasureTheory.VectorMeasure` / `SignedMeasure` 与
  有限测度接口。正测度／积分主线（R1–R4）只通过 `Measure.toSignedMeasure` 这一入口被引用，
  本 Entry 不修改它。
- **边界**：只处理**有限（实值）**有符号测度；取值 ±∞、符号可加性的一般定义不在本批。
  教材中“正集”通常默认可测，本库定义 likewise 把可测性并入谓词。
  **RA-F2**（绝对连续、互奇异、Lebesgue 分解、Radon–Nikodym）不在本 Entry，也不得从本 Entry
  的结论声称它已完成。
