---
id: analysis.trigonometric.basic-identities
kind: theorem
state: verified
title: "三角函数基本对称性、周期性与有界性"
premises: [analysis.constants.pi-definition, analysis.constants.special-values]
mathlib: ["Real.sin_neg", "Real.cos_neg", "Real.sin_add_two_pi", "Real.cos_add_two_pi", "Real.neg_one_le_sin", "Real.sin_le_one", "Real.neg_one_le_cos", "Real.cos_le_one"]
provenance:
  source_type: textbook
  ref: "高中数学：三角函数基本性质"
---

# 内容

本条目登记三角函数的三组基础性质：

- 奇偶性：`sin (-x) = -sin x`，`cos (-x) = cos x`；
- 周期性：`sin (x + 2π) = sin x`，`cos (x + 2π) = cos x`；
- 有界性：`|sin x| ≤ 1`，`|cos x| ≤ 1`。

和差、倍角、半角、积化和差及特殊角值在相邻批次中继续整理。
