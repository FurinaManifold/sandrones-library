---
id: statistics.sufficiency.definition
family: statistics.sufficiency
variant: textbook
kind: definition
state: verified
title: 充分统计量与参数无关条件律
summary: 以共同正规条件分布定义充分统计量，并建立重构桥和有限归一化因子分解消费者
premises: [statistics.model.density, statistics.estimator.definition, probability.conditional-expectation.definition]
mathlib: [ProbabilityTheory.condDistrib, ProbabilityTheory.condDistrib_comp_map, ProbabilityTheory.Kernel, ProbabilityTheory.IsMarkovKernel]
provenance:
  source_type: book
  ref: "schervish-theory-statistics-1995"
---

# 充分性的统计含义

统计模型 `P : Kernel Θ 𝓧` 为每个参数 `θ` 指定完整数据 `x∈𝓧` 的分布。统计量
`S : 𝓧 → 𝓨` 把完整数据压缩成摘要。称 `S` 对参数充分，意思是：观察 `S(x)` 以后，关于完整数据
`x` 还剩下的随机性不再含有参数信息。

因此，充分性不是说 `S` 可以逐点恢复 `x`，也不是说 `S` 与 `x` 独立。正确对象是“给定 `S` 后
`x` 的条件分布”，正确要求是这个条件分布可以选择为与 `θ` 无关。

# 正规条件分布承载

当 `𝓧` 是标准 Borel 空间时，Mathlib 提供

```lean
condDistrib id S (P θ) : Kernel 𝓨 𝓧
```

它是完整样本 `id : 𝓧 → 𝓧` 在给定统计量 `S` 后的正规条件分布。标准 Borel 条件保证事件条件概率的
版本能够同时拼成真正的概率 kernel；一般可测空间中，这样的正规条件分布未必存在。

本库定义 `IsSufficientStatistic P S` 为：`S` 可测，并存在一个参数无关 Markov kernel
`Q : Kernel 𝓨 𝓧`，使每个参数 `θ` 都满足

```lean
condDistrib id S (P θ) =ᵐ[(P θ).map S] Q.
```

# 几乎处处量词

正规条件分布只在被条件变量的分布下几乎处处唯一。若某个统计量值 `y` 在参数 `θ` 下概率为零，
`condDistrib id S (P θ) y` 可以任意修改而不改变任何条件期望或联合分布。

因此充分性的定义必须使用 `(P θ).map S` 下的 kernel a.e. 相等，不能收紧为所有 `y` 上逐点相等。
逐点要求会把零概率纤维上的任意版本选择误当成统计信息，并可能使本来充分的统计量错误地不满足
定义。

# Blackwell 重构

`ReconstructsFromStatistic P S hS` 表示存在参数无关 Markov kernel `Q`，使

```lean
Q ∘ₖ (Kernel.deterministic S hS ∘ₖ P) = P.
```

内层 deterministic kernel 把数据分布推前成统计量分布，外层 `Q` 再从统计量值随机生成完整数据。
等式表示对每个参数，混合这些条件分布恰好恢复原始样本分布。这是实验比较中的 Blackwell 重构
语言。

重构性质与共同条件律语义相关，但本库把二者分开定义：仅凭一个任意重构 kernel，不能未经证明就
断言它在每个统计量纤维上是正规条件分布。

# 充分性推出重构

`sufficientStatistic_reconstructs` 证明共同条件律定义推出 Blackwell 重构。固定 `θ`，充分性给出

```lean
condDistrib id S (P θ) =ᵐ[(P θ).map S] Q.
```

测度复合对 a.e. 相等的 kernel 不变，所以可把 `Q` 替换成 `condDistrib id S (P θ)`。随后
`condDistrib_comp_map` 给出

```text
condDistrib id S (P θ) ∘ₘ (P θ).map S = (P θ).map id = P θ.
```

对所有参数组装这些测度等式，得到 kernel 级重构。当前条目没有证明反向等价；反向需要确保重构
kernel 的纤维一致性或加入相应正则条件。

# 支配模型的因子分解

若模型被有限参考测度 `ν` 支配，本库已有联合可测 RN 密度

```lean
P.rnDeriv (Kernel.const Θ ν) θ x : ℝ≥0∞.
```

`NeymanFisherFactorizes P ν S` 要求存在联合可测 `g : Θ → 𝓨 → ℝ≥0∞` 和可测
`h : 𝓧 → ℝ≥0∞`，使每个参数下

\[
  f_\theta(x)=g(\theta,S(x))h(x)
  \quad\text{for }\nu\text{-a.e. }x.
\]

密度保留为 `ℝ≥0∞`，避免在尚未排除无穷值时错误调用 `.toReal`；等式保留 a.e. 量词，因为 RN 密度
本身只在该层级唯一。本条目只冻结定义，没有把一般 Neyman--Fisher 因子分解定理冒充已证明结果。

# 有限离散消费者

有限原型设质量函数满足

\[
  p_\theta(x)=g_\theta(S(x))h(x),
  \qquad
  \sum_{x:S(x)=y}h(x)=1.
\]

第二个条件是额外的纤维归一化。定义

\[
  q(y,x)=\begin{cases}h(x),&S(x)=y,\\0,&S(x)\ne y.
  \end{cases}
\]

则每个 `q(y,·)` 的总质量为一。因子分解和纤维归一化还给出

\[
  P_\theta(S=y)=g_\theta(y),
\]

于是

\[
  p_\theta(x)=\sum_y P_\theta(S=y)q(y,x).
\]

`finite_normalizedFactorization_implies_reconstruction` 在 Lean 中完成这个构造和有限和计算。`q` 不
依赖 `θ`，所以它是参数无关条件概率的真实有限消费者。

# 范围边界

有限原型的纤维归一化强于一般 Neyman--Fisher 因子分解；一般 `h` 需要按纤维质量归一化，并处理
零质量纤维和可测性。本条目没有证明一般因子分解与充分性的双向定理。

本条目也没有处理最小充分统计量、完备统计量、Rao--Blackwell 定理、MLE、Fisher 信息或
Cramér--Rao 下界。它们需要在充分性定义和一般因子分解桥验收后分别开放。
