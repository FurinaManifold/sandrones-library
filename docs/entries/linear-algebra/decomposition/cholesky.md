---
id: linear-algebra.decomposition.cholesky
kind: theorem
state: verified
title: Cholesky 分解
summary: 实对称正定矩阵具有正对角下三角平方根分解
premises: [linear-algebra.decomposition.qr]
mathlib: [LDL.lower, LDL.diagEntries]
provenance: {source_type: textbook, ref: "horn-johnson-matrix-analysis-2013"}
---

# 动机

正定矩阵需要保持对称和正性的三角分解接口。

# 直觉

LDL 分解中的正对角项取平方根并吸收到下三角因子，即得到 `A=LLᵀ`。

# 陈述（自然语言）

每个实对称正定矩阵都有严格正对角的下三角 Cholesky 因子，并满足规范唯一性。

# 陈述（Lean 对照）

`CholeskyFactorization A` 保存下三角性、正对角和乘积等式。

# 思维脉络（thinking trace）

先验证 LDL 的单位下三角和正对角，再构造平方根缩放并证明乘积恢复。

# 自然语言 ↔ Lean 映射

下三角因子对应 `lower`，正对角对应 `lower_diagonal_pos`，恢复对应 `eq_mul_transpose`。

# 依赖（人话版）

证明使用 Mathlib LDL 后端以及本库已有三角矩阵接口。

# 应用与陷阱

正定性不可弱化为半正定性，否则严格正对角与唯一性均可能失败。

