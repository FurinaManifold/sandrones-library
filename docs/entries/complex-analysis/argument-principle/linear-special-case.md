---
id: complex-analysis.argument-principle.linear-special-case
kind: theorem
state: verified
title: "辐角积分与 Rouché 比较的线性特例"
summary: 计算 z-c 的正规化对数导数圆周积分，并验证常数扰动的边界不等式与唯一零点
premises: ["complex-analysis.residue.circle-foundation"]
mathlib: ["logDeriv", "circleIntegral.integral_sub_center_inv"]
provenance: {source_type: book, ref: "ahlfors-complex-analysis-1979"}
---

# 动机

`circleArgumentIntegral f c R` 是 `logDeriv f=f'/f` 的正规化圆周积分。
一般绕数 API 尚缺；线性模型允许先验证计数机制和 Rouché 边界条件。

# 直觉

`z-c` 沿中心圆转一圈，而小于半径的常数扰动只把零点从 `c` 移到 `c-b`。

# 陈述（自然语言）

`z-c` 的正规化辐角积分为 `1`。若 `‖b‖<R`，则边界上 `‖b‖<‖z-c‖`，且
`(z-c)+b` 在圆内的唯一零点是 `c-b`。

# 陈述（Lean 对照）

`argumentPrinciple_linear` 和 `rouche_linear_constant`。

# 思维脉络（thinking trace）

先化简 `logDeriv (z↦z-c)` 为 `(z-c)⁻¹`，再用 Cauchy 核圆周积分。扰动特例则直接
使用圆周范数恒等式和线性方程。

# 自然语言 ↔ Lean 映射

- 对数导数 ↔ `logDeriv`。
- 计数为一 ↔ `circleArgumentIntegral ... = 1`。
- 唯一零点 ↔ `∀ z, ... = 0 ↔ z = c-b`。

# 依赖（人话版）

只依赖对数导数定义和基本 Cauchy 核圆周积分。

# 应用与陷阱

- 这不是一般辐角原理或 Rouché 定理。
- 重数计数、一般路径绕数和一般扰动仍是 ROADMAP 未完成项。
