---
id: topology.covering.pointed-recovered-subgroup
family: topology.covering
variant: pointed-connected-recovery
kind: definition
state: verified
title: 从 pointed connected covering 恢复子群
summary: 把 covering 投影诱导的基本群同态之像作为对应子群，并证明 pointed-cover 等价保持它
premises: [topology.covering.definition-standard, topology.fundamental-group.functoriality-standard]
mathlib: [PathConnectedSpace, IsCoveringMap, FundamentalGroup.mapOfEq, MonoidHom.range, Homeomorph]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

覆盖空间分类的反向从一个带基点的 connected covering `p : E → X` 恢复
`π₁(X,x₀)` 的子群。选定 `e₀ ∈ E` 且 `p(e₀)=x₀` 后，投影把 `E` 中基于 `e₀` 的
环路送到 `X` 中基于 `x₀` 的环路；这个诱导同态的像就是 covering 在该 lift point 下的对应
子群。

# Pointed connected covering

`PointedCovering X x₀` 包含 total type、其拓扑、total space 的 `PathConnectedSpace`、投影函数、
Mathlib `IsCoveringMap`、选定点 `point` 和等式 `projection point = x₀`。base 与 total 使用独立
universe。道路连通性是 carrier 的一部分，不是最终定理的临时前提。

# 投影诱导同态

covering 性给出投影的连续性，因而 `projectionContinuousMap` 把它视为 Mathlib 连续映射。
因为其在选定点的值与 `x₀` 有一个显式等式，Mathlib `FundamentalGroup.mapOfEq` 给出
`π₁(E,e₀) →* π₁(X,x₀)`。`mapOfEq` 处理目标基点的 equality cast，不需要本库另造基本群
诱导映射。

# 恢复子群

`PointedCovering.recoveredSubgroup C` 定义为上述 `mapOfEq` 的 `MonoidHom.range`。这与先前
covering lifting criterion 中出现的子群完全相同：一个 based map 可提升的必要充分条件，正是它
的基本群像包含在这个 range 中。monodromy kernel 可以作为后续刻画，但不是本条目的主定义。

# Pointed-cover 等价

`PointedCovering.Equiv C D` 包含 `C.Total ≃ₜ D.Total`，要求它严格与两个到 `X` 的投影
交换，并把 `C.point` 严格送到 `D.point`。这是 pointed covering 的同构，不允许任意更换
base 或把选定点只保持到道路。`Equiv.refl`、`Equiv.symm` 和 `Equiv.trans` 给出反身、对称与
复合设施。

# 子群不变性

若 `e : PointedCovering.Equiv C D`，total-space homeomorphism 诱导基本群同态。投影交换等式说明
`C` 的投影同态分解为该同态再复合 `D` 的投影同态，所以 `C` 的 range 包含于 `D`
的 range。对 `e.symm` 重复即得反向包含。`recoveredSubgroup_eq_of_equiv` 因此证明两个
恢复子群在 `π₁(X,x₀)` 中字面相等。

# Lean 对照

```lean
structure PointedCovering (X : Type u) [TopologicalSpace X] [PathConnectedSpace X]
    (x0 : X) where
  Total : Type v
  topology : TopologicalSpace Total
  pathConnected : @PathConnectedSpace Total topology
  projection : Total → X
  isCoveringMap : @IsCoveringMap Total X topology inferInstance projection
  point : Total
  projection_point : projection point = x0

def PointedCovering.recoveredSubgroup (C : PointedCovering X x0) :
    Subgroup (FundamentalGroup X x0)

structure PointedCovering.Equiv (C D : PointedCovering X x0) ...

theorem PointedCovering.recoveredSubgroup_eq_of_equiv
    (e : PointedCovering.Equiv C D) :
    C.recoveredSubgroup = D.recoveredSubgroup
```

# 边界

首版同时要求 base 道路连通，因为单一 `π₁(X,x₀)` 子群只描述 `x₀` 所在的道路分支，
不能静默分类 base 的其他分支。若 total space 不连通，选定点得到的基本群像只描述该点所在
的道路分支，不能当作
整个非连通 covering 的单一对应子群，所以本 carrier 要求 total space 道路连通。本条目不把
C5c 构造的 cover 打包为 pointed cover，不证明构造—恢复互逆，不证明 pointed 或 unpointed
classification，也不构造 universal cover。
