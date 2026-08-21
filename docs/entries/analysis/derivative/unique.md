---
id: analysis.derivative.unique
family: analysis.derivative
variant: ecnu
kind: theorem
state: verified
title: 导数唯一
summary: 同函数同点两个导数必相等
premises: []
mathlib: ["HasDerivAt.unique"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第三章 导数"
---

# analysis.derivative.unique

- **家族**: `analysis.derivative`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 同函数同点两个导数必相等

## 直觉

同一函数同一点的导数只有一个。

## 陈述（Lean 对照）

HasDerivAt f a x → HasDerivAt f b x → a=b

## 依赖（人话版）

mathlib: HasDerivAt.unique

## 应用与陷阱


