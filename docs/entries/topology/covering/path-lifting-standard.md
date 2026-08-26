---
id: topology.covering.path-lifting-standard
family: topology.covering
variant: unique-continuous-lift-with-prescribed-source-and-path-view
kind: theorem
state: research
title: 覆盖映射的道路提升存在唯一性
summary: 对覆盖映射、基道路及其起点上方的指定点，给出唯一连续提升，并将其视为终点由提升决定的标准 Path
premises: [topology.covering.definition-standard]
mathlib: [IsCoveringMap.liftPath, IsCoveringMap.eq_liftPath_iff', ContinuousMap, Path]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

覆盖映射的局部 sheet 结构允许沿基空间道路连续选择同一张 sheet。选择基道路起点上方的一个点后，
初始 sheet 被固定，提升便能逐段延拓且不能跳到另一张 sheet。道路提升是同伦提升、monodromy 和覆盖
空间分类的第一项核心工具，因此必须把起点、投影方程和唯一性量词写清楚。

# 教材定理

设 `p : E → X` 是覆盖映射，`gamma` 是从 `x` 到 `y` 的道路，`e : E` 满足 `p e = x`。则存在唯一
连续映射 `Gamma : I → E`，使 `Gamma(0)=e` 且 `p ∘ Gamma = gamma`。提升的终点不是输入：它由
`Gamma(1)` 决定，并自动位于 `y` 上方的 fiber。

唯一性比较的是同一个基道路、同一个初始提升点下的连续映射。若只指定某个目标 fiber 点而不固定
起点，或允许两条提升从不同 sheet 出发，结论不成立。

# Lean 正式接口

```lean
theorem existsUnique_coveringMap_pathLift
    (cov : IsCoveringMap p) (gamma : Path x y)
    (e : E) (he : p e = x) :
    ∃! Gamma : C(unitInterval, E),
      Gamma 0 = e ∧ p ∘ Gamma = gamma

noncomputable def coveringMapPathLift ... :
    Path e (cov.liftPath gamma e (gamma.source.trans he.symm) 1)

theorem coveringMapPathLift_lifts ... :
    p (coveringMapPathLift cov gamma e he t) = gamma t

theorem coveringMapPathLift_endpoint_mem_fiber ... :
    p (coveringMapPathLift cov gamma e he 1) = y
```

# 为什么存在性先用 ContinuousMap

Mathlib `Path a b` 的类型把两个端点写进类型本身，而提升终点在构造前未知。因此核心存在唯一性最
自然地量化 `Gamma : C(I,E)`，只规定初值和投影方程；这与教材定理完全一致。得到 Mathlib 的唯一
`liftPath` 后，`coveringMapPathLift` 才把它连同已知起点和新确定的终点组装成标准 `Path`。

该定义只是同一函数的 endpoint-indexed view，不是第二种道路 carrier，也没有复制提升算法。

# 自然语言 ↔ Lean 映射

“覆盖映射”对应 C1 已解释的 `IsCoveringMap p`；“基道路”直接使用 Mathlib `Path x y`；“起点上方的
点”是 `e : E` 与等式 `he : p e = x`；“连续提升”用 `ContinuousMap unitInterval E`；“投影回原道路”
是函数等式 `p ∘ Gamma = gamma`；“唯一”由 `∃!` 表达；标准道路视图的目标点是
`cov.liftPath ... 1`，其 fiber 归属由最后一条定理证明。

# 证明与 Mathlib 复用

存在 witness 直接取 Mathlib `cov.liftPath gamma e ...`；`liftPath_zero` 和 `liftPath_lifts` 给出初值与
投影。任意另一候选的连续性由 `ContinuousMap` 自带，Mathlib `eq_liftPath_iff'` 以同一初值和投影方程
给出严格函数相等。`coveringMapPathLift` 只复用该连续映射及其零时刻定理填充 `Path` 字段，逐点投影
与终点 fiber 性质由 `liftPath_lifts` 在 `t` 和 `1` 处取值得到。

# 类型假设和依赖

总空间与基空间只需 `TopologicalSpace`，不要求道路连通、局部道路连通、Hausdorff 或满射。提升只
涉及基道路实际经过的点；因此 C1 中 Mathlib 允许空 fiber 的总体约定不妨碍此定理，因为输入已经
显式给出起点 fiber 中的 `e`。本条目 import Mathlib `Topology.Homotopy.Lifting`，但不公开消费其中
同伦提升或 monodromy 部分。

# 应用与边界

AT2-C3 将以这里冻结的覆盖 carrier 和初值量词处理同伦提升；后续 monodromy 会把道路同伦类作用到
fiber 上。本批不证明提升与道路拼接、常道路或道路同伦的相容性，也不发布覆盖分类。Hatcher 第一章
§1.3 是教材来源；实际构造和唯一性证明直接复用 Mathlib，不在本库重写细分算法。
