---
id: analysis.inequalities.minkowski-finite
family: analysis.inequalities
variant: generated
kind: theorem
state: verified
title: "有限和Minkowski不等式"
premises: ["analysis.inequalities.holder-finite"]
mathlib: ["Real.Lp_add_le"]
provenance:
  source_type: book
  ref: "数学分析：有限和Minkowski不等式"
---

# 动机

Minkowski 正是 `ℓᵖ` 大小成为范数时所需的三角不等式。

# 直觉

# 陈述（自然语言）

当 `1≤p` 时，`‖f+g‖ₚ ≤ ‖f‖ₚ+‖g‖ₚ`，其中各范数由有限幂和定义。

# 陈述（Lean 对照）

# 思维脉络（thinking trace）

展开 `|f+g|ᵖ`，以共轭指数对其中乘积应用 Hölder，再约去公共范数因子。

# 自然语言 ↔ Lean 映射

# 依赖（人话版）

# 应用与陷阱
