---
id: number-theory.elementary.pell-fundamental-solution
family: number-theory.elementary
variant: least-positive
kind: theorem
state: verified
title: Pell 基本解存在
summary: 正非平方参数存在第一坐标最小的正非平凡 Pell 解
premises: [number-theory.elementary.pell-equation, number-theory.elementary.pell-positive-existence]
mathlib: [Pell.IsFundamental, Pell.IsFundamental.exists_of_not_isSquare, Pell.Solution₁.mk, Pell.Solution₁.prop, Pell.Solution₁.x_mk]
provenance:
  source_type: book
  ref: "Ireland--Rosen, A Classical Introduction to Modern Number Theory, Section 17.5"
---

# 定义与陈述

基本解 `a` 满足：

- `1 < a.x`；
- `0 < a.y`；
- 对每个 `1 < b.x` 的 Pell 解 `b`，都有 `a.x ≤ b.x`。

正非平方参数 `d` 总存在这样的基本解。最小性把“众多正解”固定到一个规范起点。

# 证明接口

Mathlib 的 `Pell.IsFundamental.exists_of_not_isSquare` 给出打包基本解。为验证它对本库所有
`PellSolution` 的最小性，证明把任意坐标解临时送入 `Pell.Solution₁.mk`，使用 Mathlib 的最小性，
再把结论拉回整数坐标。

# 准确边界

Mathlib 还证明全体打包解在符号意义下都是基本解的整数次幂。本条公开接口尚未给
`PellSolution` 建立完整交换群和整数幂，因此只转正“基本解存在与最小性”，不虚报全体解分类。
同样，本条没有证明基本解来自 `√d` 的连分数周期。
