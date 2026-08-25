---
id: functional-analysis.weak-topology.definition
kind: definition
state: staging
title: 赋范空间的弱拓扑与弱收敛
premises: [functional-analysis.hahn-banach.norming-functional]
mathlib: [WeakSpace, toWeakSpace, toWeakSpaceCLM, WeakSpace.map]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

范数收敛同时控制一个向量的全部方向，往往过强。弱拓扑只要求每个连续线性泛函观测到的标量收敛，
因而保留对偶信息，同时提供更多收敛网与紧性机会。

# 教材定义与正式承载

`E` 的弱拓扑是使所有 `f ∈ E*` 连续的最弱拓扑。Mathlib 的 `WeakSpace ℝ E` 正是在与 `E`
相同的底层向量上，用顶层对偶配对的逐坐标初始拓扑实现这一定义。`toWeakSpace ℝ E`
是原赋范空间与弱拓扑类型之间的线性恒等，`toWeakSpaceCLM` 是从范数拓扑到弱拓扑的连续版本。
本库不再建一个弱拓扑结构。

# 陈述（自然语言）

每个原连续对偶泛函在弱拓扑下仍连续。一个网弱收敛到 `x`，当且仅当它在每个 `f ∈ E*` 上的像收敛到
`f(x)`。范数收敛蕴含弱收敛，连续线性映射保持弱收敛。

# 陈述（Lean 对照）

评价连续、逐对偶收敛判据、范数收敛蕴含弱收敛与映射保持性分别对应
`weak_evaluation_continuous`、`weak_tendsto_iff_forall_dual`、`norm_tendsto_implies_weak` 与
`weak_tendsto_map`。

# 思维脉络

`WeakSpace` 的拓扑是由求值映射到函数空间的 induced topology，所以其收敛正是每个连续线性泛函上的
逐点收敛。Hahn–Banach 保证连续对偶分离点，使该 induced topology 为 Hausdorff。从范数拓扑到弱拓扑的
恒等映射连续，立即给出“范数收敛 推弱收敛”；`WeakSpace.map` 则将连续线性映射在两端都换为弱拓扑。

# 自然语言 ↔ Lean 映射

- 弱拓扑空间：`WeakSpace ℝ E`。
- 连续对偶：`StrongDual ℝ E`。
- 原空间到弱空间：`toWeakSpace ℝ E`、`toWeakSpaceCLM ℝ E`。
- 弱收敛：`Tendsto` 到 `WeakSpace ℝ E` 的邻域滤子。
- 弱化的线性映射：`WeakSpace.map T`。

# 依赖

依赖 F2 中 Hahn–Banach 给出的连续对偶分离点，以及 F1 的连续线性映射。它为下一窗的弱星拓扑和
Banach–Alaoglu 提供类型层语言。

# 应用与边界

弱拓扑通常严格弱于范数拓扑，但本条不声称在每个空间上都严格；有限维时两者相同。本条也不声称弱收敛
推出范数收敛，不引入弱星拓扑，不使用 Banach–Alaoglu，也不将弱紧性与范数紧性混同。
