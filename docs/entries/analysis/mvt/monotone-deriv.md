---
id: analysis.mvt.monotone-deriv
family: analysis.mvt
variant: ecnu
kind: theorem
state: verified
title: 导数符号判别单调
summary: f'≥0 ⟹ 单调不减；f'>0 ⟹ 严格递增（MVT 推论）
premises: ["analysis.derivative.chain-rule"]
mathlib: ["monotoneOn_of_deriv_nonneg", "strictMonoOn_of_deriv_pos"]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第三卷 第四章 微分中值定理"
---

# analysis.mvt.monotone-deriv

- **家族**: `analysis.mvt`
- **变体**: ecnu
- **状态**: verified
- **一句话**: f'≥0 ⟹ 单调不减；f'>0 ⟹ 严格递增（MVT 推论）

## 直觉

f'≥0 ⟹ f 单调不减；f'>0 ⟹ 严格递增。中值定理的直接推论。

## 陈述（Lean 对照）

monotoneOf_deriv_nonneg / strictMonoOn_of_deriv_pos

## 依赖（人话版）

mathlib: monotoneOn_of_deriv_nonneg, strictMonoOn_of_deriv_pos

## 应用与陷阱

凸区间 D=Set.Icc 上应用，需 interior 转成 Ioo。
