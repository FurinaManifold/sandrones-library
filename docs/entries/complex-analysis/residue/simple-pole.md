---
id: complex-analysis.residue.simple-pole
kind: theorem
state: verified
title: "单极点的圆周残数"
summary: 证明 g(z)/(z-a) 在以 a 为中心的圆周上的正规化积分等于 g(a)
premises: ["complex-analysis.residue.circle-foundation", "complex-analysis.cauchy.formula"]
mathlib: ["circleIntegral.integral_sub_center_inv"]
provenance: {source_type: book, ref: "ahlfors-complex-analysis-1979"}
---

# 动机

简单极点模型是 `f(z)=g(z)/(z-a)`，其中 `g` 在 `a` 附近全纯。
这是残数计算中最基本且当前后端完整支持的情形。

# 直觉

Cauchy 公式直接把 `g(z)/(z-a)` 的边界积分变为 `2πi g(a)`。

# 陈述（自然语言）

若 `R>0` 且 `g` 在闭圆盘附近全纯，则该单极点的圆周残数为 `g(a)`；特别地，
`1/(z-a)` 在任意非退化中心圆上的值为 `1`。

# 陈述（Lean 对照）

`circleResidue_div_sub` 和 `circleResidue_sub_center_inv`。

# 思维脉络（thinking trace）

以圆心 `a` 作 Cauchy 公式的评价点，再用 `2πi` 正规化。

# 自然语言 ↔ Lean 映射

- 分子全纯 ↔ `HolomorphicOnTextbook g (closedBall a R)`。
- 单极点 ↔ `fun z => g z / (z-a)`。

# 依赖（人话版）

依赖闭圆盘版 Cauchy 积分公式和基础圆周残数定义。

# 应用与陷阱

- 本条只处理中心处的一个简单极点。
- 一般有限多极点残数定理仍是 ROADMAP 未完成项。
