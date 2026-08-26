---
id: topology.fundamental-group.van-kampen-mixed-vertex-coherence
family: topology.fundamental-group
variant: mixed-grid-vertex-transition-square
kind: theorem
state: verified
title: van Kampen 网格混合标签顶点的 transition coherence
summary: 由统一交集 connector 构造混合中央顶点的四格 potentials，并与全同标签分支合并为任意内部 transition 方格关系
premises: [topology.fundamental-group.van-kampen-vertex-potential]
mathlib: [Path, FundamentalGroup, MonoidHom, Monoid.PushoutI]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

四个相邻小格共享一个中央顶点。全同标签时可在同一个覆盖成员内比较 connector；标签不全相同时，
至少一条经过中央点的内部边发生标签切换，因而中央点落在 `U ∩ V`。为了让后续网格 telescope 只消费
一个接口，需要把 common 与 switch 两种局部表示统一成同一条中央 transition 方格关系。

# 直觉

混合标签迫使中央点属于交集，所以可以从交集基点选择一条统一 connector。把它映入每个小格所属的
覆盖成员后，相对于该格局部 connector 得到一个 Pushout potential。每条内部边在中央端的 transition
都是两个相邻 potentials 的比值，因此先横后竖和先竖后横的中间 potential 严格消去。全同标签时则
直接复用同一覆盖成员中的 connector 方格。

# 陈述（自然语言）

若四格标签不全相同，则中央网格顶点属于覆盖交集，并给出交集 subtype 点及规范 connector。任意交集
参考点可以为一个小格角构造 Pushout potential；该构造对显式标签等式证明稳定。最终，对任意四个相邻
小格，不论其标签排列如何，右边起点 transition 乘下边终点 transition，等于上边起点 transition
乘左边终点 transition。

# 陈述（Lean 对照）

```lean
theorem BinaryOpenCoverSquareSubdivision.centralVertex_mem_intersection_of_not_all_eq ...
def BinaryOpenCoverSquareSubdivision.centralIntersectionVertex ...
def BinaryOpenCoverSquareSubdivision.centralIntersectionConnector ...
def BinaryOpenCoverSquareSubdivision.gridCellVertexPotentialFromIntersection ...
theorem connectorChange_cast_four_endpoints_right ...
def BinaryOpenCoverSquareSubdivision.gridCellVertexPotentialFromIntersectionOfLabel ...
theorem BinaryOpenCoverSquareSubdivision.gridCellVertexPotentialFromIntersectionOfLabel_eq ...

theorem BinaryOpenCoverSquareSubdivision.centralInternalTransitions_square ... :
  VR.startChange * HB.endChange = HT.startChange * VL.endChange
```

# 思维脉络（thinking trace）

先按下边、左边和右边标签关系找出一条 incident switch edge，由该整条边落入交集推出中央点的交集
成员性。接着以同一个交集 connector 定义四格中央角 potentials。四方向各自再按标签相同与否调用
common 或 switch edge 公式；这些识别链仅为文件内部 plumbing。混合分支应用纯群
`edgeTransitions_gridVertex_square`，全同标签分支调用上一模块的同标签中央方格，最终只做一次是否全同
标签的二分。

# 自然语言 ↔ Lean 映射

交集成员性、subtype 点、其 ambient coercion 与 connector 分别对应
`centralVertex_mem_intersection_of_not_all_eq`、`centralIntersectionVertex`、
`coe_centralIntersectionVertex`、`centralIntersectionConnector`。一般和显式标签 potential 对应
`gridCellVertexPotentialFromIntersection` 与 `gridCellVertexPotentialFromIntersectionOfLabel`；后者的
proof independence 是 `gridCellVertexPotentialFromIntersectionOfLabel_eq`。四端点 transport 的可复用
桥是 `connectorChange_cast_four_endpoints_right`，唯一统一出口是 `centralInternalTransitions_square`。

# 依赖（人话版）

道路、基本群和推出群承载继续复用 Mathlib；覆盖网格、common/switch edge transitions 以及 vertex
potential 来自此前本库模块。本条目没有另建 Path、FundamentalGroup 或 Pushout。Mathlib 没有现成的
这一有限网格 gauge-coherence 组合层，因此本库只新增组装 van Kampen 证明所需的中间接口。

# 应用与陷阱

乘法次序属于非交换群数据，不能交换四个 transition 因子。混合分支需要交集道路连通性来选择统一
connector；全同标签分支并不声称中央点因 switch edge 而落入交集。Bool 枚举只能检查分支覆盖，不能
代替一般群等式。此处尚未建立整行 telescope、二维边界消去、kernel、单射或 van Kampen 等价。
