---
id: probability.convergence.modes
family: probability.convergence
variant: textbook
kind: definition
state: verified
title: 随机变量的四种收敛模式
summary: 比较几乎必然、概率、Lp 与分布收敛并建立标准单向蕴含链
premises: [probability.variable.definition, probability.distribution.pushforward]
mathlib: [MeasureTheory.TendstoInMeasure, MeasureTheory.TendstoInDistribution, MeasureTheory.eLpNorm]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 四种收敛为什么必须区分

随机变量既是样本点的函数，也决定一个概率分布，因此“收敛”可以在逐点、概率、函数范数和分布
四个层次上理解。这些概念之间有重要的单向蕴含，但一般不等价。本条目固定一个概率空间
`(Ω, μ)` 和随机变量序列 `X n`，系统整理四种课程接口。

# 几乎必然收敛

`X n` 几乎必然收敛到 `Z`，是指

\[
  X_n(\omega)\longrightarrow Z(\omega)
  \quad\text{for }\mu\text{-almost every }\omega.
\]

Lean 直接写为

```lean
∀ᵐ ω ∂μ, Tendsto (fun n ↦ X n ω) atTop (𝓝 (Z ω))
```

a.e. 量词负责忽略一个零测集，内部 `Tendsto` 是值域拓扑中的普通数列收敛。本库不为它复制新的
carrier；`almostSurelyConverges_iff_ae_tendsto` 只建立教材措辞与正式表达的定义链接。

# 概率收敛

`X n` 依概率收敛到 `Z`，是指对每个 `ε > 0`，

\[
  \mu\{\omega:d(X_n(\omega),Z(\omega))\ge\varepsilon\}\longrightarrow 0.
\]

正式承载是 `TendstoInMeasure μ X atTop Z`。该 carrier 对一般测度称为依测度收敛；当 `μ` 是概率
测度时正是依概率收敛。`convergesInProbability_iff_measureReal_dist` 给出实值概率版本的定义展开。

# `Lᵖ` 收敛

`Lᵖ` 收敛是

\[
  \lVert X_n-Z\rVert_{L^p(\mu)}\longrightarrow 0.
\]

本库对普通随机变量直接使用

```lean
Tendsto (fun n ↦ eLpNorm (X n - Z) p μ) atTop (𝓝 0)
```

`eLpNorm` 取值 `ℝ≥0∞`，是当前 Mathlib API，并同时覆盖有限指数与 `p=∞`；定义层不强迫随机变量
先进入 `Lp` 商空间。只要 `p ≠ 0` 且相关函数 a.e. 强可测，`convergesInLp_inProbability` 证明
`Lᵖ` 收敛蕴含概率收敛。

# 分布收敛

`X n` 依分布收敛到 `Z`，是指其概率律弱收敛：

\[
  \mu\circ X_n^{-1}\Longrightarrow \mu\circ Z^{-1}.
\]

正式承载 `TendstoInDistribution` 把各推前测度放入 `ProbabilityMeasure E` 的弱拓扑，并同时记录
随机变量和极限的 a.e. 可测性。该 carrier 甚至允许每个 `X n` 来自不同的样本空间与概率测度；
本条目的同一空间版本只是常用特化，不另造更窄结构。

弱收敛等价于对所有有界连续测试函数的积分收敛。`convergenceInDistribution_continuousMapping`
给出首个真正消费者：若 `g` 连续而 `X n` 依分布收敛到 `Z`，则 `g ∘ X n` 依分布收敛到
`g ∘ Z`。

# 标准蕴含链

在本条目保留的可测性和 Borel 条件下：

\[
  L^p\text{ 收敛}\Longrightarrow\text{概率收敛}\Longrightarrow\text{分布收敛},
\]

并且

\[
  \text{几乎必然收敛}\Longrightarrow\text{概率收敛}
  \Longrightarrow\text{分布收敛}.
\]

对应 Lean 定理分别是 `convergesInLp_inProbability`、
`convergesInProbability_inDistribution`、`almostSurelyConverges_inProbability` 和
`almostSurelyConverges_inDistribution`。

# 子列原理与不可逆性

若 `X n` 依概率收敛到 `Z`，则存在严格递增指标 `ns`，使 `X (ns k)` 几乎必然收敛到 `Z`；这由
`convergesInProbability_has_almostSurelyConvergent_subsequence` 表达。结论是“存在子列”，不是原
序列 a.s. 收敛。

其余逆向一般也不成立：分布收敛不推出概率收敛；概率收敛不自动推出任何固定 `Lᵖ` 收敛；a.s.
收敛也不在缺少支配或一致可积条件时推出 `Lᵖ` 收敛。这些边界是后续极限定理选择正确结论的基础。

# 范围

本条目只建立收敛语言、经典单向蕴含、子列定理与连续映射定理。弱／强大数律、特征函数方法和
中心极限定理属于后续独立 Entry，不能因 Mathlib 已存在相应强定理而在此提前计入。
