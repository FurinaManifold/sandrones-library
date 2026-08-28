---
id: statistics.estimator.bias-variance
family: statistics.estimator
variant: textbook
kind: theorem
state: verified
title: 平方损失的偏差—方差分解
summary: 将实值估计量的均方风险精确分解为输出方差与偏差平方
premises: [statistics.estimator.definition, probability.moments.variance]
mathlib: [ProbabilityTheory.variance_eq_sub, MeasureTheory.memLp_two_iff_integrable_sq, MeasureTheory.ofReal_integral_eq_lintegral_ofReal]
provenance:
  source_type: book
  ref: "schervish-theory-statistics-1995"
---

# 均方误差

设 `Y` 是一个实值估计输出，要估计的真实值是 `a`。平方损失为

\[
  L(a,Y)=(Y-a)^2,
\]

相应的均方误差是 `E[(Y-a)²]`。若 `Y` 二次可积，则

\[
  \mathbb E[(Y-a)^2]
  =\operatorname{Var}(Y)+(\mathbb E[Y]-a)^2.
\]

这就是偏差—方差分解：第一项描述估计量自身的随机波动，第二项描述平均输出偏离真实目标的系统
误差。

# 偏差与方差

偏差是

\[
  \operatorname{Bias}(Y,a)=\mathbb E[Y]-a.
\]

本库不为这一行表达式另造 `bias` 定义，以免形成只用于改写的平行接口。方差直接复用
`Var[Y;ν]`，它是 `Y` 关于自身均值的二阶中心矩。

二次可积性写成 `MemLp Y 2 ν`。它同时保证 `Y` 一阶可积和 `Y²` 可积，因而公式里的每个实值
Bochner 积分都合法。Markov kernel 只保证输出分布总质量为一，并不自动提供这一矩条件。

# 纯概率恒等式

`squaredError_integral_eq_variance_add_bias_sq` 先在任意概率测度 `ν` 上证明

```lean
∫ ω, (Y ω - a) ^ 2 ∂ν =
  Var[Y; ν] + (∫ ω, Y ω ∂ν - a) ^ 2
```

证明展开 `(Y-a)²=Y²-2aY+a²`，逐项使用积分线性，再以 `variance_eq_sub` 将
`E[Y²]-(E[Y])²` 识别为方差。这个底层定理不依赖统计模型，清楚分离了概率恒等式与 estimator
接口。

# 统计模型中的输出律

设 `P : Kernel Θ 𝓧` 是统计模型，`κ : Kernel 𝓧 ℝ` 是实值随机化估计量，两者均为 Markov
kernel。固定参数 `θ` 时，估计输出的分布是

\[
  \nu_\theta=(\kappa\circ P)_\theta.
\]

若 `MemLp id 2 νθ`，则 `estimator_squaredLossRisk_eq_variance_add_bias_sq` 给出

\[
  \int_{\mathbb R}(y-\tau(\theta))^2\,d\nu_\theta(y)
  =\operatorname{Var}_{\nu_\theta}(id)
   +\left(\int y\,d\nu_\theta(y)-\tau(\theta)\right)^2.
\]

这里 `τ : Θ → ℝ` 是要估计的实值目标，不必等同于参数本身。

# 与风险接口的桥

估计量定义条目的损失和值风险取值于 `ℝ≥0∞`，因此平方损失写成

```lean
ENNReal.ofReal ((y - τ θ) ^ 2)
```

而逐参数风险保持原生 `lintegral`。`ofReal_integral_eq_lintegral_ofReal` 在平方误差可积且非负时，
把实值积分精确转成这个 ENNReal 风险。最终定理右端也整体使用 `ENNReal.ofReal`，没有静默
`.toReal` 或假设风险总是有限而不提供证明。

# 可测性

若目标 `τ` 可测，则 `squaredLoss_jointlyMeasurable` 证明

```lean
(θ,y) ↦ ENNReal.ofReal ((y - τ θ) ^ 2)
```

联合可测。这正是将平方损失用于平均风险、Bayes 风险或后续积分交换时需要的条件。点态分解只固定
一个 `θ`，所以不额外要求全局 `Measurable τ`。

# 范围边界

本条目只处理实值输出、实值目标和固定参数下的平方风险。它没有处理向量值偏差、协方差矩阵、一般
二次型损失，也没有把逐参数公式自动积分成先验平均风险公式。

无偏估计、最小方差无偏估计、相合性、MLE、Fisher 信息、Cramér--Rao 和一般最优估计量存在性均
是后续独立条目，本分解本身不蕴含这些结论。
