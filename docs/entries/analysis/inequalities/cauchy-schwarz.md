---
id: analysis.inequalities.cauchy-schwarz
family: analysis.inequalities
variant: generated
kind: theorem
state: verified
title: "Cauchy–Schwarz不等式"
premises: ["analysis.inequalities.holder-finite"]
mathlib: ["Finset.sum_mul_sq_le_sq_mul_sq"]
provenance:
  source_type: book
  ref: "数学分析：Cauchy–Schwarz不等式"
---

# 动机

Cauchy–Schwarz 控制有限实向量的内积，是欧氏几何、方差估计和二次型的基础。

# 直觉

# 陈述（自然语言）

`(Σfᵢgᵢ)² ≤ (Σfᵢ²)(Σgᵢ²)`。

# 陈述（Lean 对照）

# 思维脉络（thinking trace）

它是 Hölder 的 `p=q=2` 特例；平方形式避免额外处理平方根和内积符号。

# 自然语言 ↔ Lean 映射

# 依赖（人话版）

# 应用与陷阱
