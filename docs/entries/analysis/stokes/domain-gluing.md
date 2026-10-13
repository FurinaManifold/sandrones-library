---
id: analysis.stokes.domain-gluing
family: analysis.stokes
variant: textbook
kind: theorem
state: verified
title: "分段光滑区域的拼接与积分公式装配"
summary: "用整数关联数统一刻画分段光滑区域的公共边/面抵消，把各片局部 Green、Gauss、Stokes 公式装配为整体外边界定理。"
premises: [analysis.multivariable.green-gauss-stokes, analysis.multivariable.second-kind-integrals]
mathlib: ["MeasureTheory.integral_biUnion_finset", "MeasureTheory.IntegrableOn",
  "Finset.sum_subset", "Finset.erase_subset", "Finset.mem_erase", "Fin.sum_univ_two",
  "MeasurableSet.prod", "measurableSet_Iio", "measurableSet_Ici", "integrableOn_zero"]
provenance:
  source_type: book
  ref: "spivak-calculus-manifolds-1965"
---

# 动机

Green、Gauss、Stokes 公式先在被参数化的单块区域上成立。但教材里真正要处理的是圆盘、
球体、环面以及各种由若干块拼起来的区域：它们没有一张全局良好的参数化，只能分成有限
多个参数片，逐片使用局部公式。于是需要一层纯代数的“拼接”机制，把每片的边界积分相加
时公共边（二维）或公共面（三维）方向的相反性消掉，只留下整体外边界。本条目把这个
机制抽象成“分段光滑区域”，并给出四类装配定理。

# 直觉

把区域切成有限多片后，每一片的边界都包含“真正的外边界”和“与邻居共享的边”。同一条
公共边在相邻两片中的诱导方向恰好相反：左片沿它向上走，右片就沿它向下走。积分是带方向
的，所以两次贡献符号相反、逐条抵消。抵消之后，剩下的正是整体区域的外边界。用整数关联数
记录一条边在每个局部边界中的方向与重数：`+1` 表示正向走一次，`-1` 表示反向，`0` 表示
这条边不在该片边界上。公共边的 `+1` 与 `-1` 相消，于是“整体外边界关联数 = 各片局部
关联数之和”这一条整数等式就自动蕴含了公共边抵消。

# 陈述（自然语言）

设区域由有限个指标 `patches` 索引的参数片组成，每片 `i` 有参数域 `parameterDomain i`
与定义在其上的拉回密度 `pulledBackDensity i`。再给每条边标签 `e` 记两个整数：它在第
`i` 片局部边界中的关联数 `localIncidence i e`，以及它在整体外边界中的关联数
`externalIncidence e`。若：

1. 每片的参数域可测、两两不交，且该片密度在其参数域上可积；
2. 对每条边 `e`，整体外边界关联数等于各片局部关联数之和
   `externalIncidence e = ∑ i ∈ patches, localIncidence i e`；
3. 对每片 `i`，该片的有向边界值等于其参数域上密度的积分（局部 Stokes 公式）；

则整体外边界值等于所有参数片拉回密度积分之和。特别地，若整体外边界关联数全为零
（闭区域），则这个总积分为零。

二维平面情形可把参数域读作区域单元、密度读作旋度密度，Gauss 情形则把“片”读作三维
体元、“边”读作公共面。

# 陈述（Lean 对照）

核心载体是结构 `PiecewiseSmoothRegion`：

```
structure PiecewiseSmoothRegion {ι ε : Type*} (patches : Finset ι) (edges : Finset ε)
    (parameterDomain : ι → Set (ℝ × ℝ)) (pulledBackDensity : ι → ℝ × ℝ → ℝ)
    (localIncidence : ι → ε → ℤ) (externalIncidence : ε → ℤ) : Prop where
  measurable : ∀ i ∈ patches, MeasurableSet (parameterDomain i)
  pairwiseDisjoint : Set.Pairwise (↑patches) (Function.onFun Disjoint parameterDomain)
  integrable : ∀ i ∈ patches,
    IntegrableOn (pulledBackDensity i) (parameterDomain i) (volume.prod volume)
  gluing : ∀ e ∈ edges, externalIncidence e = ∑ i ∈ patches, localIncidence i e
```

对应的装配定理：

- `stokes_piecewiseSmoothRegion`：由结构成立与逐片局部公式 `hlocal`，得到
  `orientedBoundaryValue edges externalIncidence edgeIntegral =
   finiteAtlasSurfaceIntegral patches parameterDomain pulledBackDensity`。
