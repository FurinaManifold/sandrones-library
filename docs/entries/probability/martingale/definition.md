---
id: probability.martingale.definition
family: probability.martingale
variant: textbook
kind: definition
state: verified
title: 鞅、上鞅与下鞅
summary: 以适应性和条件期望的时间一致性刻画公平、上偏与下偏过程
premises: [probability.conditional-expectation.tower, probability.filtration.definition]
mathlib: [MeasureTheory.Martingale, MeasureTheory.Supermartingale, MeasureTheory.Submartingale]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 鞅

设 `𝓕` 是过滤，`X i` 是时刻 `i` 的随机变量。过程 `X` 是关于 `𝓕` 和 `μ` 的鞅，当且仅当
它强适应于 `𝓕`，并且对任意 `i ≤ j`，

\[
  \mathbb E_\mu[X_j\mid\mathcal F_i]=X_i\qquad\mu\text{-a.e.}
\]

这表示已经知道 `𝓕 i` 中的全部信息后，对未来值的最佳预测就是当前值。Lean 中直接使用
`MeasureTheory.Martingale X 𝓕 μ`；等式必须是几乎处处等式，因为条件期望本身只在 a.e. 等价类
意义下唯一。

# 上鞅和下鞅

上鞅满足

\[
  \mathbb E_\mu[X_j\mid\mathcal F_i]\le X_i\qquad\mu\text{-a.e.},
\]

下鞅满足反向不等式。它们分别由 `MeasureTheory.Supermartingale` 和
`MeasureTheory.Submartingale` 承载。值域带偏序且完备时，鞅恰好是同时为上鞅和下鞅的过程。

# 可测性与可积性边界

Mathlib 的定义使用 `StronglyAdapted`，即每个 `X i` 关于 `𝓕 i` 强可测。一般拓扑向量空间中，
普通可测与强可测并不自动等价，因此本条目不会把它偷换成过滤条目中的普通 `Adapted`。

上鞅和下鞅显式要求每个 `X i` 可积。`Martingale` 的定义没有重复写这一项；在 Banach 值域中，
把条件期望等式取在 `i = j`，结合条件期望总是可积，即可推出 `X i` 可积。因此
`martingale_integrable` 恢复了教材常见定义中的这项要求。

# 首个消费者

固定一个 Banach 空间值函数 `Y`，令

\[
  X_i=\mathbb E_\mu[Y\mid\mathcal F_i].
\]

在 `SigmaFiniteFiltration μ 𝓕` 条件下，条件期望塔式性质直接表明 `X` 是鞅。形式化定理
`conditionalExpectation_process_isMartingale` 因而同时消费过滤的单调性和此前建立的条件期望接口，
不是孤立的术语别名。

# 范围

本条目只建立鞅、上鞅、下鞅的教材定义层。停时、可选 σ-代数和可选停止定理属于下一独立条目；
连续时间正则化、鞅收敛和 Doob–Meyer 分解属于后续随机过程课程，不在此处提前引入。
