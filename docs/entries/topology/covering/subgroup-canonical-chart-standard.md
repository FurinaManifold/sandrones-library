---
id: topology.covering.subgroup-canonical-chart-standard
family: topology.covering
variant: subgroup-canonical-atlas
kind: theorem
state: verified
title: 子群道路类商的 canonical covering topology
summary: 用小邻域上的道路类乘离散 fiber 图生成拓扑，并证明终点投影是覆盖映射
premises: [topology.covering.subgroup-path-class-standard, topology.covering.semilocally-simply-connected-standard, topology.covering.definition-standard]
mathlib: [PathConnectedSpace, LocallyPathConnectedSpace, IsCoveringMap, IsEvenlyCovered, WithDiscreteTopology, TopologicalSpace.generateFrom, IsLocallyConstant]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

覆盖空间分类的构造方向从子群 `H ≤ π₁(X,x₀)` 出发。C5b 已把从 `x₀` 出发的道路
同伦类按 `H` 的起点拼接作用取商，但得到的只是集合层承载和终点函数。本条目赋予
这个商 canonical atlas topology，使小邻域上的道路类坐标成为离散 fiber 乘积图。

# 允许的小邻域

一个以 `y` 为中心的 `SmallNeighborhood` 是包含 `y` 的开、道路连通子集，并且其中任意
based loop 包含到 `X` 后在基本群中为单位元。半局部单连通给出消去 loop 的开邻域，
局部道路连通再取其中心的开道路分支，因而每个点都有这种邻域。

# Canonical chart

固定小邻域 `U` 的中心 `y`。对每个 `z ∈ U`，选一条 `U` 内从 `y` 到 `z` 的道路。从
`x₀` 到 `y` 的道路类模去 `H` 作用后构成离散索引 `FixedPathClass H y`。把其代表与
选定的局部道路拼接，得到终点在 `U` 内的 total-space 点；反向则拼接局部道路的逆。
loop-trivial 条件保证这两个操作不依赖代表，并且互逆。

# 重叠图转换

在两个小邻域 `U,V` 的交中，图转换的 base coordinate 是恒等映射。fiber coordinate
由 `U` 和 `V` 选定的两条局部道路之差决定。若交中两点由道路连接，将该道路分别
看作 `U` 和 `V` 中的道路，loop-trivial 条件说明差类不变。交作为开子空间局部道路连通，
其道路分支为开集；所以 fiber transition 是局部常值函数，从而连续。

# 由图生成拓扑

`CoveringSubgroupCanonicalChart.coveringSubgroupTopology H` 声明所有 canonical product chart 中的开集为 generator，再用
`TopologicalSpace.generateFrom` 生成 total-space 拓扑。这个定义保证 forward chart 连续。inverse
chart 对另一个 generator 的原像，正是重叠开域上连续 transition 的开集原像，因而也连续。
所以每张集合层 chart 都升级为同胚。这不是道路类商的 generic quotient topology。

# 真实 fiber 与覆盖映射

`FixedPathClass H y` 只是图的私有离散坐标，不是另一套 covering-space 定义。证明先用它
构造 `IsEvenlyCovered` 的乘积图，再调用 Mathlib
`IsEvenlyCovered.to_isEvenlyCovered_preimage`，把离散索引换成实际集合论 fiber
`projection H ⁻¹' {y}`。因此 `CoveringSubgroupCanonicalChart.coveringSubgroupProjection_isCoveringMap` 的公开结论正是 Mathlib
`IsCoveringMap`。

# Lean 对照

```lean
def coveringSubgroupTopology [PathConnectedSpace X] :
    TopologicalSpace (CoveringSubgroupPathClass x0 H)

theorem isLocallyConstant_chartTransitionFiber ... :
    IsLocallyConstant (chartTransitionFiber H U V)

theorem continuous_chartTransition ... :
    Continuous (chartTransition H U V)

theorem coveringSubgroupProjection_isCoveringMap
    [SemilocallySimplyConnectedSpace X]
    [PathConnectedSpace X] [LocallyPathConnectedSpace X] :
    @IsCoveringMap (CoveringSubgroupPathClass x0 H) X
      (coveringSubgroupTopology H) inferInstance
      (CoveringSubgroupPathClass.projection H)
```

# 边界

首版假设 base 道路连通；它不声称一个基点基本群的子群能同时分类其他道路分支。
本条目不从任意 covering 恢复子群，不证明子群与 pointed 或 unpointed covering 的双射，不构造
universal cover，也不讨论共轭模去。这些属于 C5d 及后续批次。
