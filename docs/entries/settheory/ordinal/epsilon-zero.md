---
id: settheory.ordinal.epsilon-zero
kind: theorem
state: verified
title: "ε₀：首个 epsilon 数"
premises: ["settheory.ordinal.normal-function", "settheory.ordinal.cantor-normal-form"]
mathlib: ["Ordinal.omega0_opow_epsilon", "Ordinal.epsilon_zero_le_of_omega0_opow_le"]
provenance: {source_type: book, ref: "pohlers-proof-theory-1989"}
---

# 动机
`ε₀` 是反复取 `ω` 次幂闭包的首个边界，也是 Goodstein 定理所用的证明论序数。

# 直觉
从较小序数不断做 `α↦ω^α`，其极限不再变化；最早出现的这种不动点就是 `ε₀`。

# 陈述（自然语言）
`ordinalPow ω ε₀=ε₀`；若 `ordinalPow ω α≤α`，则 `ε₀≤α`。

# 陈述（Lean 对照）
`epsilonZero_fixed_and_least`。

# 思维脉络（thinking trace）
第一部分使用 epsilon 枚举函数的不动点性质；第二部分使用下一正规函数不动点的最小性。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| ε₀ | `Ordinal.epsilon 0` |
| ω 的序数幂 | `ordinalPow Ordinal.omega0 α` |

# 依赖（人话版）
正规函数保证不动点结构；Cantor 正规形解释 ε₀ 以下表达式为何由有限展开构成。

# 从不断叠高的 ω 幂塔得到 ε₀

从 `0` 出发反复应用 `α↦ω^α`，得到
`0, 1, ω, ω^ω, ω^(ω^ω), …`。每一步都更大；在第 `ω` 个阶段取此前全部值的上确界，
得到一个再次取 `ω` 次幂也不会增长的序数。首个这样的不动点就是 `ε₀`。

# “最小”具体是什么意思

公式 `ordinalPow ω ε₀=ε₀` 说明它是不动点。第二条性质进一步说，只要某个 `α` 已满足
`ordinalPow ω α≤α`，就必有 `ε₀≤α`。因此在 `ε₀` 之前不存在另一个这样的不动点屏障。

# 与 CNF 和 Goodstein 的关系

每个小于 `ε₀` 的序数都能用有限的 `ω` 幂、乘法和加法写成嵌套 CNF。Goodstein 论证把
自然数的遗传进位制翻译成这种序数表达；自然数值可能增长，相应序数却逐步严格下降。

# 应用与陷阱
本条建立序数不动点边界，不声称已形式化完整 Goodstein 编码与逐步下降桥。
- `ε₀` 是可数序数，不是不可数基数，也不是“最大的可数序数”。
- “首个不动点”是针对 `α↦ω^α` 而言；换一个正规函数会得到另一层不动点。
- Goodstein 仍需遗传基编码和单步下降桥，本条不能替代那两部分。
