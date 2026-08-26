---
id: topology.fundamental-group.van-kampen-path-gauge-comparison
family: topology.fundamental-group
variant: common-and-switch-edge-rebase
kind: theorem
state: verified
title: van Kampen 同路局部表示的统一 gauge 比较
summary: 将方格边与字母边对同一几何道路的同标签和异标签局部表示统一改写成 endpoint vertex potentials 的非交换 rebase 公式
premises: [topology.fundamental-group.van-kampen-dual-path-potential]
mathlib: [Path, Path.cast, FundamentalGroup, Monoid.PushoutI, IsPathConnected]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

方格零同伦的左边界细边和输入字母 block 的细边是同一条环境道路，但两边分别使用 cell 标签、letter
标签和各自的基点 connectors。11b 已处理“一条道路同时具有两种异标签成员性”的局部比较；本条目
把方格水平／竖直、同标签／异标签四类情形统一成后续逐边 transport 可以直接消费的 rebase 公式。

# 直觉

一条局部道路元素由“从基点到起点的 connector—真实边—从终点回基点的 connector”组成。更换
connectors 不会改变中间真实边，只会在左右两端产生群元素。若起点变化为 `s`、终点变化为 `e`，
则新的道路元素由

```text
rebaseEdge s e q = e⁻¹ * q * s
```

给出。非交换群中这个次序是证明内容，不能交换起终点或省略逆元。

# 两种标签情形

若 cell 标签与 letter 标签不同，同一道路逐点属于两个覆盖成员，11b 的交集提升和 Pushout defining
relation 给出 dual comparison。若标签相同，两套道路都在同一成员中，直接建立
`binaryOpenCoverSamePathConnectorComparison`。两种 comparison 最终都投影到相同的 `rebaseEdge`
陈述，后续不必继续 Bool 分类。

“存在两套标签成员性证书”并不表示 cell 标签与 letter 标签在全局已经相等；这里只比较同一条已知
同时落入相应成员的几何边。

# Lean 对照

```lean
theorem BinaryOpenCoverSquareSubdivision.horizontalSwitchEdgeTransitions_start_eq_comparisonPotentials ...
theorem BinaryOpenCoverSquareSubdivision.horizontalSwitchEdgeTransitions_end_eq_comparisonPotentials ...
theorem BinaryOpenCoverSquareSubdivision.verticalCommonEdgeTransitions_start_eq_gridCellPotentials ...

theorem binaryOpenCoverDualPath_localElements_pushout_rebase ...

def binaryOpenCoverSamePathConnectorComparison ...
theorem binaryOpenCoverSamePathConnectorComparison_edgeSource ...
theorem binaryOpenCoverSamePathConnectorComparison_edgeTarget ...
theorem binaryOpenCoverSamePath_localElements_pushout_rebase ...
```

# 证明思路

水平和竖直 switch-edge 端点公式直接把 11b 的 dual comparison potentials 专门化到方格角 connectors。
common-edge 情形复用 `CommonEdgeConnectorComparison` 的 endpoint potential 定理，再用方格角 potential
的坐标无关刻画去掉局部坐标。四个仅服务这一改写的中间 common-transition 引理保持 private。

dual-path 最终公式先使用 comparison relation，再用 Pushout 中两侧交集元素相等替换中间元素。
same-path comparison 直接保存两套局部 connectors 及同一成员道路；其 coercion 规则证明左右表示的
底层环境道路确实一致，通用 connector-change 公式随后给出相同 rebase 形状。

# 正式承载与接口分类

道路、cast、基本群、Pushout 和道路连通性复用 Mathlib 的 `Path`、`FundamentalGroup`、
`Monoid.PushoutI` 与 `IsPathConnected`，均为语义一致的正式承载。`rebaseEdge`、vertex potential、方格
subdivision 和 `CommonEdgeConnectorComparison` 是前序拓扑批次已解释的本库桥。

本批新增的 `binaryOpenCoverSamePathConnectorComparison` 是将两套同成员 connectors 放入既有通用
comparison 的具名构造，不是第二套 comparison carrier。没有新增 instance、notation、Path 或
Pushout 实现。

# 假设与边界

异标签公式需要 `IsPathConnected (U ∩ V)` 以选择规范交集 connectors；方格角 connectors 还使用
`IsPathConnected U` 和 `IsPathConnected V`。本批定理给定 subdivision 和成员性证书后，不重新要求
开性或覆盖全空间。

本层只比较单条真实几何边的两套局部表示，没有把整条左边界乘起来，没有证明 telescoping、kernel
平凡、规范同态单射或最终 van Kampen 同构。

# 后续用途

VK3b-12 将用 dual/same 两条统一 rebase 定理把每条 cell-side 左边界因子搬运为 letter-side 因子；
VK3b-13 证明相邻细边和 block 接缝处的 endpoint frames 相容；VK3b-14 才执行有限 telescope。
因此本条目的稳定出口是两条 rebase 定理和实际被下游使用的方格 endpoint 公式，而不是最终定理。
