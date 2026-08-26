---
id: topology.fundamental-group.van-kampen-square-subdivision
family: topology.fundamental-group
variant: binary-open-cover-labelled-square-grid
kind: theorem
state: verified
title: 二开集覆盖下的有限带标签方格细分
summary: 连续方形逐点落在二开集之一时存在有限一致方格细分，每格落在一个覆盖成员且异标签公共边落在交集
premises: [topology.fundamental-group.van-kampen-cover-subdivision]
mathlib: [ContinuousMap, Set.Icc.convexComb, lebesgue_number_lemma_of_metric, Prod.dist_eq, Real.exists_nat_pos_inv_lt]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

van Kampen 规范同态的单射证明需要细分一个零同伦方形，而不再只是细分一条环路。本条目提供严格
的二维有限数据：每个小方格完全位于一个覆盖成员中，标签切换的整条公共边位于交集。它是后续
方格边界词与内部边抵消的输入，但本身不声称单射。

# 直觉

把两个开集沿连续方形取原像，得到紧致参数方形的开覆盖。Lebesgue 数给出统一半径；选择网格宽度
小于该半径的一致方格网格，每个闭方格都落在某个原像开集里。如果水平或竖直相邻方格选了不同
标签，它们公共边上的每一点同时属于两个方格，因此其像属于两个开集的交。

# 陈述（自然语言）

设 `H : I×I → X` 连续，`U,V` 开，并且 `H` 的每个值属于 `U` 或 `V`。则存在正整数 `N` 和
`N×N` 个 Bool 标签，使第 `(i,j)` 个闭方格的全部像位于标签指定的 `U` 或 `V`。若水平或竖直
相邻的两个方格标签不同，则它们整条公共边的像包含于 `U∩V`。

# 陈述（Lean 对照）

```lean
structure BinaryOpenCoverSquareSubdivision
    (H : C(unitInterval × unitInterval, X)) (U V : Set X)

theorem exists_binaryOpenCoverSquareSubdivision
    (H : C(unitInterval × unitInterval, X))
    (hU : IsOpen U) (hV : IsOpen V)
    (hH : ∀ z, H z ∈ U ∨ H z ∈ V) :
    Nonempty (BinaryOpenCoverSquareSubdivision H U V)

theorem BinaryOpenCoverSquareSubdivision.horizontalSwitchEdge_mem_intersection ...
theorem BinaryOpenCoverSquareSubdivision.verticalSwitchEdge_mem_intersection ...
```

# 思维脉络（thinking trace）

沿 `H` 取原像后，对紧致度量空间 `unitInterval × unitInterval` 使用 Lebesgue 数。VK1 已有的
`unitIntervalMeshPoint` 给出每轴的 `i/N` 网格点；`unitSquareCellPoint` 用两个逐坐标凸组合参数化
闭方格。乘积度量公式把方格点到左下角的距离化为两个一维距离的最大值，两者都不超过 `1/N`。
逐格选择覆盖标签即可组成结构。公共边结论分别把左／右格的横参数取 `1/0`，或下／上格的纵参数
取 `1/0`，再对两个 Bool 标签分类。

# 自然语言 ↔ Lean 映射

“第 `(i,j)` 个闭方格中的点”对应 `unitSquareCellPoint`；“有限一致方格细分”对应
`BinaryOpenCoverSquareSubdivision`，字段 `steps_pos` 保证网格非空，`label` 给出二维 Bool 标签，
`cell_mem` 记录整格像包含；存在性对应 `exists_binaryOpenCoverSquareSubdivision`；水平和竖直的
“异标签公共边落在交集”分别对应 `horizontalSwitchEdge_mem_intersection` 与
`verticalSwitchEdge_mem_intersection`。

# 依赖（人话版）

二维网格沿两轴直接复用 VK1 的 `unitIntervalMeshPoint` 和相邻距离公式。Mathlib `ContinuousMap`
承载连续方形，`Set.Icc.convexComb` 参数化闭格，`lebesgue_number_lemma_of_metric` 只作用于参数方形，
`Prod.dist_eq` 提供最大乘积度量，`Real.exists_nat_pos_inv_lt` 选择足够细的正整数网格。目标空间 `X`
只需拓扑结构，并未因证明后端而增加度量假设。

# 应用与陷阱

本条目可用于细分道路同伦或零同伦，只要先把它视为连续映射 `I×I → X`。结构只记录方格、标签和
像包含；它没有选择四条定向边，没有构造方格边界环路，也没有证明内部边抵消。公共边结论要求
标签确实不同；同标签相邻格无需推出公共边在交集。不得从本条目直接推断 van Kampen 规范同态
单射、推送同构或完整 Seifert--van Kampen 定理。
