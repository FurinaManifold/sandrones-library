---
id: settheory.ordinal.cofinality
kind: theorem
state: verified
title: "序数的共尾数"
premises: ["settheory.ordinal.successor-limit", "settheory.ordinal.supremum"]
mathlib: ["Ordinal.cof_zero", "Ordinal.cof_add_one", "Ordinal.cof_omega0"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 3: Cofinality"}
---

# 动机
共尾数衡量至少需要多大的序列才能在一个序数中无界，是研究极限阶段复杂度的尺度。

# 直觉
后继序数只需末端一个点便共尾；自然数序列自身在 `ω` 中共尾，因此其共尾数是 `ℵ₀`。

# 陈述（自然语言）
零的共尾数是零，任意后继序数的共尾数是一，`ω` 的共尾数是 `ℵ₀`。

# 陈述（Lean 对照）
`basic_cofinalities (a)` 给出三个等式的合取。

# 思维脉络（thinking trace）
三种基本序数分别使用 mathlib 对空序、带顶元序和首个极限序数的共尾数计算。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| 序数 `a` 的共尾数 | `a.cof` |
| 可数无限基数 | `Cardinal.aleph0` |

# 依赖（人话版）
后继/极限分类解释三例差异；上确界接口解释共尾族如何逼近极限。

# 应用与陷阱
共尾数是基数而非序数；`a.cof` 的结果类型是 `Cardinal`。
