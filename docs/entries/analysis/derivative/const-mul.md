---
id: analysis.derivative.const-mul
family: analysis.derivative
variant: ecnu
kind: theorem
state: verified
title: 常数数乘导数
summary: deriv (c·f)=c·deriv f
premises: []
mathlib: ["deriv_const_mul"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第三章 导数"
---

# analysis.derivative.const-mul

- **家族**: `analysis.derivative`
- **变体**: ecnu
- **状态**: verified
- **一句话**: deriv (c·f)=c·deriv f

## 直觉

常数乘进导数：deriv (c·f)=c·deriv f。

## 陈述（Lean 对照）

deriv (fun y=>c*f y) x = c * deriv f x

## 依赖（人话版）

mathlib: deriv_const_mul

## 应用与陷阱


