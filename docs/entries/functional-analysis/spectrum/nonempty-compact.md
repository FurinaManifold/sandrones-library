---
id: functional-analysis.spectrum.nonempty-compact
family: functional-analysis.spectrum
variant: complex-banach-algebra
kind: theorem
state: verified
title: 复 Banach 代数的谱非空、紧致与谱半径公式
summary: 非零复 Banach 代数中谱的非空紧致性、范数界、半径取到与 Gelfand 公式
premises: [functional-analysis.spectrum.definition]
mathlib: [spectrum.nonempty, spectrum.isCompact, spectrum.norm_le_norm_of_mem, spectrum.exists_nnnorm_eq_spectralRadius, spectrum.gelfand_formula]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 谱半径定理

设 `A` 是带单位的非零复 Banach 代数，`a : A`。Mathlib 中的谱仍是
`spectrum ℂ a = {z | z·1-a 不可逆}`，没有另造谱 carrier。教材 Theorem 5.2.7 对非零复 Banach
空间上的有界算子陈述

`σ(a) ≠ ∅`，且 `limₙ ‖aⁿ‖^(1/n) = sup_{z∈σ(a)} ‖z‖ ≤ ‖a‖`。

本条采用 Mathlib 更一般的复 Banach 代数版本。有界算子代数 `E →L[ℂ] E` 是它的直接实例。

# 假设为什么不能隐藏

`[Nontrivial A]` 对应教材的“非零空间”。若允许零环，则其中的零元同时也是单位，所有
`z·1-a` 都可逆，谱为空。因此非空性和“半径由谱点达到”必须显式要求非平凡性；紧致性和范数界
本身不依赖这个假设。

`[NormOneClass A]` 固定 `‖1‖ = 1`，所以 Neumann 级数给出精确闭球界 `‖z‖ ≤ ‖a‖`，而不是
带额外因子 `‖1‖` 的版本。

# 三段数学内容

1. **有界与紧致。** 若 `‖a‖ < ‖z‖`，Neumann 级数使 `z·1-a` 可逆，故谱包含于
   `Metric.closedBall 0 ‖a‖`。可逆元集合开，因此谱闭；在有限维标量域 `ℂ` 中闭且有界即紧。
2. **非空。** Mathlib 的 `spectrum.nonempty` 使用与 Salamon 第 212 印刷页相同的 Liouville
   思路：若谱为空，预解映射在整个复平面上全纯并在无穷远趋零，因而恒为零，与预解元可逆矛盾。
3. **谱半径。** 非空紧谱上的连续范数取得最大值，所以定义为上确界的
   `spectralRadius ℂ a : ℝ≥0∞` 实际由某个谱点达到。Gelfand 公式进一步把它识别为
   `(‖aⁿ‖₊ : ℝ≥0∞)^(1/n)` 的极限。

# Lean 对照

- `complexSpectrum_nonempty`：谱非空；
- `complexSpectrum_isCompact`：谱紧致；
- `norm_spectrum_le`：逐点范数界；
- `spectralRadius_le_nnnorm`：谱半径范数界；
- `exists_spectrum_nnnorm_eq_spectralRadius`：谱半径由谱点达到；
- `tendsto_nthRoot_nnnorm_pow_spectralRadius`：Gelfand 公式。

# 总函数约定

Gelfand 公式的序列从 `n = 0` 开始，指数写成实数 `1 / n`。Lean 在零处分母采用总函数约定；
这只改变有限个首项，不影响 `atTop` 极限。本条保留 Mathlib 的 `ℝ≥0∞` carrier，不另造实值谱半径。

# 证明角色与边界

Mathlib 已包含 Liouville 论证、紧致性和 Gelfand 公式的成熟分析核心，本库不复制这些长证明。
本条的角色是明确教材假设、解释 carrier 和总函数约定，并提供从谱定义到后续紧算子谱论所需的
稳定接口。它不声称紧算子的非零谱点都是特征值；该内容属于 F6.4。
