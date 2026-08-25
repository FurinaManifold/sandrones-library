---
id: settheory.ordinal.normal-function
kind: theorem
state: verified
title: "正规序数函数"
premises: ["settheory.ordinal.exponentiation", "settheory.ordinal.supremum"]
mathlib: ["Ordinal.isNormal_opow"]
provenance: {source_type: book, ref: "jech-set-theory-2003"}
---

# 动机
正规函数同时控制严格增长与极限连续性，其不动点构成后续 ε 数层级。

# 直觉
底数大于一时，序数幂随指数严格增长，并保持极限处的上确界。

# 陈述（自然语言）
若 `1<a`，则 `β↦ordinalPow a β` 是正规序数函数。

# 陈述（Lean 对照）
`exponentiation_isNormal ha : IsNormal (fun β : Ordinal ↦ ordinalPow a β)`。

# 思维脉络（thinking trace）
mathlib 已把严格单调与极限保持封装为 `IsNormal`，序数幂满足该接口。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| 正规函数 | `Order.IsNormal f` |
| 严格递增 | `StrictMono f` |

# 依赖（人话版）
依赖序数幂及极限上确界的语言。

# “正规”包含两个条件

序数函数 `f` 正规，要求严格递增，并在极限处保持上确界：对极限序数 `λ`，
`f(λ)=sup_{β<λ} f(β)`。这里的“连续”不是实分析中的距离连续，而是保持序数极限结构。

# 为什么序数幂正规

固定 `a>1`。后继指数会再乘一个大于一的因子，因此幂值严格增加；极限指数处，`ordinalPow`
按定义就是此前幂值的上确界。因此 `β↦ordinalPow a β` 同时满足两个条件。

# 不动点从哪里来

从任意起点反复迭代正规函数，并在极限处取上确界，会得到不再被函数推动的不动点。对
`f(α)=ω^α`，这些不动点就是 epsilon 数，这把本条与后面的 `ε₀` 连接起来。

# 应用与陷阱
- “正规”不是仅单调；还要求对极限上确界连续。
- `a=1` 时幂函数恒为一，不严格递增，所以必须要求 `1<a`。
- 不动点构造同时使用严格递增和极限连续，缺一不可。
