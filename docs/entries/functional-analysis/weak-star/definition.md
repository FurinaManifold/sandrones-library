---
id: functional-analysis.weak-star.definition
kind: definition
state: staging
title: 对偶空间的弱星拓扑与收敛
premises: [functional-analysis.weak-topology.definition, functional-analysis.bidual.reflexive]
mathlib: [WeakDual, StrongDual.toWeakDual, WeakDual.eval_continuous]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

对偶空间 `E*` 同时有两种自然的弱化拓扑。把它视为一个普通赋范空间会用全部 `E**` 测试收敛；
记住它是 `E` 的对偶，则只用原空间向量产生的求值泛函测试收敛。后者就是弱星拓扑。

# 教材定义与正式承载

弱星拓扑是 `E*` 上使所有求值映射 `f ↦ f(x)`（`x ∈ E`）连续的最弱拓扑。Mathlib 以
`WeakDual ℝ E` 承载该拓扑，并以 `StrongDual.toWeakDual` 给出从范数对偶到弱星对偶的底层线性恒等。
本库不建立第二个弱星拓扑谓词或结构。

# 陈述（自然语言）

每个向量求值映射在弱星拓扑下连续。一个对偶网弱星收敛当且仅当它在 `E` 的每个向量上逐点收敛。
对偶范数收敛蕴含弱星收敛；对偶空间自身的弱收敛也蕴含弱星收敛。

# 陈述（Lean 对照）

求值连续、逐点收敛判据、对偶范数收敛蕴含弱星收敛，以及对偶弱收敛蕴含弱星收敛，分别对应
`weakStar_evaluation_continuous`、`weakStar_tendsto_iff_forall`、
`dual_norm_tendsto_implies_weakStar` 与 `dual_weak_tendsto_implies_weakStar`。

# 思维脉络

`WeakDual` 是求值映射到函数空间所诱导的拓扑，所以其收敛判据是在每个 `x ∈ E` 上逐点收敛。
范数收敛使每个固定 `x` 上的求值收敛。若已知 `E*` 上的弱收敛，则可对双对偶中的典范求值元
`J(x)` 应用弱收敛判据，得到弱星收敛。

# 自然语言 ↔ Lean 映射

- 范数对偶：`StrongDual ℝ E`。
- 弱星对偶：`WeakDual ℝ E`。
- 底层恒等：`StrongDual.toWeakDual`。
- 弱星收敛：`Tendsto` 到 `WeakDual ℝ E` 的邻域滤子。
- 对偶空间的弱拓扑：`WeakSpace ℝ (StrongDual ℝ E)`。

# 依赖

依赖 F4.1 弱收敛判据和 F2 的典范双对偶嵌入。本条为 Banach–Alaoglu 中“对偶闭单位球在弱星拓扑下紧”
提供正式类型语言。

# 应用与边界

弱星拓扑一般比 `E*` 自身的弱拓扑更弱；当 `E` 自反时，典范嵌入满射，两种测试族才一致。本条只证明
一般情形的单向收敛蕴含，不提前证明自反时的拓扑等同，不证明 Banach–Alaoglu，也不声称弱星紧等于范数紧。
