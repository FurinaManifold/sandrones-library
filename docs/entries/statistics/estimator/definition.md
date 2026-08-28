---
id: statistics.estimator.definition
family: statistics.estimator
variant: textbook
kind: definition
state: verified
title: 统计量、随机化估计量与风险
summary: 用可测函数和 Markov kernel 统一确定性与随机化估计，并展开逐参数、平均与 Bayes 风险
premises: [statistics.model.definition]
mathlib: [ProbabilityTheory.Kernel.deterministic, ProbabilityTheory.avgRisk, ProbabilityTheory.bayesRisk, ProbabilityTheory.IsBayesEstimator]
provenance:
  source_type: book
  ref: "schervish-theory-statistics-1995"
---

# 从统计量到估计量

统计量是样本的可测函数 `T : 𝓧 → 𝓨`。它只依赖观测值，不依赖未知参数；当输出被解释为某个未知
量的估计时，同一个可测函数称为确定性估计量。可测性保证输出分布能够由数据分布推前得到。

随机化估计量允许在观察 `x` 后再随机产生输出。它由 `κ : Kernel 𝓧 𝓨` 承载，并且必须满足
`[IsMarkovKernel κ]`，即每个 `κ x` 都是概率测度。普通 kernel 只是一族可测有限或 σ-有限测度，
并不自动具有总质量一，因此不能省略 Markov 条件。

# 确定性估计量桥

可测函数 `T` 通过 `Kernel.deterministic T hT` 变为在 `T x` 处集中的 Dirac kernel。
`deterministicEstimator_isMarkov` 证明它是合法随机化估计量。若 `P : Kernel Θ 𝓧` 是统计模型，则

\[
  \operatorname{det}(T)\circ P=P.\operatorname{map}(T).
\]

这是 `deterministicEstimator_outputDistribution`。因此确定性情形不是一套平行理论，而是随机化接口
的特例。

# 输出分布与损失

在参数 `θ` 下，数据服从 `P θ`，估计输出服从 `(κ ∘ₖ P) θ`。如果模型和估计量都是 Markov
kernel，`estimatorOutput_isMarkov` 保证复合后仍是概率分布族。

损失 `ℓ θ y : ℝ≥0∞` 衡量参数为 `θ` 而采取输出 `y` 时的代价。值域使用扩展非负实数，使风险可以
为无穷而不在定义阶段强加可积性。课程接口要求二元函数联合可测；
`measurable_loss_section` 说明这会推出每个固定参数截面 `ℓ θ` 可测。

# 逐参数风险与平均风险

参数 `θ` 下的风险直接写为

\[
  R(\theta,\kappa)=\int_{\mathcal Y}\ell(\theta,y)
  \,d((\kappa\circ P)_\theta)(y).
\]

本库不为它另造同义 `risk` 定义。给定参数空间上的先验测度 `π`，平均风险为

\[
  \operatorname{avgRisk}(\ell,P,\kappa,\pi)
  =\int_\Theta R(\theta,\kappa)\,d\pi(\theta),
\]

其 Lean 展开是 `avgRisk_eq_lintegral_pointwiseRisk`。`avgRisk_deterministic` 再把确定性估计量的输出
律改写为推前测度，表明两类估计量使用同一风险接口。

# Bayes 风险

`bayesRisk ℓ P π` 是所有 Markov 估计量平均风险的下确界。因此
`bayesRisk_le_estimator_avgRisk` 对任一合法估计量给出下界不等式。该定义量化的是随机化估计量，
不能只对确定性可测函数取下确界后仍称为同一个 Bayes 风险。

`IsBayesEstimator ℓ P κ π` 表示 `κ` 的平均风险恰好等于 Bayes 风险，展开见
`isBayesEstimator_iff`。下确界可能不被达到，所以这个谓词本身不声称 Bayes 估计量一定存在。

# Lean 对照与边界

本条目直接复用 Mathlib 的 `Kernel`、`IsMarkovKernel`、`avgRisk`、`bayesRisk` 和
`IsBayesEstimator`，因为它们与教材中的随机决策规则、平均风险和 Bayes 下确界语义一致。没有建立
`Estimator` 或 `Loss` 包装结构，也没有复制逐参数风险定义。

本条目只建立定义链、确定性桥和风险展开。偏差—方差分解、相合性、充分性、矩估计、MLE、Fisher
信息、Cramér--Rao、不偏最优性和一般 Bayes 估计量存在性均是后续独立条目。
