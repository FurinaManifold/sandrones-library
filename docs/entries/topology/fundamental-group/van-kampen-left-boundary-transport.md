---
id: topology.fundamental-group.van-kampen-left-boundary-transport
family: topology.fundamental-group
variant: cell-to-letter-endpoint-rebase
kind: theorem
state: verified
title: van Kampen 左边界 cell-to-letter 逐边 transport
summary: 统一同标签与异标签分支的端点 transitions，以 vertex potentials 描述其首末变化，并把真实左边界 cell factor 重基化为对应 letter block factor
premises: [topology.fundamental-group.van-kampen-left-boundary-edge]
mathlib: [Path, FundamentalGroup, Monoid.PushoutI, IsPathConnected, Fin]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

12a 已把零同伦方格左边界的同一条真实细边分别提升到 cell 标签成员和输入 letter 标签成员，并把
两侧局部基本群元素识别为既有 grid factor 与 block factor。两侧使用的 connectors 一般不同，因此
这些识别尚不能直接把两个有限词相等。本批为每条细边构造统一的 endpoint transitions，并证明准确的
非交换重基化公式。

# 统一 transition

`leftBoundaryCellToLetterTransitions` 根据 cell 标签 `b` 与 letter 标签 `c` 是否相等选择比较方式。
同标签时使用 11c 的 same-path comparison；异标签时，同一真实边落在两个覆盖成员，使用 11b 的
dual-path comparison 和交集 Pushout 关系。两条分支都返回同一个既有承载 `EdgeTransitions`，后续
消费者不再对 Bool 标签分类。

异标签分支需要 `IsPathConnected (U ∩ V)` 来选择交集 connectors；同标签分支本身不使用这一数学
事实，但统一定义保留同一组参数。成员 `U`、`V` 的道路连通性用于 12a 已建立的 cell/letter
connectors。

# potential 刻画

逐边 transition 的起点和终点变化分别被写成两个 vertex potentials 的商。异标签情形直接来自
dual-path comparison；同标签情形先在同一覆盖成员内比较 connectors，再用 Pushout 映射将结果改写
为相同的 potential 语言。

`leftBoundaryCellEndPotential_eq_gridCellPotential` 和
`leftBoundaryCellStartPotential_eq_gridCellPotential` 进一步把 cell 侧 potential 接回方格相邻边已经
使用的 grid-cell potential。这不是新的坐标系统，而是保证 13 中相邻细边和 block 接缝能够应用既有
cocycle 定理的桥。

# Lean 对照

```lean
def PathConcatAlignedSquareSubdivision.leftBoundaryCellToLetterTransitions ...

theorem ...leftBoundaryCellToLetterTransitions_end_eq_intersectionPotentials ...
theorem ...leftBoundaryCellToLetterTransitions_start_eq_intersectionPotentials ...
theorem ...leftBoundaryCellEndPotential_eq_gridCellPotential ...
theorem ...leftBoundaryCellStartPotential_eq_gridCellPotential ...

theorem ...leftBoundaryCellToLetter_relation ...
theorem ...leftBoundaryCellEdgeToBlockFactor_relation ...
```

两个 `_of_ne` 公开定理保留异标签分支的直接计算规则；同标签分支的对应展开仅服务本文件证明，保持
private。两条 same-path Pushout 等式同样是局部消元细节，不扩大正式接口。

# 核心重基化公式

若 `cellElement`、`letterElement` 是 12a 中同一真实细边的两套局部元素，而 `T` 是本批 transition，
则核心结论为

```text
cellElement = rebaseEdge T.startChange T.endChange letterElement
            = T.endChange⁻¹ * letterElement * T.startChange.
```

左右次序由 Mathlib 基本群乘法与道路拼接约定以及 connector-change 公式共同确定。在非交换 Pushout
中不能交换两端变化，也不能把它简化为共轭而忽略起终点可能不同。

# 接回真实有限词

`leftBoundaryCellToLetter_relation` 陈述局部元素层的 transport；最终出口
`leftBoundaryCellEdgeToBlockFactor_relation` 使用 12a 的两个 element equality，将公式改写为网格
左边界有限词和 letter block word 真正消费的 factors。因而 13--14 可以只研究相邻 transitions 的
cocycle 与有限 telescope，无需再次展开 subtype 道路或 connector-corrected loops。

# 正式承载与接口边界

道路、基本群、Pushout、道路连通性和有限索引复用 Mathlib 的 `Path`、`FundamentalGroup`、
`Monoid.PushoutI`、`IsPathConnected` 与 `Fin`。`EdgeTransitions`、`transitionFromPotentials` 和
`rebaseEdge` 复用前序已验收的一般 gauge 承载。本批没有新建 Path、基本群、Pushout、comparison
carrier、instance 或 notation。

公开面是一个 transition 定义和八条定理；四条仅负责相等标签展开或 same-path Pushout 消元的定理
保持 private。公开 potential 公式与最终 factor relation 都有 13--14 的明确消费者。

# 尚未完成的边界

本批只完成单条真实左边界细边的 cell-to-letter transport。它没有证明相邻细边终点与下一细边起点
transition 相容，没有跨 block 接缝建立 cocycle，也没有执行有限乘积 telescope。因此不能由本条目
推出 kernel 平凡、规范同态单射或最终 van Kampen 同构；这些仍属于 VK3b-13--15。
