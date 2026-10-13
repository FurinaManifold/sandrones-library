---
id: probability.clt.characteristic-foundation
family: probability.clt
variant: textbook
kind: theorem
state: verified
title: 中心极限定理的特征函数基础链
summary: 由独立和乘积、二阶 Taylor 小量与 Lévy 定理证明标准化 iid 和律弱收敛到标准正态
premises: [probability.characteristic-function.levy-continuity]
mathlib: [ProbabilityTheory.iIndepFun.charFun_map_fun_finsetSum_eq_prod, MeasureTheory.taylor_charFun_two, MeasureTheory.charFun_gaussianReal]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 标准化问题

设 `X₀,X₁,…` 是独立同分布实值随机变量，并满足

\[
  \mathbb E[X_0]=0,
  \qquad
  \mathbb E[X_0^2]=1.
\]

记

\[
  Z_n=\frac1{\sqrt n}\sum_{k=0}^{n-1}X_k.
\]

本条目证明 `Zₙ` 的分布作为 `ProbabilityMeasure ℝ` 弱收敛到标准正态分布
`gaussianReal 0 1`。这是中心为零、方差为一的标准化版本。

# 归一化和的分布

`normalizedSumLaw X hX n` 把 `Zₙ` 的推前分布打包为 `ProbabilityMeasure ℝ`。参数 `hX` 保存每个
`X i` 的 a.e. 可测性，确保推前测度确实保持总质量一。

这个定义只记录分布，不要求不同 `n` 的随机变量位于不同空间，也不引入额外 coupling。原始序列在
同一概率空间上，有限和的 a.e. 可测性由逐项可测性自动得到。

# 独立和变成乘积

特征函数把独立和变成乘积。`normalizedSum_charFun_eq_pow` 证明

\[
  \varphi_{Z_n}(t)
  =\left[\varphi_{X_0}\!\left(\frac t{\sqrt n}\right)\right]^n.
\]

证明先用缩放公式把 `1/√n` 移到特征函数参数，再对前 `n` 项调用独立有限和的乘积公式。最后利用
`IdentDistrib (X i) (X 0)` 把所有乘子改写成同一个 `X₀` 的特征函数，有限乘积便成为 `n` 次幂。

# 二阶 Taylor 小量

中心零、二阶矩一给出特征函数在零点的二阶展开

\[
  \varphi_{X_0}(u)=1-\frac{u^2}{2}+o(u^2),
  \qquad u\to0.
\]

正式后端 `taylor_charFun_two` 用 `isLittleO` 表达余项。只需要二阶矩，不要求三阶矩；因此本条目没有
加入 Berry--Esseen 型绝对三阶矩前提。

# 从小量到指数极限

令 `u=t/√n`，则 `u→0` 且 `u²=t²/n`。把二阶展开代入 `n` 次幂，得到经典极限

\[
  \left[\varphi_{X_0}\!\left(\frac t{\sqrt n}\right)\right]^n
  \longrightarrow e^{-t^2/2}.
\]

`centeredVarianceOne_charFun_pow_tendsto` 使用
`tendsto_pow_exp_of_isLittleO_sub_add_div` 把 Taylor 小量稳定地传递到幂极限，而不是把 `o(1/n)` 当作
可以逐项忽略的普通等式。

# 标准正态识别

标准正态分布的特征函数满足

\[
  \varphi_{N(0,1)}(t)=e^{-t^2/2}.
\]

Mathlib 的 `charFun_gaussianReal` 对一般均值、方差给出公式；代入 `0` 和 `1` 后正好得到上述目标。
因此前一节的点态极限不是任意连续函数，而是一个已知概率测度的特征函数。

# Lévy 组装

`normalizedSum_probabilityMeasure_tendsto_standardGaussian` 把前三步组装起来，并真实调用本库
`probabilityMeasure_tendsto_iff_charFun` 的反向：

```text
归一化和的特征函数
→ iid 幂公式
→ 二阶 Taylor 幂极限
→ 标准正态特征函数
→ 概率测度弱收敛。
```

这一步没有调用 Mathlib 的最终中心极限定理；弱收敛结论由本条目展示的组件直接推出。

# 与最终 CLT 的差别

最终教材定理通常从一般 `X₀` 出发，减去均值并除以标准差。还必须分别处理方差为正和方差为零的
退化情形，并把概率测度弱收敛转换成随机变量层的 `TendstoInDistribution`。

本条目没有完成这些包装，因此不能把当前 centered variance-one 结论描述成一般均值方差版 CLT。
它提供的是最终定理可依赖的标准核心。

# 范围边界

本条目只处理实值 iid 序列、共同概率空间、中心零和二阶矩一。不处理非同分布三角阵、Lindeberg--
Feller 条件、多元 CLT、函数型 CLT 或 Berry--Esseen 收敛速度。

文件没有 import `Mathlib.Probability.CentralLimitTheorem`，也没有调用最终
`tendstoInDistribution_inv_sqrt_mul_sum`。一般 CLT 仍需单独研究和正式开发门。
