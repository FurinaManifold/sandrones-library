---
id: probability.characteristic-function
family: probability.characteristic-function
variant: textbook
kind: theorem
state: verified
title: 实值随机变量的特征函数
summary: 展开实值随机变量的特征函数并证明基本性质、独立和公式及分布唯一性
premises: [probability.distribution.pushforward, probability.independence.variables]
mathlib: [MeasureTheory.charFun, MeasureTheory.charFun_apply_real, ProbabilityTheory.IndepFun.charFun_map_fun_add_eq_mul, MeasureTheory.Measure.ext_of_charFun]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 定义与动机

实值随机变量 `X` 的特征函数定义为

\[
  \varphi_X(t)=\mathbb E[e^{itX}],\qquad t\in\mathbb R.
\]

复指数始终具有模一，所以这个期望对每个随机变量都存在，不需要先假设一阶或二阶矩。特征函数把
概率分布编码成一个连续复值函数；独立和对应函数乘法，而在实值情形它还能唯一确定分布。

# 正式承载

本库直接使用

```lean
charFun (μ.map X) : ℝ → ℂ
```

作为 `X` 在 `μ` 下的特征函数。这里 `μ.map X` 是 `X` 的分布。特征函数只依赖分布，因此先取推前
测度再调用 Mathlib 的 `charFun` 正好表达教材语义；另造一个保存同一函数的数据结构只会复制成熟
接口。

公开签名仍保留 `AEMeasurable X μ`。若省略它，`Measure.map` 对不可测函数的技术性退化行为将不再
代表随机变量分布。

# 积分展开

`realCharFun_eq_integral` 证明

\[
  \operatorname{charFun}(\mu\circ X^{-1})(t)
  =\int_\Omega \exp\!\bigl(i\,tX(\omega)\bigr)\,d\mu(\omega).
\]

证明先用 `charFun_apply_real` 展开分布测度上的积分，再由 `integral_map` 把积分拉回原样本空间。
实数乘积嵌入复数时出现的强制转换只改变表示，不改变指数中的数值。

# 基本性质

概率测度下有

\[
  \varphi_X(0)=1,
  \qquad |\varphi_X(t)|\le 1,
  \qquad \varphi_X(-t)=\overline{\varphi_X(t)}.
\]

第一式来自概率测度总质量为一；第二式来自三角不等式与 `|e^{itX}|=1`；第三式来自
`e^{-iu}=\overline{e^{iu}}`。`realCharFun_continuous` 还证明 `φ_X` 在整个实轴连续。连续性同样不要求
任何矩条件，它由模一支配和复指数的连续性得到。

# 仿射变换

对实数 `r,a,t`，本库给出

\[
  \varphi_{rX}(t)=\varphi_X(rt),
  \qquad
  \varphi_{X+a}(t)=\varphi_X(t)e^{iat}.
\]

`realCharFun_scale` 通过缩放推前测度得到第一式。`realCharFun_translate` 先将 `X+a` 的推前分解为
`X` 的分布再做平移，然后调用测度特征函数的平移公式。第二式中的复指数是确定性平移贡献的相位
因子。

# 独立和公式

若 `X` 与 `Y` 独立，则

\[
  \varphi_{X+Y}(t)=\varphi_X(t)\varphi_Y(t).
\]

Lean 定理 `realCharFun_independent_add` 的右端是函数的逐点乘法。证明后端先把独立随机变量之和的
分布识别为两个分布的卷积，再使用卷积的特征函数等于乘积。可测性假设保证三个推前测度都确实是
相应随机变量的分布。

# 分布唯一性

对可能定义在不同概率空间上的实值随机变量 `X`、`Y`，

\[
  X\overset d=Y
  \quad\Longleftrightarrow\quad
  \forall t\in\mathbb R,\ \varphi_X(t)=\varphi_Y(t).
\]

正向由同分布的推前测度相等立即得到。反向在
`identDistrib_iff_realCharFun_eq` 中调用 `Measure.ext_of_charFun`：有限测度在完备、第二可数的实内积
空间上由特征函数唯一决定。值域固定为 `ℝ`，这些拓扑条件自动满足；本条目没有把这一反向结论
未经条件披露推广到一般向量空间。

# 范围边界

本条目只处理实值随机变量。有限维实内积空间也有 `charFun`，一般 Banach 空间则应使用连续对偶上的
`charFunDual`；这些属于后续多元推广。

特征函数的矩导数、Taylor 展开、Lévy 连续性定理和中心极限定理都没有在这里证明。尤其不能仅凭
逐点极限就断言极限函数对应概率分布；Lévy 定理还需要在零点的连续性条件。CLT 必须在本基础条目
验收后另行开放。
