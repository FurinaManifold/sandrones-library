---
id: settheory.googology.goodstein-hereditary-base-exponent-borrow
kind: theorem
state: verified
title: "Goodstein 遗传指数借位：底数自身进入指数"
premises: ["settheory.googology.goodstein-finite-power-borrow", "settheory.googology.goodstein-ordinal-measure"]
mathlib: ["Order.IsNormal.strictMono", "Ordinal.natCast_lt_omega0"]
provenance: {source_type: paper, ref: "goodstein-restricted-ordinal-1944"}
---

# 动机

有限指数借位仍把指数 `k` 当作一个数字叶子，因而要求 `k<base`。Goodstein 过程的真正难点在于指数中也会出现底数，换底必须递归深入指数。本条选取精确闭合的参数族 `head+B^(B¹)`：它是第一个底数真正出现在指数子树中的局部模型。

# 直觉

原底数是 `base`，升底后是 `q=base+1`。指数表达式 `B¹` 也要一起换底，所以它在新底数下的值是 `q`；外层幂因此变成 `q^q`，而不是 `q^base`。上一条已能递归展开任意有限的 `q^k-1`，所以在这里将 `k` 取为随底数变化的 `q`。

# 陈述（自然语言）

`BaseExponentOneNormalForm` 是遗传指数 `B¹` 的证书子类：它在原底数下合法，在新底数下求值为 `q`，换成 `ω` 解释后求值为 `ω`。对任意合法头部 `head`，`head+B^(B¹)` 换底减一后，用 `q^q-1` 的有限递归展开重编码。新编码合法、求值正确，并且 `ω` 度量严格下降。

# 陈述（Lean 对照）

`BaseExponentOneNormalForm.expression` 是 `.basePow (.digit 1)`，`protocol` 同时证明它的合法性、新底数求值和 `omegaValue`。`HereditaryBaseExponentTailBorrowForm.expression` 将该表达式放入外层 `.basePow`；`borrowedExpression` 使用 `finitePowerBorrowExpansion base (base+1)`。`hereditaryBaseExponent_goodstein_borrow_descent` 给出源合法性、数值公式、目标合法性、目标求值和严格下降。

# 思维脉络（thinking trace）

证明首先拆出指数协议的三项证书，从而防止后续求值证明把指数的旧底数值和新底数值混淆。然后将上一条的递归展开取在 `k=base+1`；该展开的最大指数数字为 `base`，仍严格小于新底数。序数端先得到展开度量低于 `ω^q`，再由 `q<ω` 和本库序数幂的严格单调性得到 `ω^q<ω^ω`。

# 自然语言 ↔ Lean 映射

“底数进入指数”对应外层 `.basePow f.exponent.expression`；“指数换底后为 `q`”对应 `hexponent_eval`；“指数的序数解释为 `ω`”对应 `hexponent_omega`；“展开 `q^q-1`”对应 `finitePowerBorrowExpansion base (base+1)`；“从有限指数界提升到 `ω`指数界”对应 `exponentiation_isNormal ... .strictMono`。

# 依赖（人话版）

本条直接依赖有限指数递归借位展开和 Goodstein `ω` 度量，同时使用本库已证明的“底数大于一时序数幂是正规函数”。mathlib 在证明后端提供有限序数小于 `ω` 的定理；公开构造仍使用本库的 `ordinalAdd`、`ordinalMul` 和 `ordinalPow` 接口。

# 应用与陷阱

这是一个随底数变化、可带任意复合头部的无限参数族，不是另一个固定数字算例。但其指数语法精确限定为 `B¹`：本条没有覆盖 `B^(B^k)` 中任意 `k`、任意高度幂塔、指数内的加乘组合或通用遗传指数正规化。因此不得由此声称一般借位、一般 Goodstein 下降或终止。
