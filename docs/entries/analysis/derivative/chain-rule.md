---
id: analysis.derivative.chain-rule
family: analysis.derivative
variant: ecnu
kind: theorem
state: verified
title: 链式法则
summary: deriv (g∘f) x = deriv g (f x)·deriv f x
premises: []
mathlib: ["deriv_comp"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第三章 导数"
---

# analysis.derivative.chain-rule

- **家族**: `analysis.derivative`
- **变体**: ecnu
- **状态**: verified
- **一句话**: deriv (g∘f) x = deriv g (f x)·deriv f x

## 直觉

复合函数导数=内层导数×外层在内点导数。

## 陈述（Lean 对照）

deriv (g∘f) x = deriv g (f x) * deriv f x

## 依赖（人话版）

mathlib: deriv_comp

## 应用与陷阱

微积分最核心法则。
