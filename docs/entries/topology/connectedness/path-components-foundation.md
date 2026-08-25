---
id: topology.connectedness.path-components-foundation
family: topology.connectedness
variant: paths-in-subspace
kind: definition
state: verified
title: 道路连接、道路分支与道路连通
summary: 从本库道路和子空间拓扑建立道路连接等价关系及道路连通子集
premises: [topology.foundation.constructions, topology.homotopy.path-definition-foundation, topology.homotopy.path-concatenation-foundation, topology.homotopy.path-reversal-foundation]
mathlib: []
provenance:
  source_type: book
  ref: "Munkres, Topology, Section 24"
---

# 动机

道路只有在产生道路分支和道路连通性时才成为拓扑工具。本条把常值、逆向和拼接三个道路运算汇合为一个等价关系。

# 直觉

同一点由常值道路连接；道路可以反向；具有公共端点的道路可以拼接。因此“存在道路连接”自然把空间分割成等价类。对子集谈道路连通时，道路必须始终留在子集内。

# 陈述（自然语言）

定义两点可由道路连接，并证明该关系自反、对称、传递。点的道路分支是其等价类。非空子集道路连通，是指在该子集的子空间拓扑中任意两点均可由道路连接。每个单点集道路连通。

# 陈述（Lean 对照）

```lean
def Joined (τ : TextbookTopology X) (a b : X) : Prop
theorem joined_equivalence : Equivalence (Joined τ)
def pathComponent (τ : TextbookTopology X) (a : X) : Set X
def IsPathConnected (τ : TextbookTopology X) (s : Set X) : Prop
theorem isPathConnected_singleton (a : X) : IsPathConnected τ {a}
theorem Joined.map (h : Joined τX a b) (hf : Continuous τX τY f) :
  Joined τY (f a) (f b)
theorem IsPathConnected.image (hs : IsPathConnected τX s) (hf : Continuous τX τY f) :
  IsPathConnected τY (f '' s)
theorem pathComponent_eq_iff_joined (a b : X) :
  pathComponent τ a = pathComponent τ b ↔ Joined τ a b
theorem pathComponent_eq_of_mem_inter (h : (pathComponent τ a ∩ pathComponent τ b).Nonempty) :
  pathComponent τ a = pathComponent τ b
```

# 思维脉络（thinking trace）

`Joined` 直接保存一条本库 `Path`。三个关系律分别由 `Path.refl`、`Path.symm` 和 `Path.trans` 给出。等价类的一般推理在这里显式展开：用对称和传递证明已连接基点的分支互相包含，并由交点构造两基点间道路。道路连通子集使用 `subspace s τ` 上、载体为 subtype `s` 的道路，从类型上保证整条道路不离开子集；单点集内两个 subtype 点由外延性相等，再使用常值道路。连续像定理先把限制后的连续映射提升到像的 subtype，再用 `Path.map` 映射连接道路。

# 自然语言 ↔ Lean 映射

“可由道路连接”对应 `Joined`；“等价关系”对应 `joined_equivalence`；“道路分支”对应 `pathComponent`；“分支相等或相交”对应 `pathComponent_eq_iff_joined` 与 `pathComponent_eq_of_mem_inter`；“道路必须留在子集内”对应 `Joined (subspace s τ) a b`；首个例子对应 `isPathConnected_singleton`；“连续像保持道路连通”对应 `Joined.map`、`IsPathConnected.image` 与 `image_pathComponent_subset`。

# 依赖（人话版）

只依赖本库子空间拓扑和本库道路的常值、逆向、拼接。公开签名不出现 Mathlib 拓扑、Mathlib 道路或 Mathlib 道路连通谓词。

# 应用与陷阱

不能把“任意两个属于 `s` 的点在环境空间中可连接”当作 `s` 道路连通，因为连接道路可能离开 `s`。道路分支本身道路连通仍需道路限制和重新参数化，留给后续批次证明。
