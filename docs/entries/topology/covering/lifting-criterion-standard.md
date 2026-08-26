---
id: topology.covering.lifting-criterion-standard
family: topology.covering
variant: based-continuous-lift-iff-fundamental-group-image-inclusion
kind: theorem
state: research
title: 覆盖映射的提升判据
summary: 对道路连通且局部道路连通的定义域，以基本群像包含刻画保持指定基点的连续提升存在唯一性
premises: [topology.covering.monodromy-standard, topology.fundamental-group.functoriality-standard]
mathlib: [IsCoveringMap.existsUnique_continuousMap_lifts_of_range_le, FundamentalGroup.map, FundamentalGroup.mapOfEq, Path.Homotopic.Quotient.map_comp]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

局部上，覆盖映射总允许把映射提升到某张 sheet；全局困难在于沿不同道路延拓后能否得到同一点。C4a
把这种道路依赖编码成 monodromy。若定义域中的每个基环路经 `f` 映射后都来自总空间中的基环路，
其提升便闭合，沿道路定义的提升与道路选择无关。这正由两个诱导基本群同态的像包含表达。

# 教材定理

设 `p : E → X` 为覆盖映射，`A` 道路连通且局部道路连通，`f : A → X` 连续。指定 `a₀ : A` 和
`e₀ : E`，满足 `p(e₀)=f(a₀)`。则存在连续 `F : A → E` 满足 `F(a₀)=e₀` 且 `p∘F=f`，当且仅当
`f₍*₎π₁(A,a₀) ⊆ p₍*₎π₁(E,e₀)`。一旦存在，这个保持指定基点的提升唯一。

必要方向实际上不需要 `A` 道路连通或局部道路连通；这些假设只用于从像包含构造全局连续提升。

# Lean 正式接口

```lean
theorem coveringMap_lift_range_le_of_exists ... :
    (FundamentalGroup.map f a0).range ≤
      (FundamentalGroup.mapOfEq ⟨p, cov.continuous⟩ he).range

theorem exists_coveringMap_lift_iff_range_le ... :
    (∃ F : C(A,E), F a0 = e0 ∧ p ∘ F = f) ↔
      (FundamentalGroup.map f a0).range ≤ ...

theorem existsUnique_coveringMap_lift_iff_range_le ... :
    (∃! F : C(A,E), F a0 = e0 ∧ p ∘ F = f) ↔
      (FundamentalGroup.map f a0).range ≤ ...
```

# 必要方向

假设已有 `F`。任取 `q : π₁(A,a₀)`，先由 `FundamentalGroup.map F a₀` 得到总空间基本群中的元素。
再由覆盖投影诱导映射，其结果等于直接由 `f` 诱导的元素，因为 `p ∘ F=f`。形式证明先用基点等式
把 `e₀` 化为 `F a₀`，再用 `Path.Homotopic.Quotient.map_comp` 验证两次道路映射与复合映射相同。

这个构造对 `f₍*₎` 像中的每个元素给出 `p₍*₎` 像的显式 witness，所以得到 subgroup inclusion；没有
借用完整提升判据，也没有偷偷加入连通性假设。

# 充分方向与唯一性

Mathlib `IsCoveringMap.existsUnique_continuousMap_lifts_of_range_le` 已实现充分方向。它在
`PathConnectedSpace A` 下用从 `a₀` 出发的道路决定候选值，以像包含保证不同道路给出相同终点，并在
`LocallyPathConnectedSpace A` 下证明所得函数连续。返回值已经是 `∃!`，同时包含基点和投影方程。

存在版 iff 取这个 `∃!` 的 witness；存在唯一版 iff 直接使用完整结果。两个 iff 的反向都复用 Mathlib，
正向都调用本条目独立证明的必要方向，因而不是现成充分定理的单行别名。

# 自然语言 ↔ Lean 映射

`f₍*₎` 是 `FundamentalGroup.map f a0`。由于覆盖投影把 `e₀` 送到与 `f a₀` 相等但未必定义相等的点，
`p₍*₎` 写作 `FundamentalGroup.mapOfEq ⟨p,cov.continuous⟩ he`；`mapOfEq` 只作基点类型调整，不改变
拓扑映射。两者的 `range` 是基本群中的 `Subgroup`，“包含”写作 `≤`。提升用 `ContinuousMap A E`，
基点条件和投影条件显式保留在合取中。

# 类型假设和依赖

必要方向只要求 `A`、`E`、`X` 为拓扑空间以及 `IsCoveringMap p`，甚至覆盖性质仅用于获得投影连续性。
两个 iff 严格要求 `[PathConnectedSpace A] [LocallyPathConnectedSpace A]`，不要求 `A` 单连通，不要求
`E` 或 `X` Hausdorff，也不加入 C5 的半局部单连通假设。

基本群及诱导映射复用本库已解释的 functoriality 层；C4a 提供 monodromy/闭环的课程动机，Mathlib
提供充分方向的构造后端。

# 应用与边界

该判据可检验一个给定映射是否能提升，并为 universal cover 候选与覆盖分类准备基本群子群语言。
但本批没有构造 universal cover、没有证明 simply connected 特例，也没有给出覆盖同构类和子群共轭
类之间的对应。C5 仍处于研究门，必须另行审计道路连通、局部道路连通和半局部单连通的职责。
