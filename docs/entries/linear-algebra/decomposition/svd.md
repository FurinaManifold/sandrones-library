---
id: linear-algebra.decomposition.svd
kind: theorem
state: verified
title: 奇异值分解
summary: 有限维实或复线性映射具有正交奇异向量分解
premises: [linear-algebra.decomposition.schur]
mathlib: [LinearMap.singularValues, InnerProductSpace.rankOne]
provenance: {source_type: textbook, ref: "horn-johnson-matrix-analysis-2013"}
---

# 动机

SVD 为任意线性映射提供正交坐标、秩、范数和低秩近似的统一语言。

# 直觉

对正算子 `T†T` 对角化，特征值平方根给出奇异值，像向量归一化后给出左奇异方向。

# 陈述（自然语言）

有限维实或复内积空间之间的线性映射存在左右正交奇异基，并按非负奇异值逐坐标作用。

# 陈述（Lean 对照）

模块公开右奇异基、左奇异向量、奇异值作用公式与完整分解证书。

# 思维脉络（thinking trace）

先建立算子范数和正算子谱界，再按秩分离正奇异方向与核方向并扩充左基。

# 自然语言 ↔ Lean 映射

“右奇异向量”对应 `rightSingularBasis`，“奇异值”对应 `T.singularValues`。

# 依赖（人话版）

依赖有限维谱定理、Schur 路线和 Mathlib 奇异值接口。

# 应用与陷阱

零奇异值方向属于核；对矩形映射不能假设左右空间维数相等。

