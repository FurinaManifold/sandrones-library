---
id: analysis.asymptotic.stirling
kind: theorem
state: verified
title: "Wallis 乘积与 Stirling 公式"
premises: ["analysis.limits.asymptotic", "analysis.constants.pi-definition", "analysis.constants.e-definition"]
mathlib: ["Real.tendsto_prod_pi_div_two", "Stirling.factorial_isEquivalent_stirling", "Stirling.le_factorial_stirling", "Stirling.le_log_factorial_stirling"]
provenance:
  source_type: book
  ref: "数学分析 II：Wallis 公式与 Stirling 公式"
---

# 动机

阶乘增长快于任意固定次数的幂，但仅知道“增长很快”不足以进行精确估计。Stirling
公式同时给出指数主项、幂次修正和常数因子，是级数、概率论、组合数学以及数值分析
反复使用的基本工具。Wallis 乘积则解释了常数 `π` 为什么会出现在阶乘渐近式中。

# 陈述

Wallis 乘积满足

\[
\prod_{i=0}^{k-1}
\frac{2i+2}{2i+1}\frac{2i+2}{2i+3}\longrightarrow\frac{\pi}{2}.
\]

并且

\[
n!\sim \sqrt{2\pi n}\left(\frac ne\right)^n.
\]

此外，Stirling 主项对每个自然数都是 `n!` 的下界；对正整数取对数可得

\[
n\log n-n+\frac12\log n+\frac12\log(2\pi)\leq\log(n!).
\]

# 证明路线

经典路线先研究归一化序列
`n! / (√(2n) (n/e)ⁿ)`，证明它收敛到某个正数；再把该极限代入 Wallis 乘积，
由 Wallis 极限 `π/2` 确认未知常数恰为 `√π`。整理归一化等式后就得到
`√(2πn)` 形式的 Stirling 公式。

Mathlib 已完整实现这条证明链。本条目将其提升为本库的教材接口，并同时公开两个
实用的全局下界。下界不是渐近符号的直接改写：它对每个 `n` 都有效；对数版本再利用
对数的单调性以及乘积、幂和平方根的对数公式展开得到。

# Lean 对照

- `wallis_product`：Wallis 有限乘积趋于 `π/2`；
- `factorial_isEquivalent_stirling`：`Asymptotics.IsEquivalent` 形式的 Stirling 公式；
- `stirling_lower_bound`：所有自然数上的阶乘下界；
- `log_factorial_stirling_lower`：正整数上的对数下界。

# 边界与用法

渐近等价给出充分大 `n` 时的双边相对误差控制，但不自动给出任意固定 `n` 的同向
不等式；需要全局估计时应调用后两个定理。当前条目尚未登记 Robbins 型显式误差
`1/(12n)`；它可作为后续更精细的数值估计条目。

# 公理依赖

由注册审计脚本从四个 Lean 定理统一读取并记录。
