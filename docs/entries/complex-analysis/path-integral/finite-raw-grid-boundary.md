---
id: complex-analysis.path-integral.finite-raw-grid-boundary
family: complex-analysis.path-integral
variant: cellwise-local-primitives-common-edge-regularization
kind: theorem
state: verified
title: 局部原函数方格的外边界消去
summary: 为有限 raw grid 的内部公共边选择交集内分段 C1 替换，用逐格局部原函数证明格边界积分为零，并经有限 telescope 得到整体外边界积分和为零
premises: [topology.homotopy.finite-raw-open-path-grid, complex-analysis.path-integral.dyadic-assembly]
mathlib: [Complex.IsExactOn, Path, Path.symm, IsOpen, Finset.sum, Classical.choose]
provenance:
  source_type: book
  ref: "ahlfors-complex-analysis-1979"
---

# 动机

连续同伦的内部格边未必分段 C1，不能直接积分。若相邻两格分别选择不同的替换道路，即使端点相同，
它们的积分也不会以定义相等方式抵消。本条目为每条全局公共边只选择一次交集内分段 C1 替换，使
相邻格严格复用同一条道路；逐格局部原函数随后把每格边界积分化为端点差。

# 教材直觉

在一个拥有 primitive 的开集中，沿分段 C1 道路的积分只等于 primitive 在终点减起点，所以闭合
四边形的四条定向边积分和为零。对所有小格求和时，每条内部横边在下格中反向、在上格中正向；
每条内部竖边也出现一正一负，因而只剩整张网格的下、上、右、左外边界。

# 陈述与边界

给定 `R : FiniteRawOpenPathGrid ℂ` 和逐格假设
`hexact : ∀ i j, Complex.IsExactOn f (R.cellSet i j)`，定理
`finiteRawOpenPathGrid_outerBoundaryIntegral_eq_zero` 证明：所有下外边积分减上外边积分，加右外边
积分减左外边积分，结果为零。

假设是逐格局部 exactness，不是整个方格像或整个域上存在单个全局 primitive。结论保留 raw grid 的
四条原始外边；内部 replacement choice 不出现在公开签名中。

# Lean 对照

```lean
theorem finiteRawOpenPathGrid_outerBoundaryIntegral_eq_zero
    {f : ℂ → ℂ} (R : FiniteRawOpenPathGrid ℂ)
    (hexact : ∀ i j, Complex.IsExactOn f (R.cellSet i j)) :
    (∑ i : Fin R.steps,
        (pathIntegral f (R.horizontalRaw i 0) -
          pathIntegral f (R.horizontalRaw i (Fin.last R.steps)))) +
      ∑ j : Fin R.steps,
        (pathIntegral f (R.verticalRaw (Fin.last R.steps) j) -
          pathIntegral f (R.verticalRaw 0 j)) = 0
```

# 自然语言 ↔ Lean 映射

“逐格局部原函数”由 Mathlib `Complex.IsExactOn f (R.cellSet i j)` 承载；“内部公共边正则化”是 private
replacement choice，使用 `Path.exists_piecewiseC1_range_subset_open_and_homotopyWithin` 在相邻开集交
内选择道路；“反向边”使用 `Path.symm` 与 `pathIntegral_symm`；“所有小格求和”用两个 `Finset.sum`；
“只剩外边界”对应公开等式的四组 raw edge integrals。

# 证明思路

外边已有 PiecewiseC1 证书，故 replacement definitionally 取原道路。内部横边取上下相邻 cellSet 的
交，内部竖边取左右相邻交；raw edge 的两侧 incidence 保证它落在交中，开集内正则替换定理给出共同
PiecewiseC1 道路。对每格，`Complex.IsExactOn` 选择 primitive，经 C 的 admissibility bridge 将四条边
积分写成端点差，`abel` 得零。最后二维 `Fin` 求和分别沿行列 telescope，内部边严格成对消去，再把
四侧 replacement 改写回 raw outer edges。

# 正式承载与依赖

`Complex.IsExactOn` 是 Mathlib 对“在集合上存在导数为 `f` 的 primitive”的语义一致正式承载；本条目
显式 import `Mathlib.Analysis.Complex.HasPrimitives`，不再从旧 C2 最终包偶然获得。`Path`、反向、开集
和有限和同样直接复用 Mathlib；raw grid 与 PiecewiseC1 来自已解释的本库条目。replacement predicates、
解析 grid carrier、primitive choice 和 telescope lemmas 全部 private，没有新增 instance 或 notation。

# 应用与陷阱

R3b-F 将把同伦方形、indexed subdivision 与外边 dyadic 正则性组装成 raw grid，再用本定理产生 C 所需
的外边界标量等式。这里没有证明 replacement 与 raw 内边的积分相等，也不需要：内部 raw 边从未进入
最终积分和；共享 replacement 才是两格共同使用的边。Ahlfors 的局部原函数版 Cauchy 证明是教材
来源；精确 `Fin` telescope 与 choice 隔离是 Lean 实现分层。
