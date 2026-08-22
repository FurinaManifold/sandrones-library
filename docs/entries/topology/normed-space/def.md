---
id: topology.normed-space.def
kind: definition
state: verified
title: "赋范线性空间与Banach空间"
premises: ["topology.metric.def", "linear-algebra.vector-space.def"]
mathlib: ["NormedAddCommGroup", "NormedSpace", "CompleteSpace", "dist_eq_norm"]
provenance: {source_type: book, ref: "点集拓扑与泛函分析预备：赋范空间"}
---

# 陈述与动机

赋范线性空间是在向量空间上指定大小函数 `‖x‖`，满足正定性、三角不等式和
`‖c•x‖=‖c‖‖x‖`。范数自动诱导距离 `dist x y=‖x-y‖`，从而把线性代数接到
度量拓扑。若这个度量完备，则称为 Banach 空间。

# Lean 对照

Mathlib 把结构分成三层：`NormedAddCommGroup E` 携带范数和诱导度量，
`NormedSpace 𝕜 E` 表达数乘相容性，`CompleteSpace E` 表达完备性。本库的
`NormedLinearSpace` 与 `BanachSpace` 是教材别名，不另造不兼容的数据结构。本阶段
公开定理统一讨论实赋范线性空间，不提前开放半范数群层面的最大一般性。

# 依赖与陷阱

依赖度量空间和向量空间。`BanachSpace E` 只命名额外的完备性条件，使用时仍需
`[NormedAddCommGroup E]` 与 `[NormedLinearSpace ℝ E]`。半范数空间不属于当前
教材接口，留待后续确有需要时再单独引入。
