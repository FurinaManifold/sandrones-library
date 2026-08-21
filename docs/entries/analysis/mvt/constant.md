---
id: analysis.mvt.constant
family: analysis
variant: ecnu
kind: theorem
state: verified
title: 导数恒为 0 ⟹ 函数为常数
summary: f 处处可导且 f'≡0，则 f 是常值函数（MVT 推论）
premises: ["analysis.mvt.lagrange"]
mathlib: ["exists_deriv_eq_slope", "div_eq_zero_iff"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版：中值定理推论"
---

# analysis.mvt.constant

- **家族**: `analysis`
- **变体**: ecnu
- **状态**: verified
- **一句话**: f 处处可导且 f'≡0，则 f 是常值函数（MVT 推论）

## 直觉

导数处处为 0 意味着函数没有任何变化，故是常值。中值定理的直接推论。

## 陈述（教材记号）

f 处处可导且 ∀x, f'(x)=0 ⟹ ∃c, ∀x, f x=c（此处 f x=f y 对任意 x,y）

## 依赖（人话版）

前提：Lagrange 中值定理；mathlib: exists_deriv_eq_slope

## 应用与陷阱

对任意 x,y 套 Lagrange 于 [x,y]。
