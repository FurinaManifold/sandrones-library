---
id: statistics.maximum-likelihood
family: statistics.estimator
variant: textbook
kind: definition
state: verified
title: 似然函数与最大似然估计
summary: 以支配模型的联合可测 Radon–Nikodym 密度承载似然，用几乎处处的 argmax 定义最大似然估计并建立其订单与存在性性质
premises: [statistics.model.density, statistics.estimator.definition]
mathlib: [ProbabilityTheory.Kernel.rnDeriv, ProbabilityTheory.Kernel.measurable_rnDeriv, ProbabilityTheory.Kernel.deterministic, IsMaxOn, StrictMono.le_iff_le, Set.exists_max_image]
provenance:
  source_type: book
  ref: "schervish-theory-statistics-1995"
---

# 动机

参数模型被参考测度支配时，`statistics.model.density` 已经把每个参数的密度固定为一个联合可测的
Radon--Nikodym 导数 `p(θ,x)`。统计学关心的是反过来的读法：**观测已经给定**，哪一个参数最能解释它。
把 `θ ↦ p(θ,x)` 看作固定 `x` 的函数，就是这个似然函数；它在观测处的最大值点就是最大似然估计。

需要先解决一个真实的技术问题：密度只在参考测度下**几乎处处**唯一。零测集上改变密度的版本不改变
任何概率，却会改变逐点 argmax。因此最大似然估计不能定义成"逐点最大化一个任意选定的密度版本"，
而必须把"几乎处处"写进定义。

# 教材定义与量词

设 `P : Kernel Θ 𝓧` 是统计模型，`ν` 是样本空间上的参考测度。观测 `x` 下参数 `θ` 的似然是

\[
  L(\theta;x)=p(\theta,x)=\frac{dP_\theta}{d\nu}(x).
\]

最大似然估计是一个可测映射 `θ̂ : 𝓧 → Θ`，使得对 `ν`-几乎每个观测 `x`，

\[
  \forall \theta\in\Theta,\qquad L(\theta;x)\le L(\hat\theta(x);x).
\]

量词层级是：先对 `x` 做几乎处处约束，再在其中对全部参数取极大；可测性是估计量身份的一部分，
不是事后补充的正则性。本库不要求最大值点唯一，也不要求它存在——存在性是单独的条件。

# Lean 正式承载

似然函数不另建结构，直接给密度一个函数层名字：

```lean
noncomputable def likelihood (P : Kernel Θ 𝓧) (ν : Measure 𝓧) (θ : Θ) (x : 𝓧) : ℝ≥0∞ :=
  P.rnDeriv (Kernel.const Θ ν) θ x
```

`statistics.model.density` 已经把 `(θ,x) ↦ P.rnDeriv (Kernel.const Θ ν) θ x` 固定为联合可测版本，
`likelihood` 只是把这个一手对象命名，便于写"似然函数"和换元，不引入第二个密度载体。
`likelihood_jointlyMeasurable` 与 `likelihood_lintegral_eq_one` 分别说明它联合可测、且关于 `ν`
的总积分为一；`withDensity_likelihood_eq` 说明在 `∀ θ, P θ ≪ ν` 时

```lean
ν.withDensity (likelihood P ν θ) = P θ
```

即这个函数确实是 `P θ` 关于 `ν` 的密度，而不是任意函数。

最大似然估计用 Mathlib 的极大值谓词 `IsMaxOn` 承载：

```lean
def IsMaximumLikelihoodEstimator (P : Kernel Θ 𝓧) (ν : Measure 𝓧)
    (θhat : 𝓧 → Θ) : Prop :=
  Measurable θhat ∧ ∀ᵐ x ∂ν, IsMaxOn (fun θ => likelihood P ν θ x) Set.univ (θhat x)
```

`IsMaxOn f Set.univ a` 就是 `∀ θ, f θ ≤ f a`，因此 `isMaximumLikelihoodEstimator_iff` 给出展开

```lean
IsMaximumLikelihoodEstimator P ν θhat ↔
  Measurable θhat ∧ ∀ᵐ x ∂ν, ∀ θ, likelihood P ν θ x ≤ likelihood P ν (θhat x) x
```

这是教材陈述的逐字 Lean 对照。使用 Mathlib 的 `IsMaxOn` 是刻意的语义一致复用：极大值不是本课
专有的量词，重造 argmax 结构只会制造第二套同义谓词。

