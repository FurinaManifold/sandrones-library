---
id: topology.fundamental-group.van-kampen-cover-subdivision
family: topology.fundamental-group
variant: binary-open-cover-labelled-subpaths
kind: theorem
state: staging
title: 二开集覆盖下的有限带标签道路细分
summary: 若道路逐点落在两个开集之一，则存在有限一致网格，使每条 Mathlib 子道路落在一个带标签的覆盖成员中，且标签切换顶点落在交集
premises: [topology.homotopy.path-homotopy-standard]
mathlib: [Path.subpath, Path.range_subpath_of_le, Path.concat, Path.Homotopic.concat_subpath, lebesgue_number_lemma_of_metric]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

van Kampen 定理把一个由开集覆盖的空间的基本群还原为覆盖成员及其交集中的道路信息。第一步并
不是直接构造群同态，而是把任意道路切成有限段，使每一段完全位于一个覆盖成员中。本条目只建立
这一步所需的严格有限数据，为后续的基点修正和群论论证提供可复用接口。

# 直觉

把道路拉回到单位区间后，两个开集给出单位区间的开覆盖。紧致性产生一个 Lebesgue 数：直径足够
小的集合会完整落入某个拉回开集。取网格宽度小于该数的一致有限细分，每段就能选择一个覆盖成员
作为标签。如果相邻两段选择了不同标签，它们共同的端点同时属于两段，因而落在两个开集的交中。

# 陈述（自然语言）

设 `p` 是拓扑空间中的道路，`U,V` 是开集，且对每个参数 `t` 都有 `p(t)∈U` 或 `p(t)∈V`。则存在
正整数 `N`、每段的布尔标签以及逐段包含证明：第 `i` 条子道路
`p|[i/N,(i+1)/N]` 完整位于标签指定的 `U` 或 `V` 中。若相邻段标签不同，则公共网格顶点属于
`U∩V`。这些子道路按序拼接后，与 `p` 在整个网格首尾区间上的子道路端点相对同伦。

# 陈述（Lean 对照）

```lean
structure Path.BinaryOpenCoverSubdivision (p : Path x y) (U V : Set X)

theorem Path.exists_binaryOpenCoverSubdivision
    (p : Path x y) (hU : IsOpen U) (hV : IsOpen V)
    (hp : ∀ t, p t ∈ U ∨ p t ∈ V) :
    Nonempty (Path.BinaryOpenCoverSubdivision p U V)

theorem Path.BinaryOpenCoverSubdivision.switchVertex_mem_intersection ... :
    p (unitIntervalMeshPoint D.steps D.steps_pos i.succ) ∈ U ∩ V
```

# 思维脉络（thinking trace）

先把 `U,V` 沿连续道路取原像，得到单位区间上的有限开覆盖；再调用紧致度量空间的 Lebesgue 数引理，
并选择 `N` 使 `1/N` 小于该数。`unitIntervalMeshPoint` 把有限指标解释为 `i/N`，凸组合距离估计说明
每条 `Path.subpath` 都位于以左端点为中心的相应小球中。逐段选择覆盖标签即可组成结构。切换点结论
只展开子道路在参数 `1` 与 `0` 的取值；拼接结论直接使用 Mathlib 已有的有限子道路拼接同伦。

# 自然语言 ↔ Lean 映射

“覆盖成员标签”对应 `binaryOpenCoverPiece U V : Bool → Set X`，其中 `false` 表示 `U`、`true` 表示
`V`；“一致网格点”对应 `unitIntervalMeshPoint N hN i`；“有限带标签道路细分”对应
`Path.BinaryOpenCoverSubdivision`；逐段包含是其字段 `subpath_mem`；标签切换点性质对应
`switchVertex_mem_intersection`；逐段像与原道路闭区间像的精确关系对应 `subpath_range`；有限拼接同伦
对应 `concatSubpaths_homotopic`。

# 依赖（人话版）

本条目依赖本库已经解释的道路和端点相对道路同伦。Mathlib `Path.subpath` 与教材的线性重参数化
子道路语义一致，作为正式承载直接复用；`range_subpath_of_le` 是其公开值域刻画，`Path.concat` 与
`Path.Homotopic.concat_subpath` 是有限拼接及其端点相对同伦。`lebesgue_number_lemma_of_metric` 仅是
存在性证明后端，用于单位区间这个紧致度量空间；它没有把原空间假设加强为度量空间。

# 应用与陷阱

本结构只记录二开集覆盖、有限一致网格、逐段标签及包含证明。它没有选择交集中的统一基点，没有
构造自由积或推出群同态，也没有证明 van Kampen 典范映射满射、单射或同构。拼接定理的右端写成
从网格首点到末点的 `p.subpath`；另有首末网格点等于 `0,1` 的定理，但由于道路端点类型依赖参数，
源码不以不诚实的定义相等把它直接写成 `p`。后续工作可以依赖这些有限子道路数据，不能把本条目
当作完整 van Kampen 定理。
