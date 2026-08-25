---
id: settheory.googology.hereditary-natural-power-rank
kind: theorem
state: verified
title: "底数幂的遗传编码具有精确序数秩"
premises: ["settheory.googology.hereditary-natural-encoding-strict-order"]
mathlib: ["Nat.mul_div_left", "Nat.mul_mod_left"]
provenance: {source_type: derived, ref: "Finite omega-power rank of corrected hereditary encoding"}
---

# 动机

一般 Goodstein 借位需要比较“某个较小指数的遗传编码”与“借位前的底数幂”。上一条全局保序定理只能把自然数不等式变成两个编码序数之间的不等式；若不知道 `q^k` 的编码究竟是哪个序数，比较仍然无法与本库幂运算 `ordinalPow` 对接。本条正是补上这座精确的桥。

# 直觉

在底数 `q` 下，`q^k` 的普通表示是数字 `1` 后跟 `k` 个零。修正后的 Horner 编码每向右读取一个零，序数解释就在左边再乘一个 `ω`。因此从 `1` 的序数值 `1` 出发，依次得到 `ω`、`ω²`、`ω³`等。关键是这里不能把左乘与右乘随意交换；证明只在有限 `ω` 幂这个精确族上建立所需等式。

# 陈述（自然语言）

固定自然数底数 `q≥2` 和任意自然数 `k`。用修正后的遗传自然数编码器表示 `q^k`，再将表达式中的底数解释为 `ω`，所得序数精确等于本库 `ordinalPow ω k`。作为直接推论，若 `n<q^k`，则 `n` 的遗传编码序数严格小于 `ordinalPow ω k`。

# 陈述（Lean 对照）

`hereditaryNatEncode_power_omegaValue q hq k` 给出等式 `(hereditaryNatEncode q hq (q^k)).omegaValue = ordinalPow Ordinal.omega0 (k : Ordinal)`。`hereditaryNatEncode_lt_power_omegaValue hq hn` 把前一条等式与编码的全局严格保序性组合，得到 `n<q^k` 时的严格上界。两个公开结论都使用本库 `ordinalPow`，不将 mathlib 原生幂作为对外接口。

# 思维脉络（thinking trace）

证明对 `k` 归纳。`k=0` 时，`q^0=1<q`，所以商为零、余数为一，精确编码方程给出序数值 `1=ω^0`。归纳步先用 `q^(k+1)/q=q^k` 与 `q^(k+1)%q=0` 化简商余方程，得到 `ω·ω^k`。然后另对有限指数归纳，使用 `ordinalPow_succ` 和乘法结合律证明 `ω·ω^k=ω^(k+1)`。最后，较小输入的上界由全局严格保序性直接得到。

# 自然语言 ↔ Lean 映射

“商是 `q^k`”对应内部引理 `nat_pow_succ_div_self`；“余数是零”对应 `nat_pow_succ_mod_self`；“每读一个零左乘 `ω`”对应 `hereditaryNatEncode_omega_equation`；“有限 `ω` 幂上左乘一次就使指数加一”对应内部引理 `omega_mul_ordinalPow_omega_nat`；“较小的自然数对应较小序数”对应 `hereditaryNatEncode_omega_strictMono`。

# 依赖（人话版）

本条依赖遗传编码的精确商余序数方程和全局严格保序定理。自然数端使用乘法整除与取余的标准性质；序数端使用本库 `ordinalPow_zero`、`ordinalPow_succ` 和 `ordinalMul` 的实现桥。底数条件 `q≥2` 既保证编码器递归合法，也保证基础情形中 `1<q`。

# 应用与陷阱

第二个公开接口正是后续通用借位所需的指数上界：它可以把 `n<q^k` 变成 `encode(n).omegaValue<ω^k`。但本条没有构造“幂减一”的遗传展开，也没有证明该展开在换底后的数值正确性。因此它不是一般 Goodstein 下降定理，更不是 Goodstein 终止或 PA 不可证性结论。另外，序数乘法不交换，不得把本证明中对有限 `ω` 幂的专门归纳替换成任意因子的交换律。
