---
id: settheory.googology.hereditary-natural-encoding-strict-order
kind: theorem
state: verified
title: "遗传自然数编码的全局严格保序"
premises: ["settheory.googology.hereditary-natural-encoding-same-block-order"]
mathlib: ["Ordinal.mul_succ", "Ordinal.natCast_lt_omega0"]
provenance: {source_type: derived, ref: "pohlers-proof-theory-1989"}
---

# 动机

同商块严格保序只比较最后一位。要让遗传编码真正服务 Goodstein 指数借位，还必须证明当商上升时，前一个商的整个余数区间都低于后一个商块。这是从局部数字比较到全局自然数顺序的关键桥。

# 直觉

修正编码满足 `R(n)=ω·R(n/base)+n%base`。余数永远是有限序数，所以 `ω·a+r < ω·a+ω = ω·succ(a)`。若 `a<b`，则 `succ(a)≤b`，因而左边严格低于 `ω·b+s`。这表明不同商对应的 `ω` 块不会重叠。

# 陈述（自然语言）

固定任意底数 `base≥2`。对所有自然数 `n<m`，修正后的 `hereditaryNatEncode base n` 的 `omegaValue` 严格小于 `hereditaryNatEncode base m` 的 `omegaValue`。换言之，该序数解释是从自然数严格序到序数严格序的严格单调映射。

# 陈述（Lean 对照）

`omega_blocks_strictly_separated` 形式化 `a<b → ω·a+r<ω·b+s`，其中 `r,s` 是自然数。`hereditaryNatEncode_omega_strictMono` 返回 `StrictMono (fun n ↦ encode(n).omegaValue)`，并对较大自然数做强归纳。

# 思维脉络（thinking trace）

证明先把序数部分拆成独立块分离引理：有限余数低于 `ω`，乘法后继方程把一整块的上界改写成 `ω·succ(a)`。然后对 `m` 强归纳。若 `n` 和 `m` 的商相同，调用上一条的余数比较；若商不同，自然数除法的单调性给出商严格上升，归纳假设先比较商的编码，再用块分离引理提升到原数。

# 自然语言 ↔ Lean 映射

“余数低于 `ω`”对应 `Ordinal.natCast_lt_omega0`；“填满当前块”对应 `Ordinal.mul_succ`；“商的编码严格增大”对应强归纳假设 `hrecursive`；“同商”分支对应 `hereditaryNatEncode_omega_lt_of_div_eq`；“全局严格保序”对应 `StrictMono`。

# 依赖（人话版）

本条依赖修正编码的精确 `ω` 方程和同商块比较。mathlib 提供序数乘法的后继方程、有限序数低于 `ω` 以及自然数除法单调性。公开编码和序数解释仍使用本库已定义的遗传语法与 `ordinalAdd/Mul/Pow`。

# 应用与陷阱

该定理提供了后续 `B^(B^k)` 借位协议所需的精确指数比较：对任意 `j<N`，都可将自然数不等式转为其遗传编码 `omegaValue` 的严格不等式。它不等于已完成通用借位：仍需将这些指数编码装入幂减一的递归展开，并证明整个展开的序数界。本条也不声称 Goodstein 终止。
