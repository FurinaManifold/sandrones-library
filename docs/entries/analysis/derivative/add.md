---
id: analysis.derivative.add
family: analysis.derivative
variant: ecnu
kind: theorem
state: verified
title: 和/差导数
summary: deriv (f±g)=deriv f±deriv g
premises: []
mathlib: ["deriv_add"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第三章 导数"
---

# analysis.derivative.add

- **家族**: `analysis.derivative`
- **变体**: ecnu
- **状态**: verified
- **一句话**: deriv (f±g)=deriv f±deriv g

## 直觉

和的导数等于导数的和。

## 陈述（Lean 对照）

deriv (f+g) x = deriv f x + deriv g x

## 依赖（人话版）

mathlib: deriv_add

## 应用与陷阱


