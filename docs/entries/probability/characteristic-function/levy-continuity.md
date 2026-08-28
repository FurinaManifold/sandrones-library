---
id: probability.characteristic-function.levy-continuity
family: probability.characteristic-function
variant: textbook
kind: theorem
state: verified
title: Lévy 连续性定理
summary: 以特征函数逐点收敛刻画实概率测度的弱收敛，并区分任意点态极限的紧性结论
premises: [probability.characteristic-function]
mathlib: [MeasureTheory.ProbabilityMeasure.tendsto_iff_tendsto_charFun, MeasureTheory.isTightMeasureSet_of_tendsto_charFun]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 定理陈述

设 `μₙ`、`μ₀` 是实直线上的概率测度。Lévy 连续性定理的已知目标测度版本为

\[
  \mu_n\Rightarrow\mu_0
  \quad\Longleftrightarrow\quad
  \forall t\in\mathbb R,\ 
  \varphi_{\mu_n}(t)\longrightarrow\varphi_{\mu_0}(t).
\]

左端是概率测度的弱收敛，右端是特征函数在每个参数处逐点收敛。本库定理
`probabilityMeasure_tendsto_iff_charFun` 直接给出这个双向刻画。

# 弱收敛的 Lean 承载

实概率测度使用 `ProbabilityMeasure ℝ`。其拓扑由有限测度弱拓扑诱导，因此

```lean
Tendsto μ atTop (𝓝 μ₀)
```

就是教材中的 `μₙ ⇒ μ₀`：对所有有界连续测试函数，关于 `μₙ` 的积分趋于关于 `μ₀` 的积分。这个
拓扑已经在 Mathlib 中建立，本条目不另造同义的收敛谓词。

# 正向证明思路

固定 `t`，函数

\[
  x\longmapsto e^{itx}
\]

是有界连续复值函数。弱收敛允许把它作为测试函数，于是对应积分收敛；这些积分正是特征函数值。
因此弱收敛立即推出所有 `t` 上的特征函数收敛。

# 反向证明思路

反向比正向深。特征函数逐点收敛首先给出测度族的紧性；由 Prokhorov 型紧性可抽取弱收敛子列。
对子列极限使用正向结论，得到它的特征函数必须等于目标 `μ₀` 的特征函数；特征函数唯一性再推出
子列极限就是 `μ₀`。所有子列极限相同，因而原序列弱收敛。

Mathlib 的实现使用 tightness、有界连续特征函数生成的代数和特征函数唯一性完成这条链。

# 为什么已知目标不另写连续性

`probabilityMeasure_tendsto_iff_charFun` 的右端已经指定目标函数为 `charFun μ₀`。概率测度的特征函数
总是连续，特别是在零点连续；并且 `φ_{μ₀}(0)=1`。所以这个已知目标版本无需额外传入
`ContinuousAt (charFun μ₀) 0`，并不是 Lévy 定理取消了连续性要求。

# 任意点态极限

若只知道

\[
  \varphi_{\mu_n}(t)\to f(t)
\]

而尚不知道 `f` 是某个概率测度的特征函数，那么逐点收敛本身不够。需要至少要求 `f` 在零点连续。
`tight_of_charFun_tendsto_continuousAt_zero` 在这个条件下证明 `{μₙ}` 是紧测度族。

这个结论只是存在弱收敛子列的前置，不单独声称 `f` 已经对应某个概率测度。后续还需识别子列极限
并证明唯一性。

# 与分布收敛的关系

若随机变量 `Xₙ` 的分布是 `μₙ`，随机变量 `X` 的分布是 `μ₀`，那么 `μₙ ⇒ μ₀` 就是
`Xₙ` 依分布收敛到 `X`。本条目停留在概率测度层，因为这里的 Lévy iff 最自然也最少依赖具体的
随机变量 coupling。

从这个结论桥到本库 `TendstoInDistribution` 需要显式展开各随机变量的推前分布，属于最终 CLT
批次，而不是本定义条目的一部分。

# 范围边界

本条目固定值域为 `ℝ`。Mathlib 定理还覆盖有限维实内积空间，但高维版本需要相应内积和有限维
结构，未进入本批公开签名。

本条目不证明中心极限定理，也不处理无限维 Banach 空间的特征泛函、Lindeberg 条件或三角阵。
任意极限函数版本只登记 tightness，不把零点连续性未经证明升级为完整极限测度存在性。
