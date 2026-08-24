---
id: number-theory.elementary.best-rational-approximation
family: number-theory.elementary
variant: denominator-bounded
kind: definition
state: verified
title: 最佳有理逼近
summary: 分母不超过给定有理数分母的所有候选都不能取得更小绝对误差
premises: []
mathlib: []
provenance:
  source_type: book
  ref: "Hardy--Wright, An Introduction to the Theory of Numbers, continued fractions"
---

# 定义

```lean
def IsBestRationalApproximation (ξ : ℝ) (q : ℚ) : Prop :=
  ∀ r : ℚ, r.den ≤ q.den →
    rationalApproximationError ξ q ≤ rationalApproximationError ξ r
```

这把教材中的“分母预算”直接写进定义：在不使用更大分母的前提下，没有有理数比 `q` 更接近
`ξ`。使用 `≤` 允许误差相同的并列最优者。

# 已验证基本事实

若 `ξ` 本身就是有理数 `q`，则误差为零，而绝对值误差总是非负，所以 `q` 是最佳逼近。

# Mathlib 边界

Mathlib 当前没有“每个简单连分数收敛子都是上述最佳逼近”的现成定理。本库因此先正式建立
教材定义，但不把 Legendre 判据冒充这一缺失方向。后续补齐收敛子的行列式恒等式与误差比较后，
才应增加该桥接定理。
