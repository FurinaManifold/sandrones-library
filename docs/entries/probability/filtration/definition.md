---
id: probability.filtration.definition
family: probability.filtration
variant: textbook
kind: definition
state: verified
title: 过滤与适应过程
summary: 以递增子σ代数族表示信息流并定义过程的适应性
premises: [probability.variable.definition]
mathlib: [MeasureTheory.Filtration, MeasureTheory.Adapted]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 过滤

过滤 `𝓕 : Filtration ι m` 是按时间 `ι` 编号的一族 σ-代数。每层 `𝓕 i` 都包含在环境 σ-代数
`m` 中；若 `i ≤ j`，则 `𝓕 i ≤ 𝓕 j`。因此 `𝓕 i` 表示“截至时刻 `i` 已知的全部信息”，信息
只能随时间增加。

正式承载直接采用 `MeasureTheory.Filtration`。其时间指标只要求 `Preorder ι`，所以离散时间、
连续时间以及一般偏序信息系统都可使用同一接口；定义层没有理由要求 `LinearOrder`。

# 适应过程

过程 `X` 适应于 `𝓕`，是指每个 `X i` 关于 `𝓕 i` 可测：

\[
  \operatorname{Adapted}(\mathcal F,X)
  \quad\Longleftrightarrow\quad
  \forall i,\;X_i\text{ is }\mathcal F_i\text{-measurable}.
\]

由过滤的单调性，过去的 `X i` 对任意未来信息 `𝓕 j`（`i ≤ j`）仍然可测；又因每层都不超过
环境 σ-代数，每个 `X i` 也是普通随机变量。这两个结论是鞅定义真正使用的消费者接口。

# 版本与边界

Mathlib 4.33 的 `MeasureTheory.Adapted` 使用普通 `Measurable`。2026 年 1 月以前同名概念使用
强可测性，现已改名为 `StronglyAdapted`；本库按当前正式 API 使用前者，不复制旧定义。

自然过滤、右连续化、渐进可测性和停时都不是本定义条目的组成部分。尤其自然过滤目前要求状态
空间满足可度量 Borel 条件，并要求过程逐时刻强可测；这些额外拓扑假设不能反向污染过滤和适应性
的最小定义层。
