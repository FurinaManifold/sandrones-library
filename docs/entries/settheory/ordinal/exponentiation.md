---
id: settheory.ordinal.exponentiation
kind: definition
state: verified
title: "序数幂的后继递推"
premises: ["settheory.ordinal.transfinite-recursion", "settheory.ordinal.multiplication"]
mathlib: ["Ordinal.limitRecOn", "Ordinal.opow_succ", "Ordinal.opow_limit"]
provenance: {source_type: book, ref: "jech-set-theory-2003"}
---

# 动机
序数幂不能直接包装原生 `^`；它应由指数上的超限递归构造，并显式依赖本库乘法。

# 直觉
零指数取一；后继阶段用 `ordinalMul` 再乘一次底数；非零底数的极限阶段取此前各值的上确界。

# 陈述（自然语言）
`ordinalPow a b` 由上述三个分支定义。它满足 `ordinalPow a 0=1`、
`ordinalPow a (succ b)=ordinalMul (ordinalPow a b) a`；若 `a≠0` 且 `b` 为极限序数，
则其值是所有更小指数幂的上确界。

# 陈述（Lean 对照）
`ordinalPow` 是公开定义；`ordinalPow_zero`、`ordinalPow_succ`、`ordinalPow_limit` 是递归方程。
原生 `^` 只出现在私有桥 `ordinalPow_eq_mathlib` 中。

# 思维脉络（thinking trace）
先对零底数作教材约定 `0^0=1`、`0^b=0 (b≠0)`；非零底数使用 `Ordinal.limitRecOn`。
后继构造调用本库 `ordinalMul`，极限构造取 `iSup`。最后用私有桥验证与 mathlib 实现一致。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| 本库序数幂 | `ordinalPow a b` |
| 指数递推中的乘法 | `ordinalMul (ordinalPow a b) a` |
| 极限阶段 | `⨆ x : Set.Iio b, ordinalPow a x.1` |
| 后继 | `Order.succ b` |

# 依赖（人话版）
依赖超限递归器；后继递推右侧使用本库序数乘法。

# 从有限幂推广到超限幂

有限指数时，`a³` 表示连续三次乘以 `a`。序数指数把“重复多少次”从自然数推广到任意序数：

- `ordinalPow a 0 = 1`；
- `ordinalPow a (succ b)` 在已有 `ordinalPow a b` 后再乘一个 `a`；
- 到达没有直接前驱的极限序数 `λ` 时，不能说“取上一步再乘”，因为根本没有最后一步，
  因而对非零底数定义为此前全部幂的上确界。

例如 `ordinalPow ω ω` 是
`1, ω, ω², ω³, …` 的上确界。它比每个有限次 `ωⁿ` 都大，但仍由这些有限阶段从下方逼近。

# 为什么零底数要单独处理

教材约定 `0⁰=1`，而对非零指数 `b` 有 `0ᵇ=0`。若错误地在极限处无条件取此前所有值的
上确界，那么集合中包含指数零处的值 `1`，会错误得到至少 `1`。因此定义首先判断底数是否为零，
而 `ordinalPow_limit` 明确要求 `a≠0`。这不是 Lean 技术细节，而是数学定义本身的必要分支。

# 应用与陷阱
零底数不满足通常的极限连续公式，因为 `0^0=1`，所以 `ordinalPow_limit` 明确要求底数非零。
- 序数幂不是基数幂；它保留良序排列信息。
- 后继公式中乘法因子顺序固定，不能利用不存在的交换律调换。
