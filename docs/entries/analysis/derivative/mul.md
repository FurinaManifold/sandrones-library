---
id: analysis.derivative.mul
family: analysis.derivative
variant: ecnu
kind: theorem
state: verified
title: 积的导数（Leibniz）
summary: (fg)'=f'g+fg'
premises: []
mathlib: ["deriv_mul"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第三章 导数"
---

# analysis.derivative.mul

- **家族**: `analysis.derivative`
- **变体**: ecnu
- **状态**: verified
- **一句话**: (fg)'=f'g+fg'

## 直觉

(fg)'=f'g+fg'：先乘后导的展开。

## 陈述（Lean 对照）

deriv (f*g) x = deriv f x * g x + f x * deriv g x

## 依赖（人话版）

mathlib: deriv_mul

## 应用与陷阱

Leibniz 法则。
