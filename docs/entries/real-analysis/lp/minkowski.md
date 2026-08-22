---
id: real-analysis.lp.minkowski
kind: theorem
state: verified
title: "Minkowski 不等式"
premises: ["real-analysis.lp.holder", "analysis.inequalities.minkowski-finite"]
mathlib: ["MeasureTheory.eLpNorm_add_le", "ENNReal.lintegral_Lp_add_le"]
provenance: {source_type: book, ref: "实分析：Minkowski 不等式"}
---

# 动机

要让 `Lᵖ` 中的“长度”成为范数，关键是三角不等式。Minkowski 不等式正是积分版本
的三角不等式，也是证明 `Lᵖ` 是赋范空间并进一步讨论完备性的核心一步。

# 直觉

有限维 Minkowski 控制向量逐坐标相加后的 `p`-长度。把坐标求和替换为积分，同一
结构给出函数和的 `Lᵖ` 大小不超过各自大小之和；经典证明的关键估计来自 Hölder。

# 陈述

若 `p≥1` 且 `f,g` 几乎处处强可测，则

\[
\lVert f+g\rVert_p\leq\lVert f\rVert_p+\lVert g\rVert_p.
\]

`minkowski` 使用 `p : ℝ≥0∞` 与 `eLpNorm`，适用于一般赋范加法群值函数，并覆盖
`p=∞`。`minkowski_nonneg` 使用 `p : ℝ` 与 `lintegral`，给出非负函数的显式公式
`(∫(f+g)^p)^(1/p) ≤ (∫f^p)^(1/p) + (∫g^p)^(1/p)`。

# Lean 对照与依赖

- 函数和 ↔ 逐点加法实例 `f + g`；
- `‖f‖ₚ` ↔ `eLpNorm f p μ`；
- 抽象版本可测性 ↔ `AEStronglyMeasurable`；
- 非负版本可测性 ↔ `AEMeasurable`。

抽象版本调用 `eLpNorm_add_le`，显式版本调用 `ENNReal.lintegral_Lp_add_le`。数学上
依赖 Hölder；有限和 Minkowski 是同一结构的初等原型。

# 应用与陷阱

条件 `p≥1` 不可删除：`0<p<1` 时只有拟范数。`eLpNorm` 可为无穷，因此抽象版本
不要求 `MemLp`；显式版本的值域是 `ℝ≥0∞`，不能直接代入带符号实函数。
