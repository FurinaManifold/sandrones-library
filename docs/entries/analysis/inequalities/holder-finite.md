---
id: analysis.inequalities.holder-finite
family: analysis.inequalities
variant: generated
kind: theorem
state: verified
title: "有限和Hölder不等式"
premises: ["analysis.inequalities.young"]
mathlib: ["Real.inner_le_Lp_mul_Lq"]
provenance:
  source_type: book
  ref: "ecnu-mathematical-analysis-5"
---

# 动机

Hölder 将内积估计推广到任意共轭指数，是有限维与积分型 `Lᵖ` 理论的共同原型。

# 直觉

# 陈述（自然语言）

有限族满足 `Σ|fᵢgᵢ| ≤ (Σ|fᵢ|ᵖ)^(1/p)(Σ|gᵢ|ᑫ)^(1/q)`。

# 陈述（Lean 对照）

# 思维脉络（thinking trace）

归一化两族后逐项应用 Young，再求和并用 `1/p+1/q=1`。

# 自然语言 ↔ Lean 映射

# 依赖（人话版）

# 应用与陷阱
