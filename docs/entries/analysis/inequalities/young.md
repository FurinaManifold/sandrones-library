---
id: analysis.inequalities.young
family: analysis.inequalities
variant: generated
kind: theorem
state: verified
title: "Young 不等式"
premises: []
mathlib: ["Real.young_inequality"]
provenance:
  source_type: book
  ref: "数学分析：Young不等式"
---

# 动机

Young 不等式把乘积拆成两个纯幂项，是证明 Hölder 不等式的逐点工具。

# 直觉

# 陈述（自然语言）

若 `p,q` 共轭，则 `ab ≤ |a|ᵖ/p + |b|ᑫ/q`。

# 陈述（Lean 对照）

# 思维脉络（thinking trace）

由加权算术—几何平均不等式，取权重 `1/p,1/q`；绝对值处理任意符号。

# 自然语言 ↔ Lean 映射

# 依赖（人话版）

# 应用与陷阱
