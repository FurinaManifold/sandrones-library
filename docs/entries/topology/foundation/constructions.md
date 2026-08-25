---
id: topology.foundation.constructions
family: topology.foundation
variant: induced-subspace-product
kind: definition
state: verified
title: 诱导拓扑、子空间拓扑与积拓扑
summary: 从本库开集公理构造诱导、子空间和积拓扑，并证明包含映射及两个投影连续
premises: [topology.foundation.structure]
mathlib: []
provenance:
  source_type: book
  ref: "Munkres, Topology, Sections 16 and 19"
---

# 动机

道路的定义域是区间子空间，同伦的参数空间是区间的积，因此在定义道路与同伦以前，必须先在本库中构造子空间和积拓扑。若直接调用 Mathlib 的相应实例，复分析仍然无法得到库内可追溯的定义链。

# 直觉

映射诱导的拓扑把目标空间的开集拉回定义域；子空间拓扑是包含映射诱导的特例。积空间中的集合开，是指其中每一点附近都有一个完全包含在该集合内的开矩形。

# 陈述（自然语言）

给定 `f : X → Y` 和 `Y` 上的拓扑，`induced f τY` 的开集恰为 `f` 下的开集原像。集合 `s⊆X` 的子空间拓扑由包含映射诱导。`X×Y` 的积拓扑以开矩形为局部基；子空间包含映射和两个积投影都是连续映射。

# 陈述（Lean 对照）

```lean
def induced (f : X → Y) (τY : TextbookTopology Y) : TextbookTopology X
def subspace (s : Set X) (τX : TextbookTopology X) : TextbookTopology s
def product (τX : TextbookTopology X) (τY : TextbookTopology Y) : TextbookTopology (X × Y)

theorem continuous_fst : Continuous (product τX τY) τX Prod.fst
theorem continuous_snd : Continuous (product τX τY) τY Prod.snd
theorem continuous_prod_mk (hf : Continuous τW τX f) (hg : Continuous τW τY g) :
  Continuous τW (product τX τY) (fun w ↦ (f w, g w))
theorem continuous_subtype_mk (hf : Continuous τY τX f) (hs : ∀ y, f y ∈ s) :
  Continuous τY (subspace s τX) (fun y ↦ ⟨f y, hs y⟩)
```

# 思维脉络（thinking trace）

诱导拓扑的有限交由原像保持交得到；任意并则收集所有能表示原集合族成员的目标开集，再使用原像保持任意并。积拓扑直接使用开矩形的局部刻画：交集处把两个矩形分别取交，并集处沿成员集合复用已有矩形。投影下的开集原像分别是 `u×Y` 与 `X×v`。

# 自然语言 ↔ Lean 映射

“拉回开集”对应 `induced`；“包含映射”对应 `Subtype.val`；“子空间”对应 `subspace`；“映射提升到子空间”对应 `continuous_subtype_mk`；“开矩形”对应 `Set.prod` 记号 `u ×ˢ v`；“局部包含”对应积拓扑定义中的 `p ∈ u ×ˢ v ∧ u ×ˢ v ⊆ w`；“投影连续”对应 `continuous_fst` 和 `continuous_snd`；“坐标连续推出积映射连续”对应 `continuous_prod_mk`。

# 依赖（人话版）

本条只依赖上一条的开集公理与连续映射定义，以及集合原像、交、并和笛卡尔积的基本运算。所有拓扑构造和连续性证明均在本库定义层完成，没有使用 Mathlib 的拓扑实例或现成连续性定理。

# 应用与陷阱

诱导拓扑不是把定义域原有拓扑与目标拓扑混合，而是完全由映射拉回得到。积拓扑也不是只把开矩形本身规定为全部开集，而是要求每一点具有开矩形邻域；否则任意开矩形并不会被正确收入。后续区间、道路与同伦必须依赖这些构造。
