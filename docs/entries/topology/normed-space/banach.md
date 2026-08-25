---
id: topology.normed-space.banach
kind: theorem
state: verified
title: "范数收敛与Banach完备性"
premises: ["topology.normed-space.def", "topology.metric.cauchy-complete"]
mathlib: ["Metric.tendsto_atTop", "Metric.cauchySeq_iff", "cauchySeq_tendsto_of_complete"]
provenance: {source_type: book, ref: "munkres-topology-2000"}
---

# 陈述

序列 `uₙ` 收敛到 `x` 当且仅当 `‖uₙ-x‖→0`；它是 Cauchy 列当且仅当任意足够
靠后的两项满足 `‖uₘ-uₙ‖<ε`。Banach 空间的定义性结论是每个 Cauchy 列都有极限。

# 证明思路

利用 `dist x y=‖x-y‖`，度量空间的 ε–N 收敛判据和 Cauchy 判据可逐字改写为范数
形式。最后直接应用完备度量空间中 Cauchy 列收敛的通用定理。

# Lean 对照与应用

`tendsto_iff_norm_sub`、`cauchySeq_iff_norm_sub` 给出两个范数判据；
`cauchySeq_tendsto_of_banach` 给出完备性。它们是级数、`Lᵖ` 空间和后续泛函分析
中“证明 Cauchy 即得到极限”的统一接口。
