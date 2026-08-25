---
id: settheory.googology.goodstein-base-power-one-borrow
kind: theorem
state: verified
title: "Goodstein 首个借位形：将底数一次幂展开为有限末项"
premises: ["settheory.googology.goodstein-positive-tail-no-borrow", "settheory.googology.goodstein-ordinal-measure"]
mathlib: ["Ordinal.natCast_lt_omega0", "add_lt_add_iff_left"]
provenance: {source_type: paper, ref: "goodstein-restricted-ordinal-1944"}
---

# 动机

正数字末项的无借位定理不能处理末位数字为零的情形。最简单的真实借位出现在表达式 `P+B¹` 中：它在升底后减一时，不能把零末位直接变成“负一”，而必须从底数一次幂借出一个单位。本条精确实现这个最小借位步骤。

# 直觉

设原底数是 `b`，表达式是 `P+B¹`。换到新底数 `b+1` 后，最后一项的值是 `b+1`。再减一得到 `b`，而 `b` 正好是新底数 `b+1` 下的一个合法数字。因此新表达式可明确写成 `P+b`，不需借助未实现的通用正规化器。

# 陈述（自然语言）

对底数至少为二、头部 `P` 在该底数下合法的表达式 `P+B¹`，其 Goodstein 换底减一值等于 `P` 在新底数下的值加 `b`。表达式 `P+b` 是该值在新底数下的合法重编码，且其 `ω` 度量严格小于原表达式的 `ω` 度量。

# 陈述（Lean 对照）

`BasePowerOneTailBorrowForm base` 携带 `base_ge_two`、头部 `head` 及 `head_valid`。`expression` 是 `.add head (.basePow (.digit 1))`，`borrowedExpression` 是 `.add head (.digit base)`。`basePowerOneTail_goodstein_borrow_descent` 证明五项结论：源表达式合法、换底减一公式、借位展开合法、展开求值正确，以及序数度量严格下降。

# 思维脉络（thinking trace）

首先由 `2≤b` 推出指数数字 `1` 在底数 `b` 下合法。然后对头部表达式做结构归纳，证明原底数下合法的每个数字在新底数下仍合法。自然数端直接计算 `(b+1)¹-1=b`。序数端先由本库序数幂的后继方程算出 `ω¹=ω`，再使用有限序数 `b<ω` 以及序数加法对右参数的严格单调性。

# 自然语言 ↔ Lean 映射

“底数一次幂”对应 `.basePow (.digit 1)`；“借出一位”对应将该子树改写成 `.digit base`；“新数字合法”对应 `base < base+1`；“有限末项小于无限末项”对应 `Ordinal.natCast_lt_omega0 base`；“加上相同头部后仍严格小于”对应 `add_lt_add_iff_left`。

# 依赖（人话版）

本条依赖已定义的 Goodstein 换底减一、遗传表达式的有限底数求值与 `ω` 解释，以及本库的序数加法、乘法和幂。mathlib 仅在证明后端提供“任意有限序数小于 `ω`”和序数加法的严格单调性。

# 应用与陷阱

本条是一个真正的借位桥：它不再假设末尾已有可减的正数字，而是显式拆开 `B¹`。但它只处理系数为一、指数为一的末项；它不覆盖 `Bᵉ` 中任意指数的展开、多层连锁借位或通用 Cantor 正规形借位。因此不得由此声称一般 Goodstein 单步下降，更不得声称 Goodstein 序列存在或终止。
