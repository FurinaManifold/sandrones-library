---
id: topology.fundamental-group.van-kampen-concat-aligned-subdivision
family: topology.fundamental-group
variant: dyadic-block-grid-alignment
kind: theorem
state: verified
title: van Kampen concat 对齐方格细分
summary: 将 Path.concat 的 dyadic blocks 嵌入统一方格网格，证明 block-local 细边按序覆盖全局边，并构造保留字母覆盖成员性的 aligned subdivision certificate
premises: [topology.homotopy.path-concat-dyadic-subdivision]
mathlib: [Path, Path.subpath, Path.Homotopic, Fin, List]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

10a 已找出 `Path.concat` 的真实 dyadic 断点，但 van Kampen 方形同伦使用的是统一有限网格。要把每个
字母道路与左边界上的实际细边比较，必须证明断点确实是网格点，并把每个 dyadic block 的局部细边
无遗漏、无重复地嵌入全局边列表。

# 直觉

若方格步数是 `2^n * k`，第 `i` 个 block 的长度就是相邻 breakpoint numerator 之差乘 `k`。
block-local 索引由“block 起点加局部偏移”给出；所有 block 的连续区间依次 flatten 后正好得到全部
全局边。aligned certificate 保存原方格细分、正 refinement factor 和精确步数等式，使后续定理无需
反复拆解整除证书。

# 陈述（自然语言）

dyadic 断点可嵌入统一网格，每个 block 长度为正。各 block-local edge indices 依序 flatten 成完整
全局边列表；对应 mesh point 可写为该 block 两端 dyadic 断点的凸组合。由此，每个 block 中细
subpath 的拼接与对应 dyadic segment 端点相对同伦。任何满足二开集条件的方形同伦都有 aligned
subdivision certificate；证书的相邻 block 边在共同顶点接合，左边界真实细边逐点等于字母 segment
的细 subpath，并位于该字母指定的覆盖成员。

# 陈述（Lean 对照）

```lean
def pathConcatSegmentGridLength ...
def pathConcatSegmentGridEdgeIndex ...
theorem pathConcatSegmentGridEdgeIndices_flatten ...
def pathConcatSegmentMeshPoint ...
theorem pathConcatSegmentMeshPoint_eq_convexComb ...
theorem Path.concatSegmentMeshSubpaths_homotopic ...
def Path.concatDyadicGridSegment ...
theorem Path.concatDyadicGridSegment_homotopic ...
structure PathConcatAlignedSquareSubdivision ...
theorem exists_pathConcatAlignedSquareSubdivision ...
theorem PathConcatAlignedSquareSubdivision.segmentGridEdgeIndices_flatten ...
theorem PathConcatAlignedSquareSubdivision.leftBoundarySegmentGridEdge_apply ...
theorem PathConcatAlignedSquareSubdivision.leftBoundarySubdivision_subpath_mem_letterPiece ...
```

# 思维脉络（thinking trace）

先把 breakpoint numerator 乘 refinement factor 得到全局断点索引，再用连续有限区间的列表归纳证明
flatten。mesh-point 等式通过有理参数和域化简还原为凸组合。沿一个 block 的所有细 subpaths 拼接，
借助分割道路的标准同伦得到整个 dyadic segment。aligned certificate 从 10a 的可整除细分中提取正
factor；其索引定理由保存的 `steps_eq` transport。最后沿方格左边界展开 mesh point，得到实际细边
点态公式和字母 piece membership。

# 自然语言 ↔ Lean 映射

block 长度、点和边索引由 `pathConcatSegmentGridLength`、`pathConcatSegmentGridIndex`、
`pathConcatSegmentGridEdgeIndex` 承载，完整覆盖由 `pathConcatSegmentGridEdgeIndices_flatten`
刻画。mesh point 及凸组合公式是 `pathConcatSegmentMeshPoint*`。
`PathConcatAlignedSquareSubdivision` 是必要对齐证书，其 `breakpointGridIndex`、
`segmentGridEdgeIndex` 和接缝定理提供后续稳定接口。三个最终几何出口分别给出左边界细边点态等式、
字母 piece membership 和方格 subdivision subpath membership。

# 依赖（人话版）

道路、subpath、道路同伦、有限索引与列表直接复用 Mathlib，是语义一致的正式承载。10a 提供 dyadic
scale、breakpoint、segment 及三个公开正性／末端规则；VK3a 提供二开集方格细分。本层新增的
`PathConcatAlignedSquareSubdivision` 不是平行道路或方格结构，而是把两种既有承载连接起来、并保存
后续反复需要的精确步数和正 factor 的证书。只有 certificate existence 需要开覆盖条件；证书给定后的
索引和成员性不再要求开性。

# 应用与陷阱

不同 blocks 的长度并不相等；三输入、单位 refinement 时为 `[2,2,4]`。cell 自身的 Bool 标签与左边界
细边来自哪个字母是两类不同数据，本条目只证明后者的 piece membership，不能据此宣称二者相等。
本层尚未比较两种标签对应的 Pushout 元素，也没有证明 kernel 字母词零伦、规范同态单射或最终
van Kampen 同构；这些属于 VK3b-11 以后。
