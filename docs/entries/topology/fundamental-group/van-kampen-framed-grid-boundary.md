---
id: topology.fundamental-group.van-kampen-framed-grid-boundary
family: topology.fundamental-group
variant: framed-row-and-grid-perimeter
kind: theorem
state: verified
title: van Kampen 网格的 framed 行与外边界关系
summary: 以顶点 frames 重基化小格边界，先逐格再逐行消去内部边，得到完整有限网格的非交换四侧边界关系
premises: [topology.fundamental-group.van-kampen-mixed-vertex-coherence]
mathlib: [Fin, Path, FundamentalGroup, Monoid.PushoutI]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

van Kampen 单射证明把一个零同伦方形切成有限网格，并将每个小格的边界关系相乘。纸面证明通常说
“所有内部边两两抵消”，但相邻小格使用的 connector 不同，内部边在 Pushout 中并不会按定义直接
成为逆元。本条目引入顶点 frames，把这些基点变化显式吸收到每条边的重基化中。

# 直觉

一个小格的四个角各带一个群元素。水平相邻小格的右侧 frames 经真实 edge transition 传播到下一格
左侧 frames；中央 transition 方格保证整行 frames 沿竖直边提升后仍相容。`FocusedBoundary` 记录尚未
粘合的右边，逐格 `attachRight` 时该边与下一格左边消去。完整行再按相邻行的公共横边粘合，最后只剩
外侧四条词。

# 陈述（自然语言）

任意满足水平 transition 相容性的单行 frames 都产生一个完整行状态，其左、上、右、下边界满足
标准非交换矩形关系。规范首行 frames 可沿逐列竖直 transitions 提升，并保持水平相容。将所有完整行
递归粘合后，整个有限网格的左边界词逆、顶边界词逆、右边界词和底边界词依次相乘等于单位元。

# 陈述（Lean 对照）

```lean
structure CellVertexFrames (G : Type*) where ...
def HorizontalCellFramesCompatible (T : EdgeTransitions G) ... : Prop := ...

theorem BinaryOpenCoverSquareSubdivision.framedHorizontalFullRowState_standard_relation ...
theorem BinaryOpenCoverSquareSubdivision.framedHorizontalFullRowState_leftEdge ...
theorem BinaryOpenCoverSquareSubdivision.gridPerimeterWords_standard_relation ...
```

# 思维脉络（thinking trace）

先用单格边界关系建立 `FocusedBoundary`，并证明右附一个小格保持总关系。随后对列号递归建立 framed
row-prefix；完整行只是最后一个前缀。四顶点 transition 方格给出 `CellVertexFrames.liftAcrossVertical`
保持水平相容。再对行号递归建立 grid-row prefix，使用相邻两行的 top/bottom 词相等消去内部横边。
最后把递归状态的三个投影识别成显式 perimeter words，得到公开四侧关系。

# 自然语言 ↔ Lean 映射

聚焦粘合器是 `FocusedBoundary.attachRight`；小格 frames 与水平相容分别是 `CellVertexFrames` 和
`HorizontalCellFramesCompatible`。07b 唯一需要读取的 prefix 构造是
`FramedHorizontalRowPrefixState`/`framedHorizontalRowPrefixState`；它们是拆批 implementation API，
不是后续课程主接口。完整行由 `framedHorizontalFullRowState` 构造，其左端投影和边界关系分别由
`framedHorizontalFullRowState_leftEdge`、`framedHorizontalFullRowState_standard_relation` 给出。
网格最终高层出口是 `gridPerimeterWords_standard_relation`。

# 依赖（人话版）

有限索引、道路、基本群与 Pushout 承载复用 Mathlib。本库上一条目的
`centralInternalTransitions_square` 提供相邻四格的 frame 传播相容性；本条目新增的是有限网格的
focused/framed telescope 组合层，没有另建基本群或推出结构，也不要求覆盖成员开放或覆盖全空间。

# 应用与陷阱

乘法次序不可交换：top 与 left 以逆元出现，内部公共边的消去顺序由粘合递归固定。
`FramedHorizontalRowPrefixState` 的可见性只服务 07b 跨文件证明；08 起必须只调用 full-row 投影。
四侧乘积为一并不意味着任一外侧词为一；右锚定、左边界消失、kernel 与 van Kampen 单射均属于后续
批次。
