---
id: analysis.multivariable.normal-domain
kind: theorem
state: verified
title: "x/y 型正常区域的变限累次积分"
premises: ["analysis.multivariable.jordan-region", "analysis.multivariable.jordan-riemann-bridge", "analysis.multivariable.riemann-box", "real-analysis.riemann.eq-lebesgue"]
mathlib: ["MeasureTheory.integral_prod", "MeasureTheory.integral_indicator", "MeasureTheory.volume_preserving_finTwoArrow"]
provenance:
  source_type: book
  ref: spivak-calculus-manifolds-1965
---

# 区域

`xNormalDomain a b lower upper` 表示

`{(x,y) | a ≤ x ≤ b, lower x ≤ y ≤ upper x}`。

上下边界连续时该区域可测。

# 累次积分公式

若 `f` 在该区域上可积，则

`∫∫_D f(x,y) dxdy = ∫_[a,b] (∫_[lower x, upper x] f(x,y) dy) dx`。

证明先把区域示性函数按竖直截面分解，再应用乘积测度上的 Fubini 定理。该陈述不要求
区域之外的函数值，也不引入任意奇异可测区域，是教材计算使用的正常区域接口。

# Riemann 计算链

核心定理
`riemannBoxIntegral_xNormalDomain_eq_integral_riemann_of_aeContinuous`
不要求区域 Jordan 可测，也不要求上下边界连续。上下边界可测即可建立区域可测性；
Riemann 可积性所需条件直接施加于真正参与盒积分的零延拓函数：它在外包盒上有界且
几乎处处连续。证明把各层桥梁显式组装起来：

1. 一般零可测区域上，有界且几乎处处连续的零延拓之多元 Riemann 积分等于区域
   Lebesgue 积分；
2. 保体积等价 `Fin 2 → ℝ ≃ ℝ × ℝ` 将盒积分坐标改成 Fubini 的积坐标；
3. Fubini 把二重 Lebesgue 积分降成竖直截面的累次积分；
4. `riemannIntegral_eq_interval` 把每条截面的 Lebesgue 积分转回本库的一维
   `riemannIntegral`。

若截面 Riemann 积分作为 `x` 的函数在 `[a,b]` 上连续，
`riemannBoxIntegral_xNormalDomain_eq_iteratedRiemann` 再对外层使用同一座一维桥，得到
完整的二次 Riemann 积分。这正是教材中“先降维，再用一元积分计算”的依赖方向。

原来的 Jordan 条件现在只出现在方便调用的推论
`riemannBoxIntegral_xNormalDomain_eq_integral_riemann` 中：边界零测自动提供零延拓的
几乎处处连续性。它不再限制核心计算接口可以处理的区域。

# y 型区域

`yNormalDomain c d left right` 表示
`{(x,y) | c ≤ y ≤ d, left y ≤ x ≤ right y}`。可测左右边界已经足以建立区域可测性；
`integral_yNormalDomain_eq_iterated_of_measurable` 使用反向 Fubini，先对 `x` 积分。
对应的 Riemann 降维桥同样不要求区域 Jordan 可测。

`x`/`y` 两套接口共同支持交换积分次序和区域重写。下一项进入多重积分换元公式。
