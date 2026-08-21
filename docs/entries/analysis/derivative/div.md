---
id: analysis.derivative.div
family: analysis.derivative
variant: ecnu
kind: theorem
state: verified
title: 商导数
summary: (f/g)'=(f'g-fg')/g²（g≠0）
premises: []
mathlib: ["deriv_div"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第三章 导数"
---

# analysis.derivative.div

- **家族**: `analysis.derivative`
- **变体**: ecnu
- **状态**: verified
- **一句话**: (f/g)'=(f'g-fg')/g²（g≠0）

## 直觉

(f/g)'=(f'g-fg')/g²，分母非零。

## 陈述（Lean 对照）

deriv (f/g) x = (deriv f x * g x - f x * deriv g x)/g x^2

## 依赖（人话版）

mathlib: deriv_div

## 应用与陷阱


