---
id: settheory.googology.goodstein-positive-tail-no-borrow
kind: theorem
state: verified
title: "Goodstein 正末位无借位下降：复合前缀与正数字末项"
premises: ["settheory.googology.goodstein-positive-digit-descent", "settheory.googology.goodstein-ordinal-measure"]
mathlib: ["Nat.add_sub_assoc", "Order.lt_succ"]
provenance: {source_type: paper, ref: "R. L. Goodstein, On the Restricted Ordinal Theorem, 1944"}
---

# 动机

单个正数字的下降只覆盖最简单的 Goodstein 状态。真正的遗传表达式通常包含幂、乘法和多个加法项。本条向前推进一步：允许一个任意复合的合法前缀，只要它后面还有一个严格为正的数字末项。此时减一不需要向前缀借位。

# 直觉

把表达式看成 `P + d`，其中 `P` 可以是很复杂的遗传表达式，而 `d` 是满足 `0 < d < b` 的末位数字。换到底数 `b+1` 后，整体是 `P(b+1)+d`。由于 `d` 不是零，减一立即得到 `P(b+1)+(d-1)`；前缀的任何一层都不需改写。

# 陈述（自然语言）

给定底数 `b` 下一个合法的遗传前缀 `P` 和一个合法正数字 `d`，用 `P+(d-1)` 作为 `P+d` 换底减一后的显式重编码。该重编码在新底数下合法，求值正确，并且它的 `ω` 解释严格小于原表达式的 `ω` 解释。

# 陈述（Lean 对照）

`PositiveTailNoBorrowForm base` 保存 `head`、`head_valid`、`digit`、`digit_positive` 和 `digit_valid`。`expression` 构造 `head + digit`，`predecessorExpression` 构造 `head + (digit-1)`。`positiveTail_goodstein_descent` 一次给出换底减一的数值公式、新表达式合法性、新表达式求值正确性和序数度量严格下降四项结论。

# 思维脉络（thinking trace）

证明先用 `d>0` 得到 `d-1<d` 以及 `(d-1)+1=d`。接着对前缀的语法树做结构归纳，证明一个在底数 `b` 下合法的表达式在更大底数 `b+1` 下仍合法。自然数求值端只用“正末位减一无需借位”。序数端则把原末位 `d` 改写成 `succ (d-1)`，再用本库序数加法的后继递推式。

# 自然语言 ↔ Lean 映射

“复合前缀”对应 `head : HereditaryBaseExpr`；“前缀在原底数下合法”对应 `head_valid`；“正的合法末位”对应 `digit_positive` 与 `digit_valid`；“不借位”对应 `predecessorExpression` 仅将 `digit` 改成 `digit-1`；“度量下降”对应结论最后的严格不等式。

# 依赖（人话版）

本条复用已建立的 Goodstein 换底减一、遗传表达式的 `ω` 解释，以及本库序数加法的后继方程。自然数部分使用正数减一的基本性质；序数部分使用任意序数严格小于它的后继。

# 应用与陷阱

这是从“单个数字”到“真正含有复合前缀的表达式”的局部下降桥，可直接处理例如 `b^(b+1) + 3` 这类末项为正数字的形式。它绝不覆盖 `P+0` 或末尾根本没有数字项的情形：那些情形需要向更高位借位并重新展开低位。本条也没有证明任意 Goodstein 单步下降、序列存在或 Goodstein 定理。
