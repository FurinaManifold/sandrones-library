---
id: probability.law-large-numbers.weak
family: probability.law-large-numbers
variant: textbook
kind: theorem
state: verified
title: 弱大数律
summary: 用独立和方差可加性与 Chebyshev 不等式证明二次可积 iid 样本均值依概率收敛
premises: [probability.convergence.modes, probability.inequalities.chebyshev]
mathlib: [ProbabilityTheory.iIndepFun, ProbabilityTheory.IdentDistrib, ProbabilityTheory.IndepFun.variance_sum, MeasureTheory.TendstoInMeasure]
provenance:
  source_type: book
  ref: "durrett-probability-theory-and-examples-2019"
---

# 定理

设 `X₀,X₁,…` 是概率空间上的独立同分布实值随机变量，并且 `X₀` 二次可积。记共同期望为

\[
  m=\mathbb E[X_0].
\]

则样本均值

\[
  \overline X_n=\frac1n\sum_{i=0}^{n-1}X_i
\]

依概率收敛到 `m`。换言之，对每个 `ε>0`，

\[
  \mathbb P\bigl(|\overline X_n-m|\geq\varepsilon\bigr)\longrightarrow 0.
\]

Lean 定理是 `weakLaw_of_iid_finiteVariance`，结论使用本库已经解释过的
`TendstoInMeasure` 概率收敛 carrier。

# iid 的正式承载

全族独立由 `iIndepFun X μ` 表示。同分布写成

```lean
∀ i, IdentDistrib (X i) (X 0) μ μ
```

`IdentDistrib` 表示两个随机变量的推前分布相同；它同时携带所需的可测性。这里不另定义一个 `IID`
结构，因为这两个成熟谓词已经精确表达教材量词，并能直接调用二次可积、积分和方差的不变性。

有限方差用 `MemLp (X 0) 2 μ` 表示。`iid_memLp_of_memLp_zero` 由同分布把这一性质传给所有 `X i`，
而 `iid_sum_memLp` 与 `iid_sampleMean_memLp` 再证明有限和及样本均值二次可积。

# 期望计算

同分布给出

\[
  \mathbb E[X_i]=\mathbb E[X_0].
\]

有限和积分的线性性于是得到

\[
  \mathbb E\!\left[\sum_{i<n}X_i\right]=n\mathbb E[X_0],
\]

即 `iid_sum_integral`。当 `n>0` 时除以 `n`，得到
`iid_sampleMean_integral`：样本均值的期望仍为共同期望。

# 方差计算

全族独立通过 `iIndepFun.indepFun` 给出任意两项的独立性。`IndepFun.variance_sum` 因此给出

\[
  \operatorname{Var}\!\left(\sum_{i<n}X_i\right)
  =\sum_{i<n}\operatorname{Var}(X_i)
  =n\operatorname{Var}(X_0).
\]

这是 `iid_sum_variance`。方差在乘常数时按常数平方缩放，所以对 `n>0`，

\[
  \operatorname{Var}(\overline X_n)=\frac{\operatorname{Var}(X_0)}n,
\]

对应 `iid_sampleMean_variance`。这正是样本平均具有稳定性的定量来源。

# Chebyshev 证明

对任意 `ε>0`，本库的 `chebyshev_inequality` 给出

\[
  \mathbb P(|\overline X_n-m|\geq\varepsilon)
  \leq \frac{\operatorname{Var}(\overline X_n)}{\varepsilon^2}
  =\frac{\operatorname{Var}(X_0)}{n\varepsilon^2}.
\]

右端是常数乘 `1/n`，因而趋于零。Lean 中 Chebyshev 首先给出 `ℝ≥0∞` 测度不等式；证明用
`ENNReal.toReal_mono` 将有限上界转成 `Measure.real`，再用夹逼定理组装成
`convergesInProbability_iff_measureReal_dist` 所要求的极限。

# 零样本量约定

本文件使用 `Finset.range n={0,…,n-1}`。当 `n=0` 时，Lean 中空和为零、实数零的逆元也为零，因此
序列首项被定义为零。这不会改变 `atTop` 极限：证明在最终满足 `1≤n` 的尾部才使用除法化简和
Chebyshev 方差公式。

# 范围边界

方差法实际只需要两两独立及适当的共同矩条件，但本条目按教材首个版本冻结为 iid。它没有证明只
假设一阶矩的弱大数律，也没有处理非同分布序列、三角阵、Banach 值随机变量或强大数律。

尤其，本证明没有从 Mathlib 的强大数律反推结论；它完整保留了“方差可加—Chebyshev—概率夹逼”
这一教材证明链。强大数律、特征函数与中心极限定理仍是独立的后续条目。
