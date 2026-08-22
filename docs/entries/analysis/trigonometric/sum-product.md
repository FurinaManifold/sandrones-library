---
id: analysis.trigonometric.sum-product
kind: theorem
state: verified
title: "三角函数和差化积公式"
premises: [analysis.trigonometric.add-sub, analysis.trigonometric.product-sum]
mathlib: ["Real.sin_add", "Real.sin_sub", "Real.cos_add", "Real.cos_sub"]
provenance:
  source_type: textbook
  ref: "高中数学：三角函数和差化积"
---

# 内容

本条目登记四类和差化积公式：
\[
\sin x+\sin y=2\sin\frac{x+y}{2}\cos\frac{x-y}{2},
\]
\[
\sin x-\sin y=2\cos\frac{x+y}{2}\sin\frac{x-y}{2},
\]
\[
\cos x+\cos y=2\cos\frac{x+y}{2}\cos\frac{x-y}{2},
\]
\[
\cos x-\cos y=-2\sin\frac{x+y}{2}\sin\frac{x-y}{2}.
\]

证明通过令 `u=(x+y)/2`、`v=(x-y)/2`，再调用和差公式完成。
