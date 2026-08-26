---
id: topology.fundamental-group.van-kampen-dual-path-potential
family: topology.fundamental-group
variant: intersection-lift-and-endpoint-gauge
kind: theorem
state: verified
title: van Kampen 双标签道路与通用顶点 potential
summary: 将同时落在两个不同覆盖标签中的道路提升到交集，比较交集规范 connector 与成员内局部 connector，并把端点变化统一写成 Pushout 中的 vertex potentials
premises: [topology.fundamental-group.van-kampen-letter-block-word]
mathlib: [Path, Path.map, Path.cast, Path.Homotopic, FundamentalGroup, Monoid.PushoutI, IsPathConnected]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

零同伦方格的真实边和输入字母 block 的真实边可能是同一条环境道路，却使用不同的覆盖标签及不同
的基点 connectors。要让后续左边界 telescope 成立，必须把这种 dependent subtype 表示差异压缩为
Pushout 中只依赖端点的统一变化因子，而不能在每条细边上重新展开 Bool 分支和 cast。

# 直觉

若一条道路逐点同时落在两个不同标签的覆盖成员中，它实际上逐点落在交集。先把道路提升到 `U ∩ V`，
用交集内从公共基点到两端的规范 connectors 形成 corrected loop，再映回任一覆盖成员。Pushout 的
定义关系保证从两侧映入的交集基本群元素相等。

将这套规范 connectors 与任意局部 connectors 比较时，差异完全由起点和终点的 connector changes
决定。把每个端点变化映入 Pushout，就得到与网格坐标无关的 vertex potential。

# 正式对象

`binaryOpenCoverDualPathInIntersection` 是环境 `Path` 到交集 subtype `Path` 的提升；
`binaryOpenCoverPathInPiece` 是到单个覆盖成员 subtype 的提升。
`binaryOpenCoverDualPathPieceElement` 是交集 corrected loop 映入指定成员基本群所得元素。
`binaryOpenCoverDualPathConnectorComparison` 复用已有 `CommonEdgeConnectorComparison`，同时保存规范
交集 connectors 与任意局部 connectors。

本批没有新建道路、同伦、基本群、Pushout 或 comparison carrier；前三类直接复用 Mathlib，最后
一类复用本库已验收的通用 connector comparison。

# Lean 对照

```lean
def binaryOpenCoverDualPathInIntersection ...
def binaryOpenCoverPathInPiece ...
def binaryOpenCoverDualPathPieceElement ...
theorem binaryOpenCoverDualPathPieceElements_pushout_eq ...
def binaryOpenCoverDualPathConnectorComparison ...
theorem binaryOpenCoverDualPathConnectorComparison_relation ...

theorem binaryOpenCoverVertexPotentialFromIntersection_cast ...
theorem binaryOpenCoverVertexPotentialFromIntersection_cast_label ...
theorem CommonEdgeConnectorComparison.pushout_startChange_inv_eq_vertexPotentials ...
theorem binaryOpenCoverDualPathConnectorComparison_sharedPotential ...
```

# 证明思路

先对两个 Bool 标签分类，证明异标签的共同成员性给出交集成员性；subtype 道路的连续性由
`continuous_induced_rng.mpr` 得到。交集道路映回成员后的底层函数与直接成员提升相同，端点差异由
`Path.cast` 和 proof irrelevance 消去。

双侧 piece elements 的 Pushout 等式直接使用 `Monoid.PushoutI` 的 defining relation。connector
comparison 的群等式复用 `CommonEdgeConnectorComparison.rightElement_eq`。最后把 connector changes
改写为既有 `binaryOpenCoverVertexPotentialFromIntersection`；proof/cast/label 稳定性保证相邻边在
同一环境顶点处得到严格相同的 potential。

# 公开承载分类

- Mathlib `Path`、`Path.map/cast`、`FundamentalGroup`、`Monoid.PushoutI` 与 `IsPathConnected` 是语义
  一致的正式承载。
- `binaryOpenCoverPiece`、交集包含映射、规范 intersection connector、vertex potential 和
  `CommonEdgeConnectorComparison` 是本库前序批次已经解释并验收的桥侧接口。
- 八个展开、cast 和 connector-map 引理保持 private，只是 dependent transport 的证明后端。
- 没有全局 instance、notation 或替代 Pushout 实现。

# 假设与方向

交集内规范 connector 需要 `IsPathConnected (U ∩ V)`。本批给定道路及其两侧逐点成员性，不需要
`U`、`V` 开，也不需要 `U ∪ V = univ`；这些条件只在更早的方格细分存在性中使用。

Pushout 等式方向与 `rebaseEdge s e q = e⁻¹ * q * s` 的非交换约定一致。起点和终点 potential 的
逆号及乘法次序不能交换。

# 应用与未完成边界

11c 将消费这里的 dual-path comparison、proof/cast 稳定性和 endpoint potentials，把同标签与异标签
两种情况统一成 path rebase 公式。12--14 再用该公式逐边搬运并 telescope。

本条目尚未给出完整同路 rebase 接口，也没有完成左边界 transport、全局 telescope、kernel 平凡、
规范映射单射或最终 van Kampen 同构。
