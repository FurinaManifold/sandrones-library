---
id: topology.foundation.constructions
family: topology.foundation
variant: induced-subspace-product
kind: definition
state: staging
title: 诱导拓扑、子空间拓扑与积拓扑的正式承载
summary: 解释 Mathlib 的诱导、subtype 与积拓扑如何实现教材构造，并保留旧显式结构作为迁移兼容层
premises: [topology.foundation.structure]
mathlib: [TopologicalSpace.induced, isOpen_induced_iff, continuous_subtype_val, Continuous.subtype_mk, isOpen_prod_iff, continuous_fst, continuous_snd, Continuous.prodMk]
provenance:
  source_type: book
  ref: "munkres-topology-2000"
---

# 动机

子空间和积空间是道路、同伦、复分析与流形的共同基础。本条需要让读者看清这些构造的教材含义，但不需要复制 Mathlib 已成熟且语义相同的拓扑实例；可追溯性由公开刻画定理和课程解释提供。

# 直觉

映射诱导的拓扑把目标空间的开集拉回定义域；subtype 的拓扑是包含映射诱导的特例，因此映射到子空间连续等价于其环境值映射连续。积空间中的集合开，是指其中每一点附近都有完全包含在该集合内的开矩形；映射到积空间连续，可以逐坐标检查。

# 陈述（自然语言）

Mathlib 的 `TopologicalSpace.induced f τY` 以目标开集的原像为开集；subtype 使用包含映射诱导拓扑。积拓扑由开矩形构成局部基。映射到 subtype 连续当且仅当复合包含映射后连续；映射到积空间连续当且仅当两个坐标函数都连续。旧 `TextbookTopology.induced/subspace/product` 只为已提交模块保留，不再作为新课程承载。

# 陈述（Lean 对照）

```lean
theorem isOpen_induced_iff_exists (f : X → Y) (τY : TopologicalSpace Y) (s : Set X) :
  IsOpen[TopologicalSpace.induced f τY] s ↔
    ∃ v, IsOpen[τY] v ∧ f ⁻¹' v = s

theorem continuous_subtype_iff [TopologicalSpace X] [TopologicalSpace Y]
    {s : Set X} (f : Y → s) :
  Continuous f ↔ Continuous (fun y ↦ (f y : X))

theorem isOpen_prod_iff_rectangles [TopologicalSpace X] [TopologicalSpace Y]
    (s : Set (X × Y)) :
  IsOpen s ↔ ∀ x y, (x, y) ∈ s →
    ∃ u v, IsOpen u ∧ IsOpen v ∧ x ∈ u ∧ y ∈ v ∧ u ×ˢ v ⊆ s

theorem continuous_prod_mk_iff [TopologicalSpace X] [TopologicalSpace Y]
    [TopologicalSpace Z] (f : Z → X) (g : Z → Y) :
  Continuous (fun z ↦ (f z, g z)) ↔ Continuous f ∧ Continuous g
```

# 思维脉络（thinking trace）

首先用 `isOpen_induced_iff` 展开诱导拓扑的开集。subtype 的包含映射是 inducing map，所以 `IsInducing.subtypeVal.continuous_iff` 给出映射到子空间的连续性判据。积拓扑直接用 `isOpen_prod_iff` 展开为逐点开矩形。积映射的正向用连续积映射分别复合 `continuous_fst`、`continuous_snd`，反向用 `Continuous.prodMk` 从两个坐标连续性组装。

# 自然语言 ↔ Lean 映射

“拉回开集”对应 `TopologicalSpace.induced` 与 `isOpen_induced_iff_exists`；“包含映射”对应 `Subtype.val`；“映射到子空间”对应 `continuous_subtype_iff`；“开矩形”对应 `Set.prod` 记号 `u ×ˢ v`；“开矩形局部基”对应 `isOpen_prod_iff_rectangles`；“投影连续”对应 Mathlib 的 `continuous_fst`、`continuous_snd`；“逐坐标检查连续性”对应 `continuous_prod_mk_iff`。

# 依赖（人话版）

正式接口依赖 Mathlib 的 `Topology.Constructions`：subtype 与 product 已有规范拓扑实例，包含映射、投影和积映射的连续性已有成熟定理。本库旧显式构造继续依赖 `TextbookTopology`，只用于保持旧道路与同伦施工可编译。

# 应用与陷阱

诱导拓扑不是把定义域原有拓扑与目标拓扑混合，而是完全由映射拉回得到。积拓扑也不是把开矩形本身当成全部开集，而是取它们生成的拓扑，故公开刻画使用“每点存在开矩形”。新定理必须使用 Mathlib 的 subtype/product 实例，不得调用旧 `subspace/product` 扩张平行层级；旧 `continuous_of_closed_cover` 也不迁移成同名包装，课程需要粘合时应选择 Mathlib 的成熟接口。
