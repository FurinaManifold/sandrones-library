---
id: analysis.sequence.le
family: analysis.sequence
variant: ecnu
kind: theorem
state: verified
title: 极限保序
summary: aₙ≤bₙ 恒成立且 aₙ→x、bₙ→y，则 x≤y
premises: ["analysis.sequence.definition"]
mathlib: ["ge_of_tendsto"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第二章 §1-§3 数列极限"
---

# analysis.sequence.le

- **家族**: `analysis.sequence`
- **变体**: ecnu
- **状态**: verified
- **一句话**: aₙ≤bₙ 恒成立且 aₙ→x、bₙ→y，则 x≤y

## 直觉

逐项 aₙ≤bₙ 且都有极限，则极限也保序。

## 陈述（教材记号）

aₙ≤bₙ 恒成立且 aₙ→x、bₙ→y，则 x≤y

## 依赖（人话版）

前提：数列极限定义；mathlib: ge_of_tendsto

## 应用与陷阱

用 b−a 的极限与≥0 取极限。
