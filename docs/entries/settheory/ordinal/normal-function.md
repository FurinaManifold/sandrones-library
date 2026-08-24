---
id: settheory.ordinal.normal-function
kind: theorem
state: verified
title: "正规序数函数"
premises: ["settheory.ordinal.exponentiation", "settheory.ordinal.supremum"]
mathlib: ["Ordinal.isNormal_opow"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 2: Normal Functions"}
---

# 动机
正规函数同时控制严格增长与极限连续性，其不动点构成后续 ε 数层级。

# 直觉
底数大于一时，序数幂随指数严格增长，并保持极限处的上确界。

# 陈述（自然语言）
若 `1<a`，则 `β↦a^β` 是正规序数函数。

# 陈述（Lean 对照）
`exponentiation_isNormal ha : IsNormal (fun β : Ordinal ↦ a ^ β)`。

# 思维脉络（thinking trace）
mathlib 已把严格单调与极限保持封装为 `IsNormal`，序数幂满足该接口。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| 正规函数 | `Order.IsNormal f` |
| 严格递增 | `StrictMono f` |

# 依赖（人话版）
依赖序数幂及极限上确界的语言。

# 应用与陷阱
“正规”不是仅单调；还要求对适当上确界连续。
