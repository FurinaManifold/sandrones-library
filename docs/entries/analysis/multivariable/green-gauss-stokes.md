---
id: analysis.multivariable.green-gauss-stokes
kind: theorem
state: verified
title: "Green、Gauss与Stokes公式"
premises: ["analysis.multivariable.second-kind-integrals"]
mathlib: ["MeasureTheory.integral2_divergence_prod_of_hasFDerivAt",
  "MeasureTheory.integral_divergence_of_hasFDerivAt_off_countable",
  "HasFDerivAt.neg", "intervalIntegral.integral_neg",
  "intervalIntegral.integral_add_adjacent_intervals",
  "intervalIntegral.integral_deriv_eq_sub",
  "MeasureTheory.integral_biUnion_finset", "Matrix.crossProduct"]
provenance:
  source_type: book
  ref: "spivak-calculus-manifolds-1965"
---

# 动机

Green、Gauss、Stokes 公式把区域内部的导数积分转化为有向边界积分，是多元微积分
基本定理的不同维数版本。本批从边界方向可以完全显式核对的矩形 Green 公式开始。

# 直觉

把平面向量场 `(P,Q)` 旋转成 `(Q,-P)`，其散度就是
`∂Q/∂x-∂P/∂y`；旋转场穿过外法向的通量，则等于原场沿逆时针切向的做功。

# 陈述（自然语言）

若 `P,Q` 在矩形上连续、内部可微，且旋度可积，则逆时针边界上的
`P dx+Q dy` 等于矩形内部 `∂Q/∂x-∂P/∂y` 的二重积分。

# 陈述（Lean 对照）

`rectangleBoundaryIntegral` 按下、右、上、左四条边定义边界积分；
`green_rectangle` 调用二维矩形散度定理，并对 `(Q,-P)` 展开四个边界项。
`divergence3`、`boxBoundaryFlux3` 和 `gauss_box3` 分别给出三维散度、六面外向通量及
三维盒上的 Gauss 公式。`surfacePullbackCoeff₁/₂` 把空间协向量场拉回参数曲面，
`stokes_parametrized_rectangle` 再调用 Green 公式得到矩形参数曲面上的 Stokes 公式。
`curlMatrix3_dot_cross` 把 Jacobian 的反对称部分化成
`curl F · (σᵤ × σᵥ)`，`stokes_parametrized_rectangle_curl` 给出教材常见的三维向量形式。
两个 `rectangleBoundaryIntegral_split_*` 定理证明矩形沿竖线或横线剖分后，内部公共边
因方向相反而抵消；它们是从矩形推广到有限矩形剖分区域的局部拼接组件。
`green_binormal_domain` 进一步覆盖同时可写成 `x` 型和 `y` 型的曲边正常域：对两个偏导
分别选取适合的截面方向，调用 Fubini 和一元 Newton–Leibniz 公式后得到完整边界项。
`GreenFiniteDecomposition` 与 `green_finite_decomposition` 再把有限个局部公式拼成整体：
区域积分由有限可加性合并，几何侧只需证明内部公共边的两个方向贡献抵消。
`orientedBoundaryValue` 用整数关联数编码边的方向和重数；
`green_finite_decomposition_of_edge_incidence` 将公共边抵消降为逐边核对 `+1 + (-1)=0`。
三维的 `GaussFiniteDecomposition` 与 `gauss_finite_decomposition_of_face_incidence`
以同样方式处理有限体元及公共面的外法向抵消；Stokes 侧的
`stokes_finite_patches_of_edge_incidence` 拼合同一参数化下的有限曲面片，
`stokes_finite_atlas_of_edge_incidence` 则允许每片使用独立参数域和拉回密度。
具体区域不放在理论模块中；顶层 `Examples/GreenRegions.lean` 收录三角形和圆盘的
横、竖正常域表示、Green 公式及数值计算。
顶层 `Examples/GaussStokes.lean` 另收录两个三维教材例题：单位立方体上位置向量场
`F(x)=x` 的总外向通量为 `3`，以及水平单位正方形上 1-形式 `x dy` 的边界环流为 `1`。
两者分别直接调用 `gauss_box3` 与 `stokes_parametrized_rectangle`，而非重复证明公式。

# 思维脉络（thinking trace）

先将 `P` 取负并交换两个分量，把 Green 公式化为散度公式；再用
`intervalIntegral.integral_neg` 把负号提出四条边积分，最后用交换群恒等式整理边界次序。

# 自然语言 ↔ Lean 映射

- 逆时针矩形边界积分：`rectangleBoundaryIntegral`
- 矩形 Green 公式：`green_rectangle`
- 三维散度：`divergence3`
- 六面外向通量：`boxBoundaryFlux3`
- 三维盒 Gauss 公式：`gauss_box3`
- 有限体元 Gauss 拼接：`GaussFiniteDecomposition`、`gauss_finite_decomposition`、
  `gauss_finite_decomposition_of_face_incidence`
- 曲面拉回系数：`surfacePullbackCoeff₁`、`surfacePullbackCoeff₂`
- 矩形参数曲面 Stokes 公式：`stokes_parametrized_rectangle`
- Jacobian 旋度向量：`curlMatrix3`
- 旋度—叉积坐标恒等式：`curlMatrix3_dot_cross`
- 经典三维向量形式：`stokes_parametrized_rectangle_curl`
- 同一参数化下有限曲面片 Stokes 拼接：`stokes_finite_patches_of_edge_incidence`
- 多坐标图曲面积分与 Stokes 拼接：`finiteAtlasSurfaceIntegral`、
  `stokes_finite_atlas_of_edge_incidence`
- 闭曲面上外微分积分为零：`stokes_closed_finite_atlas`
- 竖向/横向剖分的公共边抵消：`rectangleBoundaryIntegral_split_vertical`、
  `rectangleBoundaryIntegral_split_horizontal`
- 双正常曲边域边界积分：`normalDomainBoundaryIntegral`
- 双正常曲边域 Green 公式：`green_binormal_domain`
- 标准直角三角形及其 Green 公式：`standardRightTriangle`、
  `green_standardRightTriangle`
- 三角形面积型数值例：`standardRightTriangleBoundaryIntegral_zero_fst`
- 有限分片数据与整体拼接：`GreenFiniteDecomposition`、`green_finite_decomposition`
- 有向边关联数及自动抵消：`orientedBoundaryValue`、`orientedBoundaryValue_sum`、
  `green_finite_decomposition_of_edge_incidence`

# 依赖（人话版）

依赖第二型有向积分的方向约定、Fréchet 导数、矩形上的 Fubini 积分与 Mathlib 的
二维 Bochner 散度定理。

# 应用与陷阱

Green 结论覆盖矩形及双正常曲边域，Gauss 结论针对三维盒，Stokes 结论针对矩形参数曲面片。
扩展到任意分片 Jordan 区域仍需要边界分片、内部剖分及公共边/面抵消。四边方向必须固定
为与曲面参数方向相容的逆时针方向，六面法向必须取外向。
