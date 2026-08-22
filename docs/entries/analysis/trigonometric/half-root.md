---
id: analysis.trigonometric.half-root
kind: theorem
state: verified
title: "三角函数半角平方根公式"
premises: [analysis.trigonometric.double-half]
mathlib: ["Real.abs_sin_half", "Real.cos_sq", "Real.sqrt_sq_eq_abs", "Real.sin_nonneg_of_nonneg_of_le_pi", "Real.cos_nonneg_of_mem_Icc"]
provenance:
  source_type: textbook
  ref: "高中数学：三角函数半角公式"
---

# 内容

本条目先登记无条件的绝对值形式：
\[
\left|\sin\frac x2\right|=\sqrt{\frac{1-\cos x}{2}},
\qquad
\left|\cos\frac x2\right|=\sqrt{\frac{1+\cos x}{2}}.
\]

再在明确的区间条件下去掉绝对值：

- `0 ≤ x ≤ π` 时，`sin(x/2)` 取非负值；
- `-π ≤ x ≤ π` 时，`cos(x/2)` 取非负值。
