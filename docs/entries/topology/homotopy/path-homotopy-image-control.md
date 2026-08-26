---
id: topology.homotopy.path-homotopy-image-control
family: topology.homotopy
variant: image-controlled-relative-composition
kind: theorem
state: verified
title: 道路同伦的像集控制与有限拼接
summary: 为仿射同伦、同伦复合、重参数化和有限依赖拼接携带逐点集合成员证书
premises: [topology.homotopy.path-homotopy-standard]
mathlib: [Path.Homotopy, ContinuousMap.Homotopy.affine, Path.concat, Path.subpath, Convex]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

相对端点的道路同伦若要用于开集内部的道路替换，仅知道起点道路和终点道路落在开集里还不够；还
必须控制同伦过程中每个中间点。本条目给常见道路同伦构造附加逐点落在集合 `S` 中的证书，并把
这一证书传过依赖端点的有限道路拼接。

# 直觉

水平或竖直复合的同伦在参数方形的每一半只运行一个已有同伦，因此两部分都留在 `S` 就足够。
重参数化和子道路结合只改变访问原道路的时间，不产生新空间点。有限拼接则逐段归纳：已经控制的
前缀与最后一段水平复合，端点类型的 cast 不改变实际取值。

# 陈述（自然语言）

在实赋范线性空间中，两条同端点道路之间存在逐点仿射的端点相对同伦；若两道路落在同一凸集或球
中，则整个同伦也落在其中。对一般拓扑空间，水平复合、竖直复合、重参数化、常值同伦及子道路
结合保持任意逐点像集界。因而有限局部同伦可以拼成带同一像集证书的整体同伦；若有限道路段及其
顶点都属于 `S`，其 `Path.concat` 的整个值域也属于 `S`。

# 陈述（Lean 对照）

```lean
def Path.affineHomotopy (p q : Path x y) : p.Homotopy q

theorem Path.Homotopy.hcomp_mapsTo ...
theorem Path.Homotopy.trans_mapsTo ...

def Path.Homotopy.concatWithMapsTo ... :
    {K : (Path.concat vertices P).Homotopy (Path.concat vertices Q) //
      ∀ t s, K (t, s) ∈ S}

theorem Path.concat_range_subset ... :
    Set.range (Path.concat vertices pieces) ⊆ S
```

# 思维脉络（thinking trace）

二元复合定理展开 Mathlib 的求值公式，再按参数落在哪一半分支调用对应证书。重参数化类定理把求值
归约为原道路某一参数处。两个有限同伦构造对段数归纳：零段是常值道路；后继步取已认证前缀，
水平接上最后一个局部同伦，并用 `cast_apply` 消除依赖端点转换。有限值域定理同样归纳，后继步用
`Path.trans_range` 把值域化为前缀与末段值域之并。

# 自然语言 ↔ Lean 映射

教材中的端点相对道路同伦正式承载为 Mathlib `Path.Homotopy`；“同伦始终位于 `S`”写成
`∀ t s : unitInterval, F (t,s) ∈ S`。逐点直线插值是 `Path.affineHomotopy`；有限局部同伦族由
`Path.Homotopy.concatWithMapsTo` 组装；有限道路值域结论是 `Path.concat_range_subset`。

# 依赖（人话版）

本条目直接复用 Mathlib 的道路、端点相对同伦、水平／竖直复合、重参数化、子道路和有限 concat，
这些承载与教材语义一致。只有仿射插值使用 `[NormedAddCommGroup E] [NormedSpace ℝ E]` 以及凸集；
其余像集传递接口只要求 `[TopologicalSpace X]`。本库新增的是 Mathlib 尚未统一封装的 maps-to 证书
层，而不是第二套同伦定义。

# 应用与陷阱

“首尾两条道路都在 `S`”一般不能推出任意同伦都在 `S`；仿射结论必须额外利用凸性。返回 subtype
`{K // ...}` 是同伦与证书的依赖对，并非新的同伦商。有限拼接的顶点成员假设在零段和 cast 分支中
仍然必要。本条目止于像集控制，不声称道路分段足够细、不构造折线路径，也不涉及光滑性或线积分。
