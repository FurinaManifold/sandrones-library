---
id: topology.fundamental-group.van-kampen-normalized-grid-gauge
family: topology.fundamental-group
variant: boundary-potential-and-two-dimensional-gauge
kind: theorem
state: verified
title: van Kampen 网格的二维规范化 gauge
summary: 以同伦方形边界的基点 potentials 归一化逐格横边，并沿竖直 transitions 传播 frames，证明完整网格左右 holonomy 相等
premises: [topology.fundamental-group.van-kampen-framed-grid-boundary]
mathlib: [Path.Homotopy, Fin, FundamentalGroup, Monoid.PushoutI]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

上一条目只证明完整网格四侧边界词的乘积为一。要进一步消去外边界，需要利用道路同伦方形的上下边
是给定环路、左右边是常值道路。第一步是选择一个二维 gauge，使每个小格的水平边在重基化后严格
成为单位元；这样整行关系只比较左右竖边 holonomy。

# 直觉

方形最下行的两个下顶点、最上行的两个上顶点以及左右边界顶点，在相应覆盖成员中都等于公共基点。
把局部 connector 相对于常值 connector 的变化送入 Pushout，就得到边界格角 potential。沿一行递归
选取 frames，使每格上下横边同时归一化为一；再沿中央竖直 transitions 将整行 frames 提升到下一行。
中央方格 coherence 保证提升后仍保持水平相容。

# 陈述（自然语言）

道路同伦方形的四侧网格顶点和边具有严格基点识别，由此构造的格角 potential 可将底边重基化为一。
对任意一行，存在水平相容的规范 frames，且每个小格的上下横边重基化后均为一。把这些 frames 传播
到全部行后，每个完整行的左边 holonomy 等于右边 holonomy；整张网格累计的左右边界词也相等。

# 陈述（Lean 对照）

```lean
def BinaryOpenCoverSquareSubdivision.gridCellBasepointPotential ...
def BinaryOpenCoverSquareSubdivision.gaugeNormalizedRowFrames ...
theorem BinaryOpenCoverSquareSubdivision.gaugeNormalizedRowFrames_compatible ...
theorem BinaryOpenCoverSquareSubdivision.gaugeNormalizedRowFrames_horizontal_edges ...
theorem BinaryOpenCoverSquareSubdivision.framedFullRow_leftEdge_eq_rightEdge ...
theorem BinaryOpenCoverSquareSubdivision.gaugeGridFullBoundary_left_eq_right ...
```

# 思维脉络（thinking trace）

先计算同伦方形四侧在 mesh 端点的严格值，构造基点 potential，并用常值 corrected loop 的重基化公式
证明底边为一。单行 frames 对列号递归：下一格左侧 frames 由前格右侧及 edge transition 决定，右侧
frames 再选择为使本格横边归一的 potential。二维阶段对行号递归，使用 07a 的 vertical lift 保持水平
相容。文件内部 prefix 归纳证明 top/bottom words 为一，公开 full-row 定理再结合标准矩形关系消去它们。

# 自然语言 ↔ Lean 映射

边界顶点/边的严格识别由 `gridCellVertexInPiece_*_eq_basepoint` 与 `coe_gridCell*Edge_eq` 给出；一般基点
potential 是 `gridCellBasepointPotential`。规范单行 frames 及其两个性质对应
`gaugeNormalizedRowFrames`、`gaugeNormalizedRowFrames_compatible`、
`gaugeNormalizedRowFrames_horizontal_edges`。完整行高层出口是
`framedFullRow_leftEdge_eq_rightEdge`，累计网格出口是 `gaugeGridBoundaryWordsAt_left_eq_right` 和
`gaugeGridFullBoundary_left_eq_right`。所有带 `RowPrefix` 的归纳定理均为 private。

# 依赖（人话版）

同伦方形、道路、有限索引、基本群和 Pushout 承载复用 Mathlib。07a 提供 `CellVertexFrames`、竖直提升、
完整行状态与边界关系；本条目只增加针对道路同伦边界的 potentials 和二维 gauge 选择，不复制第二套
frame structure，也不要求覆盖成员开放或覆盖全空间。

# 应用与陷阱

规范化的是重基化后的横边，而不是声称原道路或原基本群元素按定义为常值。左右 holonomy 相等并不
推出任一侧为单位元；下一批必须用右边界常值锚定，再把单位性向左传播。dependent endpoint casts
只对齐同一点的类型表示。此处不处理 kernel word、单射或最终 van Kampen 等价。
