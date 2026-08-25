---
id: topology.normed-space.inequalities
kind: theorem
state: verified
title: "范数基本不等式"
premises: ["topology.normed-space.def"]
mathlib: ["norm_nonneg", "norm_eq_zero", "norm_add_le", "abs_norm_sub_norm_le", "norm_smul"]
provenance: {source_type: book, ref: "munkres-topology-2000"}
---

# 陈述

本条目集中给出范数非负、零范数判定、三角不等式、反三角不等式以及标量数乘公式：

\[
\|x+y\|\leq\|x\|+\|y\|,\qquad
|\|x\|-\|y\||\leq\|x-y\|,\qquad
\|cx\|=\|c\|\|x\|.
\]

# 意义与 Lean 对照

反三角不等式说明范数函数连续，且为 `1`-Lipschitz。本库所有公开签名统一置于
实赋范线性空间 `[NormedLinearSpace ℝ E]` 中，不把更广的半范数群接口暴露给
当前课程。底层证明分别调用 `norm_add_le`、`abs_norm_sub_norm_le` 和 `norm_smul`。

# 陷阱

不要把 `‖x-y‖` 与 `‖y-x‖` 当作句法相同；需要时使用范数取负不变性。实数范数
等于绝对值，但一般赋范空间不能用实数绝对值引理替代范数引理。
