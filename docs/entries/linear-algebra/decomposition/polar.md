---
id: linear-algebra.decomposition.polar
kind: theorem
state: verified
title: 极分解
summary: 有限维线性映射分解为部分等距与正半定模的乘积
premises: [linear-algebra.decomposition.svd]
mathlib: [InnerProductSpace.rankOne, ContinuousLinearMap.IsPositive]
provenance: {source_type: textbook, ref: "Polar decomposition from SVD"}
---

# 动机

极分解把线性映射的方向变化和大小变化分离。

# 直觉

模 `|T|` 在右奇异方向乘以奇异值，部分等距因子把正奇异方向送到左奇异方向。

# 陈述（自然语言）

有限维线性映射可写为 `T=U|T|`，其中 `|T|` 正半定且平方为 `T†T`，`U` 在核正交方向保范数。

# 陈述（Lean 对照）

`absoluteValue T`、`polarPartialIsometry T b` 和 `IsPartialIsometry` 给出三个公开接口。

# 思维脉络（thinking trace）

利用 SVD 逐基向量构造两个因子，再把正因子写成非负秩一算子之和。

# 自然语言 ↔ Lean 映射

“模”对应 `absoluteValue`，“部分等距”对应本库 `IsPartialIsometry`。

# 依赖（人话版）

依赖 SVD、秩一算子与正算子接口。

# 应用与陷阱

非单射映射的方向因子通常不是酉算子，只能声称部分等距。

