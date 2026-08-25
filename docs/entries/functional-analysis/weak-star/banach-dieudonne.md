---
id: functional-analysis.weak-star.banach-dieudonne
kind: theorem
state: verified
title: Banach--Dieudonné 弱星闭性判据
premises: [functional-analysis.weak.metrizable-separable, functional-analysis.hahn-banach.extension]
mathlib: [WeakDual, ZeroAtInfty, Submodule.mkQ]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

对偶空间的弱星拓扑远弱于范数拓扑，因此一个线性子空间在每个有界范围内的弱星闭性，
未必表面上就能推出整个子空间弱星闭。Banach--Dieudonné 定理说明，对 Banach 原空间的
连续对偶子空间，只需检查闭单位球截面。

# 教材概念与正式承载

对偶子空间使用 `M : Submodule ℝ (StrongDual ℝ X)`；弱星拓扑使用 Mathlib `WeakDual ℝ X`。
`weakStarImage` 只把同一个范数连续对偶通过 `StrongDual.toWeakDual` 放到弱星承载中，
不建立第二套对偶或子空间定义。`dualUnitSlice M` 是 `M` 与范数闭单位球的交。

# 陈述（自然语言）

若 `X` 是实 Banach 空间，而对偶线性子空间 `M` 的闭单位球截面在弱星拓扑中为闭集，
则 `M` 整体在弱星拓扑中为闭集。反向显然成立，因而这给出一个充要判据。

# 陈述（Lean 对照）

分离形式是 `exists_weakStar_separator_of_dualUnitSlice_closed`；正向主定理是
`weakStarImage_submodule_isClosed_of_dualUnitSlice_closed`；充要形式是
`weakStarImage_submodule_isClosed_iff_dualUnitSlice_closed`。完备性由 `[CompleteSpace X]` 明确承载。

# 证明思路

先由单位球截面的弱星闭性得到 `M` 的范数闭性，并为外点 `f₀` 取正范数间隙 `δ`。
对递增范数球与先前的有限求值约束应用 Banach--Alaoglu 紧性，递归选出有限检测块。
把第 `k` 块中向量缩放为 `k⁻¹ x`并用自然数配对枚举，得到一条趋于零的单位球序列。
求值映射把对偶送入 `C₀(ℕ,ℝ)`；商空间上的 Hahn--Banach 泛函给出绝对可和坐标，
再利用 `X` 的完备性在原空间求和，得到消去 `M` 而在 `f₀` 上取值一的分离向量。

# 自然语言 ↔ Lean 映射

- 弱星对偶：`WeakDual ℝ X`，其求值连续性由 `WeakDual.eval_continuous` 承载。
- 趋零检测序列的求值函数：`C₀(ℕ,ℝ)`，即 `ZeroAtInfty` 承载。
- 对偶子空间的像的商：`Submodule.mkQ`。
- 弱星分离向量：`x₀ : X`，满足 `f₀ x₀ = 1` 且对所有 `f ∈ M` 有 `f x₀ = 0`。

# 应用与边界

本条证明的是对偶的线性子空间闭性判据，不是任意凸集或任意非线性集合的判据。
`CompleteSpace X` 用于把绝对可和向量级数在 `X` 中求和，不能从当前陈述中删去。
定理不声称单位球在范数拓扑中紧，也不提前使用 Eberlein--Šmulian、闭值域或 Fredholm 理论。
