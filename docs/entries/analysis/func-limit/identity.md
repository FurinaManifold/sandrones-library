---
id: analysis.func-limit.identity
family: analysis.func-limit
variant: ecnu
kind: lemma
state: verified
title: 恒等函数连续
summary: x↦x 在 a 处趋近 a（id 的连续/恒等极限）
premises: []
mathlib: ["tendsto_id"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第一章 函数极限"
---

# analysis.func-limit.identity

- **家族**: `analysis.func-limit`
- **变体**: ecnu
- **状态**: verified
- **一句话**: x↦x 在 a 处趋近 a（id 的连续/恒等极限）

## 直觉

x 去哪儿，x 就带到哪儿——自己总跟着自己。

## 陈述（Lean 对照）

`Tendsto id (𝓝 a) (𝓝 a)`

## 依赖（人话版）

mathlib: tendsto_id

## 应用与陷阱

连续性的第一个例子。
