---
id: complex-analysis.cauchy.triangle-ball
family: complex-analysis.cauchy
variant: ball
kind: theorem
state: verified
title: 球内三角形边界积分为零
summary: 由圆盘上全纯函数的原函数存在性推出三条有向边上的路径积分之和为零
premises: [complex-analysis.holomorphic.definition, complex-analysis.integral.path]
mathlib: [DifferentiableOn.isExactOn_ball, intervalIntegral.integral_eq_sub_of_hasDerivAt, curveIntegral_segment, convex_ball]
provenance:
  source_type: book
  ref: "Ahlfors, Complex Analysis, Cauchy's theorem for a triangle; formalized here in the currently supported ball-with-primitive form"
---

# 动机

经典 Cauchy–Goursat 定理说明，全纯函数沿三角形边界的积分为零。当前 Mathlib 尚未提供这一经典局部三角形定理本身，但已经证明全纯函数在圆盘上有原函数。因此这个 foundation 条目只给出后端能够完整支撑的圆盘版本；一般 Goursat 条目继续保持未完成。

# 直觉

若 `g' = f`，则每条有向边上的积分等于 `g` 在终点与起点的差。三条边按 `a → b → c → a` 相加后望远镜消去。圆盘的凸性保证只要三个顶点在圆盘内，三条线段也全部留在圆盘内。

# 陈述（自然语言）

若 `f` 在圆盘 `ball center r` 上全纯，且 `a,b,c` 都属于该圆盘，则 `f` 沿三条有向线段 `a→b`、`b→c`、`c→a` 的路径积分之和为零。

更基础的版本不要求圆盘或全纯性：只要某个集合包含三条边，`f` 在该集合上连续，并存在 `g` 满足集合内处处 `g' = f`，同一结论成立。

# 陈述（Lean 对照）

```lean
theorem pathIntegral_triangle_eq_zero_of_holomorphicOnTextbook_ball
    (hf : HolomorphicOnTextbook f (ball center r))
    (ha : a ∈ ball center r) (hb : b ∈ ball center r) (hc : c ∈ ball center r) :
    pathIntegral f (.segment a b) + pathIntegral f (.segment b c) +
      pathIntegral f (.segment c a) = 0
```

原函数版本是 `pathIntegral_triangle_eq_zero_of_primitive`，单边端点公式是 `pathIntegral_segment_eq_sub_of_primitive`。

# 思维脉络（thinking trace）

先用 `pathIntegral_segment` 把复路径积分化为 `[0,1]` 上的区间积分。链式法则给出 `t ↦ g (lineMap a b t)` 的实导数是 `(b-a) * f (lineMap a b t)`；微积分基本定理得到单边公式。三边公式随后只需代入并做加法交换群消去。最后通过 `holomorphicOnTextbook_iff_differentiableOn` 进入 Mathlib 接口，再用 `DifferentiableOn.isExactOn_ball` 取得原函数。

# 自然语言 ↔ Lean 映射

“沿 `a→b` 的线段”对应 `Path.segment a b`；“线段留在定义域”对应 `[a -[ℝ] b] ⊆ U`；“`g` 是 `f` 的原函数”对应 `∀ z ∈ U, HasDerivAt g (f z) z`；“三角形边界”在此明确表示三个有向积分的和，而不是一个未经说明的几何边界对象。

# 依赖（人话版）

本条目依赖 `Holomorphic.lean` 的教材全纯定义及开放集桥接、`PathIntegral.lean` 的标量路径积分与线段公式、Mathlib 的区间积分微积分基本定理、`Complex.HasPrimitives` 中的 `DifferentiableOn.isExactOn_ball`，以及圆盘的实凸性。

# 应用与陷阱

该结果足以处理完全位于同一圆盘中的三角形及其退化情形。它不是经典 Cauchy–Goursat 三角形定理的完整形式：经典形式通常只要求在包含三角形的适当邻域全纯，不要求整个圆盘上存在原函数。也不能把本定理改名为“一般单连通域版”；Mathlib 的 `HasPrimitives.lean` 明确把这一推广列为 TODO。
