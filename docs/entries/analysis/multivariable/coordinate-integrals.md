---
id: analysis.multivariable.coordinate-integrals
kind: theorem
state: verified
title: "坐标积分：极坐标与柱坐标"
premises: ["analysis.multivariable.change-variables", "real-analysis.measure.fubini"]
mathlib: ["integral_comp_polarCoord_symm", "hasFDerivAt_polarCoord_symm", "det_fderivPolarCoordSymm"]
provenance:
  source_type: book
  ref: "数学分析：二重积分的极坐标换元"
---

# 当前结果

`polarMap (r,θ) = (r cos θ,r sin θ)`，其 Jacobian 行列式为 `r`。由此得到

`∫_{ℝ²} f = ∫_{r>0,-π<θ<π} r f(r cos θ,r sin θ)`，

以及在拉回函数可积时的 Fubini 累次积分形式。负实轴和原点为零测集，因此角度区间
`(-π,π)` 已足以计算全平面积分。

# 后续

柱坐标被实现为“二维极坐标 × 恒等坐标”，得到全空间三重累次积分公式，权重仍为
半径 `r`。这一证明复用了极坐标和 Fubini，没有重复建立三维 Jacobian 理论。

本条目仍在扩充：下一批加入球坐标及其 Jacobian，然后加入质量、重心和
转动惯量例题。ROADMAP 总项在这些内容完成前保持进行中。

球坐标固定采用 `(ρ,θ,φ)` 顺序，并定义
`sphericalMap = (ρ sinφ cosθ, ρ sinφ sinθ, ρ cosφ)`。其 Fréchet 导数矩阵
及行列式 `-ρ² sinφ` 已完成；在标准区域上的换元权重因而是 `ρ² sinφ`。
下一步利用一般换元定理组装全空间球坐标积分公式。
