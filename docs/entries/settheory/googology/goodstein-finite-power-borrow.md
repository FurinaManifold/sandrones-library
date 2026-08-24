---
id: settheory.googology.goodstein-finite-power-borrow
kind: theorem
state: verified
title: "Goodstein 有限指数借位：递归展开底数幂减一"
premises: ["settheory.googology.goodstein-base-power-two-borrow", "settheory.googology.goodstein-ordinal-measure"]
mathlib: ["Ordinal.opow_mul_add_lt_opow", "Ordinal.natCast_lt_omega0"]
provenance: {source_type: paper, ref: "R. L. Goodstein, On the Restricted Ordinal Theorem, 1944"}
---

# 动机

只分别处理 `B¹`、`B²`、`B³` 会不断重复同一种证明，也看不出借位展开的统一规律。本条改为一次定义全部有限数字指数：对每个满足 `0<k<base` 的 `k`，递归构造新底数下 `q^k-1` 的遗传表达式，并统一证明它的求值、合法性和序数上界。

# 直觉

令新底数 `q=base+1`，因而 `base=q-1` 是新底数下最大的数字。借位恒等式是 `q^(j+1)-1=q^j·base+(q^j-1)`。它每次取出一个系数为 `base` 的最高项，然后递归展开剩余的 `q^j-1`。例如 `q³-1` 展开为 `q²·base + q·base + base`。

# 陈述（自然语言）

`finitePowerBorrowExpansion base k` 是新底数 `base+1` 下 `(base+1)^k-1` 的递归展开。它对任意 `k≤base` 都是合法表达式，求值正好等于所声称的幂减一，而其 `ω` 解释严格小于 `ω^k`。因此，对带任意合法头部的 `head+B^k`，用该展开重编码换底减一的结果，其数值正确且序数度量严格下降。

# 陈述（Lean 对照）

`finitePowerBorrowExpansion` 在零指数时返回 `.zero`，在 `k+1` 时构造 `B^k·base + expansion k`。`FinitePowerBorrowForm` 用 `exponent_positive` 和 `exponent_valid` 证书限制 `0<k<base`。`finitePowerBorrowExpansion_eval`、`finitePowerBorrowExpansion_valid` 和 `finitePowerBorrowExpansion_omega_lt` 分别建立递归展开的三项核心性质；`finitePower_goodstein_borrow_descent` 将它们组装成完整单步定理。

# 思维脉络（thinking trace）

求值证明对 `k` 归纳：后继步使用 `q^(k+1)=q^k·(base+1)`，将它减一分成 `q^k·base` 与已知的 `q^k-1`。合法性归纳使用 `k≤base`：当前指数叶子小于新底数，系数 `base` 也小于 `base+1`。序数证明的后继步为 `ω^k·base+E_k<ω^(k+1)`，其中归纳假设是 `E_k<ω^k`，而有限系数满足 `base<ω`。

# 自然语言 ↔ Lean 映射

“展开 `q^k-1`”对应 `finitePowerBorrowExpansion base k`；“取出一个最高项”对应 `.mul (.basePow (.digit k)) (.digit base)`；“有限数字指数”对应 `exponent_valid : exponent < base`；“展开序数低于原幂”对应 `finitePowerBorrowExpansion_omega_lt`；“相同头部不改变严格比较”对应最终证明中的 `add_lt_add_iff_left`。

# 依赖（人话版）

本条继承前两条的显式借位构造和 Goodstein `ω` 度量，但把固定指数提升为自然数参数。公开定义与定理使用本库的 `ordinalAdd`、`ordinalMul` 和 `ordinalPow`。mathlib 在证明后端提供 `Ordinal.opow_mul_add_lt_opow`，它正好将“最高 Cantor 项系数低于 `ω`”和“余项低于该最高幂”合成严格上界。

# 应用与陷阱

本条不再是 `B³` 之类的单个算例，而是覆盖全部 `0<k<base` 的统一定理。但这个限制必须保留：当 `k≥base` 时，`.digit k` 不是合法的单个数字，指数必须自身以遗传形式展开。本条没有建立这种任意遗传指数的借位，也没有处理任意系数正规形、一般 Goodstein 单步或序列终止。
