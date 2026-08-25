---
id: complex-analysis.cauchy.admissible-path-connectivity-foundation
family: complex-analysis.cauchy
variant: open-connected-reachability
kind: theorem
state: verified
title: 开连通域中的可积道路可达性
summary: 连续复函数在开连通域内从固定基点到每一点都有像留在域内且可积的道路，因此单连通原函数构造只剩端点积分无关性
premises: [complex-analysis.integral.path, complex-analysis.cauchy.primitive-from-path-independence-foundation]
mathlib: [IsPreconnected.subset_left_of_subset_union, Metric.isOpen_iff, Path.trans_range, curveIntegrable_segment]
provenance:
  source_type: textbook
  ref: "Open connected subsets of a normed vector space are polygonally connected; clopen reachable-set proof"
---

# 动机

由路径积分构造原函数需要从基点到每一点选择一条域内可积道路。标准教材常用“开连通集是多边形连通的”一句带过，但当前 Mathlib 没有可直接调用的多边形道路接口。本条直接证明所需的精确版本，消除一般单连通原函数路线中的道路存在性假设。

# 直觉

把从基点能由 admissible 道路到达的点组成集合 `R`。若 `z∈R`，开放性给出 `z` 周围完全位于域内的小球；把已有道路接上一条球内短线段，就能到达球内所有点，所以 `R` 是开集。反过来，若 `z` 不可达而附近某点可达，把那条道路接回 `z` 的短线段会产生矛盾，因此不可达点集在域内也是开集。连通域不能分成两个不交的非空开部分，而基点属于 `R`，故整个域都可达。

# 陈述（自然语言）

设 `U` 是开且连通的复平面子集，`f` 在 `U` 上连续，`c∈U`。则每个 `z∈U` 都存在从 `c` 到 `z` 的道路，其像完全位于 `U`，且一形式 `f(z)dz` 沿该道路可积。若 `f` 进一步全纯并且 admissible 路径积分只依赖端点，则 `f` 在 `U` 上存在原函数；对于标准单连通开集，可达性自动满足，剩余唯一假设就是积分无关。

# 陈述（Lean 对照）

```lean
theorem exists_admissiblePath_of_isPreconnected
    (hU : IsOpen U) (hf : ContinuousOn f U) (hc : c ∈ U)
    (hconn : IsPreconnected U) :
    ∀ z ∈ U, ∃ gamma : Path c z, AdmissiblePath f U gamma

theorem exists_primitive_of_isSimplyConnected_of_pathIntegralIndependentOn
    (hU : IsOpen U) (hf : HolomorphicOnTextbook f U)
    (hconn : IsSimplyConnected U) (hind : PathIntegralIndependentOn f U) :
    ∃ g : ℂ → ℂ, ∀ z ∈ U, HasDerivAt g (f z) z
```

# 思维脉络（thinking trace）

先证明球内任意两点间的线段是 admissible：凸性控制值域，连续性给区间可积。随后定义可达集合 `R`。对 `R` 中一点，用小球和道路拼接证明邻域仍在 `R`；对 `U\R` 中一点，假设小球内存在可达点，再将其道路接上反向短线段得到矛盾。于是 `R` 与 `U\R` 都是环境空间中的开集，并把 `U` 分割。应用 `IsPreconnected.subset_left_of_subset_union` 和基点非空性得到 `U⊆R`。最后把该可达性送入前一模块的路径积分原函数构造。

# 自然语言 ↔ Lean 映射

“可达点集”对应 `R := {z | ∃ gamma : Path c z, AdmissiblePath f U gamma}`；“接短线段”对应 `gamma.trans (.segment z w)`；“拼接值域”对应 `Path.trans_range`；“可达与不可达两部分都开”分别是 `hRopen` 与 `hVopen`；“连通性排除分割”对应 `IsPreconnected.subset_left_of_subset_union`。

# 依赖（人话版）

本条依赖本库的 admissible 道路、路径积分可积性和原函数构造。Mathlib 后端提供度量开集的小球刻画、球的凸性、道路拼接值域、线段曲线可积判据以及预连通集不能跨越两个不交开集的分割定理。证明不依赖单连通同伦接口，因而对任意开连通域成立。

# 应用与陷阱

本条只解决“存在足够多可积道路”，不证明这些道路的积分相等。开连通性本身不能推出积分无关，例如穿孔平面上的 `1/z`。单连通性会在下一层用于排除这种绕洞差异，但仍需要把连续道路同伦与曲线积分定理的正则性连接起来。不要把最后一个带 `PathIntegralIndependentOn` 前提的推论误报为无条件单连通原函数定理。
