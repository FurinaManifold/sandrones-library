---
id: functional-analysis.closed-range
kind: theorem
state: verified
title: 闭值域的零化子刻画
premises: [functional-analysis.dual-operator.definition, functional-analysis.subspace.annihilator-closure, functional-analysis.hahn-banach.extension]
mathlib: [ContinuousLinearMap.exists_preimage_norm_le, ContinuousLinearMap.antilipschitz_of_injective_of_isClosed_range, StrongDual.polarSubmodule]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

连续线性算子的值域未必闭。核商 `E/ker T` 消去了值域表示中的非唯一性；
对偶空间中，“在 `ker T` 上恒为零”正是一个对偶函数能否由 `T` 的值域上的函数产生的
代数条件。闭值域定理把这个代数条件与连续性精确联系起来。

# 教材概念与正式承载

算子使用 `T : E →L[ℝ] F`，核和值域直接使用 `T.ker` 与 `T.range`。对偶算子是已登记的
`dualOperator T : StrongDual ℝ F →L[ℝ] StrongDual ℝ E`。连续零化子直接使用
Mathlib `StrongDual.polarSubmodule ℝ S`，由 `mem_continuousAnnihilator_iff` 展开为逐点取零。

# 陈述（自然语言）

对任意连续线性算子，对偶算子的核等于原算子值域的连续零化子，而对偶值域包含于
原核的连续零化子。当 `E` 和 `F` 是 Banach 空间时，`T` 的值域闭，当且仅当
`range (T') = (ker T)⊥`。

# 陈述（Lean 对照）

无条件的核恒等式和值域包含分别是 `dualOperator_ker_eq_range_annihilator` 与
`dualOperator_range_le_ker_annihilator`。闭值域推出等号是
`dualOperator_range_eq_ker_annihilator_of_isClosed_range`，逆向是
`isClosed_range_of_dualOperator_range_eq_ker_annihilator`，充要形式是
`isClosed_range_iff_dualOperator_range_eq_ker_annihilator`。

# 证明思路

正向中，将 `T` 下降为从 `E/ker T` 到 `F` 的单射。闭值域使这张商映射具有反 Lipschitz
估计。因此每个消去 `ker T` 的对偶函数都能连续地定义在 `range T` 上，再由
Hahn--Banach 延拓到 `F`。逆向中，等号使对偶算子到零化子的限制映射满射；
开映射定理给出受控制的原像。对 `E/ker T` 中向量取范数化对偶函数，即得商映射的
反 Lipschitz 估计，从而值域闭。

# 自然语言 ↔ Lean 映射

- 核商：`HasQuotient.Quotient E T.ker`；它只在私有证明后端中使用。
- 零化子：`StrongDual.polarSubmodule ℝ T.ker`，不是新的本库子空间定义。
- 闭值域：`IsClosed (Set.range T)`，拓扑是值域的范数拓扑。
- 受控原像：`ContinuousLinearMap.exists_preimage_norm_le`。
- 商映射下界：`AntilipschitzWith`。

# 应用与边界

本批次精确完成“`range T` 闭 ⇔ `range T' = (ker T)⊥`”及无条件的核/值域零化子关系。
它尚未声称 `range T'` 的范数闭性与 `range T` 闭性等价，也未给出原/对偶的四项闭值域等价或
双零化子全链。这些是 F5.2 后续独立增量，不得从当前定理推测。本文件不使用也不定义 Fredholm 算子。
