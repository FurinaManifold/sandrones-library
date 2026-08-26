---
id: topology.fundamental-group.van-kampen-switch-shared-edge
family: topology.fundamental-group
variant: different-label-adjacent-grid-cells
kind: theorem
state: verified
title: van Kampen 方格中异标签公共边的 Pushout 比较
summary: 将异标签相邻方格的公共边提升到交集，并利用 Pushout 合并关系给出两侧修正边的精确端点 gauge 公式
premises: [topology.fundamental-group.van-kampen-common-shared-edge]
mathlib: [Path.map, Path.cast, FundamentalGroup.map, FundamentalGroup.fromPath, IsPathConnected.joinedIn, Monoid.PushoutI.of_apply_eq_base]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

相邻小格标签不同的时候，同标签公共边定理不适用：两侧 based edges 位于不同覆盖成员的基本群中。
van Kampen 的关键机制是公共边本身落在 `U∩V`，因此可以先在交集基本群中构造同一个元素，再利用
合并自由积的识别关系比较它在两个覆盖成员中的像。

# 直觉

公共边的每一点同时属于左右（或上下）两格，标签不同便意味着同时属于 `U` 与 `V`。从交集公共
基点连接到公共边两端，得到一个交集基本群元素。把它分别映入两个覆盖成员后，在 Pushout 中是
同一个元素。两格各自选取的角 connector 与交集 connector 不同，再应用换 connector 公式，就得到
两侧真实边元素之间的四个端点 gauge 因子。

# 陈述（自然语言）

若两个水平或竖直相邻小格标签不同，且 `U∩V` 道路连通，则它们的公共定向边可提升为交集道路。
该道路以交集 connector 修正后的基本群元素，经两侧 inclusion 映入覆盖成员并送入规范 Pushout 后
相等。结合两侧 connector comparisons，可推出两个真实单格边元素满足精确的非交换 Pushout relation。

# 陈述（Lean 对照）

```lean
theorem BinaryOpenCoverSquareSubdivision.horizontalSwitchEdge_pushout_relation ...
theorem BinaryOpenCoverSquareSubdivision.verticalSwitchEdge_pushout_relation ...
```

# 思维脉络（thinking trace）

先由 VK3a 的异标签公共边成员性把水平或竖直公共边提升到 `U∩V`。交集 connector 在目标为公共
基点时定义为常值道路，保证以后周界 gauge 能严格化简。`FundamentalGroup.map` 把交集边元素送入
任一覆盖成员，`Monoid.PushoutI.of_apply_eq_base` 给出两幅像在 Pushout 中的识别。随后复用 VK3b-02
的 `CommonEdgeConnectorComparison`，分别比较交集 connector 的成员内像和两格角 connector；纯群
恒等式把两个 comparison relation 与共同中间元素合成为最终公式。

# 自然语言 ↔ Lean 映射

“交集 connector”对应 `binaryOpenCoverIntersectionConnector`；“交集道路映入成员”对应
`binaryOpenCoverIntersectionPathToPiece`；“公共边交集元素”对应两类
`*SwitchEdgeIntersectionElement`；“规范成员像”对应 `*SwitchEdgePieceImageNormalized`；“两侧
connector comparison”对应水平 left/right 和竖直 bottom/top 四个结构实例；最终关系对应两个
`*SwitchEdge_pushout_relation`。

# 依赖（人话版）

本条依赖同标签层已经建立的通用换 connector 结构，以及 VK3a 提供的公共边交集成员性。交集道路
连通性只用于选择交集基点到公共边端点的道路。开放性与覆盖全空间仍不进入局部 relation；它们只
负责更上游的细分存在性。

# 应用与陷阱

本条同时处理异标签的水平和竖直公共边，但尚未把同标签和异标签两种 relation 统一为一个
`EdgeTransitions` 接口，也没有执行任何有限 telescope。Pushout 中两侧交集像相等不表示覆盖成员
基本群中的元素相等；等式只在合并自由积中成立。交集 connector 的基点规范化是正式设计要求，
不能随意换成总是使用 `somePath` 的定义。
