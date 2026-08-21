---
id: analysis.mvt.lagrange-deriv
family: analysis.mvt
variant: ecnu
kind: theorem
state: verified
title: Lagrange 中值定理（导函数版）
summary: 存在 c 使 f'(c)=(f b−f a)/(b−a)
premises: ["analysis.derivative.chain-rule"]
mathlib: ["exists_hasDerivAt_eq_slope"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第四章 微分中值定理"
---

# analysis.mvt.lagrange-deriv

- **家族**: `analysis.mvt`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 存在 c 使 f'(c)=(f b−f a)/(b−a)

## 直觉

若 f' 确实是 f 的导数（有 HasDerivAt），则 f'(c) 等于割线斜率。

## 陈述（Lean 对照）

exists_hasDerivAt_eq_slope f f' hab hfc hff'

## 依赖（人话版）

mathlib: exists_hasDerivAt_eq_slope

## 应用与陷阱


