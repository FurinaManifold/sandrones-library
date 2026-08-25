---
id: settheory.googology.goodstein-positive-digit-descent
kind: theorem
state: verified
title: "Goodstein 的非零数字正规形下降"
premises: ["settheory.googology.goodstein-step", "settheory.googology.goodstein-ordinal-measure"]
mathlib: ["Nat.sub_one_lt"]
provenance: {source_type: textbook, ref: "goodstein-restricted-ordinal-1944"}
---

# 动机

完整 Goodstein 证明的难点不是写出“换底后减一”，而是减一可能从高次项一路借位，必须把结果重新写成规范的遗传基表示。现有通用语法树还没有唯一正规化算法，因此本条先隔离一个能完整闭环的非平凡子类：当前表示只是一个非零数字。

# 直觉

数字叶不含“当前底数”节点，所以把底数从 `b` 提高到 `b+1` 时，数字 `k` 的值仍是 `k`。若 `k>0`，最后减一得到 `k-1`；它在新底数下仍是合法数字。把两个表示中的底数换成 `ω` 后，度量分别是有限序数 `k` 和 `k-1`，因而严格下降。

# 陈述（自然语言）

设 `0<k<b`，并把 `k` 看作底数 `b` 下的单数字正规形。它的 Goodstein 单步值是 `k-1`。表达式 `digit (k-1)` 在新底数 `b+1` 下合法，其求值恰好是该单步值，并且它的 `ω` 度量严格小于原表达式的 `ω` 度量。

# 陈述（Lean 对照）

`PositiveDigitNormalForm base` 保存数字 `digit` 以及 `0 < digit` 和 `digit < base` 两份证书。`expression` 把它嵌入 `HereditaryBaseExpr`，`predecessorExpression` 生成 `.digit (digit-1)`。定理 `positiveDigit_goodstein_descent` 同时给出单步等式、新表示合法性、重编码求值等式和序数严格下降。

# 思维脉络（thinking trace）

先用带证书的结构把“非零且是合法数字”变成显式前提。然后直接展开数字叶的换底求值，用 `Nat.sub_one_lt` 得到 `k-1<k`。这个同一不等式既证明新数字小于新底数，又经有限序数嵌入转成 `ω` 度量下降。因为没有高次项，这一子类不需要借位算法。

# 自然语言 ↔ Lean 映射

“底数 `b` 下的非零数字”对应 `PositiveDigitNormalForm b`；“换底后数值不变”对应第一个合取分量；“减一后重编码”对应 `predecessorExpression`及中间两个分量；“把底数换成 `ω`”对应 `HereditaryBaseExpr.omegaValue`；最后的 `<` 分量就是严格下降桥。

# 依赖（人话版）

本条依赖已有的 Goodstein 换底减一定义和遗传表达式的 `ω` 度量。mathlib 的 `Nat.sub_one_lt` 只负责“正自然数减一严格变小”；有限自然数到序数的不等式转换由 Lean 的数值嵌入机制核对。它不依赖完整 Goodstein 定理。

# 应用与陷阱

该定理是通用下降证明的一个可编译基例，也可作为日后正规化器输出协议的测试：每步必须同时交付合法新表示和度量下降。但它只覆盖单个非零数字；不覆盖底数幂、多项和、乘法树或任何借位，不能用来声称一般 Goodstein 序列下降或终止。零被明确排除，因为自然数截断减法下 `0-1=0`，度量不会严格下降。
