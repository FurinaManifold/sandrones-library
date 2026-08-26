---
id: functional-analysis.ergodic.mean.reflexive
family: functional-analysis.weak
variant: reflexive-everywhere-convergence
kind: theorem
state: verified
title: 自反空间上的均值遍历收敛
summary: 自反 Banach 空间中幂一致有界算子的 Cesàro 平均在每个向量上范数收敛
premises: [functional-analysis.ergodic.mean, functional-analysis.eberlein-smulian]
mathlib: [Bornology.IsBounded, IsSeqCompact, NormedSpace.inclusionInDoubleDual]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 教材命题

Salamon Theorem 3.6.9(ii) 断言：若 Banach 空间 `X` 自反，则每个幂一致有界算子 `T` 的 Cesàro
平均 `Sₙx` 对所有 `x∈X` 都在范数中收敛。因此一般 decomposition 中的收敛域 `Z` 在自反情形
等于全空间。

# 正式承载

本条完全复用 `functional-analysis.ergodic.mean` 已冻结的 `IsPowerBounded`、
`meanErgodicAverage`、`meanErgodicConvergenceSubmodule` 和弱子列判据。自反性仍按既有条目写成双对偶
典范嵌入 `NormedSpace.inclusionInDoubleDual ℝ E` 满射，没有新建自反性谓词。

# 证明

幂一致有界给出 `‖Sₙ‖≤c`，所以对固定 `x`，序列 `Sₙx` 的值域有界。自反性经已经形式化的
Eberlein--Šmulian 定理给出弱收敛子列。decomposition 批的
`mem_meanErgodicConvergenceSubmodule_iff_weak_subsequence_of_powerBounded` 随即把弱子列提升为整条
Cesàro 序列的范数收敛。对任意 `x` 应用该结论，得到收敛子空间等于 `⊤`。

# Lean 对照

- `meanErgodicConvergenceSubmodule_eq_top_of_reflexive`：收敛域等于全空间；
- `exists_tendsto_meanErgodicAverage_of_reflexive`：逐向量给出范数极限。

# 边界

本条不重证 decomposition，也不选择或构造极限投影。极限投影的线性、连续性以及
`ST=TS=S²=S` 属于独立的 `mean-ergodic.projection` 消费者批次。
