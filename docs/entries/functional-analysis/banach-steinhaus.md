---
id: functional-analysis.banach-steinhaus
kind: theorem
state: staging
title: Banach–Steinhaus 一致有界原理
premises: [functional-analysis.baire.theorem, functional-analysis.operator.space]
mathlib: [banach_steinhaus, ContinuousLinearMap.le_opNorm]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

逐点有界允许控制常数随向量变化，看似比统一控制弱得多。Baire 定理却说明：在 Banach 定义域上，
这种逐点信息已经迫使整个连续线性算子族具有同一个算子范数上界。

# 教材定义与正式承载

算子族直接写成 `g : ι → E →L[ℝ] F`。点态有界保留教材量词
`∀ x, ∃ C, ∀ i, ‖g i x‖ ≤ C`；一致有界写成 `∃ C, ∀ i, ‖g i‖ ≤ C`。两者没有需要命名的额外
数学对象，因此本库不建立点态有界或一致有界包装谓词。

# 陈述（自然语言）

设 `E` 是 Banach 空间，`F` 是赋范空间。若连续线性算子族对每个 `x ∈ E` 都在 `x` 处一致有界，
则存在非负常数 `C`，所有算子的算子范数都不超过 `C`。于是对所有指标 `i` 和向量 `x`，都有
`‖gᵢx‖ ≤ C‖x‖`。

# 陈述（Lean 对照）

分别对应 `uniform_operatorNorm_bound_of_pointwise_bounded` 和
`uniform_apply_bound_of_pointwise_bounded`。

# 思维脉络

按允许的输出大小构造一列闭集；点态有界说明这些闭集覆盖整个定义域。Baire 覆盖形式保证其中一个
闭集有非空内部。线性允许把这块局部统一控制平移、作差并缩放到单位球，从而得到全局算子范数界。

# 自然语言 ↔ Lean 映射

- 连续线性算子族：`g : ι → E →L[ℝ] F`。
- 点态有界：`∀ x, ∃ C, ∀ i, ‖g i x‖ ≤ C`。
- 统一算子范数界：`∀ i, ‖g i‖ ≤ C`。
- 定义域 Banach：`[BanachSpace E]`；值域只需赋范，不要求完备。

# 依赖

依赖 Baire 定理和 F1 已解释的连续线性算子、算子范数基本估计。

# 应用与边界

本条没有假设指标集可数；可数性只出现在证明内部的闭集覆盖。结论不声称算子族在其他拓扑或弱
拓扑下紧致，也不展开更一般的桶空间版本。
