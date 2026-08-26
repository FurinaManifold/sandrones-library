---
id: functional-analysis.ergodic.mean
family: functional-analysis.weak
variant: power-bounded-decomposition
kind: theorem
state: verified
title: 幂有界算子的均值遍历分解
summary: 幂一致有界 Banach 算子的 Cesàro 平均收敛域等于固定点空间与差分像闭包的直和，并由弱收敛子列刻画
premises: [functional-analysis.weak-topology.definition, functional-analysis.closed-range.double-annihilator]
mathlib: [birkhoffAverage, ContinuousLinearMap, LinearMap.eqLocus, Submodule.topologicalClosure]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

对算子反复迭代往往不收敛，但前 `n` 次迭代的 Cesàro 平均可能收敛。均值遍历分解指出，是否收敛
完全由向量能否分成一个固定点和一个差分 `Tx-x` 的闭极限决定；弱收敛子列已经足以迫使整个平均
序列范数收敛。

# 教材定义

有界线性自映射 `T` 称为幂一致有界，如果存在 `c ≥ 1`，使每个 `n` 都有 `‖Tⁿ‖ ≤ c`。平均算子
是 `Sₙ = n⁻¹ ∑_{k<n} Tᵏ`。收敛域由所有满足 `Sₙx` 在范数中收敛的 `x` 组成；固定点空间是
`ker(1-T)`，差分部分是 `closure(range(T-1))`，两种符号的 range 相同。

# 正式承载

`IsPowerBounded T` 直接冻结教材的共同常数量词。点值平均复用 Mathlib `birkhoffAverage`；
`meanErgodicAverage T n` 只是同一公式的连续线性算子提升，并由 `meanErgodicAverage_apply` 连接。
收敛域用 `meanErgodicConvergenceSubmodule`，固定点直接挂靠 `LinearMap.eqLocus T 1`，差分闭包直接
挂靠 `(T-1).range.topologicalClosure`。

# 基本性质

`norm_meanErgodicAverage_le` 给出 `‖Sₙ‖ ≤ c`。固定点上的平均恒等，差分像上的平均由望远镜求和
趋于零；`uniformEquicontinuous_meanErgodicAverage` 把共同算子界提升为一致等度连续，从而
`tendsto_meanErgodicAverage_differenceClosure` 将趋零性质延伸到差分像闭包。

# 分解定理

`meanErgodic_decomposition_of_powerBounded` 断言收敛域是闭线性子空间，并且
`Z = fix(T) ⊔ closure(range(T-1))`，两个分量交为零。`map_mem_meanErgodicConvergenceSubmodule`
说明 `Z` 在 `T` 下不变。加法映射从两个闭分量的积到 `E` 被证明为 anti-Lipschitz，因此其值域
闭；这给出教材中“`Z` 是闭子空间”的真实证明。

# 弱子列判据

`mem_meanErgodicConvergenceSubmodule_iff_weak_subsequence_of_powerBounded` 给出 Salamon
Theorem 3.6.9(i)：`Sₙx` 范数收敛，当且仅当存在严格递增子列及 `z`，使每个连续线性泛函 `f`
都满足 `f(S_{φ(n)}x) → f(z)`。这里弱收敛按既有弱拓扑条目逐对偶泛函展开。

# 证明思路

若平均收敛到 `z`，望远镜恒等式推出 `Tz=z`；对所有零化 `range(T-1)` 的泛函取极限，既有双
零化子定理推出 `x-z` 属于差分像闭包。反之固定分量恒定、差分闭包分量趋零。弱子列方向对每个
泛函重复这两个极限论证，再用连续对偶分离点恢复 `Tz=z`。

# Lean 对照

完备性由 `[CompleteSpace E]` 承载。`StrongDual ℝ E` 是弱子列量词中的测试泛函；
`mem_range_topologicalClosure_iff_forall_dualOperator_ker` 是差分闭包恢复后端。Mathlib 已有的
Hilbert 收缩版 `ContinuousLinearMap.tendsto_birkhoffAverage_orthogonalProjection` 没有被用于
证明一般 Banach 结论。

# 边界

本批不证明自反空间上 `Z=E`，也不构造极限投影或证明 `ST=TS=S²=S`；这些按 Main 权限等待
decomposition 接口验收。`Lᵖ` Koopman 应用、遍历测度极点刻画与 Birkhoff 点态遍历定理属于后续
概率或动力系统路线。
