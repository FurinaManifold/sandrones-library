---
id: topology.fundamental-group.van-kampen-vertex-potential
family: topology.fundamental-group
variant: connector-cocycle-and-grid-potential
kind: theorem
state: verified
title: van Kampen 网格顶点的 connector potential
summary: 将同一点 connector 变化写成群 cocycle，以顶点 potential 的比值统一边 transition 并证明同标签中央 coherence
premises: [topology.fundamental-group.van-kampen-edge-gauge]
mathlib: [Path, FundamentalGroup, MonoidHom, Monoid.PushoutI]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

同一网格顶点可由相邻小格选取不同的基点连接道路。公共边的 endpoint gauge 若逐条独立处理，会在
中央顶点产生大量相容性义务。本条目把每条局部 connector 相对于共同参考 connector 的变化看作
顶点 potential，使边 transition 成为两个 potentials 的比值，并把中央相容性降为严格 cocycle。

# 直觉

从 connector `p` 换到 `q` 的环路记为 `connectorChange p q`。经中间 connector 的两次变化等于
直接变化。若给每个局部 connector 分配 potential `P`，从源到目标的 transition 就是
`P_target * P_source⁻¹`；沿两条相邻边相乘时，中间 potential 与其逆元相消。方格中央横后竖和竖后横
两条路线因此得到同一个总变化。

# 陈述（自然语言）

connector changes 满足单位、逆元与复合 cocycle，并与连续映射诱导的基本群同态相容。一般群中的
`transitionFromPotentials` 满足复合和方格相容公式。VK3b 的 common/switch edge transitions 可写成
相应顶点 potentials 的比值；全同标签四格在中央点的四个 transition 满足方格关系。模块还唯一
定义交集规范 connector 参考的 potential，以及同一覆盖成员内任意参考 connector 的 potential。

# 陈述（Lean 对照）

```lean
def connectorChange (fromConnector toConnector : Path x₀ z) : FundamentalGroup X x₀
def transitionFromPotentials (sourcePotential targetPotential : G) : G :=
  targetPotential * sourcePotential⁻¹

theorem edgeTransitions_gridVertex_square ...
theorem BinaryOpenCoverSquareSubdivision.commonCentralTransition_square_of_label ...

def binaryOpenCoverVertexPotentialFromIntersection ...
def binaryOpenCoverConnectorPotential ...
```

# 思维脉络（thinking trace）

`Path.correctedLoop_product` 直接给出 connector-change cocycle；群同态自然性由映射保持道路拼接和
反向得到。纯群 potential 公式只做结合与逆元消去。对 switch transitions，展开 04 的显式 change
因子即可识别 potential 比值；对 common transitions，先把 comparison 中的逆向 change 改成直接
connector change。全同标签中央定理最后把四个依赖类型 comparison transport 到同一显式 Bool
标签，再应用抽象方格 cocycle。

# 自然语言 ↔ Lean 映射

connector cocycle 是 `connectorChange_mul`；potential 比值是 `transitionFromPotentials`，复合与方格
规律分别是 `transitionFromPotentials_mul/square`。四方向 transition 的 potential 表示由
`*SwitchEdgeTransitions_*_potential` 和 `CommonEdgeConnectorComparison.map_*_eq_potentials` 给出；
最终同标签中央出口是 `commonCentralTransition_square_of_label`。

# 依赖（人话版）

道路、基本群及诱导同态直接复用 Mathlib；`rebaseEdge` 和 `EdgeTransitions` 来自上一条目。本库新增
Mathlib 尚无的 connector cocycle/potential 组合层。两个最终 potential 构造语义不同：交集版本提供
跨成员共享的规范参考，成员内版本只相对于调用者给出的同 piece connector；两者不能互相冒充。

# 应用与陷阱

potential 不是空间上的连续函数，而是有限网格顶点处的群元素。全同标签中央定理不处理混合标签；
混合情形需要下一模块统一。模块中的长 cast 证明只对齐 dependent endpoint 表示，不增加同伦假设。
本条目不执行行/列 telescope，不证明 kernel、单射或 van Kampen 同构。
