---
id: complex-analysis.liouville
kind: theorem
state: verified
title: "Liouville 定理"
summary: 证明在整个复平面上全纯且全局有界的复函数必为常值
premises: ["complex-analysis.cauchy.derivatives"]
mathlib: ["Differentiable.exists_const_forall_eq_of_bounded", "isBounded_iff_forall_norm_le"]
provenance:
  source_type: book
  ref: "Conway, Functions of One Complex Variable I（Liouville 定理）"
---

# 定义

整函数是在 `Set.univ` 上全纯的复函数。“全局有界”在公开接口中表示存在实数 `C`，
使每个 `z : ℂ` 都满足 `‖f z‖ ≤ C`。

# 动机

Liouville 定理是复分析的核心刚性结果：实分析中有很多非常数的有界光滑函数，但全局全纯性
强到足以排除它们。代数基本定理的标准证明就以此为关键。

# 直觉

对任意大半径 `R`，Cauchy 估计给出 `‖f'(c)‖ ≤ C/R`。因为整函数可以选择任意大的圆盘，
令 `R→∞` 得 `f'(c)=0`；所有点导数为零便迫使 `f` 为常值。

# 陈述（自然语言）

若 `f : ℂ → ℂ` 在整个复平面上全纯，且其范数被一个固定实数一致控制，则存在 `b : ℂ`
使得对所有 `z` 都有 `f z=b`。等价地，`f` 在任意两点取值相同。

# 陈述（Lean 对照）

`liouville` 给出 `∃ b, ∀ z, f z = b`；`liouville_eq` 给出任意 `z w` 上的 `f z = f w`。

# 思维脉络（thinking trace）

先用教材桥将 `HolomorphicOnTextbook f Set.univ` 转为 Mathlib 的全局 `Differentiable ℂ f`。
再把课程形式的范数上界转为 `Set.range f` 的有界性，应用 Mathlib 的 Liouville 后端。

# 自然语言 ↔ Lean 映射

- 整函数 ↔ `HolomorphicOnTextbook f Set.univ`。
- 全局有界 ↔ `∃ C : ℝ, ∀ z : ℂ, ‖f z‖ ≤ C`。
- 常值性 ↔ `∃ b : ℂ, ∀ z : ℂ, f z = b`。
- 两点形式 ↔ `liouville_eq` 的 `f z = f w`。

# 依赖（人话版）

概念上依赖 Cauchy 导数估计。Lean 证明使用 Mathlib 已封装的 Liouville 定理，并通过本库桥定理
保持公开全纯前提的教材形式。

# 应用与陷阱

- “有界”必须是整个复平面上的统一上界，不是每个有界集上分别有界。
- 仅在某个开集上全纯不足以得出常值性；必须是 `Set.univ`。
- 有界性是对复数范数的实数不等式，不是复数的次序比较。
