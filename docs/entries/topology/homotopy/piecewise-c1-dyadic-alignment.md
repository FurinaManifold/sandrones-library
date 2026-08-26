---
id: topology.homotopy.piecewise-c1-dyadic-alignment
family: topology.homotopy
variant: midpoint-concat-tree-dyadic-depth-certificate
kind: theorem
title: 分段 C1 道路的 dyadic 对齐证书
state: verified
summary: 为既有分段 C1 道路的中点拼接树给出可共同加细的 dyadic 深度证书，并证明每个对齐网格小段及同伦方形外边的分段 C1 性
premises: [topology.homotopy.piecewise-c1-path, topology.homotopy.homotopy-square-grid]
mathlib: [Path, Path.subpath, Path.trans, Path.cast, ContDiffOn, Set.Icc.convexComb]
provenance:
  source_type: book
  ref: "ahlfors-complex-analysis-1979"
---

# 动机

既有 `Path.PiecewiseC1` 按中点拼接归纳生成，任意子道路未必仍能由同一构造表达；但只要网格断点与
构造树的 dyadic 深度对齐，每个小段都落入一个整体 C1 叶子。

# 教材直觉

有限分段 C1 道路有有限多个拼接层级。Mathlib `Path.trans` 总在参数中点拼接，所以每深入一层，原
道路的一半参数区间再次二分。将所有叶子的深度补到共同的 `n` 后，断点都落在 `k/2^n`，于是每个
dyadic 小区间都完整位于一个 C1 叶子之内。这里记录的是“某个深度足够细”的证书，不选最小深度。

# 定义与边界

`Path.DyadicC1AtDepth gamma n` 是 Prop 值对齐证书，不是第二种道路类型。它可忘却为既有
`Path.PiecewiseC1`；反之，每个 `PiecewiseC1` 证明都存在某个有限深度证书。证书可单调提升到更细深度。

# Lean 对照与结论

```lean
inductive Path.DyadicC1AtDepth : Path x y → ℕ → Prop
theorem Path.DyadicC1AtDepth.mono ...
theorem Path.DyadicC1AtDepth.piecewiseC1 ...
theorem Path.PiecewiseC1.exists_dyadicC1AtDepth ...
theorem Path.DyadicC1AtDepth.dyadicSegment_piecewiseC1 ...
theorem Path.PiecewiseC1.exists_dyadicGrid_segments_piecewiseC1 ...
```

对深度 `n` 的每个 `Fin (2^n)` 小区间，`dyadicSegment_piecewiseC1` 给出相应 `Path.subpath` 的
`PiecewiseC1` 证书。四条 homotopy-square 外边桥为最终 raw grid 提供边界正则性。

# 自然语言 ↔ Lean 映射

“深度对齐证书”对应 `Path.DyadicC1AtDepth`；“共同加细”对应 `mono`；忘记深度与从既有分段 C1
证明恢复某个深度分别对应 `piecewiseC1` 和 `exists_dyadicC1AtDepth`；“每个 dyadic 小段仍分段 C1”
对应 `dyadicSegment_piecewiseC1`。同伦方形的下、上常值边以及左、右端道路小段分别由四个
`pathHomotopySquare_*_piecewiseC1` 桥承载。

# 证明思路

对 `DyadicC1AtDepth` 证书归纳。整体 C1 叶子的任意 affine subpath 仍整体 C1；拼接节点把左半、右半
网格分别搬回两个子道路，并对相应子证书递归；端点 cast 逐点不改变道路。对既有 `PiecewiseC1`
证明归纳时，两棵子树取深度最大值，再用 `mono` 共同加细并在拼接处增加一层。方形下、上边由常
道路得到，左、右边用共享 square-grid 的外边计算与 dyadic 小段定理识别。

# 正式承载与类型假设

道路、子道路、拼接与端点 cast 直接复用 Mathlib `Path`、`Path.subpath`、`Path.trans`、`Path.cast`；
它们与教材对象语义一致。整体 C1 叶子沿用前提 Entry 的 `ContDiffOn ℝ 1 gamma.extend (Icc 0 1)`。
环境只要求 `[NormedAddCommGroup E] [NormedSpace ℝ E]`，没有增加完备性、有限维性或复结构。

新 `DyadicC1AtDepth` 是既有 `PiecewiseC1` 性质的 proof-relevant Prop 证书，不是第二个道路 carrier、
全局 instance、notation 或可计算语法树。公开网格结论使用共享 `unitIntervalMeshPoint`，没有暴露
私有 dyadic 缩写。

# 应用与陷阱

该证书允许后续把道路积分或边界消去逐段应用到共同 dyadic 网格。它只保证与中点拼接树对齐的
`2^n` 个小段；没有证明任意实端点 `Path.subpath` 都保持当前归纳定义的 `PiecewiseC1`。由于源证明
位于 `Prop`，结论是 `∃ n`，不能从证明项计算规范或最小深度。四条方形桥只控制外边，不赋予内部
格边任何正则性。

# 来源角色

Ahlfors 的复积分课程提供有限分段光滑曲线及其积分的教材背景；Hatcher 第一章提供道路、端点相对
道路同伦及同伦方形的拓扑语境。`DyadicC1AtDepth` 是为匹配 Mathlib `Path.trans` 实际中点参数化而
新增的 Lean 证书，不声称是两本教材中的具名定义或定理。

本条目以 Ahlfors 的有限分段光滑曲线语义为课程来源；Hatcher 的端点相对道路同伦仅作为共享方形
消费者的拓扑背景。`DyadicC1AtDepth` 是为匹配 Mathlib `Path.trans` 的实际中点参数化而新增的 Lean
证书，不声称是教材中的具名定义或定理。
