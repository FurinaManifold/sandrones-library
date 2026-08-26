---
id: topology.fundamental-group.van-kampen-common-shared-edge
family: topology.fundamental-group
variant: same-label-adjacent-grid-cells
kind: theorem
state: verified
title: van Kampen 方格中同标签公共边的 connector 比较
summary: 相邻同标签方格对同一公共边选择不同端点 connector 时，两侧修正边元素由起终点 connector changes 精确联系
premises: [topology.fundamental-group.van-kampen-cell-boundary]
mathlib: [Path.cast, Path.trans, Path.symm, FundamentalGroup.fromPath, IsPathConnected.joinedIn]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

两个相邻小格共享同一条几何边，但单格边界关系分别使用各自选择的四角 connector。即使两格标签
相同，公共边对应的 based-loop 元素也不会定义相等。本条目建立精确的换 connector 公式，为以后
把公共边放入统一 gauge 语言并进行有限消去提供局部接口。

# 直觉

固定同一条定向边，左侧表示使用一对起终点 connector，右侧表示使用另一对。把起点处两条
connector 首尾相接形成 start change，把终点处两条 connector 形成 end change。右侧修正边就等于
end change 的逆元、左侧修正边和 start change 的乘积。水平、竖直相邻格只是这个通用公式的两个
方格实例。

# 陈述（自然语言）

若两个水平或竖直相邻小格具有相同覆盖标签，则公共几何边可提升到同一个覆盖成员。两格在该成员
中选取的角 connector 所产生的公共边基本群元素，满足由起点和终点 connector changes 给出的精确
非交换群关系。该关系不需要交集道路连通、覆盖开放或覆盖全空间。

# 陈述（Lean 对照）

```lean
theorem CommonEdgeConnectorComparison.rightElement_eq ... :
    C.endChange⁻¹ * C.leftElement * C.startChange = C.rightElement

theorem BinaryOpenCoverSquareSubdivision.horizontalCommonEdge_pieceElements_relation ...
theorem BinaryOpenCoverSquareSubdivision.verticalCommonEdge_pieceElements_relation ...
```

# 思维脉络（thinking trace）

先用 `correctedLoop_change_connectors` 在任意拓扑空间中证明通用换 connector 公式，再用 `Path.cast`
处理端点依赖类型的 transport。标签相等使相邻两格的公共边提升到同一 subtype；八条端点识别把
两格对应角与公共边的起终点严格对齐。最后将通用 comparison 的左右元素改写为两格实际 based
edges，得到水平和竖直的稳定 relation。

# 自然语言 ↔ Lean 映射

“换 connector”对应 `CommonEdgeConnectorComparison`；四个派生群元素对应
`leftElement/rightElement/startChange/endChange`；“显式共同标签”对应
`gridCellMapInPieceOfLabel` 和两类 `gridCellBased*EdgeInPieceOfLabel`；同标签水平、竖直公共边最终
关系分别对应两个 `*CommonEdge_pieceElements_relation`。

# 依赖（人话版）

本条依赖单格边界层提供的定向格边、四角 connector 和 based edges。Mathlib 提供道路 cast、拼接、
逆道路和道路同伦商；本库补充 corrected-loop 在换 connector 与端点 cast 下的稳定公式。道路连通性
只用于选择两格角 connector，不用于公共边几何相等本身。

# 应用与陷阱

本条只处理相邻格标签相同的情形。标签不同时，公共边必须先提升到 `U∩V`，再用 Pushout 合并关系
比较两侧元素；这些 switch-edge 声明严格属于下一条目。当前 relation 也不等于“内部边已经消去”：
必须先把 start/end changes 组织成相容的 vertex frames，才能沿有限网格 telescope。
