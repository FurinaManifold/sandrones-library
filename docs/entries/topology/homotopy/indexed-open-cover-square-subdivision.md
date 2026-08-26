---
id: topology.homotopy.indexed-open-cover-square-subdivision
family: topology.homotopy
variant: indexed-open-cover-dyadic-square-grid-with-minimum-depth
kind: theorem
state: research
title: indexed 开覆盖下的 dyadic 方格细分
summary: 对被任意指标开覆盖逐点覆盖的连续方形，构造指数不低于指定深度的统一 dyadic 网格及逐格从属标签
premises: [topology.homotopy.homotopy-square-grid]
mathlib: [ContinuousMap, IsOpen, lebesgue_number_lemma_of_metric, Set.Icc.convexComb, Prod.dist_eq]
provenance:
  source_type: book
  ref: "munkres-topology-2000"
---

# 动机

在道路同伦方形上逐格使用局部结论时，每个闭小格必须整体落入同一个开集。二开集 Bool 标签不足以
表达局部原函数等由任意指标族给出的开覆盖；同时边界道路已有的分段 C1 断点要求网格至少达到某个
dyadic 深度。本条目一次返回这两类兼容数据。

# 教材直觉

把目标空间的开覆盖沿连续方形取原像，得到紧致单位方形的开覆盖。Lebesgue 数给出一个统一正半径，
使以每个参数点为中心的足够小球落在某个原像开集内。取 `2^-n` 小于该半径且 `n` 不低于调用者指定
深度；每个闭格到左下角的乘积距离都小于 Lebesgue 数，因此整格可赋同一个覆盖标签。

# 陈述与边界

设 `H : I × I → X` 连续，`W : ι → Set X` 的每一项开放，并且每个 `H z` 落入某个 `W k`。对任意
`minimumDepth`，存在 `n ≥ minimumDepth` 和二维标签
`label : Fin (2^n) → Fin (2^n) → ι`，使每格内任意局部参数 `u,v` 的像落入相应 `W (label i j)`。

结论不要求指标类型有限，也不输出有限子覆盖；有限性来自返回的网格。它不声称开覆盖局部有限、
不构造 nerve，也不比较相邻格标签。

# Lean 对照

```lean
theorem exists_indexedOpenCoverSquareSubdivisionData_atLeastDepth
    (H : C(unitInterval × unitInterval, X)) (W : ι → Set X)
    (hW : ∀ k, IsOpen (W k)) (hH : ∀ z, ∃ k, H z ∈ W k)
    (minimumDepth : ℕ) :
    ∃ n, minimumDepth ≤ n ∧
      ∃ label : Fin (2 ^ n) → Fin (2 ^ n) → ι,
        ∀ i j u v,
          H (unitSquareCellPoint (2 ^ n) (by positivity) i j u v) ∈ W (label i j)
```

公开定理直接返回消费者所需数据，不暴露证明内部存储 `steps` 及 `steps = 2^n` 的 carrier，因而下游
无需反复沿等式 transport。

# 自然语言 ↔ Lean 映射

“连续方形”由 Mathlib `ContinuousMap` 承载；“指标开覆盖”由函数 `W : ι → Set X`、逐项 `IsOpen`
以及逐点存在标签的量词表达；“至少指定深度”是 `minimumDepth ≤ n`；“dyadic 闭小格”复用共享
`unitSquareCellPoint (2^n)`；“整格从属”是对 `i j u v` 的最终 membership 量词。

# 证明思路

沿 `H` 取原像后使用 Mathlib 的紧致度量空间 Lebesgue-number 引理。先证明存在 dyadic 倒数小于
Lebesgue 数，再把指数与 `minimumDepth` 取最大值。每格选择覆盖标签；两个坐标的凸组合到左下角
距离均不超过 `2^-n`，`Prod.dist_eq` 将乘积距离化为二者最大值，因而整格落入所选原像开集。

# 正式承载与依赖

`ContinuousMap`、`IsOpen` 与任意指标族是教材语义一致的正式承载；`lebesgue_number_lemma_of_metric`
只作为紧致参数方形上的证明后端，不把度量假设泄漏给目标空间 `X`，后者仅需 `TopologicalSpace`。
共享 `HomotopySquareGrid` 提供 `unitSquareCellPoint` 与统一坐标约定。内部 subdivision structure、经典
选择和距离估计均为 private，不形成第二套公开方格 carrier。

# 应用与来源

后续可用 `minimumDepth` 同时加细到边界道路的 dyadic C1 深度，再对每格选择局部原函数。Munkres
关于紧致度量空间开覆盖与 Lebesgue 数的论证是存在性来源；dyadic 指数下界及直接数据返回形式是
适配本库消费者的形式化接口，不作为教材原句引用。本条目没有复数、微分或积分假设。
