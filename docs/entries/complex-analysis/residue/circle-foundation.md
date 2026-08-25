---
id: complex-analysis.residue.circle-foundation
kind: definition
state: verified
title: "圆周正规化残数基础"
summary: 将指定正向圆周上的积分除以 2πi，作为局部残数理论的 foundation 接口
premises: ["complex-analysis.cauchy.formula"]
mathlib: ["circleIntegral"]
provenance: {source_type: book, ref: "ahlfors-complex-analysis-1979"}
---

# 动机

`circleResidue f a R = (2πi)⁻¹ ∮_{|z-a|=R} f(z) dz`，它显式依赖所选圆周。
Mathlib 尚无一般 Laurent 残数 API；该定义提供可验证的圆周积分基础层。

# 直觉

`2πi` 是 Cauchy 核绕中心一圈的标准积分，除去它使核的正规化值为 `1`。

# 陈述（自然语言）

圆周残数是指定圆周积分的 `1/(2πi)` 倍。

# 陈述（Lean 对照）

`circleResidue` 及 `circleResidue_eq_normalized_circleIntegral`。

# 思维脉络（thinking trace）

直接包装 Mathlib `circleIntegral`，不引入尚未形式化的 Laurent 系数。

# 自然语言 ↔ Lean 映射

- 正向圆周 ↔ `C(a,R)`。
- 正规化 ↔ `(2 * Real.pi * Complex.I)⁻¹ * ...`。

# 依赖（人话版）

仅依赖圆周路径积分和 `2πi ≠ 0`。

# 应用与陷阱

- 这不是一般 Laurent 残数定义。
- 未证明圆周独立性时，不能省略 `R`。
