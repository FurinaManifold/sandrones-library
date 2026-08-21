---
id: analysis.sequence.add
family: analysis.sequence
variant: ecnu
kind: theorem
state: verified
title: 极限之和
summary: lim(aₙ+bₙ)=lim aₙ+lim bₙ
premises: ["analysis.sequence.definition"]
mathlib: ["Filter.Tendsto.add"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第二章 §1-§3 数列极限"
---

# analysis.sequence.add

- **家族**: `analysis.sequence`
- **变体**: ecnu
- **状态**: verified
- **一句话**: lim(aₙ+bₙ)=lim aₙ+lim bₙ

## 直觉

和的极限等于极限的和：序列逐项相加后求极限，等于各自极限相加。

## 陈述（教材记号）

lim(aₙ+bₙ)=lim aₙ+lim bₙ

## 依赖（人话版）

前提：数列极限定义；mathlib: Filter.Tendsto.add

## 应用与陷阱

教材第二章基本运算。
