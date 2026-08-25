---
id: linear-algebra.decomposition.pseudoinverse
kind: theorem
state: verified
title: Moore–Penrose 伪逆
summary: 有限维线性映射存在满足四条 Penrose 方程的规范伪逆
premises: [linear-algebra.decomposition.polar]
mathlib: [LinearMap.singularValues, InnerProductSpace.rankOne]
provenance: {source_type: textbook, ref: "horn-johnson-matrix-analysis-2013"}
---

# 动机

伪逆把逆映射和最小二乘推广到奇异或非方线性映射。

# 直觉

在正奇异值方向除以奇异值，在其余左奇异方向取零。

# 陈述（自然语言）

每个有限维实或复线性映射都有满足四条 Penrose 方程的伪逆。

# 陈述（Lean 对照）

`pseudoinverseWith` 构造候选，四个 `penrose` 定理验证反身和自伴方程。

# 思维脉络（thinking trace）

在奇异基上逐方向计算前两式，再把两个复合写成正交投影之和得到自伴性。

# 自然语言 ↔ Lean 映射

“正奇异方向取倒数”对应 `pseudoinverseWith` 中的分支，“投影”对应秩一算子和。

# 依赖（人话版）

依赖 SVD/极分解的奇异基和 Mathlib 秩一算子接口。

# 应用与陷阱

伪逆不是一般双边逆；只有可逆方阵情形才退化为普通逆矩阵。

