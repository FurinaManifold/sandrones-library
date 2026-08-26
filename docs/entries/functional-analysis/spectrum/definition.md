---
id: functional-analysis.spectrum.definition
family: functional-analysis.spectrum
variant: complex-banach-algebra
kind: definition
state: verified
title: 谱、预解集、预解映射与谱半径
summary: 复 Banach 代数元素的谱论基本对象及其 Mathlib 可逆性承载
premises: [functional-analysis.banach-algebra.foundation]
mathlib: [spectrum, resolventSet, resolvent, spectralRadius, IsUnit]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 谱与预解集

设 `a` 是复 Banach 代数 `A` 的元素。Mathlib 定义

- `resolventSet ℂ a = {z | IsUnit (algebraMap ℂ A z - a)}`；
- `spectrum ℂ a = (resolventSet ℂ a)ᶜ`。

因此教材中的 `zI-a` 由 `algebraMap ℂ A z - a` 精确承载。这里的 `IsUnit` 是环论双边可逆性，
并非只存在左逆或右逆。对于有界算子 `T : E →L[ℂ] E`，同一表达式直接位于连续线性自同态代数
中；本库不建立另一套“算子谱”。

# 预解映射

Mathlib 的 `resolvent a z` 定义为 `Ring.inverse (z·1-a)`。当 `z` 属于预解集时，它等于相应 unit
的逆，并同时满足
`(z·1-a)·resolvent(a,z)=1` 和 `resolvent(a,z)·(z·1-a)=1`。当 `z` 位于谱中时，
`Ring.inverse` 按总函数约定取零；所以涉及真正逆元的公式必须显式携带 `z ∈ resolventSet ℂ a`。

# 谱半径

`spectralRadius ℂ a : ℝ≥0∞` 是 `‖z‖₊` 在 `z ∈ spectrum ℂ a` 上的上确界。使用扩展非负实数可以
在定义层同时容纳空谱和无界谱；后续 Banach 代数定理才会证明相应有限性、非空性和半径公式。

# Lean 对照

- `spectrum_eq_compl_resolventSet`：谱是预解集补集；
- `mem_resolventSet_iff_isUnit`、`mem_spectrum_iff_not_isUnit`：可逆性判据；
- `resolvent_eq_ringInverse`：预解映射的总函数定义；
- `spectralParameter_sub_mul_resolvent`、`resolvent_mul_spectralParameter_sub`：双边逆公式；
- `spectralRadius_eq_iSup_norm`：谱半径定义；
- `operator_mem_resolventSet_iff_isUnit`、`operator_mem_spectrum_iff_not_isUnit`：有界算子实例桥。

# 边界

本条只完成定义与展开桥，不声称谱非空、紧致、预解集开、谱半径有限或 Gelfand 半径公式。这些属于
F6.3；Main 当前仍将 F6.3 以后冻结，因此不能以 Mathlib 已有强定理提前把后续窗口标成完成。
