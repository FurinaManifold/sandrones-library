---
id: topology.covering.subgroup-path-class-standard
family: topology.covering
variant: subgroup-orbit-carrier
kind: definition
state: verified
title: 子群对应覆盖的道路类承载
summary: 把从固定基点出发的道路同伦类按子群环路的起点拼接作用取轨道商，并定义端点投影
premises: [topology.fundamental-group.operations-standard]
mathlib: [Path.Homotopic.Quotient, FundamentalGroup, Subgroup, Setoid, Quotient]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

覆盖空间分类从基点基本群的子群出发重建覆盖。教材构造先考虑所有从基点 `x₀` 出发的道路，若两条
道路具有同一终点，并且它们的差环路属于给定子群 `H`，便把它们识别。本条目建立这个构造所需的
集合层承载，暂不赋拓扑。

# 变终点道路类

`CoveringSubgroupBasedPath x₀` 有两个字段：`endpoint : X` 是变动终点，`path` 是从 `x₀` 到该终点的
端点固定道路同伦类。Lean 中第二个字段的类型依赖第一个字段，因此一个 structure equality 同时处理
终点相等与道路类型的 transport。道路同伦商直接采用 Mathlib 的 `Path.Homotopic.Quotient`，其语义
正是教材的端点固定道路同伦类。

# 子群轨道关系

对 `h : H`，`prepend H h a` 在 `a.path` 前拼接环路 `h`，不改变终点。`Related H a b` 定义为存在
`h : H` 使 `prepend H h a = b`。这种轨道表述避免把某个端点相等证明及其 dependent cast 暴露在
主 relation 中；它没有另造道路、基本群或子群。

# 乘法方向与右陪集

Mathlib 把基本群实现成基本群胚基点处的自同态群，所以 `h * k` 的道路代表按范畴复合约定是
`k.trans h`。因此 `prepend_mul` 的精确公式是
`prepend H (h * k) a = prepend H k (prepend H h a)`。在基点 fiber 中，若 based loop 用群元素 `g`
表示，轨道元素是 `g * h`，故 fiber 对应右陪集 `gH`，不是左陪集 `Hg`。

# 等价关系与商

单位元给出自反性，逆元给出对称性，乘法与 `prepend_mul` 给出传递性。它们组装成
`related_equivalence` 和 `orbitSetoid`。`CoveringSubgroupPathClass x₀ H` 是该 setoid 的 `Quotient`；
它目前只是类型商，不携带拓扑。

# 端点投影

`endpoint_eq_of_related` 说明起点拼接不会改变终点，因此 endpoint 在轨道上为常值。
`CoveringSubgroupPathClass.projection H` 用 `Quotient.lift` 得到从道路类商到 `X` 的良定义函数。这里的
“投影”只表示集合函数；本条目没有连续性结论。

# Lean 对照

```lean
structure CoveringSubgroupBasedPath ...
def CoveringSubgroupBasedPath.prepend ...
def CoveringSubgroupBasedPath.Related ...
theorem CoveringSubgroupBasedPath.prepend_one ...
theorem CoveringSubgroupBasedPath.prepend_mul ...
theorem CoveringSubgroupBasedPath.related_refl ...
theorem CoveringSubgroupBasedPath.related_symm ...
theorem CoveringSubgroupBasedPath.related_trans ...
theorem CoveringSubgroupBasedPath.related_equivalence ...
def CoveringSubgroupBasedPath.orbitSetoid ...
theorem CoveringSubgroupBasedPath.endpoint_eq_of_related ...
def CoveringSubgroupPathClass ...
def CoveringSubgroupPathClass.projection ...
```

# 边界

本条目不发布“同端点且差环路属于 `H`”的 dependent-cast 版本 iff，不给商类型注册 topology instance，
不证明投影连续、局部同胚或为 covering map，也不进行子群恢复、pointed/unpointed 分类或 universal
cover 构造。这些都属于 C5c 及后续独立批次。
