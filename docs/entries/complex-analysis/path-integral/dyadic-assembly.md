---
id: complex-analysis.path-integral.dyadic-assembly
family: complex-analysis.path-integral
variant: piecewise-c1-admissibility-and-dyadic-leaf-sum-assembly
kind: theorem
state: research
title: 分段 C1 道路的可积性桥与 dyadic 积分组装
summary: 将分段 C1 道路在连续被积函数和像集控制下转为 admissible path，并从 dyadic 小段可积性与外边界有限和恢复整条道路积分相等
premises: [topology.homotopy.piecewise-c1-path, topology.homotopy.unit-interval-mesh, complex-analysis.cauchy.primitive-from-path-independence-foundation]
mathlib: [Path, Path.subpath, PathIntegrable, ContinuousOn, Finset.sum, Set.Icc.convexComb]
provenance:
  source_type: book
  ref: "ahlfors-complex-analysis-1979"
---

# 动机

后续同伦方格论证需要连接两种已存在接口：拓扑层用 `Path.PiecewiseC1` 表示有限分段正则性，复分析
层用 `AdmissiblePath` 存储像集控制、可积性和逐段整体 C1；而最终方格消去得到的是 dyadic 小段积分
的有限和，不是直接得到整条道路积分。本条目分别建立这两个纯解析组装桥。

# 教材直觉

连续函数沿一条整体 C1 且位于开集内的道路可积；有限条这样的道路拼接仍可积。因此分段 C1 证明树
可递归转为 admissible path。另一方面，把 `[0,1]` 反复二分后，整条道路积分等于所有 dyadic 小段
积分之和；证明只需积分对道路拼接的可加性，不使用同伦不变性。

# 陈述与边界

`admissiblePath_of_piecewiseC1`：若 `gamma` 分段 C1、道路像包含于 `U`，且 `f` 在 `U` 上连续，则
`gamma` 是既有 `AdmissiblePath f U`。

`pathIntegral_eq_of_dyadicOuterBoundary`：若 `gamma`、`delta` 的每个深度 `n` dyadic 小段都可积，
四组有限标量 `bottom/top/left/right` 中水平两组为零、竖直两组分别等于源与目标小段积分，且定向
外边界总和为零，则两条整道路积分相等。

第二个结论不构造这些边界值，也不选择开覆盖或 primitive；它只完成标量有限和组装。

# Lean 对照

```lean
theorem admissiblePath_of_piecewiseC1
    (hgamma : Path.PiecewiseC1 gamma)
    (hrange : Set.range gamma ⊆ U) (hf : ContinuousOn f U) :
    AdmissiblePath f U gamma

theorem pathIntegral_eq_of_dyadicOuterBoundary
    (gamma delta : Path a b) (n : ℕ)
    (hgammaLeaf : ∀ i : Fin (2^n), PathIntegrable f (gamma.subpath ... ...))
    (hdeltaLeaf : ∀ i : Fin (2^n), PathIntegrable f (delta.subpath ... ...))
    ...
    (houter : (∑ i, bottom i - top i) + ∑ i, right i - left i = 0) :
    pathIntegral f gamma = pathIntegral f delta
```

# 自然语言 ↔ Lean 映射

“分段 C1”复用 `Path.PiecewiseC1`；“道路位于开集”是 `Set.range gamma ⊆ U`；“沿道路可积”由
`PathIntegrable` 承载；“dyadic 小段”是共享 `unitIntervalMeshPoint (2^n)` 端点间的 `Path.subpath`；
“有限边界和”用 `Finset.sum` 表达；标量组装定理的 `bottom/top/left/right` 是已经计算出的复数值，
不是新的几何边 carrier。

# 证明思路

第一个定理对 `PiecewiseC1` 证书归纳：整体 C1 情形由 `ContinuousOn` 的 scalar one-form 沿正则道路
可积；拼接情形分别限制 range 后用 `AdmissiblePath.trans`；cast 逐点不改变道路。

第二个定理先证明一次中点二分的道路严格拼回原道路（差一个规范 endpoint cast），从而积分可加。
再对深度归纳，将 `2^(n+1)` 小段拆成左右各 `2^n` 项，得到整道路积分等于全部叶子积分之和。把
水平零值和左右叶子积分代入 `houter`，有限和差为零即给出目标等式。全程不调用任何同伦不变性。

# 正式承载与依赖

`Path`、`Path.subpath`、`PathIntegrable`、`ContinuousOn`、`Finset.sum` 和区间凸组合均为 Mathlib 中
语义一致的正式承载。`AdmissiblePath` 与 `Path.PiecewiseC1` 是已解释的本库谓词；本条目新增必要
桥而不复制 carrier。源码直接 import 最小化后的 `PrimitiveFromPathIntegral`，其闭包不再经过旧 C2
同伦不变性最终包。所有 dyadic reindex、半区间参数恒等式和有限和拆分均保持 private。

# 应用与陷阱

R3b-E 将为 raw grid 的边附加 admissibility 与逐格 primitive 计算，R3b-F 再向本条目的标量组装定理
提供外边界消去等式。不能从 `admissiblePath_of_piecewiseC1` 删除 `ContinuousOn f U` 或 range 控制；
也不能把第二定理误读为“任意同伦道路积分相等”。Ahlfors 的分段光滑曲线积分可加性和局部原函数
论证是教材来源；dyadic induction 是适配本库中点拼接接口的形式化安排。
