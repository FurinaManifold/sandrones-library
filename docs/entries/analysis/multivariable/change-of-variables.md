---
id: analysis.multivariable.change-variables
kind: theorem
state: verified
title: "多重积分换元与 Jacobian 公式"
premises: ["analysis.multivariable.x-normal-domain", "analysis.multivariable.frechet"]
mathlib: ["MeasureTheory.integral_image_eq_integral_abs_det_fderiv_smul", "MeasureTheory.integrableOn_image_iff_integrableOn_abs_det_fderiv_smul"]
provenance:
  source_type: book
  ref: "数学分析：多重积分换元公式"
---

# 定理

设 `s ⊆ ℝⁿ` 可测，`φ : ℝⁿ → ℝⁿ` 在 `s` 上可微且单射，则

`∫_{φ(s)} g(y) dy = ∫_s g(φ(x)) |det Dφ(x)| dx`。

库中用 `absJacobianWithin φ s x` 表示区域内导数行列式的绝对值，并同时提供：

- `integral_image_eq_integral_absJacobian_mul`：积分换元；
- `integrableOn_image_iff_integrableOn_absJacobian_mul`：两侧可积性等价；
- `volume_image_eq_lintegral_absJacobian`：像区域的 Jacobian 体积公式。

# 设计说明

核心接口只要求可测、区域上可微和区域上单射，不额外要求开区域或全局微分同胚。
这比教材常见假设更弱，同时可直接用于后续极坐标、柱坐标和球坐标计算。使用
`fderivWithin` 可以自然处理区域边界。
