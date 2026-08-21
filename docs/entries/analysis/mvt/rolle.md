---
id: analysis.mvt.rolle
family: analysis.mvt
variant: ecnu
kind: theorem
state: verified
title: 罗尔定理
summary: 闭区间连续、开区间可导、端点值相等的函数在开区间内某点导数为 0
premises: ["analysis.derivative.chain-rule"]
mathlib: ["exists_deriv_eq_zero"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第四章 微分中值定理"
---

# analysis.mvt.rolle

- **家族**: `analysis.mvt`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 闭区间连续、开区间可导、端点值相等的函数在开区间内某点导数为 0

## 直觉

函数在两端等高，中间必有一处导数为 0——由最值定理与费马引理推出。

## 陈述（Lean 对照）

exists_deriv_eq_zero：∃ c ∈ Ioo a b, deriv f c = 0

## 依赖（人话版）

mathlib: exists_deriv_eq_zero

## 应用与陷阱

Rolle 是 Lagrange/Cauchy MVT 的基石。
