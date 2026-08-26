---
id: topology.fundamental-group.van-kampen-combined-frames
family: topology.fundamental-group
variant: aligned-block-and-grid-potential-compatibility
kind: theorem
state: verified
title: van Kampen 左边界的组合 frames
summary: 将逐边 cell-to-letter transitions 与二维右锚定 cell frames 合成，证明 block 内相邻性、相邻 block 全局索引桥及四方向内部边的统一 grid-potential 公式
premises: [topology.fundamental-group.van-kampen-left-boundary-cocycle]
mathlib: [Path, FundamentalGroup, Monoid.PushoutI, Fin, Group]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

13a 只证明逐边 cell-to-letter transition 在共享顶点满足 cocycle；二维右锚定网格已有另一套 cell
frames。有限 telescope 真正需要的是两套变化合成后的 frame，并且必须证明它们沿每条细边和 block
索引严格相容。本批完成这一组合层，同时把后续 residual gauge 所需的内部边 transition 统一为
grid-cell potentials。

# block 内 combined frames

`combinedLeftBoundaryFrames_adjacent` 将一条细边的 cell-to-letter transition 与对应网格行的
`rightAnchoredGridRowFramesAt` 相乘。13a 给出 transition cocycle，08b 给出上下行 cell frames 沿真实
竖直公共边的相容性；结合后得到下边组合 frame 的终点严格等于上边组合 frame 的起点。

组合次序遵循 13a 的 nested rebase 公式：逐边 transition 是内层变化，右锚定 cell frame 是外层变化，
两端均按 `inner * outer` 相乘。这里没有使用交换律。

# 相邻 block 的全局索引桥

`pathConcatSegmentGridEdgeIndex_block_adjacent` 是纯有限索引定理：相邻 concat blocks 中，前一 block
最后细边的后继端点等于后一 block 第一细边的前驱端点。其 aligned 版本
`segmentGridEdgeIndex_block_adjacent` 将该事实专门化到当前 subdivision factor。

`rightAnchoredBlockFrames_adjacent` 随后把这个索引等式送入已验收的右锚定行 frame 相容性。它只处理
cell-side frames；真正的 letter connector 接缝 cocycle属于 13c。

# 四方向内部边 potentials

水平和竖直内部边各有起点与终点，共四条统一公开定理。每条定理都允许相邻格标签相同或不同：
common 分支使用已有 common-edge comparison，switch 分支使用 dual comparison；给定共享顶点的交集
代表后，两者都被改写为相邻两格对应角的 `gridCellVertexPotentialFromIntersection` 之比。

因此 14 的 residual gauge 不再读取 common/switch Bool 分支，也不重新展开 comparison connectors。
十二条单侧 potential transport 和 common/switch 展开保持 private。

# Lean 对照

```lean
theorem PathConcatAlignedSquareSubdivision.combinedLeftBoundaryFrames_adjacent ...
theorem pathConcatSegmentGridEdgeIndex_block_adjacent ...
theorem PathConcatAlignedSquareSubdivision.segmentGridEdgeIndex_block_adjacent ...
theorem PathConcatAlignedSquareSubdivision.rightAnchoredBlockFrames_adjacent ...

theorem BinaryOpenCoverSquareSubdivision.
  verticalInternalEdgeTransitions_end_eq_gridCellPotentials ...
theorem BinaryOpenCoverSquareSubdivision.
  horizontalInternalEdgeTransitions_start_eq_gridCellPotentials ...
theorem BinaryOpenCoverSquareSubdivision.
  horizontalInternalEdgeTransitions_end_eq_gridCellPotentials ...
theorem BinaryOpenCoverSquareSubdivision.
  verticalInternalEdgeTransitions_start_eq_gridCellPotentials ...
```

两条 simp 定理 `coe_leftBoundaryBlockLastLetterEnd` 与
`coe_leftBoundaryBlockFirstLetterStart` 记录每个 letter block 首末 connector 送回环境空间后都是公共
基点常值道路，为 13c 和 kernel word 提供端点计算。

# 正式承载与公开面

道路、基本群、Pushout、群和有限索引复用 Mathlib。right-anchored frames、aligned subdivision、
cell-to-letter transitions、internal-edge comparisons 与 grid-cell potentials 均复用前序本库承载。
本批没有新增 carrier、instance、notation、Path、基本群或 Pushout。

公开面为四条 combined/index bridges、四条方向对称的统一 potential 公式和两条 block connector 端点
公式，共十项。十二个 private 只证明 common/switch 分支的单侧 potential 识别。

# 后续用途

13c 使用 block 全局索引相邻性和首末 letter connectors 建立跨 block transition cocycle。14a/14b 使用
combined frame 相容性把逐边 transport 相乘，14c 使用四个内部边 potential 公式识别 residual gauge。
kernel word 直接消费两条 connector 端点 simp 公式。

# 尚未完成的边界

本批没有证明相邻 letter blocks 的完整 transition cocycle，没有将一个 block 或完整左边界的 factors
相乘，也没有证明 residual gauge 为一、kernel 平凡、规范同态单射或最终 van Kampen 同构。
