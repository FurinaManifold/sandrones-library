---
id: settheory.googology.goodstein-base-power-two-borrow
kind: theorem
state: verified
title: "Goodstein 高幂借位：底数平方的显式展开"
premises: ["settheory.googology.goodstein-base-power-one-borrow", "settheory.googology.goodstein-ordinal-measure"]
mathlib: ["Ordinal.mul_succ", "Ordinal.natCast_lt_omega0", "mul_lt_mul_of_pos_left"]
provenance: {source_type: paper, ref: "R. L. Goodstein, On the Restricted Ordinal Theorem, 1944"}
---

# 动机

对 `B¹` 的借位只会产生一个有限数字。当末项上升为 `B²` 时，减一后的展开已经包含一个新的底数幂项，因而更接近 Goodstein 证明中真正的多位借位。本条不跳到任意指数，而是完整形式化平方这个第一个高幂实例。

# 直觉

设升底后的新底数为 `q=b+1`。普通算术恒等式给出 `q²-1=q·b+b`。因此 `P+B²` 换底减一后可重写成 `P+(B·b+b)`，其中右边的 `B` 现在指新底数 `q`，两个 `b` 都是小于 `q` 的合法数字。

# 陈述（自然语言）

对底数 `b≥3` 以及在该底数下合法的复合头部 `P`，表达式 `P+B²` 在换到底数 `b+1` 并减一后，可显式重编码为 `P+(B·b+b)`。该重编码在新底数下合法且求值正确；它的 `ω` 度量严格小于原表达式的 `ω` 度量。

# 陈述（Lean 对照）

`BasePowerTwoTailBorrowForm base` 携带 `base_ge_three`、`head` 和 `head_valid`。`expression` 构造 `head + B²`；`borrowedExpression` 构造 `head + (B·base+base)`。`basePowerTwoTail_goodstein_borrow_descent` 证明源表达式合法、换底减一的数值公式、目标表达式合法、目标求值正确和序数度量严格下降。

# 思维脉络（thinking trace）

第一步用 `3≤b` 确保指数叶子 `2` 在底数 `b` 下合法。第二步证明头部在更大底数下仍合法，并通过 `q²=(q·b+b)+1` 验证减一后的显式展开。序数端先计算 `ω²=ω·ω`，再将目标末尾化为 `ω·b+b`；最后分两步比较 `ω·b+b < ω·(b+1) < ω·ω`。

# 自然语言 ↔ Lean 映射

“底数至少为三”对应 `base_ge_three`；“底数平方”对应 `.basePow (.digit 2)`；“借位展开”对应 `.add (.mul (.basePow (.digit 1)) (.digit base)) (.digit base)`；“有限末项小于 `ω`”对应 `Ordinal.natCast_lt_omega0`；“左乘正序数保持严格不等式”对应 `mul_lt_mul_of_pos_left`。

# 依赖（人话版）

本条建立在已有的带证书 Goodstein 状态思路、借位一次幂示例和 `ω` 度量之上。序数计算使用本库公开的 `ordinalAdd`、`ordinalMul` 和 `ordinalPow`；mathlib 仅为证明后端提供序数乘法后继公式、有限序数小于 `ω` 以及正左因子下的严格单调性。

# 应用与陷阱

本条可处理任意合法复合头部加一个底数平方末项，是比 `B¹` 借位更完整的局部模型。底数下界不能忽略：底数二下的指数 `2` 不能直接作为合法数字叶子，而必须再写成遗传二进制表达式。本条也不处理 `Bᵉ` 的任意遗传指数、更高系数、连锁借位或一般 Goodstein 序列，因此不得由此声称一般下降或终止。
