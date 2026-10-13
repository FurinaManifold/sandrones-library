---
id: functional-analysis.condensation
kind: theorem
state: verified
title: Banach–Steinhaus 1927 奇点凝聚定理 I
premises: [functional-analysis.baire.theorem, functional-analysis.operator.space, functional-analysis.banach-steinhaus]
mathlib: [Metric.dense_iff, isOpen_lt, IsGδ.iInter_of_isOpen, IsGδ.iInter, dense_iInter_of_Gδ, exists_nat_gt, Finset.single_le_sum]
provenance: {source_type: paper, ref: "banach-steinhaus-condensation-1927"}
---

# 动机

一列算子能在某一点产生任意大的输出，并不直接告诉我们另一列算子是否在同一点无界。
原论文定理 I 说明：对可数个这样的算子列，可以找到同一个点，令每一列都无界。
这比现有的一致有界原理多出了“不同列各自的坏点凝聚成公共坏点”的结论。

# 教材定义与正式承载

定义域 `E` 是实 Banach 空间。每行 `p` 的值域 `F p` 是赋范实线性空间，行内固定，
行间可以不同，也无需完备。双指标族的精确接口是
`g : ∀ p : ℕ, ℕ → E →L[ℝ] F p`。`ContinuousLinearMap` 直接承载连续实线性算子。

“第 `p` 行在 `x` 处无界”是 `∀ C : ℝ, ∃ q, C < ‖g p q x‖`。
“上极限为无穷大”展开为每个尾段都无界：
`∀ C : ℝ, ∀ N : ℕ, ∃ q, N ≤ q ∧ C < ‖g p q x‖`。
两者的正向联系由 `unbounded_on_tail_of_unbounded` 证明；反向取 `N = 0` 即得。

`Dense S` 表示每个非空开球都含有 `S` 的点；`IsGδ S` 表示 `S` 是可数个开集的交。
这里直接复用语义一致的 Mathlib 承载，不另设同义结构。

# 陈述（自然语言）

如果每个行指标 `p` 都有一个点 `zₚ`，使该行的输出范数无界，则存在同一个点 `x`，
使每个 `p`、每个实数阈值 `C` 和每个起始位置 `N` 都能找到 `q ≥ N` 满足
`‖gₚq x‖ > C`。这样的公共点组成稠密 Gδ 集。

进一步，如果每一行的算子范数无界，也能得到同样的公共点结论。

# 陈述（Lean 对照）

```lean
theorem condensation_exists
    {g : ∀ p : ℕ, ℕ → E →L[ℝ] F p}
    (h : ∀ p, ∃ z : E, ∀ C : ℝ, ∃ q, C < ‖g p q z‖) :
    ∃ x : E, ∀ p, ∀ C : ℝ, ∀ N : ℕ,
      ∃ q, N ≤ q ∧ C < ‖g p q x‖
```

`condensation_dense_Gδ` 给出公共点集的稠密性和 Gδ 性；
`condensation_of_unbounded_operatorNorm` 接受每行算子范数无界的前提。

# 思维脉络

对每一行和自然数阈值构造开集
`Uₚₘ = {x | ∃ q, m < ‖gₚq x‖}`。连续性保证它开。
假设某个开球完全避开它，则该球内所有输出都不超过 `m`。
把已知无界的向量 `z` 缩成 `t z`，令 `x + t z` 仍在球内；线性和三角不等式给出
`t ‖gₚq z‖ ≤ 2m`，与无界性矛盾。因此每个 `Uₚₘ` 都稠密。

Baire 定理先对阈值取交，再对行取交。自然数阈值足以覆盖全部实数阈值，因为
每个实数都有更大的自然数。最后，有限前缀只有有限范数和，无法承载任意大的输出，
所以无界性必然保留在每个尾段中。

# 自然语言 ↔ Lean 映射

| 数学判断 | Lean 中的对应 | 审阅重点 |
|---|---|---|
| 每一行各有一点 | `∀ p, ∃ z` | `z` 可以依赖 `p` |
| 同一个公共点 | `∃ x, ∀ p` | `x` 必须在行量词之前选定 |
| 上极限无穷大 | `∀ C N, ∃ q, N ≤ q ∧ C < ...` | 超过一次阈值不够，须在任意尾段超过任意阈值 |
| 完备性发挥作用 | `[BanachSpace E]` 与 Baire 交集 | 开集和局部稠密性两个辅助引理不需要完备性 |
| 各行值域可不同 | `F : ℕ → Type*` | 符合原文定理后的值域说明 |

证明中的 `by_contra` 将“开球没有坏点”转成局部统一界；`calc` 展示范数估计；
`linarith`／`nlinarith` 仅验证已列出的实数不等式；`ext` 和 `rw` 验证公共点集等于可数交。

# 依赖

复用本库 Baire 定理、连续线性算子的教材接口和算子范数。
只有算子范数版本调用本库一致有界原理的逆否命题；定理 I 的主证明直接建立稠密开集。
Mathlib 提供开集原像、Gδ 可数交、自然数阿基米德性和有限和估计作为通用后端。

# 应用与原文定位

对应 [原论文重印](https://kielich.amu.edu.pl/Stefan_Banach/pdf/oeuvres2/366.pdf)
§2 定理 I（重印 p. 369；原刊论文为 pp. 50–61），定义见重印 p. 366。
下游 `CondensationDivergence.lean` 在范数无界分支实际使用本条，复现定理 II。
本条的可数行来自原文双数列；自然数阈值是证明施工，不额外限制实数阈值。
