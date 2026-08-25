---
id: settheory.googology.goodstein-hereditary-power-exponent-borrow
kind: theorem
state: verified
title: "Goodstein 遗传幂指数借位：从 B¹ 推进到 B^k"
premises: ["settheory.googology.hereditary-natural-power-rank", "settheory.ordinal.power-bridge"]
mathlib: ["Ordinal.natCast_lt_omega0", "Ordinal.opow_le_opow_right"]
provenance: {source_type: paper, ref: "R. L. Goodstein, On the Restricted Ordinal Theorem, 1944"}
---

# 动机

上一条遗传指数借位只处理 `head+B^(B¹)`。它已经说明“底数也出现在指数里”会发生什么，但内层指数固定为一，尚未展示指数随参数增长时的统一论证。本条把它推广到 `head+B^(B^k)`，其中 `k` 是任意正的合法数字：`0<k<base`。这不是逐个列举 `k=1,2,3`，而是一次证明整个参数族。

困难不在算出换底后的自然数。设新底数 `q=base+1`，内层 `B^k` 换底后显然是 `q^k`，外层于是成为 `q^(q^k)`。真正的困难是给 `q^(q^k)-1` 找到合法遗传表示，并证明这个表示的序数值低于原来的 `ω^(ω^k)`。数值可能极大，已经不能依靠“所有指数仍是一个小数字”的有限展开。

# 直觉

本条使用一般自然数遗传编码器来处理借位后的整个尾部。无论 `q^(q^k)-1` 多大，`hereditaryNatEncode q` 都能把它写成新底数 `q` 下的合法遗传表达式，并保证求值仍是这个自然数。这样，数值正确性不再依赖手工列出长达 `q^k` 层的借位展开。

序数下降分成两道严格不等式。第一道由编码器的严格保序性和精确幂秩给出：因为 `q^(q^k)-1<q^(q^k)`，借位尾部的序数值小于 `ω^(q^k)`。第二道比较指数：`q^k` 仍是有限序数，而正指数保证 `ω≤ω^k`，所以 `q^k<ω^k`；序数 `ω` 幂对指数严格递增，因而 `ω^(q^k)<ω^(ω^k)`。两道不等式接起来就是需要的下降。

# 陈述（自然语言）

固定原底数 `base≥2`，选择正整数 `k` 且 `k<base`，再选择一个在原底数下合法的任意头部 `head`。源表达式是 `head+B^(B^k)`。把底数升为 `q=base+1` 后再减一，其数值是 `head` 在 `q` 下的值加上 `q^(q^k)-1`。

定理构造的新表达式保留同一个 `head`，并用 `hereditaryNatEncode q` 重编码尾部 `q^(q^k)-1`。结论同时保证五件事：源表达式合法；Goodstein 数值公式正确；新表达式在 `q` 下合法；新表达式确实求值为该 Goodstein 单步结果；新表达式的 `omegaValue` 严格小于源表达式的 `omegaValue`。

# 陈述（Lean 对照）

`HereditaryPowerExponentBorrowForm base` 保存 `base_ge_two`、参数 `exponent`、正性和合法数字证书，以及任意合法 `head`。`exponentExpression` 是内层 `.basePow (.digit exponent)`，`expression` 再把它放入外层 `.basePow`，因此语法树准确对应 `head+B^(B^k)`，没有把两个指数层压成自然数幂。

`borrowedTail` 令 `q=base+1`，调用 `hereditaryNatEncode q` 编码 `q^(q^exponent)-1`；`borrowedExpression` 把该尾部接回 `head`。公开定理 `hereditaryPowerExponent_goodstein_borrow_descent` 的五个合取依次对应源合法性、换底减一的数值、新表示合法性、新表示求值正确和序数严格下降。

# 思维脉络（thinking trace）

第一步先检查源指数协议。数字叶子 `k` 合法是因为结构中保存了 `k<base`；内层 `B^k` 在新底数下求值为 `q^k`；把底数换成 `ω` 后，它的值则是本库的 `ordinalPow ω k`。这一步把“自然数求值”和“序数解释”明确分开，避免在双层幂中混淆两种指数。

第二步调用一般遗传编码器。编码器的合法性—求值定理直接说明借位尾部在新底数下合法并等于 `q^(q^k)-1`。第三步处理序数界：`hereditaryNatEncode_lt_power_omegaValue` 把自然数不等式转成 `omegaValue<ω^(q^k)`；`natPower_lt_omegaPower` 再证明有限指数 `q^k<ω^k`；最后 `omegaPow_lt_omegaPow_iff` 把指数不等式提升到外层幂。头部两边完全相同，使用序数左加法保持严格不等式即可。

# 自然语言 ↔ Lean 映射

“`k` 是正的合法数字”对应 `exponent_positive` 与 `exponent_valid`；“内层 `B^k`”对应 `exponentExpression`；“升底后指数为 `q^k`”对应私有引理 `exponentProtocol` 的第二项；“任意大借位结果也能重编码”对应 `hereditaryNatEncode_valid_eval`。

“编码值低于 `ω^(q^k)`”对应 `hereditaryNatEncode_lt_power_omegaValue`，这一步直接调用 `HereditaryNatPowerRank` 提供的精确幂秩桥；“从 `q^k<ω^k` 推到外层幂下降”对应 `omegaPow_lt_omegaPow_iff.mpr`，它直接来自 `OrdinalPowerBridge`。因此两座新桥都实际进入证明链，而不是只被导入或在说明文字中提及。

# 依赖（人话版）

一般自然数遗传编码提供两类基础事实：任何自然数都能在底数 `q≥2` 下合法编码并保持求值；固定底数时，更大的自然数编码成更大的序数。`HereditaryNatPowerRank` 又精确计算 `q^m` 的编码秩是 `ω^m`，使自然数的严格前驱关系能够变成所需的序数上界。

`OrdinalPowerBridge` 证明本库递归定义的 `ordinalPow` 与 mathlib 序数幂一致，并给出 `ω` 幂的指数比较接口。mathlib 的 `natCast_lt_omega0` 说明每个自然数序数都小于 `ω`，`opow_le_opow_right` 则用于证明正整数 `k` 时 `ω≤ω^k`。公开结论仍以本库的遗传表达式、Goodstein 单步和 `ordinalPow` 表述。

# 应用与陷阱

本条首次允许借位后的巨大自然数由一般编码器整体重建，因此比固定 `B¹` 的条目更接近一般 Goodstein 论证。它可直接覆盖每个 `base≥2`、每个 `0<k<base` 和每个合法复合头部，而不需要为不同的 `k` 重新编写借位展开。

边界必须保留：这里的 `k` 仍是原底数下的单个合法数字，指数语法精确为 `B^k`。定理没有处理指数中的加法、乘法、任意遗传编码或更高幂塔，也没有证明每个 Goodstein 表达式都属于这个子类。因此它既不是任意复合遗传指数的借位定理，也不是完整 Goodstein 下降或 Goodstein 终止定理。
