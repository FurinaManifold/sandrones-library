---
id: topology.homotopy.path-polygonal-approximation
family: topology.homotopy
variant: relative-open-set-uniform-mesh-polygonalization
kind: theorem
state: verified
title: 开集内道路的相对折线逼近
summary: 将实赋范空间开集内的连续道路相对端点同伦到同一开集内的有限直线段拼接
premises: [topology.homotopy.path-homotopy-image-control, topology.homotopy.unit-interval-mesh]
mathlib: [Path.segment, Path.concat, Path.Homotopy, IsCompact.exists_cthickening_subset_open, UniformContinuous]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

许多拓扑论证希望把任意连续道路替换成有限折线，同时不能离开原来的开集，也不能移动端点。仅把
有限采样点相连并不自动保证线段仍在开集内，更不能自动给出整个替换过程都在开集中的同伦。本条目
同时构造足够细的网格、折线路径和完整的开集内相对同伦证书。

# 直觉

原道路像是紧集，而开集包含该紧集，因此可以选一个统一正半径，使紧集周围的厚化仍落在开集。
道路在紧参数区间上一致连续，所以充分细的统一网格让每个小道路段及其两个采样端点落入同一个
小球。球是凸的，于是连接相邻采样点的直线段和原小段到该直线段的逐点仿射同伦都留在球内。

# 陈述（自然语言）

设 `p` 是实赋范线性空间中从 `x` 到 `y` 的道路，其像包含于开集 `U`。存在正整数 `N`，使相邻
统一网格采样点之间的所有直线段都位于 `U`。这些线段的有限拼接给出从 `x` 到 `y` 的折线路径，
其整个值域包含于 `U`；并且存在从 `p` 到该折线路径的端点相对道路同伦，该同伦的每个值也属于
`U`。

# 陈述（Lean 对照）

```lean
structure Path.MeshBallSubdivision (p : Path x y) (U : Set E)

def Path.meshPolygonal (p : Path x y) (N : ℕ) (hN : 0 < N) : Path x y

theorem Path.exists_meshPolygonal_range_subset_open_and_homotopyWithin
    (p : Path x y) (hU : IsOpen U) (hpU : ∀ t, p t ∈ U) :
    ∃ N, ∃ hN : 0 < N,
      Set.range (Path.meshPolygonal p N hN) ⊆ U ∧
        ∃ K : p.Homotopy (Path.meshPolygonal p N hN),
          ∀ t s, K (t, s) ∈ U
```

# 思维脉络（thinking trace）

紧像的统一厚化给出半径 `δ`，一致连续性给出时间尺度 `η`，再选 `N⁻¹ < η`。网格相邻距离的精确
公式把每个子道路参数控制在 `η` 内；一致连续性把子道路送进以左采样点为心的 `δ` 球，凸性控制
对应直线段。逐段仿射同伦通过上一条目的有限 maps-to 拼接组装，原子道路拼接与原道路之间则由
Mathlib 子道路重参数化同伦连接；竖直复合给出最终开集内同伦。

# 自然语言 ↔ Lean 映射

统一网格和公共球证书是 `Path.MeshBallSubdivision`；折线路径是 `Path.meshPolygonal`，其一手展开式
`meshPolygonal_eq_concat` 显示它就是 `Path.segment` 的有限 `Path.concat`。原子道路拼接是
`meshSubpathConcat`；逐段直线化和重参数化分别由两个 `...HomotopyWithMapsTo` 认证构造承担；最终
存在定理显式返回网格、值域包含和同伦的逐点成员证明。

# 依赖（人话版）

本条目复用 Mathlib 的紧性、一致连续性、度量球凸性、直线段、道路有限拼接和端点相对同伦；复用
本库 `UnitIntervalMesh` 的统一网格计算，以及上一条目的有限同伦像集控制。`MeshBallSubdivision`
不是第二套道路或同伦结构，而是把证明所需的有限网格、半径和局部几何证书打包为可复验数据。

# 应用与陷阱

空间必须是实赋范线性空间，因为“直线段”和仿射同伦需要实标量结构；一般拓扑空间没有折线概念。
开集条件用于从紧像取得统一正厚度，不能随意降为只包含道路像的任意集合。结论是有限线段拼接及
连续端点相对同伦，不声称折线路径在折点处光滑，不证明同伦的光滑性或任何线积分不变性。
