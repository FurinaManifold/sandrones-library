---
id: topology.homotopy.standard
family: topology.homotopy
variant: continuous-map-relative-set
kind: definition
state: staging
title: 一般同伦、相对同伦与复合
summary: 以 Mathlib ContinuousMap.Homotopy/HomotopyRel 承载连续映射的变形、集合上的全程固定条件及复合
premises: [topology.foundation.constructions, topology.foundation.structure, topology.homotopy.path-homotopy-standard]
mathlib: [ContinuousMap.Homotopy, ContinuousMap.HomotopyRel, ContinuousMap.Homotopy.comp, ContinuousMap.HomotopyRel.compContinuousMap]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

道路同伦只是一般同伦在单位区间上并固定两个端点的特例。要讨论空间的同伦等价和映射诱导的拓扑不变量，需要先把任意连续映射之间的变形以及“相对某个子集不动”的条件精确化。

# 直觉

一般同伦是一族随时间连续变化的连续映射。相对 `S` 的同伦要求 `S` 中每个点在整个动画过程中完全静止；这比只要求动画开头和结尾在 `S` 上相同更强。两个相容的动画可以在每个相同时间逐点复合。

# 陈述（自然语言）

连续映射 `f,g:X→Y` 之间存在同伦，当且仅当存在连续 `F:[0,1]×X→Y`，其时间零切片为 `f`、时间一切片为 `g`。相对 `S` 的同伦还要求对每个时间 `t` 和每个 `x∈S` 都有 `F(t,x)=f(x)`。同伦复合把 `F(t,x)` 送入同一时间的第二个同伦；连续后复合保留相对固定集合。

# 陈述（Lean 对照）

```lean
theorem nonempty_homotopy_iff_exists_continuous_deformation :
  Nonempty (f.Homotopy g) ↔
    ∃ F : unitInterval × X → Y, Continuous F ∧
      (∀ x, F (0, x) = f x) ∧ (∀ x, F (1, x) = g x)

theorem nonempty_homotopyRel_iff_exists_continuous_deformation_fixed_on :
  Nonempty (f.HomotopyRel g S) ↔
    ∃ F, Continuous F ∧ … ∧ (∀ t x, x ∈ S → F (t, x) = f x)
```

`homotopy_comp_apply` 和 `homotopyRel_compContinuousMap_apply` 给出两种复合的逐点公式。

# 思维脉络（thinking trace）

一般同伦的正向展开读取底层连续映射及两个时间边界；反向把连续函数与边界等式装回 `ContinuousMap.Homotopy`。相对版本再读取或构造 `prop'`，其量词正是“所有时间、所有 `S` 中的点”。复合公式直接展开 Mathlib 构造，表明没有隐藏的重新参数化。

# 自然语言 ↔ Lean 映射

“连续映射族”对应 `ContinuousMap.Homotopy`；“相对 `S` 固定”对应 `ContinuousMap.HomotopyRel ... S`；“存在同伦”对应 `Nonempty`；“两个动画同步复合”对应 `Homotopy.comp`；“对动画每一帧施加连续映射”对应 `HomotopyRel.compContinuousMap`。

# 依赖（人话版）

本条目依赖积拓扑、连续映射和已解释的标准道路同伦。教材定位为 Hatcher 的同伦基础及第 1.1 节。Mathlib 两个同伦类型与教材语义一致，直接作为正式承载；旧 `TextbookTopology.Homotopy` 继续冻结，仅供旧下游兼容。

# 应用与陷阱

第一坐标始终是同伦时间。`Homotopy.comp` 是映射复合而不是先后执行两个同伦；先后执行由 `Homotopy.trans` 表示。相对同伦要求全程固定，不可用 `f`、`g` 在 `S` 上相等替代。本批不建立同伦等价、同伦商或基本群，集成必须等待 T4-H1 进入 Main。
