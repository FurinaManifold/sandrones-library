---
id: functional-analysis.hilbert.riesz
kind: theorem
state: staging
title: Fréchet–Riesz 表示定理
premises: [functional-analysis.hilbert.projection, functional-analysis.operator.space]
mathlib: [StrongDual, InnerProductSpace.toDual, InnerProductSpace.toDual_symm_apply]
provenance: {source_type: book, ref: "Conway, A Course in Functional Analysis, Chapter II"}
---

# 动机

连续线性泛函看似是 Hilbert 空间之外的新对象，Riesz 表示定理却说明它们恰好都由空间中的向量通过
内积产生。这把抽象对偶问题重新转化为空间内部的几何问题。

# 教材定义与正式承载

实 Hilbert 空间的连续对偶直接写成 `E →L[ℝ] ℝ`，也就是 Mathlib 的 `StrongDual ℝ E`。
`InnerProductSpace.toDual ℝ E` 把 `y` 映成泛函 `x ↦ inner ℝ y x`；在实数域没有复共轭线性方向
的额外负担。本库直接使用这一等距等价，不定义新的对偶或 Riesz 映射。

# 陈述（自然语言）

对实 Hilbert 空间上的每个连续线性泛函 `ℓ`，存在唯一向量 `y`，使所有 `x` 都满足
`⟨y,x⟩=ℓ(x)`。这个表示向量可写成 `toDual.symm ℓ`，并且 `‖y‖=‖ℓ‖`。

# 陈述（Lean 对照）

对应 `existsUnique_inner_right_eq_continuousLinearFunctional`、`rieszRepresentative_inner` 和
`norm_rieszRepresentative`。

# 思维脉络

若泛函为零，表示向量取零。否则考察其核，这是闭子空间；从核的正交补中选择非零向量，并按泛函
值和自身内积缩放，就得到表示向量。唯一性来自内积的非退化性。范数相等由 Cauchy–Schwarz 上界
和在表示向量方向取等共同给出。

# 自然语言 ↔ Lean 映射

- 连续线性泛函：`ℓ : E →L[ℝ] ℝ`。
- 连续对偶：`StrongDual ℝ E`，与上述类型同义。
- Riesz 等距等价：`InnerProductSpace.toDual ℝ E`。
- 表示向量：`(InnerProductSpace.toDual ℝ E).symm ℓ`。
- 表示恒等式：`inner ℝ y x = ℓ x`。

# 依赖

依赖闭子空间正交投影的几何思想，以及 F1 的连续线性泛函和算子范数。

# 应用与边界

本条先固定实 Hilbert 空间，从而避免内积参数顺序与共轭线性约定遮蔽主旨。复 Hilbert 空间中同一
Mathlib 接口是共轭线性等距等价，后续伴随窗会明确使用其稳定约定。
