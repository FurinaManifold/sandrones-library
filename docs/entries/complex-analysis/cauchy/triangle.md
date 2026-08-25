---
id: complex-analysis.cauchy.triangle
family: complex-analysis.cauchy
variant: local-triangle
kind: theorem
state: verified
title: 三角形上的 Cauchy--Goursat 定理
summary: 若函数在包含闭三角形的开集上全纯，则沿三条有向边的路径积分之和为零
premises: [complex-analysis.holomorphic.definition, complex-analysis.integral.path]
mathlib: [Convex.exists_forall_hasDerivWithinAt, intervalIntegral.integral_eq_sub_of_hasDerivAt_of_le, convex_convexHull, lineMap_mem_segment]
provenance:
  source_type: book
  ref: "ahlfors-complex-analysis-1979"
---

# 动机

三角形版本是局部 Cauchy 理论的核心接口。先前的 foundation 结果要求三个顶点位于同一圆盘，并直接使用圆盘原函数；这不足以表达“任意开集内的一个闭三角形”。本条去掉圆盘形状限制，为后续局部原函数、同伦不变和 Laurent 理论提供正确的课程入口。

# 直觉

把三个顶点的实凸包记为 `T`，它正是包含边界和内部的闭三角形。全纯函数限制到凸集 `T` 后存在一个只需在 `T` 内求导的相对原函数 `g`。沿每条边仍有积分端点公式；把 `a→b`、`b→c`、`c→a` 三式相加，三个原函数值望远镜消去。

# 陈述（自然语言）

设 `U` 是复平面中的开集，`f` 在 `U` 上按本库教材定义全纯。若顶点 `a,b,c` 的闭实凸包完全包含在 `U` 中，则 `f` 沿有向边 `a→b`、`b→c`、`c→a` 的三个路径积分之和等于零。三点共线或重合的退化情形也包含在内。

# 陈述（Lean 对照）

```lean
theorem pathIntegral_triangle_eq_zero_of_holomorphicOnTextbook
    (hU : IsOpen U) (hf : HolomorphicOnTextbook f U)
    (htriangle : convexHull ℝ ({a, b, c} : Set ℂ) ⊆ U) :
    pathIntegral f (.segment a b) + pathIntegral f (.segment b c) +
      pathIntegral f (.segment c a) = 0
```

辅助接口 `pathIntegral_segment_eq_sub_of_primitiveWithin_convex` 明确允许原函数只在闭凸集内具有相对导数。

# 思维脉络（thinking trace）

第一步通过开放集桥把 `HolomorphicOnTextbook f U` 转成 `DifferentiableOn ℂ f U`，再限制到三点凸包 `T`。第二步使用凸集上的 Poincare 接口构造 `g`，其结论是 `HasDerivWithinAt g (f z) T z`，因此没有假设边界点存在全邻域原函数。第三步把线段写成 `lineMap a b`：在参数区间内部，凸性保证附近参数仍映入 `T`，链式法则便给出复合函数的普通实导数。区间微积分基本定理推出单边端点公式，最后用交换加法群恒等式消去三项。

# 自然语言 ↔ Lean 映射

“闭三角形”对应 `convexHull ℝ ({a, b, c} : Set ℂ)`；“整个三角形位于开集内”对应 `htriangle`；“相对原函数”对应 `HasDerivWithinAt g (f z) T z`；“有向三角形边界”对应三个 `Path.segment` 的积分按 `a→b→c→a` 相加。`IsOpen U` 只用于把本库的全邻域全纯定义桥接到 `DifferentiableOn`，并未要求 `U` 是凸集或圆盘。

# 依赖（人话版）

本条依赖教材全纯定义和路径积分定义；几何上使用实凸包及凸集内线段封闭性；证明后端使用 Mathlib 在凸集上由复可微函数构造相对原函数的 Poincare 定理，以及区间积分的微积分基本定理。后端不直接提供本条三角形路径积分结论，边界端点公式和三边组装均在本模块中完成。

# 应用与陷阱

该定理适用于任意形状的开集，只要指定闭三角形没有越出该开集；它不要求整个开集单连通。它也不等于“一般闭曲线积分为零”：多边形、分段光滑闭曲线和同伦不变仍需进一步的分割或拓扑论证。不要把 `HasDerivWithinAt` 误读成全空间导数；恰恰是相对导数使闭三角形边界点的证明成立。
