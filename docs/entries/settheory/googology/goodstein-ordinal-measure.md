---
id: settheory.googology.goodstein-ordinal-measure
kind: definition
state: verified
title: "Goodstein 序数度量：把有限底数换成 ω"
premises: ["settheory.googology.goodstein-certified-state", "settheory.ordinal.exponentiation"]
mathlib: ["Ordinal.omega0"]
provenance: {source_type: paper, ref: "goodstein-restricted-ordinal-1944"}
---

# 动机

Goodstein 序列的自然数值在早期通常会猛烈上升，因而不能用自然数大小直接证明终止。经典路线是把遗传表达式中的底数替换为第一个无限序数 `ω`，并研究所得序数是否严格下降。

# 直觉

表达式树的形状不变：数字仍是有限序数，加法节点改用序数加法，乘法节点改用序数乘法，而每个“当前底数的指数次幂”改为 `ω` 的相同序数指数次幂。

# 陈述（自然语言）

`omegaValue` 递归地把遗传表式解释为序数：零、数字、加法和乘法保留各自结构，底数幂节点改用 `ω` 为底。一个状态的 `ordinalMeasure` 就是对该状态携带的表达式执行这种解释。

# 陈述（Lean 对照）

`HereditaryBaseExpr.omegaValue` 对五种构造子递归定义，分别使用自然数强制转换、`ordinalAdd`、`ordinalMul` 和 `ordinalPow Ordinal.omega0`。`omegaValue_equations` 公开五条计算方程，不要求用户直接展开定义。

# 思维脉络（thinking trace）

首先保留表达式语法树，以确保底数在指数深处的出现也会被替换；然后复用本库已从教材定义构造的序数加、乘、幂，而不在公共定义中直接偷用 mathlib 运算符。

# 自然语言 ↔ Lean 映射

“把底数换成 `ω`”对应 `.basePow exponent` 分支中的 `ordinalPow Ordinal.omega0 exponent.omegaValue`；“递归深入指数”对应对 `exponent.omegaValue` 的调用；“状态度量”对应 `s.expression.omegaValue`。

# 依赖（人话版）

本条依赖遗传表达式、带证书状态，以及本库已定义的序数加法、乘法和幂。它目前建立的是度量函数及其计算方程，并未建立每次 Goodstein 迁移都使度量下降。

# 应用与陷阱

它是将来连接 Goodstein 计算与序数良基性的桥头。但对任意合法语法树，“减一”与“重编码”并不自动对应 Cantor 正规形的严格下降；还需正规编码、借位分析和下降引理。在那些桥尚未形式化前，绝不能声称已证明 Goodstein 定理。
