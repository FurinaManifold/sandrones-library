---
id: analysis.trigonometric.product-sum
kind: theorem
state: verified
title: "三角函数积化和差公式"
premises: [analysis.trigonometric.add-sub, analysis.trigonometric.double-half]
mathlib: ["Real.sin_add", "Real.sin_sub", "Real.cos_add", "Real.cos_sub"]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

本条目登记三类积化和差公式：
\[
\sin x\sin y=\frac{\cos(x-y)-\cos(x+y)}2,
\]
\[
\cos x\cos y=\frac{\cos(x-y)+\cos(x+y)}2,
\]
\[
\sin x\cos y=\frac{\sin(x+y)+\sin(x-y)}2.
\]

它们由和差公式直接展开并进行环算术化简得到。
