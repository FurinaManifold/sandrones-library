---
id: functional-analysis.eberlein-smulian
family: functional-analysis.weak
variant: closed-unit-ball-four-way
kind: theorem
state: verified
title: Eberlein--Šmulian 闭单位球四项等价
summary: 实 Banach 空间自反、闭单位球弱紧、闭单位球弱序列紧与有界序列具有弱收敛子列四者等价
premises: [functional-analysis.bidual.reflexive, functional-analysis.banach-alaoglu, functional-analysis.weak-star.banach-dieudonne]
mathlib: [WeakSpace, WeakDual, NormedSpace.inclusionInDoubleDual, IsCompact, IsSeqCompact]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 范围

本条严格采用 Bühler--Salamon 定理 3.4.1 的范围：对象是实 Banach 空间的闭单位球，结论是
自反性、弱紧致性、弱序列紧致性和有界序列抽取性质的四项等价。它不声称已经形式化任意
子集版本，也不建立第二套弱拓扑、双对偶或自反空间类型类。

# 正式承载

- 自反性：`Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)`；
- 弱闭单位球：`weakClosedUnitBall`，即原闭单位球通过 `toWeakSpace` 的像；
- 弱紧致与弱序列紧致：Mathlib 的 `IsCompact`、`IsSeqCompact`；
- 弱收敛：对每个 `f : StrongDual ℝ E` 的逐点 `Tendsto`；
- 完备性：最终四项等价显式要求 `[CompleteSpace E]`。

# Lean 对照

主定理是 `eberlein_smulian_four_way`。公开证明链还包括：

- `closure_inclusionInDoubleDualWeak_unitBall`：Goldstine 单位球弱星稠密；
- `exists_unitBall_eq_bidual_on_finset`：教材 Step 1 的有限精确插值；
- `weakStarImage_dualUnitSlice_ker_isClosed`：教材 Step 2 的核单位切片弱星闭；
- `reflexive_of_bounded_sequence_has_weakly_convergent_subsequence`：Step 3 与困难方向；
- `reflexive_closedSubspace`：闭子空间继承自反性；
- `weakClosedUnitBall_isSeqCompact_of_reflexive`：通过序列生成的可分闭子空间处理一般情形；
- `reflexive_of_weakClosedUnitBall_isCompact`：由 Goldstine 与紧集闭性恢复自反性。

# 证明边界

困难方向真实使用 Goldstine、依赖选择、弱收敛子列、有限闭凸包逼近和 Banach--Dieudonné，
没有把最终等价作为中间引理循环调用。自反推出弱序列紧致时，只对给定序列生成的闭子空间
使用可分版本；没有为整个空间添加虚假的可分性假设。
