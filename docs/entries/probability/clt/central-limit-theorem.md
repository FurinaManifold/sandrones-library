---
id: probability.central-limit-theorem
family: probability.clt
variant: textbook
kind: theorem
state: verified
title: 一般 iid 中心极限定理（中心化与标准化）
summary: 由中心化标准化归约与特征函数基础链证明任意均值、正方差 iid 序列的中心极限定理，并给出退化方差边界与随机变量层分布收敛消费者
premises: [probability.clt.characteristic-foundation, probability.convergence.distribution-bridge]
mathlib: [ProbabilityTheory.variance, ProbabilityTheory.variance_eq_integral, ProbabilityTheory.ae_eq_integral_of_variance_eq_zero, MeasureTheory.MemLp.integrable, MeasureTheory.gaussianReal_zero_var, MeasureTheory.ProbabilityMeasure]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 教材陈述

设 `X₀, X₁, …` 是同一概率空间上的实值随机变量，独立同分布，且二阶矩有限：

\[
  \mathbb E[X_0]=\mu,
  \qquad
  \operatorname{Var}(X_0)=\sigma^2>0.
\]

记

\[
  Z_n=\frac{1}{\sigma\sqrt n}\sum_{k=0}^{n-1}(X_k-\mu).
\]

本条目证明 `Zₙ` 的分布作为 `ProbabilityMeasure ℝ` 弱收敛到标准正态 `gaussianReal 0 1`；并证明
若 `σ²=0`，则 `(√n)⁻¹∑(Xₖ-μ)` 的分布弱收敛到退化的 `gaussianReal 0 0`。最后把正方差结论经
`probability.convergence.distribution-bridge` 送回随机变量层的 `TendstoInDistribution`。

# 为什么用中心化标准化归约

已验收的 `probability.clt.characteristic-foundation` 只处理中心为零、二阶矩为一的序列
`(√n)⁻¹∑Xₖ`，且目标测度是已知的 `gaussianReal 0 1`。一般 iid 定理不需要重新做特征函数或
Taylor 展开，只需要把它化成那个已证情形。

令

\[
  Y_k=\frac{X_k-\mu}{\sigma}.
\]

则 `Y₀,Y₁,…` 仍然独立、同分布，且 `𝔼[Y₀]=0`、`𝔼[Y₀²]=1`。同时

\[
  \frac{1}{\sqrt n}\sum_{k<n}Y_k
  =\frac{1}{\sigma\sqrt n}\sum_{k<n}(X_k-\mu)
\]

逐点恒等。因此把 `Y` 代入标准化核心，就得到一般均值和方差下的结论。

这里的归约只使用**已知目标测度** `gaussianReal 0 1` 的 Lévy 反向，没有触碰“任意点态特征函数
极限是否仍是特征函数”的存在性问题，也没有 import 或调用 Mathlib 的最终
`CentralLimitTheorem`。

# 正式承载与记号

教材概念“随机变量序列依分布收敛”直接复用 Mathlib 的
`MeasureTheory.TendstoInDistribution` 作为正式承载（本库已在
`probability.convergence.modes` 中解释并登记）。正方差结论的核心承载是
`MeasureTheory.ProbabilityMeasure ℝ` 上的弱收敛 `Filter.Tendsto`，与基础链一致。

分布对象由本条目新增的 `centeredScaledSumLaw X hX μ σ n : ProbabilityMeasure ℝ` 承载：它是
`(σ√n)⁻¹∑(Xₖ-μ)` 的推前分布。`hX` 保存每项的 a.e. 可测性，有限和的 a.e. 可测性由
`Finset.aemeasurable_fun_sum` 自动得到，因此推前测度确实是概率测度。

# 独立性与同分布经映射保持

`iIndepFun_centeredScaled` 证明 `iIndepFun X P` 经逐点映射 `x ↦ (x-μ)/σ` 保持为
`iIndepFun (fun k ω ↦ (X k ω - μ)/σ) P`；`identDistrib_centeredScaled` 证明
`IdentDistrib (X i) (X 0)` 传递到标准化序列。两条都是 Mathlib 通用接口
`iIndepFun.comp`、`IdentDistrib.comp` 的直接实例化，没有新建结构。

# 矩条件化为标准化矩

