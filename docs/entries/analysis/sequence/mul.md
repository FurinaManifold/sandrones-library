---
id: analysis.sequence.mul
family: analysis.sequence
variant: ecnu
kind: theorem
state: verified
title: 极限之积
summary: lim(aₙbₙ)=lim aₙ·lim bₙ
premises: ["analysis.sequence.definition"]
mathlib: ["Filter.Tendsto.mul"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第二章 §1-§3 数列极限"
---

# analysis.sequence.mul

- **家族**: `analysis.sequence`
- **变体**: ecnu
- **状态**: verified
- **一句话**: lim(aₙbₙ)=lim aₙ·lim bₙ

## 直觉

积的极限等于极限的积。

## 陈述（教材记号）

lim(aₙbₙ)=lim aₙ·lim bₙ

## 依赖（人话版）

前提：数列极限定义；mathlib: Filter.Tendsto.mul

## 应用与陷阱


