---
id: functional-analysis.baire.theorem
kind: theorem
state: staging
title: Banach 空间的 Baire 范畴定理
premises: [topology.normed-space.banach]
mathlib: [BaireSpace, dense_iInter_of_isOpen_nat, nonempty_interior_of_iUnion_of_closed]
provenance: {source_type: book, ref: "Conway, A Course in Functional Analysis, Chapter II"}
---

# 动机

Baire 定理把完备性转化为“稠密性质不能在可数次取交后消失”。一致有界原理和开映射定理都用它
从逐点或覆盖信息中抽取一个具有非空内部的统一控制区域。

# 教材定义与正式承载

教材称空间具有 Baire 性质，是指任意可数族稠密开集的交仍然稠密。Mathlib 的
`BaireSpace E` 正好保存这一性质，核心展开是 `BaireSpace.baire_property`。Banach 空间的范数度量
完备，因此 Mathlib 自动提供相应 `BaireSpace` 实例；本库不另建 Baire 谓词。

# 陈述（自然语言）

Banach 空间中，可数个稠密开集的交仍然稠密。等价的常用覆盖形式是：若可数个闭集覆盖一个非空
Banach 空间，则至少一个闭集具有非空内部。

# 陈述（Lean 对照）

分别对应 `banach_dense_iInter_of_isOpen` 和
`banach_nonempty_interior_of_iUnion_of_closed`。

# 思维脉络

在第一个稠密开集中选取一个小闭球，再递归地在后续稠密开集中选择半径趋零的嵌套闭球。球心构成
Cauchy 序列，完备性给出的极限同时落在全部开集中。对闭集覆盖取补集，便得到覆盖形式；若每个
闭集内部都为空，其补集就是稠密开集，交不可能为空。

# 自然语言 ↔ Lean 映射

- 稠密：`Dense U`，即 `closure U = Set.univ` 的标准拓扑承载。
- 开集：`IsOpen U`。
- 可数交：`⋂ n : ℕ, U n`。
- 闭集内部：`interior (F n)`。
- Banach 完备性：`[BanachSpace E]`。

# 依赖

依赖 F1 采用的 Banach 完备性，以及点集拓扑中已经建立的开集、闭集、闭包、内部和稠密概念。

# 应用与边界

本条只给出后续三大定理所需的两个标准形式，不展开疏集、第一纲集、残余集或局部紧 Baire 空间的
一般理论。`BaireSpace` 是语义一致的正式承载，而不是未解释的证明后端。
