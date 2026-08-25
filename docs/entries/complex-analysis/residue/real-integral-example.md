---
id: complex-analysis.residue.real-integral-example
kind: theorem
state: verified
title: "实积分例题：洛伦兹核"
summary: 验证整条实轴上 1/(1+x²) 的积分等于 π
premises: []
mathlib: ["integral_univ_inv_one_add_sq"]
provenance: {source_type: book, ref: "ahlfors-complex-analysis-1979"}
---

# 动机

被积函数是实函数 `x ↦ (1+x²)⁻¹`，积分域为全实轴。
这是常见的围道积分例题，但形式化必须说清实际采用的后端。

# 直觉

`π` 来自反正切函数在两端的极限之差。

# 陈述（自然语言）

`∫_ℝ 1/(1+x²) dx = π`。

# 陈述（Lean 对照）

`real_integral_inv_one_add_sq`。

# 思维脉络（thinking trace）

精确复用 Mathlib 已证明的广义积分结果，不伪造残数证明链。

# 自然语言 ↔ Lean 映射

- 全实轴积分 ↔ `∫ x : ℝ, ...`。
- `1/(1+x²)` ↔ `(1 + x^2)⁻¹`。

# 依赖（人话版）

后端使用反正切的导数和无穷远极限。

# 应用与陷阱

- 此 Lean 证明不是残数法证明。
- 一般围道积分方法仍是 ROADMAP 项目。
