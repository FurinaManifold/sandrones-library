---
id: number-theory.elementary.continued-fraction-convergent
family: number-theory.elementary
variant: textbook
kind: definition
state: verified
title: 实数连分数的有理收敛子
summary: 用递归的有理数序列表示实数简单连分数的逐级截断
premises: []
mathlib: [Real.convergent, Real.convergent_zero]
provenance:
  source_type: book
  ref: "Ireland--Rosen, A Classical Introduction to Modern Number Theory, continued fractions"
---

# 动机与直觉

简单连分数把实数逐次写成“整数部分加上一个倒数”。在第 `n` 层停止，就得到一个有理数，
称为第 `n` 个收敛子。收敛子是把无限展开变成可计算有理近似的基本对象。

# Lean 接口

```lean
noncomputable def continuedFractionConvergent (ξ : ℝ) (n : ℕ) : ℚ

theorem continuedFractionConvergent_zero (ξ : ℝ) :
    continuedFractionConvergent ξ 0 = (⌊ξ⌋ : ℤ)
```

`noncomputable` 来自实数取整及其实数表示，不改变数学陈述。公开接口返回 `ℚ`，因此读者不必
接触 Mathlib 的广义连分数结构。

# 边界

本条只定义收敛子并给出第零项；收敛性、最佳逼近性质不是定义的一部分。Mathlib 的
`Real.convergent` 是本条的实现地基。
