---
id: real-analysis.measure.tonelli
family: real-analysis.measure.tonelli
variant: generated
kind: theorem
state: verified
title: "Tonelli 定理"
premises: ["real-analysis.measure.product-measure", "real-analysis.measure.lintegral"]
mathlib: ["MeasureTheory.lintegral_prod", "MeasureTheory.lintegral_prod_symm"]
provenance: {source_type: book, ref: "folland-real-analysis-1999"}
---

# 陈述

若 `f : α × β → ℝ≥0∞` 几乎处处可测，则

\[
\int f\,d(\mu\times\nu)
=\int_\alpha\!\left(\int_\beta f(x,y)\,d\nu(y)\right)d\mu(x).
\]

若两个测度都满足 `SFinite`，两个变量的次序也可以交换。

# 思维脉络

Tonelli 处理非负函数，因此积分允许取 `∞`，不需要预先假设可积。证明从示性函数的
矩形公式出发，扩展到非负简单函数，再借单调收敛定理扩展到所有非负可测函数。
Lean 中 `∫⁻` 是 `lintegral`，值域 `ℝ≥0∞` 正好保留无穷值。

# 使用边界

对有正负号的一般实值函数，不能仅凭可测性交换积分；应证明绝对可积并使用 Fubini。

# 公理依赖

由公理审计脚本读取 Lean 内核结果。
