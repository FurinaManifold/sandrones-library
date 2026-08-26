---
id: topology.fundamental-group.van-kampen-cell-boundary
family: topology.fundamental-group
variant: binary-open-cover-single-grid-cell
kind: theorem
state: verified
title: van Kampen 方格细分中的单格边界关系
summary: 将道路同伦方形的每个细分小格提升到其标签覆盖成员，并证明四条修正边组成的 Pushout 边界词为单位元
premises: [topology.homotopy.homotopy-square-grid, topology.fundamental-group.van-kampen-square-subdivision, topology.fundamental-group.van-kampen-surjectivity]
mathlib: [Path.Homotopy, Path.trans, Path.symm, Path.Homotopy.map, IsPathConnected.joinedIn, FundamentalGroup.fromPath, Monoid.PushoutI.of]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

van Kampen 单射性证明把一个零伦环路的道路同伦方形切成有限小格。全局内部边消去之前，必须先
证明每个小格自身给出一个合法关系：小格边界完全位于某个覆盖成员中，因而在该成员基本群以及
合并自由积中等于单位元。本条目只完成这一局部关系，不提前声称整张网格已经消去。

# 直觉

每个小格是标准单位方形经过仿射参数变换后的像。标准方形边界可在方形内部线性收缩到左下角；
映入标签覆盖成员后，这个收缩仍固定环路端点。再从公共覆盖基点分别连接到四个角，把下、右、上、
左四边改成同一基点处的环路。按边界方向，下边和右边正向，上边和左边反向；四者的乘积因此为一。

# 陈述（自然语言）

设一个连续方形已有二开集一致网格细分，每个小格带有一个覆盖成员标签。若两个覆盖成员都道路
连通，且公共基点同时属于二者，则任意小格的下、右、上、左四条边可在其标签成员内修正到公共
基点；这些边送入规范合并自由积后，按左逆、上逆、右正、下正的群乘法次序组成的边界词等于单位元。

# 陈述（Lean 对照）

```lean
def BinaryOpenCoverSquareSubdivision.gridCellPushoutEdgeWord ... :
    binaryVanKampenPushout U V hxU hxV

theorem BinaryOpenCoverSquareSubdivision.gridCellPushoutEdgeWord_eq_one ... :
    D.gridCellPushoutEdgeWord hxU hxV hU hV i j = 1
```

# 思维脉络（thinking trace）

共享 `homotopy-square-grid` 前提中的 `pathHomotopySquare` 冻结道路同伦的坐标约定，横边统一从左到右、
竖边统一从下到上。
`gridCellMapInPiece` 用细分结构的逐格包含证书把标准单位方形提升到标签成员。单位方形中的逐坐标
凸组合给出边界环路的端点相对收缩。四个角分别由道路连通性选择基点 connector；
`Path.correctedLoop_product` 与反向边对应逆元的补充引理把整条边界分解成四条 based edges。最后由
`Monoid.PushoutI.of` 保持乘法，把标签成员内的单位关系送入合并自由积。

# 自然语言 ↔ Lean 映射

“道路同伦参数方形”对应共享前提 `pathHomotopySquare`；“统一定向格边”对应共享前提
`squareGridHorizontalEdge/squareGridVerticalEdge`；本条目新增的“单格逆时针边界”对应 `squareGridCellBoundary`；
“提升到标签成员”对应 `gridCellMapInPiece`；“四角基点连接”对应
`gridCellVertexConnectorInPiece`；“修正边”对应两类 `gridCellBased*EdgeInPiece`；“单格 Pushout
边界词为一”对应 `gridCellPushoutEdgeWord_eq_one`。

# 依赖（人话版）

本条目依赖共享道路同伦方形网格、既有二开集道路细分、规范 Pushout、van Kampen 满射层和二维方格
细分证书。Mathlib 提供道路、端点相对同伦、道路连通性和基本群商；共享前提提供参数方形的统一坐标
接口，本条目新增单格边界、单格提升、四角 connector 以及四边词。开放性和覆盖全空间只用于上游
证明细分存在，不是本条局部关系的前提。

# 应用与陷阱

本定理只说明一个小格的边界词为一。相邻小格可能为同标签，也可能为异标签；它们对公共几何边
使用的 connector 不同，不能直接用 `simp` 宣称内部边抵消。公共边 comparison、端点 gauge、有限
telescope、kernel 消失和最终 van Kampen 同构都属于后续条目。角 connector 由经典选择得到，不是
规范可计算算法；结论不依赖具体选择，但不得把选择的道路误当成定义唯一。
