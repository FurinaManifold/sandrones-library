---
id: topology.fundamental-group.van-kampen-block-boundary-cocycle
family: topology.fundamental-group
variant: adjacent-letter-block-seam
kind: theorem
state: verified
title: van Kampen 相邻字母 blocks 的边界 cocycle
summary: 将相邻 letter blocks 的首末左边界顶点识别为公共基点，并证明两侧 cell-to-letter transitions 与真实竖直网格 transition 在 block 接缝满足 cocycle
premises: [topology.fundamental-group.van-kampen-combined-frames]
mathlib: [Path, FundamentalGroup, Monoid.PushoutI, Fin]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

13a 已证明同一 letter block 内相邻细边的 transition cocycle，13b 又建立 combined frames 与全局网格
索引桥。但两个不同输入 letters 的标签可以不同，前一 block 的末 connector 与后一 block 的首
connector 也属于不同 subtype。有限 telescope 还需要证明这些 block 接缝在公共基点处使用同一套
potential 坐标。

# block 首末顶点

`leftBoundaryBlockLastVertex_eq_basepoint` 使用 13b 的末 connector 环境 coercion 公式，将一个 block
最后细边的终点网格顶点严格识别为 `x₀`。`leftBoundaryBlockFirstVertex_eq_basepoint` 对第一细边起点作
同样处理。

这两个结论发生在环境空间 `X`，不声称不同 letter 标签 subtype 中的点定义性相等。它们使公共交集
基点 `binaryOpenCoverIntersectionBasepoint` 能同时作为下 block cell/letter 与上 block cell/letter
四个 endpoint potentials 的统一代表。

# 跨 block cocycle

对相邻 block 索引 `i.succ = j.castSucc`，13b 的严格索引桥确定前一 block 最后细边与后一 block 第一
细边对应的全局网格行。`leftBoundaryBlockTransitions_cocycle` 随后分别将：

- 下边 end transition 写成下格 grid potential 到下 letter potential；
- 上边 start transition 写成上格 grid potential 到上 letter potential；
- 真实竖直 transition 写成下格 grid potential 到上格 grid potential。

两个 letter endpoint connectors 送回环境空间后都是基点常值道路，因此其 potentials 相等。应用
13a 的通用 `edgeTransitions_cocycle_of_potentials` 得到

```text
lowerT.endChange = upperT.startChange * vertical.startChange.
```

# Lean 对照

```lean
theorem PathConcatAlignedSquareSubdivision.leftBoundaryBlockLastVertex_eq_basepoint ...
theorem PathConcatAlignedSquareSubdivision.leftBoundaryBlockFirstVertex_eq_basepoint ...
theorem PathConcatAlignedSquareSubdivision.leftBoundaryBlockTransitions_cocycle ...
theorem PathConcatAlignedSquareSubdivision.coe_leftBoundaryBlockLetterConnectors_adjacent ...
```

最后一条定理公开记录相邻 blocks 的两条 letter connectors 送回 `X` 后逐点相等；它是 cocycle 的几何
解释，也供后续端点审计使用。

# 正式承载与公开面

道路、基本群、Pushout 与有限索引复用 Mathlib。aligned grid、cell-to-letter transitions、grid-cell
potentials、block 首末 connector 公式和全局索引相邻性均复用前序本库接口。本批没有新增 carrier、
instance、notation、Path、基本群或 Pushout。

四条定理全部公开：两条顶点识别由 kernel word 消费，transition cocycle 由 14 telescope 消费，
connector agreement 是接缝的稳定几何刻画。本文件没有 private 实现接口。

# 后续用途

至此 combined frames 在 block 内相邻细边和 block 间接缝两处都严格相容。14a 可以对单个 letter
block 的逐边 factor relation 作有限 telescope；14b 将 blocks 连成完整左边界；14c 再识别 residual
gauge。

# 尚未完成的边界

本批没有形成任何有限 edge product，没有证明 block word、完整左边界或 residual gauge 的最终等式，
也没有证明 kernel 平凡、规范同态单射或最终 van Kampen 同构。
