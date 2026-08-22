---
id: real-analysis.measure.fubini
family: real-analysis.measure.fubini
variant: generated
kind: theorem
state: verified
title: "Fubini 定理"
premises: ["real-analysis.measure.tonelli", "real-analysis.measure.dominated-convergence"]
mathlib: ["MeasureTheory.integral_prod", "MeasureTheory.integral_integral_swap"]
provenance: {source_type: book, ref: "实分析：Fubini 定理"}
---

# 陈述

若 Banach 空间值函数 `f` 在乘积测度下可积，则乘积积分等于迭代积分，并且两个迭代
积分的次序可以交换。

# 思维脉络

`Integrable f (μ.prod ν)` 同时包含强可测性和范数的有限积分。Tonelli 应用于 `‖f‖`
后保证几乎每条截面可积，也保证内层积分形成可积函数；随后分别处理正负部分（或在
Bochner 框架中用可积函数逼近）即可得到 Fubini 等式。

Lean 中二元柯里化函数 `f : α → β → E` 通过 `Function.uncurry f : α × β → E`
表达乘积空间上的可积性。`fubini_swap` 的结论正是教材中的交换积分次序公式。

# 使用边界

若只知道两种迭代积分分别存在，通常不足以推出换序；本条目要求乘积空间上的绝对
可积性。非负但可能积分为无穷的情形应使用 Tonelli。

# 公理依赖

由公理审计脚本读取 Lean 内核结果。
