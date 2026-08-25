---
id: topology.connectedness.path-components-foundation
family: topology.connectedness
variant: paths-in-subspace
kind: definition
state: staging
title: 道路连接、道路分支与道路连通的正式承载
summary: 解释 Mathlib 的 Path、Joined、JoinedIn 与 IsPathConnected 如何实现教材语义，并保留旧道路连通链作为迁移兼容层
premises: [topology.foundation.constructions]
mathlib: [Path, Joined, JoinedIn, pathComponent, IsPathConnected, IsPathConnected.image]
provenance:
  source_type: book
  ref: "Munkres, Topology, Section 24"
---

# 动机

道路只有在产生道路分支和道路连通性时才成为拓扑工具。Mathlib 已把道路、道路连接、集合内道路连接与道路连通子集组织成同一条成熟接口链；本条公开解释其教材含义，不再复制平行关系。

# 直觉

`Joined x y` 就是“存在一条从 `x` 到 `y` 的道路”。常值、反向和拼接使它成为等价关系，等价类就是 `pathComponent`。对子集谈道路连通时，仅在环境空间中连接还不够；`JoinedIn s x y` 额外要求整条道路留在 `s` 内。

# 陈述（自然语言）

Mathlib 的 `Joined x y` 定义为 `Nonempty (Path x y)`。集合 `s` 道路连通，当且仅当它非空且任意两个属于 `s` 的点满足 `JoinedIn s x y`。连续映射把道路连通集合送到道路连通像集。旧本库 `Joined/pathComponent/IsPathConnected` 只为已提交下游保留。

# 陈述（Lean 对照）

```lean
theorem joined_iff_nonempty_path [TopologicalSpace X] (x y : X) :
  Joined x y ↔ Nonempty (Path x y)

theorem isPathConnected_iff_nonempty_joinedIn [TopologicalSpace X] (s : Set X) :
  IsPathConnected s ↔ s.Nonempty ∧
    ∀ x ∈ s, ∀ y ∈ s, JoinedIn s x y

theorem isPathConnected_image [TopologicalSpace X] [TopologicalSpace Y]
    (hs : IsPathConnected s) (hf : Continuous f) :
  IsPathConnected (f '' s)
```

# 思维脉络（thinking trace）

先用定义等式展开 `Joined` 为非空道路类型。随后调用 Mathlib 的 `isPathConnected_iff`，把以某个基点连接所有点的定义改写成教材常用的“非空且任意两点在集合内连接”。连续像结论直接使用 `IsPathConnected.image`；其数学机制是用 `Path.map` 把原集合内的道路映到像集内。

# 自然语言 ↔ Lean 映射

“可由道路连接”对应根命名空间 `Joined`；“一条实际道路”对应 `Path x y`；“道路必须留在子集内”对应 `JoinedIn s x y`；“道路分支”对应 `pathComponent x`；“子集道路连通”对应 `IsPathConnected s`；教材的任意两点刻画对应 `isPathConnected_iff_nonempty_joinedIn`；“连续像保持道路连通”对应 `isPathConnected_image` 与 Mathlib 的 `IsPathConnected.image`。

# 依赖（人话版）

正式接口依赖 Mathlib 的 `Topology.Connected.PathConnected`，并直接使用规范 `TopologicalSpace`、`Path`、`JoinedIn` 和 `IsPathConnected`。旧本库道路及子空间链仍留在文件后半部，仅保证旧同伦下游继续编译；新接口不依赖它们。

# 应用与陷阱

不能把“任意两个属于 `s` 的点在环境空间中满足 `Joined`”当作 `s` 道路连通，因为道路可能离开 `s`；必须使用 `JoinedIn`。新课程也不得借旧 `TextbookTopology.Joined` 继续构建平行道路理论。Mathlib 已有 `Joined.refl/symm/trans/map`、`pathComponent` 及连续像定理，直接引用并解释即可。