# 关键性质与证明思路

**合法估计量。** `maximumLikelihoodEstimator_isMarkov` 说明 `Kernel.deterministic θhat h.1` 是
Markov kernel，从而最大似然估计接入 `statistics.estimator.definition` 的随机化估计量接口。

**严格单调变换保持最大值点。** `isMaxOn_univ_comp_strictMono_iff` 证明对任意严格单调 `φ`，

\[
  \operatorname{argmax}_\theta \varphi(f(\theta))=\operatorname{argmax}_\theta f(\theta).
\]

`Real.log` 在 `Set.Ioi 0` 上严格单调，正是"最大化似然等价于最大化对数似然"的教材原型；本条目不
为对数单独复制一份 argmax 论证，而是把这条订单层事实抽成对任意严格单调 `φ` 的正式引理。

**换参数不变性。** `isMaxOn_univ_comp_equiv_iff` 是订单层核心：双射 `e : Θ' ≃ Θ` 下，
`θ' ↦ p(e θ')` 的最大值点恰是 `p` 的最大值点的逆像。由此 `maximumLikelihoodEstimator_reparametrize`
给出

\[
  \hat\theta \text{ 是 } P \text{ 的 MLE}
  \iff
  e^{-1}\circ\hat\theta \text{ 最大化 } \theta'\mapsto p(e\theta';x)\ \text{（} \nu\text{-a.e.）},
\]

且可测性在可测等价 `e : Θ' ≃ᵐ Θ` 下自动传递。右端刻意用换元后的似然函数表述，而不引入某个
重参数化 kernel：本库尚未冻结一般参数 comap 的 kernel 载体，把订单层结论与 kernel 层构造分开
可以避免在载体未定时伪造等价。

**似然层面的几乎处处唯一。** `maximumLikelihoodEstimator_likelihood_eq_ae` 证明任何两个最大似然
估计给出相同的最大似然值（`ν`-a.e.）。存在多个 argmax 时逐点取值可以不同，但似然值一致。

**常数似然不产生唯一估计。** `isMaximumLikelihoodEstimator_of_const_likelihood` 说明若似然完全
不依赖参数，则每个可测映射都是最大似然估计。接口不会在退化的常数模型上伪造唯一性。

# 有限参数存在性

`exists_maxOn_likelihood_of_finite` 在 `[Finite Θ] [Nonempty Θ]` 下证明每个观测处都取得最大值，
用 `Set.exists_max_image`（有限集上实值函数取最大值）而不是可测选择定理。
`maximumLikelihoodMapOfFinite` 作经典选择得到显式映射，`maximumLikelihoodEstimator_of_finite`
在样本空间可数且单点可测时证明它是最大似然估计。

额外的 `[Countable 𝓧] [MeasurableSingletonClass 𝓧]` 是"任意样本空间上存在可测 argmax"这一未解
问题的真实代价：当 `𝓧` 可数时任何从 `𝓧` 出发的映射可测，经典选择给出的 argmax 映射自动合法；
一般样本空间上的可测选择定理本条目不声称。

# Mathlib 角色分类

- `ProbabilityTheory.Kernel.rnDeriv`、`Kernel.measurable_rnDeriv`：**语义一致的正式承载**，
  由 `statistics.model.density` 引入；本条目直接复用，不另建密度。
- `IsMaxOn`（`Mathlib.Order.Filter`）：**语义一致的正式承载**，逐字对应"整个参数空间上的极大值点"；
  公开签名扫描归为第 1 类。
- `StrictMono.le_iff_le`、`Set.exists_max_image`：证明后端，不出现在核心公开签名中。
- `Kernel.deterministic`：承接估计量身份的正式承载，把确定性估计接入 `Kernel` 接口。

# 依赖与边界

依赖 `statistics.model.density`（联合可测密度）与 `statistics.estimator.definition`（估计量身份）。
联合可测性和 `likelihood` 的构造继续要求 `MeasurableSpace.CountableOrCountablyGenerated Θ 𝓧`，
与密度条目一致。

**本条目不证明**：一般可测选择（任意样本空间上存在可测的最大似然选择）、最大似然估计的相合性、
渐近正态性、Fisher 信息不等式或渐近效率；也不宣称任意模型的最大似然估计存在或唯一。似然比检验、
Cramér--Rao 下界与 Neyman--Pearson 定理是继续受门控的后续内容。
