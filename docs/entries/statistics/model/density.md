---
id: statistics.model.density
family: statistics.model
variant: textbook
kind: definition
state: verified
title: 支配统计模型与联合可测密度
summary: 用概率核的 Radon–Nikodym 导数统一承载参数化模型的联合可测似然
premises: [statistics.model.definition]
mathlib: [ProbabilityTheory.Kernel.rnDeriv, ProbabilityTheory.Kernel.measurable_rnDeriv, ProbabilityTheory.Kernel.withDensity_rnDeriv_eq]
provenance:
  source_type: book
  ref: "lehmann-casella-theory-of-point-estimation-1998"
---

# 支配模型

设 `P : Kernel Θ 𝓧` 是统计模型，`ν` 是样本空间上的参考测度。称模型被 `ν` 支配，是指

\[
  \forall\theta,\qquad P_\theta\ll\nu.
\]

于是每个参数下都存在 Radon--Nikodym 密度。统计学还需要一个额外要求：应选择同一个版本，使
密度 `p(θ,x)` 对参数和样本联合可测；否则无法安全地对参数积分或把它直接作为一般似然函数。

# 正式密度

本库直接使用

```lean
P.rnDeriv (Kernel.const Θ ν) θ x
```

而不新建密度结构。`Kernel.const Θ ν` 把固定参考测度视为参数化常 kernel，`Kernel.rnDeriv` 给出
`Θ → 𝓧 → ℝ≥0∞` 的联合可测版本。`statisticalModel_density_jointlyMeasurable` 正式说明
`(θ,x) ↦ p(θ,x)` 可测。

# 为什么不能只用逐参数 RN 导数

对固定 `θ`，普通 `Measure.rnDeriv (P θ) ν` 只确定到 `ν`-a.e. 相等。分别对每个参数选择代表，
并不能推出所得二元函数联合可测。Kernel RN 导数专门解决了这个可测选择问题，并由
`statisticalModel_density_ae_eq_measure_rnDeriv` 保证它逐参数仍与普通 RN 导数 a.e. 相等。

# 概率重建

若 `P θ ≪ ν`，则

\[
  P_\theta(A)=\int_A p(\theta,x)\,d\nu(x)
\]

对每个可测集合 `A` 成立。对应的 Lean 结论是 `statisticalModel_withDensity_eq` 和
`statisticalModel_setLIntegral_density`。取 `A = 𝓧` 并使用 `P θ` 为概率测度，得到

\[
  \int p(\theta,x)\,d\nu(x)=1,
\]

即 `statisticalModel_lintegral_density_eq_one`。

# 类型类边界

联合可测 kernel RN 构造要求
`MeasurableSpace.CountableOrCountablyGenerated Θ 𝓧`：参数空间可数，或者样本 σ-代数可数生成。
这是可测选择的真实边界，不是证明噪声。

本条目取 `[IsFiniteMeasure ν]`，因为当前 kernel 重建定理要求模型 kernel 与参考 kernel 都有限。
Markov 模型自动有限；一般只有 σ-有限的参考测度不能未经额外桥直接套用本签名。

密度值域是 `ℝ≥0∞`。它关于 `ν` 几乎处处不等于 `∞`，但本条目不在没有证明相应 a.e. 转换规则
时静默改成实值函数。所有唯一性结论也只应按 `ν`-a.e. 理解。

# 后续范围

本条目建立支配模型和联合可测密度，供 likelihood、Bayes 风险与似然比使用。MLE、充分统计量、
Fisher 信息和一般估计定理仍是独立且受门控的后续内容；零测集上任意改变密度版本不能改变概率，
但可能改变未经 a.e. 稳健化的逐点最大化，因此 MLE 接口需要另行冻结。
