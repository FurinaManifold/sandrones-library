---
id: analysis.derivative.const
family: analysis.derivative
variant: ecnu
kind: theorem
state: verified
title: 常数/线性函数导数
summary: 常数导数 0，恒等导数 1，线性函数 a·x+b 导数 a
premises: []
mathlib: ["deriv_const", "deriv_id", "deriv_add_const"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第三章 导数"
---

# analysis.derivative.const

- **家族**: `analysis.derivative`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 常数导数 0，恒等导数 1，线性函数 a·x+b 导数 a

## 直觉

常数导数 0，恒等导数 1，线性函数 a·x+b 导数 a。

## 陈述（Lean 对照）

deriv (fun _=>c) x=0；deriv id x=1；deriv (a·x+b)=a

## 依赖（人话版）

mathlib: deriv_const, deriv_id, deriv_add_const

## 应用与陷阱


