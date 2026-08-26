---
id: topology.fundamental-group.van-kampen-left-boundary-edge
family: topology.fundamental-group
variant: aligned-cell-and-letter-local-elements
kind: theorem
state: verified
title: van Kampen aligned 左边界细边的双重局部表示
summary: 将对齐零同伦方格的真实左边界细边分别提升到 cell 与输入字母覆盖成员，构造两侧 connectors 和局部基本群元素，并识别为既有 grid 与 block factors
premises: [topology.fundamental-group.van-kampen-path-gauge-comparison]
mathlib: [Path, Path.cast, Path.subpath, FundamentalGroup, IsPathConnected, Fin]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

11c 已能比较同一几何道路的两套局部表示，但还没有把这套通用接口连接到零同伦方格的真实左边界。
对齐细分中每条左边界细边一方面是第零列某个小格的竖边，另一方面是某个输入字母 dyadic block 的
细 subpath。后续逐边 rebase 必须同时拥有这两种严格 typed 的表示。

# 同一细边的两种 subtype 表示

环境道路 `leftBoundaryAlignedGridEdge` 的端点是方格网格顶点。cell 侧把它提升到当前小格标签指定的
`binaryOpenCoverPiece`；letter 侧把同一底层道路提升到输入字母标签指定的成员。这两条 subtype
`Path` 的源类型、目标类型和端点证明一般不同，因而不能直接写成 Lean 等式。

两条 membership 定理分别证明环境道路逐点落在 cell piece 和 letter piece；它们是构造 subtype
道路的语义依据，不是重复假设。私有 source/target cast 引理只负责消去证明项和端点 transport。

# 三层数据及其责任

第一层是 membership：回答真实环境边落在哪个覆盖成员。第二层是 connector：分别从公共基点连接到
cell-side 和 letter-side 的源、目标端点，使开放道路可修正为基环路。第三层是 local element：用
`Path.correctedLoop` 和 `FundamentalGroup.fromPath` 把真实边及两端 connectors 组成成员基本群元素。

这三层不能合并成一个黑箱。12b 比较 local elements 时需要 connectors 的 endpoint changes；13--15
还直接消费相邻 connectors 与 potentials 的严格相容性。

# Lean 对照

```lean
def PathConcatAlignedSquareSubdivision.leftBoundaryAlignedGridEdge ...
theorem ...leftBoundaryAlignedGridEdge_mem_cellPiece ...
theorem ...leftBoundaryAlignedGridEdge_mem_letterPiece ...

def ...leftBoundaryAlignedGridEdgeCellStart ...
def ...leftBoundaryAlignedGridEdgeCellEnd ...
def ...leftBoundaryAlignedGridEdgeLetterStart ...
def ...leftBoundaryAlignedGridEdgeLetterEnd ...

def ...leftBoundaryAlignedGridEdgeCellElement ...
def ...leftBoundaryAlignedGridEdgeLetterElement ...
theorem ...leftBoundaryAlignedGridEdgeCellElement_eq ...
theorem ...leftBoundaryAlignedGridEdgeLetterElement_eq ...
```

# connector 与 potential 相容

字母侧相邻细边在共同网格顶点使用同一个 block connector，形成严格 adjacency。cell 侧 connectors
则与竖直 switch/common comparisons 的上下格 connectors 对齐。对应的 potential 定理把这些具体
connector 识别送入 11b/11c 的坐标无关 vertex potential 语言，为 12b 的统一 transition 提供输入。

这些定理只处理单个共享顶点或相邻细边；本层尚未把一列或一个 block 的所有 factors 相乘。

# 接回既有有限词

`leftBoundaryAlignedGridEdgeCellElement_eq` 证明新构造的 cell-side local element 正是方格细分已有的
左边界竖边 factor。`leftBoundaryAlignedGridEdgeLetterElement_eq` 证明 letter-side local element正是
11a block corrected-loop word 中对应的细边 factor。

只有这两个等式把新的双重局部数据接回前序有限词；若缺少它们，本批只会得到两套孤立的 local
elements，无法供后续 telescope 使用。

# 正式承载与类型假设

道路、subpath、cast、基本群与道路连通性复用 Mathlib `Path`、`FundamentalGroup` 和
`IsPathConnected`。aligned subdivision、block grid、cell connectors、letter connectors 与 vertex
potential 都复用前序本库接口。本批不新建 Path、网格、基本群、Pushout、comparison carrier、
instance 或 notation。

`U`、`V` 和 `U ∩ V` 的道路连通性分别用于选择成员内及交集内 connectors。给定 aligned
subdivision 后，本批不重新要求开性或覆盖等式。

# 尚未完成的边界

12a 只提供同一真实边的两侧 typed 数据和它们各自到既有 factors 的识别。它尚未构造统一的
cell-to-letter transition，也没有证明

```text
cellFactor = rebaseEdge startChange endChange letterFactor.
```

该逐边 relation 属于 12b。相邻 transition cocycle、block/global telescope、kernel 平凡、规范映射
单射和最终 van Kampen 同构属于 13--15。
