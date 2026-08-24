---
id: settheory.ordinal.transfinite-recursion
kind: definition
state: verified
title: "超限递归"
premises: ["settheory.ordinal.transfinite-induction"]
mathlib: ["Ordinal.limitRecOn"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 2: Transfinite Recursion"}
---

# 动机
序数运算和层级函数必须在零、后继、极限三类输入上分别定义。

# 直觉
后继阶段读取上一值；极限阶段可读取所有更小位置的值。

# 陈述（自然语言）
给出零值、后继构造和极限构造后，可对每个序数递归地产生对应类型中的值。

# 陈述（Lean 对照）
`transfiniteRec zero succ limit α := Ordinal.limitRecOn α zero succ limit`。

# 思维脉络（thinking trace）
复用 mathlib 已由良基性建立的三分递归器，接口明确暴露极限分支的全部前驱值。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| 后继分支 | `∀ α, M α → M (Order.succ α)` |
| 极限分支 | `∀ α, IsSuccLimit α → (∀ β < α, M β) → M α` |

# 依赖（人话版）
超限归纳保证递归定义沿良基关系成立。

# 三个分支各自在做什么

超限递归不是一个神秘的新运算，而是把熟悉的递归补上极限阶段：

- **零分支**决定起点，例如序数幂规定 `a⁰=1`；
- **后继分支**从当前值制造下一值，例如 `a^(succ β)=a^β·a`；
- **极限分支**同时查看此前所有值，例如非零底数的序数幂在极限 `λ` 处取
  `sup_{β<λ} a^β`。

函数值的类型可以依赖输入序数，所以 Lean 写成 `M : Ordinal → Sort*`。如果所有阶段都返回
普通序数，可以把它想成较简单的 `M α = Ordinal`。

# 为什么定义不会互相打架

每个序数恰好处于零、后继、非零极限三种情况之一。后继分支只读取更早位置，极限分支也只读取
严格更小的位置，因此不存在向未来索取尚未定义值的循环。其合法性最终来自序数严格序的良基性。

# 应用与陷阱
公开接口使用结构性的 `Order.succ`，不预先借用尚未定义的序数加法。底层
`Ordinal.limitRecOn` 的 `α+1` 表示仅在实现桥中通过 `Order.succ_eq_add_one` 对齐。
这是依赖选择的非可计算定义；它不是自然数上的可执行递归器。
- “极限阶段取上确界”不是超限递归强制规定的；这是具体定义自己选择的极限分支。
- 后继接口使用 `Order.succ`，因为序数加法在本章稍后才定义。
