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
| 后继分支 | `∀ α, M α → M (α + 1)` |
| 极限分支 | `∀ α, IsSuccLimit α → (∀ β < α, M β) → M α` |

# 依赖（人话版）
超限归纳保证递归定义沿良基关系成立。

# 应用与陷阱
这是依赖选择的非可计算定义；它不是自然数上的可执行递归器。
