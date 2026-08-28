---
id: statistics.estimator.consistency
family: statistics.estimator
variant: textbook
kind: theorem
state: verified
title: 估计量的逐参数相合性
summary: 用 TendstoInMeasure 展开逐参数相合，并证明均方收敛蕴含概率相合
premises: [statistics.estimator.bias-variance, probability.convergence.modes]
mathlib: [MeasureTheory.TendstoInMeasure, MeasureTheory.eLpNorm]
provenance:
  source_type: book
  ref: "schervish-theory-statistics-1995"
---

# 相合性的含义

设 `T n` 是样本量为 `n` 时使用的实值估计量，`τ θ` 是参数 `θ` 对应的真实目标。逐参数相合表示：
对每个固定 `θ` 和每个 `ε>0`，

\[
  P_\theta\bigl(|T_n-\tau(\theta)|\geq\varepsilon\bigr)
  \longrightarrow 0.
\]

也就是说，样本量增大时，估计误差超过任意固定容差的概率趋于零。相合性不要求每条样本轨道最终
收敛；后者是更强的几乎必然相合。

# 共同观测空间

本条目使用

```lean
P : Kernel Θ 𝓧
T : ℕ → 𝓧 → ℝ
```

所有 `T n` 都定义在同一个观测空间 `𝓧` 上。典型解释是：`𝓧` 是无限样本轨道空间，`T n` 只读取
前 `n` 个坐标。本条目只冻结收敛接口，没有额外形式化“只依赖前 n 个坐标”的可测子代数条件。

共同空间很重要，因为 `TendstoInMeasure` 要求函数序列共享同一个底层测度。若每个样本量使用不同
空间 `𝓧 n`，或随机化 kernel 序列只给出各自边缘输出律而没有共同 coupling，就不能直接套用同一
个 `TendstoInMeasure`。

# Lean 中的逐参数相合

固定 `θ` 后，正式 carrier 是

```lean
TendstoInMeasure (P θ) T atTop (fun _ ↦ τ θ)
```

`P` 是 Markov kernel，所以 `P θ` 是概率测度。极限是观测空间上的常函数。这里直接复用概率收敛
条目，不另建一个只展开为同一命题的 `Consistent` 谓词。

`pointwiseConsistency_iff` 将它展开为教材的偏差概率极限，集合事件写成
`{x | ε ≤ |T n x - τ θ|}`。

# 均方相合

若

\[
  \|T_n-\tau(\theta)\|_{L^2(P_\theta)}\longrightarrow0,
\]

则 `T n` 在参数 `θ` 下依概率相合。Lean 使用

```lean
eLpNorm (T n - fun _ ↦ τ θ) 2 (P θ)
```

作为普通函数的扩展 `L²` 半范数，不要求先打包成 `Lp` 商空间元素。
`pointwiseConsistent_of_L2` 复用本库已证明的 `Lᵖ →` 概率收敛桥。

# 与偏差—方差的关系

若每个 `T n` 二次可积，偏差—方差条目给出

\[
  \mathbb E_\theta[(T_n-\tau(\theta))^2]
  =\operatorname{Var}_\theta(T_n)
   +(\mathbb E_\theta T_n-\tau(\theta))^2.
\]

因此，方差趋零且偏差趋零会使均方误差趋零，进而应得到本条目的 `L²` 充分条件。实积分 MSE 到
`eLpNorm` 的精确平方根归一化需要单独桥接；本条目没有把这一步未经证明写成定义相等。

# 一致相合

一致相合要求误差概率对所有参数同时趋零，量词顺序是

\[
  \forall\varepsilon>0,\qquad
  \sup_{\theta\in\Theta}
  P_\theta(|T_n-\tau(\theta)|\geq\varepsilon)
  \longrightarrow0.
\]

它严格强于“对每个 `θ` 分别相合”。在 Lean 中可用原始 `ℝ≥0∞` 测度的 `iSup` 表示最坏参数，避免
实数上确界需要额外有界性条件。本文件没有从逐参数相合无条件推出一致相合，也没有把二者合并为
一个模糊谓词。

# 随机化估计量边界

既有 estimator 定义允许 `κ n : Kernel 𝓧 ℝ`。但边缘输出律 `(κ n ∘ₖ P) θ` 本身不指定不同 `n`
之间如何在共同概率空间上耦合。可以直接用最坏偏差概率定义其分布层相合，也可以加入共同随机源后
恢复函数序列；这两种方案均需独立冻结。

当前条目只处理确定性估计量序列。它们可经 `Kernel.deterministic` 进入随机化接口，但本结论不
冒充一般随机化序列相合理论。

# 范围边界

本条目没有证明一致相合、几乎必然相合、渐近正态，也没有处理变化样本空间。MLE 相合、矩估计
相合、Fisher 信息、Cramér--Rao 和一般最优性都需要额外正则性与识别条件，仍属于后续受门控内容。
