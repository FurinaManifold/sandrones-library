---
id: settheory.googology.goodstein-certified-state
kind: definition
state: verified
title: "Goodstein 带证书状态：数值与表示不可分离"
premises: ["settheory.googology.hereditary-base"]
mathlib: []
provenance: {source_type: paper, ref: "R. L. Goodstein, On the Restricted Ordinal Theorem, 1944"}
---

# 动机

只记录当前自然数不足以定义 Goodstein 过程：同一个数可写成许多棵不同的表达式树，换底后它们可能产生不同的新数。如果库中尚未实现唯一正规编码，就必须把实际使用的表示和其正确性一起保存。

# 直觉

可以把状态想成一张“带验算的记账卡”。卡上写有底数 `b`、数值 `n` 和遗传表达式 `e`；后面附两张证明：`e` 的每个数字都小于 `b`，且在底数 `b` 下计算 `e` 的结果正好是 `n`。

# 陈述（自然语言）

一个合法的带证书 Goodstein 状态包含底数、自然数值和遗传基表达式。底数至少为二；表达式在该底数下合法；其求值等于状态记录的数值。

# 陈述（Lean 对照）

`CertifiedGoodsteinState` 的字段 `base_ge_two`、`expression_valid` 和 `expression_evaluates` 分别是上述三项证书。`certifiedGoodsteinState_specification` 把结构中的证书重新组装成一个合取命题，便于下游定理直接使用。

# 思维脉络（thinking trace）

首先区分“数”和“数的表示”；然后观察到换底操作作用于后者，不是只作用于前者。由于现有 `HereditaryBaseExpr.Valid` 只检查数字范围，并不给出唯一正规形，最安全的形式化是保留表达式并附上求值等式。

# 自然语言 ↔ Lean 映射

“底数至少为二”对应 `base_ge_two : 2 ≤ base`；“数字合法”对应 `expression_valid`；“这棵树确实表示该数”对应 `expression_evaluates`。结构字段不是额外注释，而是 Lean 会逐项检查的逻辑证书。

# 依赖（人话版）

本条直接使用已有的遗传表达式、有限底数求值和合法性判定。它不依赖自然数到正规形的算法，也没有证明每个数的表示唯一。

# 应用与陷阱

该结构适合作为单步迁移和整条序列的状态类型。但“有证书”不等于“已正规化”：两个合法表达式仍可表示同一数，且它们的 `ω` 解释可能不同。不能仅凭本条就声称序数严格下降。
