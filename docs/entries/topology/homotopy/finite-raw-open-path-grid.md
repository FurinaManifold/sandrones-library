---
id: topology.homotopy.finite-raw-open-path-grid
family: topology.homotopy
variant: finite-square-grid-with-open-cell-incidence-and-regular-outer-boundary
kind: definition
state: verified
title: 有限开集道路原始方格
summary: 在任意实赋范线性空间中记录有限方格顶点、逐格开集、统一定向原始边、四侧 incidence 与外边分段 C1 证书
premises: [topology.homotopy.piecewise-c1-path, topology.homotopy.homotopy-square-grid]
mathlib: [Path, Set.range, IsOpen, Fin, NormedAddCommGroup, NormedSpace]
provenance:
  source_type: book
  ref: "munkres-topology-2000"
---

# 动机

方格同伦证明的拓扑层只需知道每格属于哪个开集、四条原始边位于该开集，并且整张方格最外侧的边
具有以后积分所需的分段 C1 性。局部原函数、道路积分和内边替换属于解析层，不应写进共享 carrier。
本条目冻结这条 ownership 边界。

# 教材直觉

把一张有限方格看成顶点、横边、竖边和二维小格的组合数据。每条横边统一向右，每条竖边统一向上；
一个小格的下、右、上、左四边都落在该格所选开集。内部公共边只存一次原始道路，相邻小格通过同一
索引复用它；是否把它替换成更规则道路留给后续构造。

# 定义与边界

`FiniteRawOpenPathGrid E` 记录 `steps`、二维顶点、每格开集、水平与竖直原始 `Path`、四边 range
包含证书，以及整张网格下、上、左、右外边的 `Path.PiecewiseC1` 证书。载体允许 `steps = 0`；此时
cell 和 edge family 为空，后续有限和自然退化为空和。真实方形细分 adapter 仍要求 `0 < steps`。

该结构不存每格标签的来源，不存局部 primitive，也不要求内部边分段 C1。它不是 CW complex、
simplicial complex、cubical set 或一般 cell complex 的定义。

# Lean 对照

```lean
structure FiniteRawOpenPathGrid (E : Type*)
    [NormedAddCommGroup E] [NormedSpace ℝ E] where
  steps : ℕ
  vertex : Fin (steps + 1) → Fin (steps + 1) → E
  cellSet : Fin steps → Fin steps → Set E
  cellSet_open : ∀ i j, IsOpen (cellSet i j)
  horizontalRaw : ... → Path ...
  verticalRaw : ... → Path ...
  bottom_mem : ...
  right_mem : ...
  top_mem : ...
  left_mem : ...
  horizontal_zero_piecewiseC1 : ...
  horizontal_last_piecewiseC1 : ...
  vertical_zero_piecewiseC1 : ...
  vertical_last_piecewiseC1 : ...

def finiteRawOpenPathGrid_of_squareSubdivisionData ... :
    FiniteRawOpenPathGrid E
```

# 自然语言 ↔ Lean 映射

“有限方格”对应 `steps` 及 `Fin steps` 索引；“顶点”对应 `vertex`；向右横边与向上竖边分别对应
`horizontalRaw`、`verticalRaw`；“第格的开集”对应 `cellSet` 和 `cellSet_open`；四侧落入开集对应
四个 `*_mem` range inclusion 字段；外边正则性对应四个 `*_piecewiseC1` 字段。共享方形数据的组装
对应 `finiteRawOpenPathGrid_of_squareSubdivisionData`。

# Adapter 证明思路

adapter 以共享 `squareGridVertex`、`squareGridHorizontalEdge` 和 `squareGridVerticalEdge` 填充几何字段，
以标签选中的 `W (label i j)` 填充开集。四侧 incidence 将边参数分别代入
`unitSquareCellPoint i j u 0`、`... 1 v`、`... u 1`、`... 0 v`，直接消费逐格 membership。四条外边
正则性由调用者提供，adapter 不偷偷从连续性推出分段 C1。

# 正式承载与类型假设

道路、range、开集、有限 index 直接复用 Mathlib `Path`、`Set.range`、`IsOpen`、`Fin`；分段 C1
复用已解释的本库谓词。`E` 只要求 `[NormedAddCommGroup E] [NormedSpace ℝ E]`，以便后续正则道路
接口统一；没有 `Complex`、完备性或有限维假设。结构和 adapter 是本库必要的数据边界，不复制
Mathlib 已有的 cell-complex carrier，也不注册 instance、coercion 或 notation。

# 应用与来源

R3b-E 将为内部公共原始边选择开集内的分段 C1 替换并附加局部原函数数据，R3b-F 再做有限边界和
消去。Munkres 提供开覆盖与方格细分的拓扑背景；Ahlfors 的局部原函数证明说明为何外边正则性与
逐格开集是所需数据。`FiniteRawOpenPathGrid` 是本库用于隔离拓扑和解析 ownership 的形式化 carrier，
不冒充教材中的具名对象或定理。
