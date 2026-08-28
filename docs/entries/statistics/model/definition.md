---
id: statistics.model.definition
family: statistics.model
variant: textbook
kind: definition
state: verified
title: 统计模型
summary: 以概率核承载随参数可测的一族样本分布
premises: [probability.space.definition]
mathlib: [ProbabilityTheory.Kernel, ProbabilityTheory.IsMarkovKernel]
provenance:
  source_type: book
  ref: "lehmann-casella-theory-of-point-estimation-1998"
---

# 教材定义

给定参数空间 `Θ` 和样本空间 `𝓧`，统计模型是一族由参数 `θ : Θ` 编号的概率测度

\[
  \{P_\theta:\theta\in\Theta\}.
\]

观察数据时，`P θ` 描述真实参数为 `θ` 时样本的分布。若要进一步对参数积分、讨论先验分布、风险
或联合可测似然，还必须控制 `P θ` 对 `θ` 的可测依赖。

# Lean 正式承载

本库不定义新的 `StatisticalModel`。正式模型由两部分共同表达：

```lean
P : ProbabilityTheory.Kernel Θ 𝓧
[ProbabilityTheory.IsMarkovKernel P]
```

`Kernel Θ 𝓧` 是从参数到样本测度的可测函数；`IsMarkovKernel P` 断言每个 `P θ` 都是概率测度。
这正好分离了“可测参数族”和“纤维总质量为一”两项语义。

# 一手性质

kernel 的可测性意味着，对每个样本空间中的可测事件 `s`，

\[
  \theta\longmapsto P_\theta(s)
\]

是可测函数。Markov 条件则给出 `P θ univ = 1`，并为每个纤维提供
`IsProbabilityMeasure (P θ)` 实例。本库分别通过 `statisticalModel_eventProbability_measurable`、
`statisticalModel_measure_univ` 和 `statisticalModel_fiber_isProbabilityMeasure` 公开这些展开。

# 两个基本构造

若概率测度 `μ` 与参数无关，则 `Kernel.const Θ μ` 是常统计模型。若观测由可测函数
`f : Θ → 𝓧` 完全确定，则

\[
  P_\theta=\delta_{f(\theta)}
\]

由 `Kernel.deterministic f hf` 承载。这两个构造说明固定分布和确定性模型都已经进入统一 kernel
接口，无需再定义特例结构。

# 与任意测度族的差别

有些初等教材只写任意集合指标的概率测度族，不要求参数可测。这样的族不能自动构造为 kernel；
如果给参数集配置离散可测结构，仍需注意该结构不一定使任意实值函数可测，除非存在相应的可测空间
条件。本条目不会用未经证明的“离散参数桥”掩盖这一问题。

# 后续消费者与边界

Mathlib 的 `avgRisk`、`bayesRisk` 和 `minimaxRisk` 已直接以 `Kernel Θ 𝓧` 作为数据生成模型；后续
统计决策条目将复用同一 carrier。支配模型与 likelihood 则应使用 `Kernel.rnDeriv` 保持
`(θ,x)` 联合可测，而不是逐参数任意选取 `Measure.rnDeriv` 的版本。

本条目只完成模型定义层。支配密度、估计量、充分性、相合性和一般估计定理均属于后续独立条目，
不能由本定义层提前宣称完成。
