---
id: settheory.googology.hereditary-natural-encoding
kind: theorem
state: verified
title: "任意自然数的遗传基编码"
premises: ["settheory.googology.hereditary-base"]
mathlib: ["Nat.strongRec", "Nat.div_add_mod"]
provenance: {source_type: textbook, ref: "Goodstein sequences, hereditary base notation"}
---

# 动机

先前的 Goodstein 借位只能在所需指数仍是新底数下的单个数字时自动构造重编码。一旦指数超过底数，`.digit n` 就不再合法。本条解决这个表示层阻塞：对任意自然数构造真正递归的遗传基表达式。

# 直觉

把 `n` 除以底数 `b`，得到商 `q` 和余数 `r`，于是 `n=q·b+r`。余数天然小于 `b`，可直接作为数字叶子；商不被留作一个过大数字，而是再用同一方法递归编码。因为 `b≥2` 且 `n>0` 时 `q<n`，这个过程一定向零前进。

# 陈述（自然语言）

对每个底数 `b≥2` 和自然数 `n`，`hereditaryNatEncode b n` 通过商余强归纳构造一棵遗传表达式树。该树的每个数字都小于 `b`，因而在底数 `b` 下合法；将它在底数 `b` 下求值会精确得回 `n`。

# 陈述（Lean 对照）

`hereditaryNatEncode` 在零处返回 `.zero`；在正数 `n` 处返回 `encode (n/base) · B¹ + digit (n%base)`。`hereditaryNatEncode_zero` 和 `hereditaryNatEncode_of_pos` 公开这两条计算方程。`hereditaryNatEncode_valid_eval` 对 `n` 做强归纳，同时证明 `Valid base` 和 `eval base = n`。

# 思维脉络（thinking trace）

定义的终止性来自正数的商严格小于原数。合法性证明分为三部分：递归商由归纳假设保证，底数幂的指数 `1` 由 `b≥2` 保证，余数由除法定理保证。求值证明将递归商还原后，直接使用 `n/base·base+n%base=n`。

# 自然语言 ↔ Lean 映射

“商严格变小”对应 `Nat.div_lt_self`；“对商继续编码”对应 `Nat.strongRec` 提供的 `rec (n/base)`；“乘以底数”对应 `.mul ... (.basePow (.digit 1))`；“加上本位余数”对应 `.digit (n%base)`；“商余还原”对应 `Nat.div_add_mod`。

# 依赖（人话版）

本条依赖已有的遗传表达式语法、合法性和求值定义，以及自然数除法的商余定理。它是完整的自然数编码器，不是“假设已给出一棵表达式”的条件协议。

# 应用与陷阱

该编码器解决了“大于底数的指数如何获得合法遗传表式”的存在性问题。模块还提供经过证明的严格后继界 `hereditaryNatEncodeOmegaCeiling`，所以它不是未证明的占位符；但该界只是“当前序数的后继”，完全不提供不同自然数、不同指数编码之间的大小比较。当前尚未证明 `omegaValue` 随 `n` 严格单调，也尚未建立通用借位所需的精确指数比较。因此这个 ceiling 接口本身不足以服务一般借位下降，更不得由本条声称任意遗传指数下降或 Goodstein 终止。