- `stokes_closed_piecewiseSmoothRegion`：再加 `∀ e ∈ edges, externalIncidence e = 0`，
  得到 `finiteAtlasSurfaceIntegral ... = 0`。
- `green_piecewiseSmoothRegion`：各片共用旋度密度 `curlDensity` 时，经
  `PiecewiseSmoothRegion.toGreenFiniteDecomposition` 得到
  `GreenFiniteDecomposition`，交给 `green_finite_decomposition_of_edge_incidence`，
  结论为整体并区域上的旋度积分。
- `gauss_piecewiseSmoothRegion`：三维不可复用二维结构，直接接收
  `GaussFiniteDecomposition` 与逐面关联数，转调
  `gauss_finite_decomposition_of_face_incidence`。

两片共享边的显式结果：

- `twoPatch_sharedEdge_externalIncidence_zero`：共享边局部关联数相反时，外边界在该边
  的关联数为零。
- `twoPatch_sharedEdge_cancellation`：进一步证明从整体外边界值中删去这条共享边不改变
  结果（该边单项贡献为零）。
- `stokes_twoPatch_sharedEdge`：两片共享边、局部关联数相反时，整体外边界值等于两片
  参数域积分之和，并且外边界在共享边上的关联数为零。
- `twoPatchRegion_example` / `twoPatchRegion_stokes_example`：用 `Finset` 索引的两片
  矩形参数域显式实例化结构并调用 `stokes_piecewiseSmoothRegion`，说明该接口是可用的、
  非空的。

# 定义与记号

- `orientedBoundaryValue edges incidence edgeIntegral`：按整数关联数 `incidence` 加权
  求和的有向边界值，`∑ e ∈ edges, incidence e • edgeIntegral e`。负系数表示反向遍历。
- `finiteAtlasSurfaceIntegral patches parameterDomain pulledBackDensity`：各片参数域上
  拉回密度积分之和，即多坐标图曲面上的总“内部积分”。
- `localIncidence i e` / `externalIncidence e`：第 `i` 片局部边界 / 整体外边界中边 `e`
  的方向重数。
- `gluing`：整体外边界关联数等于各片局部关联数之和的整数恒等式。
- `PiecewiseSmoothRegion.toGreenFiniteDecomposition`：当各片密度一致时，把分段光滑区域
  的测度数据桥接到 `GreenFiniteDecomposition`。

# 证明思路

证明分两层。分析层完全由假设 `hlocal` 承担：它声明每片的有向边界值等于该片参数域上的
拉回密度积分（这一层就是先把局部 Green / Gauss / Stokes 公式证好）。代数层负责拼接：

1. `gluing` 把整体关联数替换成逐片关联数之和；
2. `orientedBoundaryValue_sum` 把“关联数之和的边界值”拆成“边界值之和”，这正是有限
   线性性的体现；
3. 逐片代入 `hlocal`，再用 `finiteAtlasSurfaceIntegral` 的定义合并为总积分。

闭区域推论则观察到 `externalIncidence ≡ 0` 时整体边界值为零。两片共享边的抵消是这套
机制的显式特例：由 `gluing` 与 `Fin.sum_univ_two` 得到共享边外关联数为两片局部关联数
之和，而两者相反应为零；再由 `Finset.sum_subset` 说明该项为零后从求和中删去该边不改变
边界值。

# 依赖与边界

本条目依赖 `analysis.multivariable.green-gauss-stokes` 提供的
`GreenFiniteDecomposition`、`orientedBoundaryValue` 系列、`finiteAtlasSurfaceIntegral`
与三个装配定理，以及 `analysis.multivariable.second-kind-integrals` 的方向约定。

诚实边界：

- 这里的“分段光滑区域”是**接口层**：局部公式（每片的 Green / Gauss / Stokes）作为假设
  `hlocal` 输入，本模块不重新证明它们，也不构造真正的光滑图册或剖分。
- 参数域固定在 `ℝ × ℝ` 上；三维 Gauss 情形另行接收 `GaussFiniteDecomposition`，没有
  把维度抽象成统一结构。
- 公共边（面）的识别依赖使用者给出的整数关联数标签；本模块只验证代数抵消，不判断几何
  上两条边是否真的是同一条。
- 一般光滑流形上的 Stokes 定理、图册细化、单位分解以及坐标无关的曲面积分结构**不在**
  本条目覆盖范围内；`stokes_finite_atlas_of_edge_incidence` 已把单矩形片推广到有限图册，
  但流形层仍需另行处理。
- Registry 中的 `premises`、`mathlib` 与本文档保持一致；本文件只描述上述已形式化的范围，
  不主张更强结论。
