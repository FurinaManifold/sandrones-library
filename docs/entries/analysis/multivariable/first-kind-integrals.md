---
id: analysis.multivariable.first-kind-integrals
kind: theorem
state: verified
title: "第一型曲线积分与曲面积分"
premises: []
mathlib: ["intervalIntegral.integral_comp_mul_deriv_of_deriv_nonneg", "MeasureTheory.integral_image_eq_integral_abs_det_fderiv_smul"]
provenance:
  source_type: book
  ref: "数学分析 II：第一型曲线积分与第一型曲面积分"
---

# 当前结果

第一型曲线积分定义为 `∫ f(γ(t))‖γ'(t)‖dt`，第一型曲面积分定义为
`∫∫ f(σ(u,v))‖σᵤ×σᵥ‖du dv`。常密度分别退化为常数乘弧长与常数乘曲面面积。

曲线积分已证明在导数非负的保向可微换参数下不变。曲面积分已证明一般换参数定理：
若参数域可测，参数变换全局可微且在该区域上单射，则复合参数化在原域上的积分等于
原参数化在像域上的积分。证明复用曲面面积元的 Jacobian 变换公式和一般积分换元定理。

# Lean 对照

- `curveIntegralFirstKind`：第一型曲线积分；
- `surfaceIntegralFirstKind3`：三维第一型曲面积分；
- `curveIntegralFirstKind_const`、`surfaceIntegralFirstKind3_const`：常密度公式；
- `curveIntegralFirstKind_comp_of_deriv_nonneg`：曲线保向换参数；
- `surfaceIntegralFirstKind3_comp_reparam`：曲面一般换参数。
