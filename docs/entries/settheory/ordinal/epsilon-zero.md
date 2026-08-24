---
id: settheory.ordinal.epsilon-zero
kind: theorem
state: verified
title: "ε₀：首个 epsilon 数"
premises: ["settheory.ordinal.normal-function", "settheory.ordinal.cantor-normal-form"]
mathlib: ["Ordinal.omega0_opow_epsilon", "Ordinal.epsilon_zero_le_of_omega0_opow_le"]
provenance: {source_type: book, ref: "Wolfram Pohlers, Proof Theory, Section 1.2: Epsilon Numbers"}
---

# 动机
`ε₀` 是反复取 `ω` 次幂闭包的首个边界，也是 Goodstein 定理所用的证明论序数。

# 直觉
从较小序数不断做 `α↦ω^α`，其极限不再变化；最早出现的这种不动点就是 `ε₀`。

# 陈述（自然语言）
`ω^ε₀=ε₀`；若 `ω^α≤α`，则 `ε₀≤α`。

# 陈述（Lean 对照）
`epsilonZero_fixed_and_least`。

# 思维脉络（thinking trace）
第一部分使用 epsilon 枚举函数的不动点性质；第二部分使用下一正规函数不动点的最小性。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| ε₀ | `Ordinal.epsilon 0` |
| ω 的序数幂 | `Ordinal.omega0 ^ α` |

# 依赖（人话版）
正规函数保证不动点结构；Cantor 正规形解释 ε₀ 以下表达式为何由有限展开构成。

# 应用与陷阱
本条建立序数不动点边界，不声称已形式化完整 Goodstein 编码与逐步下降桥。
