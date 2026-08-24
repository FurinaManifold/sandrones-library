---
id: number-theory.elementary.pell-equation
family: number-theory.elementary
variant: positive
kind: definition
state: verified
title: Pell 方程的整数解
summary: 用整数坐标记录正 Pell 方程 x²-dy²=1 的解
premises: []
mathlib: []
provenance:
  source_type: book
  ref: "Ireland--Rosen, A Classical Introduction to Modern Number Theory, Section 17.5"
---

# 定义

```lean
structure PellSolution (d : ℤ) where
  x : ℤ
  y : ℤ
  equation : x ^ 2 - d * y ^ 2 = 1
```

公开接口就是教材中的整数二元组及其方程证明，没有暴露二次整数环、范数一元素或群结构。
`(1,0)` 对每个 `d` 都给出平凡解。

# 边界

这里只研究正 Pell 方程右端 `1`。右端 `-1` 的负 Pell 方程并不总有解，Mathlib 的 Pell 文件也
把它列为后续扩展，因此本条不作相关存在性声称。
