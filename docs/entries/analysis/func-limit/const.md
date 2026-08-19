---
id: analysis.func-limit.const
family: analysis.func-limit
variant: ecnu
kind: lemma
state: verified
title: 常数函数趋于常数
summary: 恒等于 c 的函数在任意滤波器下趋近 c
premises: []
mathlib: ["tendsto_const_nhds"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第一章 函数极限"
---

# analysis.func-limit.const

- **家族**: `analysis.func-limit`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 恒等于 c 的函数在任意滤波器下趋近 c

## 直觉

一个不动的值 c 无论自变量怎么跑，函数值永远停在 c，自然趋近 c。

## 陈述（Lean 对照）

`Tendsto (fun _ : ℝ => c) f (𝓝 c)`（任意滤波器 f）

## 依赖（人话版）

mathlib: tendsto_const_nhds

## 应用与陷阱

零负担引理，为后续四则运算打底。
