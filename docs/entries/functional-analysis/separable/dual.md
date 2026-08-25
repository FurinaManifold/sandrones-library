---
id: functional-analysis.separable.dual
kind: theorem
state: staging
title: 可分空间、对偶与双对偶边界
premises: [functional-analysis.bidual.reflexive]
mathlib: [TopologicalSpace.SeparableSpace, StrongDual, Submodule.span]
provenance: {source_type: book, ref: "Bühler–Salamon, Functional Analysis, Section 2.4"}
---

# 动机

可分性表示空间可由可数多个点稠密逼近。转到连续对偶后，这一性质不会无条件保留；双对偶的
典范嵌入则给出一条可靠的比较通道。

# 教材定义与正式承载

可分性直接使用 Mathlib `TopologicalSpace.SeparableSpace`，即存在可数稠密子集，不建立本地谓词。
原空间到连续双对偶仍使用 `NormedSpace.inclusionInDoubleDualLi`。

# 陈述（自然语言）

若 `E*` 可分，则 `E` 可分。若 `E` 可分且自反，则 `E**` 是 `E` 的连续像，因而可分；
再对 `E*` 应用前一蕴含，得到 `E*` 可分。

# 陈述（Lean 对照）

自反时双对偶可分、对偶可分推原空间可分，以及可分自反空间的对偶可分，分别对应
`separable_bidual_of_reflexive`、`separable_of_separable_dual` 与
`separable_dual_of_reflexive`。

# 思维脉络

对 `E*` 取可数稠密集 `D`。对每个 `d ∈ D`，选取单位球中几乎取到 `‖d‖` 的向量 `x_d`。
设 `S` 是所有 `x_d` 的线性生成。若非零泛函 `f` 消灭 `S`，将 `f` 归一化并用 `D` 中的 `d` 近似它；
一方面 `d(x_d)` 因近似取范而足够大，另一方面因 `f(x_d)=0` 而必须很小，矛盾。因此 `S`
的连续零化子只有零，零化子—闭包刻画给出 `closure S = E`。`S` 由可数集生成而可分，
故 `E` 可分。连续满射保持可分性则给出自反时的双对偶和对偶推论。

# 自然语言 ↔ Lean 映射

- 可分空间：`TopologicalSpace.SeparableSpace E`。
- 连续对偶：`StrongDual ℝ E`。
- 连续双对偶：`StrongDual ℝ (StrongDual ℝ E)`。
- 自反性：`Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)`。

# 依赖

依赖上一条冻结的典范双对偶嵌入，以及零化子—闭包条目。证明后端直接使用 Mathlib 的
`TopologicalSpace.exists_countable_dense`、`ContinuousLinearMap.exists_lt_apply_of_lt_opNorm`、
`TopologicalSpace.IsSeparable.span` 和连续稠密像可分性。

# 应用与边界

一般的“`E` 可分 推出 `E*` 可分”是错的；经典边界是可分的 `ℓ1` 具有不可分对偶 `ℓ∞`。本条证明了
反向蕴含，并说明加上自反性后正向蕴含成立。对偶单位球的弱星可度量化、序列 Banach–Alaoglu
和闭单位球弱紧性仍依赖 F4，本条没有提前引入弱或弱星拓扑。
