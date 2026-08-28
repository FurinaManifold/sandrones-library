---
id: probability.martingale.optional-stopping-entry
family: probability.martingale
variant: textbook
kind: theorem
state: verified
title: 有界停时的可选停止定理
summary: 一致有界停时不改变离散时间实值鞅的期望
premises: [probability.martingale.definition]
mathlib: [MeasureTheory.IsStoppingTime, MeasureTheory.stoppedValue, MeasureTheory.Submartingale.expected_stoppedValue_mono]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 停时

对过滤 `𝓕`，随机时刻 `τ : Ω → ℕ∞` 是停时，是指对每个确定时刻 `i`，事件

\[
  \{\omega:\tau(\omega)\le i\}
\]

属于 `𝓕 i`。换言之，只凭时刻 `i` 已经拥有的信息，就能判断停止是否已经发生。Lean 正式承载
是 `MeasureTheory.IsStoppingTime 𝓕 τ`；`stoppingTime_iff_measurableSet_le` 原样公开上述定义。

取值域为 `ℕ∞ = WithTop ℕ` 允许过程永不触发停止，此时 `τ = ∞`。停止值
`stoppedValue X τ` 在有限分支上就是 `X (τ ω) ω`。正式定义用 `(τ ω).untopA ω` 为无限分支选取
一个值；本条目的有界假设会排除该分支，所以最终结论不依赖这项任意选择。

# 有界可选停止

设 `X` 是关于 `𝓕` 和 `μ` 的离散时间实值鞅，`τ`、`σ` 是停时，并满足

\[
  \tau\le\sigma\le N
\]

其中 `N` 是同一个确定自然数。那么

\[
  \mathbb E_\mu[X_\tau]=\mathbb E_\mu[X_\sigma].
\]

形式化定理是 `martingale_expected_stoppedValue_eq`。取 `τ = 0` 得到课程中最常用的形式
`martingale_expected_stoppedValue_eq_initial`：`𝔼[X_σ] = 𝔼[X_0]`。

# 为什么有界性足够

若 `σ ≤ N`，则 `τ ≤ σ` 也有界，两个停止值都只从 `X 0, …, X N` 中按可测事件选择。
鞅的逐时刻可积性因而保证停止值可积。一般无界停时不能仅凭鞅条件推出期望守恒；通常还需要一致
可积性、对增量和停时的控制，或其他可选停止条件。本条目不隐藏这些经典反例所要求的边界。

# Lean 证明结构

Mathlib 已证明：下鞅在有界且有序的两个停时处满足期望单调性。鞅 `X` 是下鞅，所以得到
`𝔼[X_τ] ≤ 𝔼[X_σ]`；`-X` 仍是鞅，对它应用同一定理得到反向不等式。反对称性给出等号。
因此本库复用成熟证明，不复制停时分割求和的底层技术。

# 范围

本条目只给出 `ℕ` 指标、实值鞅和一致有界停时版本。可选抽样的条件期望等式、停止过程仍为鞅、
Doob 最大不等式、无界停时版本和连续时间版本属于后续随机过程课程。
