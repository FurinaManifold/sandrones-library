---
id: functional-analysis.bidual.reflexive-examples
kind: theorem
state: verified
title: 有限维空间与实 Hilbert 空间的自反性
premises: [functional-analysis.bidual.reflexive]
mathlib: [LinearMap.toContinuousLinearMap, Subspace.dual_finrank_eq, InnerProductSpace.toDual]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

自反性并非所有 Banach 空间都具有，但有限维空间和 Hilbert 空间是两个最基本的正例。
它们也展示了两种不同证明：有限维情形依靠维数，Hilbert 情形依靠 Riesz 表示。

# 教材定义与正式承载

本条不建立本地 `Reflexive` 类，继续以
`Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)` 表达自反性。
有限维证明用 `LinearMap.toContinuousLinearMap` 识别代数对偶和连续对偶，并用
`Subspace.dual_finrank_eq` 比较维数。Hilbert 证明直接使用
`InnerProductSpace.toDual ℝ E` 的 Riesz 等价。

# 陈述（自然语言）

每个有限维实赋范空间都是自反的。每个完备实内积空间都是自反的。

# 陈述（Lean 对照）

两项结论分别对应 `finiteDimensional_reflexive` 与 `realHilbert_reflexive`。

# 思维脉络

有限维时，典范嵌入已经由 Hahn–Banach 给出单射性；原空间与连续双对偶维数相等，故它也满射。
在完备实内积空间中，Riesz 表示把连续对偶识别回原空间。给定双对偶元，先沿 Riesz 映射复合得到
一个连续泛函，再对它作 Riesz 逆变换，即得到代表该双对偶元的向量。

# 自然语言 ↔ Lean 映射

- 自反性：`Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)`。
- 有限维：`FiniteDimensional ℝ E`。
- 实 Hilbert 空间：`InnerProductSpace ℝ E` 与 `CompleteSpace E`。
- Riesz 表示：`InnerProductSpace.toDual ℝ E`。

# 应用与边界

本条只证明两个正例，不断言任意 Banach 空间自反。经典的 `c₀`、`ℓ¹` 与 `ℓ∞` 边界需要先确认
Mathlib 中序列空间、连续对偶识别和非自反性证明所需接口；在接口审计完成前不添加平行空间定义，
也不把这些经典事实标为已形式化。
