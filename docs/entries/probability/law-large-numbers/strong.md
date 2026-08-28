---
id: probability.law-large-numbers.strong
family: probability.law-large-numbers
variant: textbook
kind: theorem
state: verified
title: 强大数律
summary: 由 Etemadi 截断证明得到一阶可积、两两独立同分布样本均值的几乎必然收敛
premises: [probability.law-large-numbers.weak, probability.convergence.modes]
mathlib: [ProbabilityTheory.strong_law_aux1, ProbabilityTheory.strong_law_aux7, ProbabilityTheory.strong_law_ae_real, ProbabilityTheory.iIndepFun]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 定理

设 `X₀,X₁,…` 是概率空间上的同分布实值随机变量，任意两个不同的变量彼此独立，并且
`E|X₀|<∞`。则

\[
  \frac1n\sum_{i=0}^{n-1}X_i
  \longrightarrow \mathbb E[X_0]
\]

几乎必然成立。Lean 的 `strongLaw_of_pairwise_independent_integrable` 将结论写成

```lean
∀ᵐ ω ∂μ, Tendsto (fun n ↦ sampleMean n ω) atTop (𝓝 (∫ ω, X 0 ω ∂μ))
```

这表示存在一个零测集，除去它以后每条样本轨道都按普通实数极限收敛。

# 两种独立性接口

Etemadi 定理只需要两两独立，正式写成

```lean
Pairwise (Function.onFun (fun f g ↦ f ⟂ᵢ[μ] g) X)
```

即对所有 `i ≠ j`，`X i` 与 `X j` 独立。这弱于全族联合独立。

标准教材中的 iid 用 `iIndepFun X μ` 和逐项 `IdentDistrib` 承载。
`strongLaw_of_iid_integrable` 通过 `iIndepFun.indepFun` 提取两两独立，然后调用 Etemadi 版本。这样既
保留常用 iid 接口，也没有隐藏定理实际需要的更弱条件。

# 最小矩条件

强大数律只假设

```lean
Integrable (X 0) μ
```

即 `E|X₀|<∞`。同分布把可积性传给其余各项。这里不要求 `MemLp (X 0) 2 μ`：方差可以不存在，
因此 WLLN 中的 Chebyshev 方差证明不能直接承担本定理。

这也是强大数律证明比二次矩弱大数律更精细的原因。证明需要截断尾部，而不能只计算有限和方差。

# 截断与几何子列

Mathlib 使用 `truncation (X i) i`，把第 `i` 项裁剪到随指标增长的有界区间。固定 `c>1`，先只观察
样本量约为 `cⁿ` 的几何子列。`strong_law_aux1` 证明中心化截断和最终满足

\[
  \left|S^{\mathrm{tr}}_{\lfloor c^n\rfloor}
   -\mathbb E S^{\mathrm{tr}}_{\lfloor c^n\rfloor}\right|
  <\varepsilon\lfloor c^n\rfloor
\]

几乎必然成立。其证明使用截断后的二次矩控制、独立性和可求和坏事件；这是 Borel--Cantelli 型
步骤发挥作用的位置。

`strong_law_aux2` 将这一结论整理为：随机波动相对于几何样本量是 `o(cⁿ)`。

# 截断期望

随机波动趋小还不够，截断和的期望必须逼近原共同期望。`strong_law_aux3` 证明

\[
  \mathbb E S_n^{\mathrm{tr}}-n\mathbb E[X_0]=o(n).
\]

这里真正使用一阶可积性控制被裁掉的尾部，并使用同分布把每项的尾部估计统一回 `X₀`。

`strong_law_aux4` 把随机波动与期望误差合并，得到几何子列上的截断和已经以正确中心
`n E[X₀]` 满足小 `o` 控制。

# 去除截断

`strong_law_aux5` 证明截断和与原部分和之差几乎必然为 `o(n)`：一阶可积性使“大于截断阈值”的
尾事件概率可求和，所以最终只有可忽略的截断误差。

合并随机波动、期望误差和截断误差，`strong_law_aux6` 得到原样本均值沿几何子列收敛到共同期望。

# 填补子列间隙

对非负随机变量，部分和随样本量单调。若 `cⁿ≤k≤cⁿ⁺¹`，便可用相邻两个几何子列的部分和夹住
`S_k/k`。再让 `c↓1`，上下界汇合。`strong_law_aux7` 正式完成这个填隙步骤，从几何子列收敛得到
所有自然数样本量上的收敛。

这一步解释了为什么只证明一个稀疏子列还不是强大数律，也解释了非负性在中间版本中的作用。

# 正负部分

一般实值变量写成

\[
  X=X^+-X^-.
\]

一阶可积性保证正部和负部都可积；可测函数复合保持两两独立与同分布。Mathlib 的
`strong_law_ae_real` 分别对两部分调用非负版本，再将两个几乎必然极限相减，得到一般实值结论。

本库最终两个公开定理复用这个完整后端，而不是从强结论名称跳过上述证明链。

# 与弱大数律的关系

几乎必然收敛蕴含依概率收敛，所以强大数律在结论上强于弱大数律；但本条目的证明没有调用 WLLN
再做不可能的反向提升。相反，它使用更弱的一阶矩假设和截断方法直接建立 a.s. 收敛。

两条定理的假设也不能只按强弱机械比较：本库 WLLN 条目采用二次可积 iid，SLLN 最小版本采用一阶
可积、同分布且两两独立。

# 范围边界

公开签名保留 `[IsProbabilityMeasure μ]`，明确概率空间语境。Mathlib 后端在某些非平凡条件下可
内部推出测度归一化，但本条目不把这种后端额外强度变成教材接口。

本条目限于实值变量。Mathlib 还有 Banach 值 `strong_law_ae` 和 `Lᵖ` 收敛版本，但它们需要额外
空间结构或指数条件，留作后续推广。非同分布 Kolmogorov 条件、三角阵、遍历定理、特征函数和
中心极限定理均不在本条目范围内。
