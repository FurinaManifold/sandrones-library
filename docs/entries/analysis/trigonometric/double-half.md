---
id: analysis.trigonometric.double-half
kind: theorem
state: verified
title: "三角函数倍角与降幂公式"
premises: [analysis.trigonometric.add-sub]
mathlib: ["Real.sin_two_mul", "Real.cos_two_mul", "Real.sin_sq_eq_half_sub", "Real.cos_sq", "Real.sin_sq_add_cos_sq"]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

本条目登记正弦、余弦倍角公式：
\[
\sin(2x)=2\sin x\cos x,
\qquad
\cos(2x)=2\cos^2x-1.
\]

并登记降幂形式：
\[
\sin^2x=\frac12-\frac12\cos(2x),
\qquad
\cos^2x=\frac12+\frac12\cos(2x),
\]
以及基础平方和恒等式 `sin² x + cos² x = 1`。
