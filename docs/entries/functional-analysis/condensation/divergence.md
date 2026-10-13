---
id: functional-analysis.condensation.divergence
kind: theorem
state: verified
title: Banach–Steinhaus 1927 同时发散定理 II
premises: [functional-analysis.condensation, functional-analysis.baire.theorem, functional-analysis.banach-steinhaus, functional-analysis.operator.space]
mathlib: [Metric.cauchySeq_iff, Metric.mem_closure_iff, isClosed_of_closure_subset, Submodule.eq_top_of_nonempty_interior', CauchySeq.isBounded_range, Bornology.IsBounded.exists_norm_le, dense_iInter_of_Gδ, cauchySeq_tendsto_of_complete]
provenance: {source_type: paper, ref: "banach-steinhaus-condensation-1927"}
---

# 动机

输出不收敛可以是振荡，也可以是无界。例如 `1, -1, 1, -1, ...` 有界但不收敛，
因此定理 I 的无界结论不足以复现原文定理 II。本条处理每一行各有不收敛点的情况，
证明存在令所有行同时不收敛的公共点。

# 教材定义与正式承载

连续线性算子、Banach 定义域和按行变化的值域沿用定理 I 的接口。
`CauchySeq (fun q => g p q x)` 精确表示：
对每个 `ε > 0`，存在 `N`，使所有 `m,n ≥ N` 的输出距离小于 `ε`。
对应公开刻画 `Metric.cauchySeq_iff`。

非 Cauchy 版本允许值域不完备。极限版本对每一行值域增加完备性，
此时 Cauchy 性等价于存在值域内的极限。极限写作
`∃ y : F p, Tendsto (fun q => g p q x) atTop (𝓝 y)`。
这一区别在公开接口中体现，而不是留给定理名字猜测。

# 陈述（自然语言）

设有可数行连续实线性算子，定义域是 Banach 空间。如果每一行都在某一点形成非 Cauchy
输出列，那么令所有行同时非 Cauchy 的点集稠密，因而至少存在一个公共点。

当各行值域完备时：如果每行在某点不收敛，就有同一个点令每行都不存在极限。

# 陈述（Lean 对照）

```lean
theorem condensation_divergence_exists
    {g : ∀ p : ℕ, ℕ → E →L[ℝ] F p}
    (h : ∀ p, ∃ z : E, ¬ CauchySeq (fun q => g p q z)) :
    ∃ x : E, ∀ p, ¬ CauchySeq (fun q => g p q x)

theorem condensation_nonconvergence_exists [∀ p, BanachSpace (F p)]
    {g : ∀ p : ℕ, ℕ → E →L[ℝ] F p}
    (h : ∀ p, ∃ z : E,
      ¬ ∃ y : F p, Tendsto (fun q => g p q z) atTop (𝓝 y)) :
    ∃ x : E, ∀ p,
      ¬ ∃ y : F p, Tendsto (fun q => g p q x) atTop (𝓝 y)
```

`condensation_divergence_dense` 给出公共点集稠密性。

# 思维脉络

固定一行，分两种情况。

算子范数统一有界时，Cauchy 点构成一个线性子空间。若某点是这些点的极限，
先找邻近的 Cauchy 点，再用统一算子范数控制两侧误差，中间误差由 Cauchy 性控制。
三个误差各小于 `ε/3`，所以原点也是 Cauchy 点，这个子空间是闭集。
既然有一个非 Cauchy 点，该子空间是真子空间；它没有内部，补集便开且稠密。

算子范数无界时，一致有界原理的逆否命题提供输出无界的点。定理 I 随后提供稠密 Gδ
无界点集。Cauchy 列的范数一定有界，所以这些点都是非 Cauchy 点。

每一行的非 Cauchy 点集由此都包含一个稠密 Gδ 集。取可数交，再用 Baire 定理，得到公共点。
这里只声称整个公共非 Cauchy 点集稠密；所选稠密 Gδ 子集是证明中的支架。

# 自然语言 ↔ Lean 映射

| 数学对象／步骤 | Lean 对应 | 解释 |
|---|---|---|
| Cauchy 点子空间 | 私有 `cauchyPointsSubmodule` | 用 `Submodule` 保存加法和标量乘法封闭性，不增加公开定义 |
| 三项误差估计 | `isClosed_cauchy_points_of_operatorNorm_bound` | 显式选取 `δ = ε / (3(C+1))`，兼顾 `C = 0` |
| 真子空间无内部 | `Submodule.eq_top_of_nonempty_interior'` 的逆否 | 复用一般拓扑线性代数后端，公开结论仍是稠密开集 |
| 每行有足够多坏点 | `exists_dense_Gδ_nonCauchy_points` | 两分支都给出同样的下游接口 |
| 同一个公共坏点 | `∃ x, ∀ p, ¬ ...` | 不能替换成 `∀ p, ∃ x, ¬ ...` |
| 非 Cauchy与无极限 | 最后一个公开定理 | 从“无极限”转为“非 Cauchy”时需要值域完备 |

`choose` 从每行存在性取得集合族，`dense_iInter_of_Gδ` 检查它们的可数交，
`calc` 把闭性证明的三项误差展示为数学估计，线性算术 tactic 只关闭最后的数值目标。

# 依赖

依赖定理 I 的公共无界点集、既有一致有界原理和 Baire 定理。
Mathlib 负责 Cauchy 列有界性、完整空间的极限存在性及真子空间无内部的通用事实。
两个论文主定理的拼装和各分支接口在本库源码中完成。

# 应用与原文定位

对应 [原论文重印](https://kielich.amu.edu.pl/Stefan_Banach/pdf/oeuvres2/366.pdf)
§2 定理 II（重印 pp. 369–370），闭性步骤对应 p. 368 的引理 4。
验收文件用统一有界的交替符号算子验证本条能够处理振荡，也用线性增长算子验证定理 I。
本批完成 §2 两个核心定理；§3 的正交级数应用是独立的下一批工作。
