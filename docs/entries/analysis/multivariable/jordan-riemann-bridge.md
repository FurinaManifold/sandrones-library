---
id: analysis.multivariable.jordan-riemann-bridge
kind: theorem
state: verified
title: "Jordan 区域 Riemann–Lebesgue 积分桥"
premises: ["analysis.multivariable.jordan-region", "analysis.multivariable.riemann-box"]
mathlib: ["AEContinuous.hasBoxIntegral", "integral_indicator₀"]
provenance:
  source_type: book
  ref: "数学分析：Jordan 可测区域上的多重 Riemann 积分"
---

# 教材构造

对 Jordan 可测区域 `D`，选择任意包含它的闭盒 `I`，把连续函数 `f` 在 `D` 外延拓
为零，然后在 `I` 上取多元 Riemann 积分。

# 核心结论

零延拓只可能在 `frontier D` 上不连续，而 Jordan 可测性保证该边界体积为零。零延拓
在闭盒上有界，因此 Riemann 可积，并且

`riemannBoxIntegral (D.indicator f) I = ∫ x in D, f x`。

右侧是区域上的 Lebesgue 积分。由于等式对每个包含 `D` 的盒都成立，教材定义与
外包盒的选择无关。

# Lean 对照

- 零延拓几乎处处连续：`jordan_indicator_ae_continuous`；
- 核心数值桥：`hasRiemannBoxIntegral_indicator_eq_setIntegral`；
- 外包盒存在：`exists_box_hasRiemannIntegral_jordan`；
- 外包盒无关性：`riemannIntegral_jordan_independent_of_box`。
