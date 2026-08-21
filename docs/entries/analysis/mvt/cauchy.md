---
id: analysis.mvt.cauchy
family: analysis.mvt
variant: ecnu
kind: theorem
state: verified
title: 柯西中值定理
summary: 两函数闭区间连续、开区间可导，存在 c 使 (g b−g a)·f'(c)=(f b−f a)·g'(c)
premises: [analysis.mvt.lagrange]
mathlib: [exists_ratio_deriv_eq_ratio_slope]
provenance:
  source_type: book
  ref: 华东师大《数学分析》第五版 第三卷 第四章 微分中值定理
---

# analysis.mvt.cauchy

- **家族**: `analysis.mvt`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 两函数导数比值与增量比值成比例，是 L'Hôpital 法则的基础。

## 直觉

把 Lagrange 中值定理用到两个函数的组合 h(x)=(g b−g a)·f x − (f b−f a)·g x 上，
h 在端点相等（Rolle），得 h'(c)=0，展开即 Cauchy 中值定理。

## 陈述（Lean 对照）

`∃ c ∈ Set.Ioo a b, (g b - g a) * deriv f c = (f b - f a) * deriv g c`

## 依赖（人话版）

premises: analysis.mvt.lagrange；mathlib: exists_ratio_deriv_eq_ratio_slope

## 应用与陷阱

柯西中值定理是 L'Hôpital 法则与多数值中值推论的来源。注意参数序：
`exists_ratio_deriv_eq_ratio_slope f hab hfc hfd g hgc hgd`（f、g 显式且位置分离）。