- `integral_centeredScaled_eq_zero`：`X₀` 可积且 `P[X₀]=μ` 时，`∫ (X₀-μ)/σ = 0`。证明用
  `integral_div`、`integral_sub`、`integral_const` 把中心化项拆开。
- `integral_sq_centeredScaled_eq_one`：二阶中心矩为 `σ²`（`σ≠0`）时，
  `∫ ((X₀-μ)/σ)² = 1`。证明先把 `((X₀-μ)/σ)²` 写成 `(X₀-μ)²/σ²`，再用 `integral_div` 与
  `div_self`。

主定理把教材假设 `Var[X₀]=σ²` 通过 `variance_eq_integral` 转换为二阶中心矩的积分形式
`P[(X₀-μ)²]=σ²`，其中 `μ=𝔼[X₀]`。

# 归一化和的恒等式

`centeredScaledSumLaw_eq_normalizedSumLaw` 证明

\[
  \mathrm{law}\!\left((\sqrt n)^{-1}\sum_{k<n}Y_k\right)
  =\mathrm{law}\!\left((\sigma\sqrt n)^{-1}\sum_{k<n}(X_k-\mu)\right).
\]

两侧函数逐点由域的结合律 `(√n)⁻¹·(a/σ)=a/(σ√n)` 相等，故用 `Measure.map_congr` 得到推前测度
相等。这里没有用到 `σ≠0`：`n=0` 时两侧都归约为零测度的推前，恒等式仍成立。

# 主定理与证明链

`iid_centeredScaled_clt` 在 `iIndepFun X P`、逐项同分布、`MemLp (X 0) 2 P`、
`P[X₀]=μ`、`Var[X₀]=σ²`、`σ>0` 下证明

\[
  \mathrm{law}(Z_n)\Rightarrow N(0,1).
\]

证明顺序：

1. 由 `MemLp.integrable` 得 `X₀` 可积；
2. 由 `variance_eq_integral` 把方差假设转成二阶中心矩；
3. 用上面两条矩条件把 `Y` 凑齐标准化核心的前提；
4. 调用 `normalizedSum_probabilityMeasure_tendsto_standardGaussian`；
5. 用归一化和恒等式把序列改写为中心化缩放和律。

全链只依赖已验收基础链与本条目的矩与代数引理。

# 退化方差边界

`degenerateVariance_centeredSum_tendsto` 处理 `Var[X₀]=0`。由
`ae_eq_integral_of_variance_eq_zero`，`X₀` 几乎必然等于 `𝔼[X₀]=μ`；同分布经
`IdentDistrib.ae_snd` 把这一点传给每一项。于是对每个 `n`，中心化归一化和
`(√n)⁻¹∑(Xₖ-μ)` 几乎必然为零，其推前分布恒为 `Measure.dirac 0 = gaussianReal 0 0`，弱收敛结论
由常序列得到。

这条边界只覆盖“方差为零”这一半，且结论中的缩放是 `√n` 而非 `σ√n`（`σ=0` 时后者无定义）。

# 随机变量层消费者

`iid_centeredScaled_clt_tendstoInDistribution` 在正方差前提下，若另有随机变量 `Z` 满足
`P'.map Z = gaussianReal 0 1`，则

\[
  \left((\sigma\sqrt n)^{-1}\sum_{k<n}(X_k-\mu)\right)_{n}
  \xrightarrow{d} Z
\]

即 `TendstoInDistribution`。它直接调用本批的通用桥
`tendstoInDistribution_of_tendsto_law_gaussian`（见 `probability.convergence.distribution-bridge`），
说明弱收敛结论确实能进入随机变量层接口。

# 依赖与边界

- 库内前提：`probability.clt.characteristic-foundation`（标准化核心）与
  `probability.convergence.distribution-bridge`（随机变量层桥）。
- Mathlib 正式承载：`ProbabilityMeasure`、`TendstoInDistribution`、`MemLp`、`variance`、
  `gaussianReal` 及 `Measure.map_congr`、`integral_div` 等积分与测度后端。
- 未完成边界：非同分布三角阵、Lindeberg--Feller 条件、Berry--Esseen 收敛速度、多元与函数型 CLT；
  一般点态特征函数极限的存在性（即“任意 `φₙ→f` 且 `f` 在零连续”版本）仍未证，本条目只使用已知
  目标测度 `gaussianReal 0 1`。
