---
id: functional-analysis.dual-operator.definition
kind: definition
state: staging
title: 连续线性算子的对偶算子
premises: [functional-analysis.operator.space, functional-analysis.bidual.reflexive]
mathlib: [ContinuousLinearMap.precomp, StrongDual]
provenance: {source_type: book, ref: "Bühler–Salamon, Functional Analysis, Section 4.1"}
---

# 动机

算子 `T : E → F` 不仅把向量向前送，也能把 `F` 上的标量观测反向拉回到 `E`。这个反向过程是后续
核、像、闭值域和 Fredholm 理论的基本语言。

# 教材定义与正式承载

对 `T : E →L F`，对偶算子 `T' : F* →L E*` 定义为 `T'(f)=f∘T`。当前 Mathlib 没有
`ContinuousLinearMap.dualMap` 专名，但 `ContinuousLinearMap.precomp` 已把“用固定连续线性映射预复合”
打包为连续线性映射。因此本库的 `dualOperator T` 只是 `T.precomp ℝ` 的教材具名桥。

# 陈述（自然语言）

`(T'f)(x)=f(Tx)`。它满足 `‖T'f‖ ≤ ‖T‖‖f‖` 及 `‖T'‖ ≤ ‖T‖`。复合的对偶反转次序：
`(S∘T)'=T'∘S'`；恒等算子的对偶仍是恒等算子。

# 陈述（Lean 对照）

对偶算子定义、求值展开、逐泛函范数估计、算子范数估计、复合反序与恒等对应 `dualOperator`、
`dualOperator_apply`、`norm_dualOperator_apply_le`、`norm_dualOperator_le`、
`dualOperator_comp` 与 `dualOperator_id`。

# 思维脉络

预复合直接给出求值公式和复合反序。连续线性映射的复合范数不等式给出 `‖f∘T‖ ≤ ‖f‖‖T‖`，再对所有
`f` 取算子范数上界，得到 `‖T'‖ ≤ ‖T‖`。

# 自然语言 ↔ Lean 映射

- 原算子：`T : E →L[ℝ] F`。
- 对偶空间：`StrongDual ℝ E`、`StrongDual ℝ F`。
- 对偶算子：`dualOperator T : StrongDual ℝ F →L[ℝ] StrongDual ℝ E`。
- Mathlib 证明后端：`T.precomp ℝ`。

# 依赖

依赖 F1 连续线性映射与算子范数，以及 F2 的连续对偶语言。后续闭值域与紧算子条目可以直接使用本定义。

# 应用与边界

对偶算子不是 Hilbert 空间上的伴随算子：它适用于一般赋范空间，反转的是对偶配对，而伴随算子依赖内积与
Riesz 表示把对偶重新识别为原空间。本条尚未证明 `‖T'‖=‖T‖`，也不声称对偶算子保持满射或紧性。
