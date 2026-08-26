---
id: topology.homotopy.unit-interval-mesh
family: topology.homotopy
variant: uniform-finite-mesh
kind: definition
state: verified
title: 单位区间的一致有限网格
summary: 以有限指标表示单位区间的等距网格点，并刻画首末点、相邻单调性和精确间距
premises: [topology.foundation.real-line]
mathlib: [unitInterval, Fin, Subtype.dist_eq, Real.dist_eq]
provenance:
  source_type: book
  ref: "munkres-topology-2000"
---

# 动机

道路细分、同伦方格细分和折线逼近都需要把单位区间分成有限个等长闭区间。如果网格定义归属于某个
van Kampen 专用模块，其他拓扑论证就会产生不必要的基本群依赖。本条目把这项通用有限设施放回
单位区间层，并保持原有声明名称不变。

# 直觉

给定正整数 `N`，第 `i` 个网格点就是实数 `i/N` 连同它位于 `[0,1]` 的证明。有限指标
`i : Fin (N+1)` 自动保证 `i≤N`。相邻指标 `i`、`i+1` 的距离是
`|(i/N)-((i+1)/N)|=1/N`。

# 陈述（自然语言）

对每个正整数 `N`，存在以 `Fin (N+1)` 编号的单位区间网格点。第零点为 `0`，最后一点为 `1`；
每一对相邻点按通常次序单调，且它们在单位区间继承度量下的距离精确等于 `N⁻¹`。

# 陈述（Lean 对照）

```lean
def unitIntervalMeshPoint (N : ℕ) (hN : 0 < N)
    (i : Fin (N + 1)) : unitInterval

theorem unitIntervalMeshPoint_zero ...
theorem unitIntervalMeshPoint_last ...
theorem unitIntervalMeshPoint_castSucc_le_succ ...
theorem dist_unitIntervalMeshPoint_castSucc_succ ...
```

# 思维脉络（thinking trace）

定义以 subtype pair 保存 `(i : ℝ) / N` 和上下界证明。首末点由自然数、实数强制转换和除法计算
得到。相邻单调性在正分母下化为 `i≤i+1`。精确距离先用 `Subtype.dist_eq` 回到实数距离，再把差
整理为 `-N⁻¹`，最后取绝对值得到 `N⁻¹`。

# 自然语言 ↔ Lean 映射

“正整数段数”是 `N : ℕ` 与 `hN : 0 < N`；“第 `i` 个点”是
`unitIntervalMeshPoint N hN i`；相邻左、右指标分别用 `i.castSucc` 和 `i.succ`；首末规则对应
`unitIntervalMeshPoint_zero/last`；相邻单调性与间距分别对应
`unitIntervalMeshPoint_castSucc_le_succ` 和 `dist_unitIntervalMeshPoint_castSucc_succ`。

# 依赖（人话版）

Mathlib `unitInterval` 是实数闭区间 `[0,1]` 的 subtype，`Fin` 提供有限指标及其上界，
`Subtype.dist_eq` 说明单位区间继承实数距离。本条目不依赖道路、同伦、开覆盖、基本群或 Pushout。

# 应用与陷阱

这些点描述的是一致等距网格，不是任意 partition。`hN` 不只是避免除零，也保证最后指标与距离公式
具有预期含义。道路和方形模块可以用凸组合或 `Path.subpath` 在相邻网格点之间参数化，但这些连续
对象不属于本条目的结论。正式源码只有这一套声明；VK1 通过 import 消费它，没有保留 alias 或副本。
