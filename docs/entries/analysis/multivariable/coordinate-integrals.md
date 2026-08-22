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
标准参数域 `ρ>0, -π<θ<π, 0<φ<π` 的可测性、开性和球坐标映射的单射性
已证明，并由一般换元定理得到该参数域像上的球坐标积分公式。通过两次调用
二维极坐标局部同胚，已证明标准域的像遍历所有 `y ≠ 0` 的点；其补集因而包含于
`y=0` 超平面并为零测集。这已给出全空间球坐标公式。下一步用 Fubini 将其展开为
`ρ、θ、φ` 的三重累次积分。该 Fubini 展开现已完成：只假设整个带权拉回函数
可积，几乎处处的截面可积性由 Fubini 自动提供，无需对每个半径另加假设。

球坐标理论接口因而完成。本条目剩余任务是教材例题：先由径向积分计算球体体积，
再计算均匀球体的质量、重心和绕坐标轴的转动惯量。
