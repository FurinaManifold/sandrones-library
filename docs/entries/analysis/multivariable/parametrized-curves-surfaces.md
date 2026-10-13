---
id: analysis.multivariable.parametrized-curves-surfaces
title: "参数曲线与参数曲面"
status: in-progress
premises: ["analysis.multivariable.rectangle-integral"]
mathlib: ["HasDerivAt.smul_const", "intervalIntegral.integral_const", "HasDerivAt.scomp",
  "intervalIntegral.integral_comp_mul_deriv_of_deriv_nonneg", "Fintype.linearIndependent_iff",
  "Submodule.mem_span_pair"]
---

# 参数曲线与参数曲面

`ParametrizedGeometry.lean` 建立经典微分几何与曲线曲面积分共用的前置。
`ParametrizedCurve n` 与 `ParametrizedSurface n` 是透明函数数据载体，分别展开为
`ℝ → ℝⁿ` 与 `ℝ² → ℝⁿ`；它们只记录参数域和值域，不自行声称连续、可微或正则。
这些教材性质由 `CurveRegularAt`、`CurveRegularOn`、`SurfaceRegularAt` 和
`SurfaceRegularOn` 明确表达，因此无需另建一套函数结构。

参数曲线已有速度、速率、点态/集合正则性和有向弧长；仿射直线的速度、
速率、正则判据与弧长公式已完成。

二参数曲面已有两个坐标切向量和“微分作为 `ℝ² → ℝⁿ` 单射”的正则性定义，
并完成仿射平面的显式微分公式：两个坐标切向量恰为生成方向 `u,v`，其
正则性等价于 `u,v` 线性无关。参数化的像也已识别为 `p + span{u,v}`，
从而证明仿射平面只依赖方向张成的子空间，不依赖具体生成方向的选择。
曲线部分还完成了换参数后的速度链式法则、速率绝对值公式，以及保向可微
换参数下的弧长不变性（包括固定端点的教材形式）。

三维曲面的面积元现定义为 `‖σᵤ × σᵥ‖`，参数域上的曲面面积定义为该面积元的
Lebesgue 二重积分。仿射平面的面积元已化为常数 `‖u×v‖`；其正则性等价于面积元
非零；闭参数矩形上的面积为 `(b-a)(d-c)‖u×v‖`。下一步证明一般可微双射换参数下
面积元的 Jacobian 变换公式及曲面面积不变性。

参数交换这一基本反向换参数已经完成：两条坐标切向量互换，叉积改变符号而面积元
保持不变；对乘积参数域 `s×t`，交换后的 `t×s` 给出完全相同的曲面面积。这是一般
换参数定理的第一个非平凡特例，也明确展示了第一型面积不依赖曲面方向。

一般点态换参数公式也已完成。对二维可微参数变换 `φ`，两条新切向量由链式法则写成
原切向量的线性组合；其叉积恰好乘以 `det Dφ`，所以面积元满足
`J(σ∘φ)=|det Dφ|·(Jσ)∘φ`。抽象行列式与标准基坐标行列式的桥也已证明。

积分级一般换参数定理现已完成：若 `s` 可测、`φ` 全局可微并在 `s` 上单射，则
`surfaceAreaOn3 (σ∘φ) s = surfaceAreaOn3 σ (φ '' s)`。证明直接调用一般 Jacobian
换元公式吸收面积元中的 `|det Dφ|`。至此参数曲线与参数曲面的本阶段前置完成。

边界：`curveVelocity`、`surfaceTangent₁`、`surfaceTangent₂` 的底层选择函数在不可微点沿用
Mathlib 的零值约定；任何几何结论都必须携带相应可微或正则性假设，不能仅从参数化载体推出。
