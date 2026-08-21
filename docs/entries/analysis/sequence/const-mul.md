---
id: analysis.sequence.const-mul
family: analysis.sequence
variant: ecnu
kind: theorem
state: verified
title: 极限的常数数乘
summary: lim(c·aₙ)=c·lim aₙ
premises: ["analysis.sequence.definition"]
mathlib: ["Filter.Tendsto.const_mul"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第二章 §1-§3 数列极限"
---

# analysis.sequence.const-mul

- **家族**: `analysis.sequence`
- **变体**: ecnu
- **状态**: verified
- **一句话**: lim(c·aₙ)=c·lim aₙ

## 直觉

常数乘进极限。

## 陈述（教材记号）

lim(c·aₙ)=c·lim aₙ

## 依赖（人话版）

前提：数列极限定义；mathlib: Filter.Tendsto.const_mul

## 应用与陷阱


