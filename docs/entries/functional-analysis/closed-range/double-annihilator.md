---
id: functional-analysis.closed-range.double-annihilator
kind: theorem
state: verified
title: 闭值域的双零化子与对偶闭性
premises: [functional-analysis.closed-range, functional-analysis.weak-star.banach-dieudonne]
mathlib: [Submodule.topologicalClosure, StrongDual.polarSubmodule, WeakDual.eval_continuous]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

对偶算子核中的函数全部消去原算子的值域。反过来，被这些函数全部消去的向量，
一般只能确定属于值域的拓扑闭包。值域闭时，闭包可以去掉，这就是闭值域的双零化子形式。

# 教材概念与正式承载

原值域使用 `T.range : Submodule ℝ F`，闭包使用 `T.range.topologicalClosure`。
对偶核使用 `(dualOperator T).ker`。“共同零点”直接展开为
`∀ f ∈ (dualOperator T).ker, f y = 0`，不建立新的 preannihilator 包装。

# 陈述（自然语言）

任意连续线性算子的值域闭包，精确是对偶算子核的共同零点。值域闭时，
原值域本身就等于这个共同零点集。此时对偶值域等于原核的连续零化子，
所以它同时在范数拓扑和弱星拓扑中闭。

# 陈述（Lean 对照）

闭包刻画是 `mem_range_topologicalClosure_iff_forall_dualOperator_ker`；闭值域版是
`mem_range_iff_forall_dualOperator_ker`。对偶值域的范数闭性和弱星闭性分别是
`dualOperator_range_isClosed_of_isClosed_range` 与
`dualOperator_range_isWeakStarClosed_of_isClosed_range`。

# 证明思路

先用已有双零化子闭包定理 `mem_topologicalClosure_iff_forall_annihilator`，再代入
`ker T' = (range T)⊥`。值域闭时，`topologicalClosure_minimal` 把闭包收回原值域。
对偶值域的两种闭性则由 `range T' = (ker T)⊥` 化约到连续零化子：范数拓扑中它是
求值核的交，弱星拓扑中它也是弱星连续求值核的交。

# 自然语言 ↔ Lean 映射

- 值域闭包：`T.range.topologicalClosure`。
- 对偶核：`(dualOperator T).ker`。
- 范数闭的对偶值域：`IsClosed ((dualOperator T).range : Set (StrongDual ℝ E))`。
- 弱星闭的对偶值域：将该子空间用 `weakStarImage` 送入 `WeakDual ℝ E`后为闭集。
- 弱星连续求值：`WeakDual.eval_continuous`。

# 应用与边界

本条增强了闭值域的必要后果，但仍没有证明“`range T'` 范数闭反推 `range T` 闭”，
也没有声称对偶算子的值域闭与原值域闭的完整四项等价。弱星闭性使用的是
`WeakDual` 拓扑，不得与 `StrongDual` 的范数闭性混同。
