---
id: analysis.mvt.lagrange
family: analysis.mvt
variant: ecnu
kind: theorem
state: verified
title: 拉格朗日中值定理
summary: 闭区间连续、开区间可导，存在 c 使 f'(c)=割线斜率
premises: ["analysis.derivative.chain-rule"]
mathlib: ["exists_deriv_eq_slope"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第四章 微分中值定理"
---

# analysis.mvt.lagrange

- **家族**: `analysis.mvt`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 闭区间连续、开区间可导，存在 c 使 f'(c)=割线斜率

## 直觉

割线斜率在开区间内某点被切线斜率取到；把 Rolle 用到函数减去割线上。

## 陈述（Lean 对照）

exists_deriv_eq_slope：∃ c ∈ Ioo a b, deriv f c = (f b - f a)/(b-a)

## 依赖（人话版）

mathlib: exists_deriv_eq_slope

## 应用与陷阱

最常用的中值定理。
