---
id: number-theory.elementary.pell-positive-existence
family: number-theory.elementary
variant: positive-nonsquare
kind: theorem
state: verified
title: 正非平方参数的 Pell 非平凡解存在
summary: d>0 且 d 不是平方时，存在 x>1、y>0 满足 x²-dy²=1
premises: [number-theory.elementary.pell-equation]
mathlib: [Pell.Solution₁.exists_pos_of_not_isSquare, Pell.Solution₁.prop]
provenance:
  source_type: book
  ref: "Ireland--Rosen, A Classical Introduction to Modern Number Theory, Section 17.5"
---

# 陈述

对正整数参数 `d`，若不存在整数 `z` 使 `d=z²`，则正 Pell 方程存在 `x>1`、`y>0` 的解。
严格正性排除了 `(1,0)` 这个平凡解。

# 实现边界

Mathlib 在 `Pell.Solution₁` 中以二次整数环的范数一元素证明存在性。本条只在证明内部取出其
`x`、`y` 坐标和方程证书，再包装成本库的 `PellSolution`；高层代数表示没有泄漏到教材签名。

该存在性证明没有建立解与 `√d` 连分数周期的对应。Mathlib 原文件明确把这个连接列为 TODO。
