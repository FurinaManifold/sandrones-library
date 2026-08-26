---
id: functional-analysis.ergodic.mean.projection
family: functional-analysis.weak
variant: reflexive-limit-projection
kind: theorem
state: verified
title: 均值遍历极限投影
summary: 自反 Banach 空间上幂一致有界算子的 Cesàro 极限构成连续线性投影并满足 ST=TS=S²=S
premises: [functional-analysis.ergodic.mean.reflexive]
mathlib: [ContinuousLinearMap, LinearMap.mkContinuous, Filter.Tendsto]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 教材命题

Salamon Theorem 3.6.9 在收敛域 `Z` 上定义 `Sx=lim Sₙx`，并证明 `S` 有界且
`ST=TS=S²=S`。自反消费者已经证明 `Z=X`，所以本条把该极限组装为整个空间上的连续线性投影。

# 正式承载

`meanErgodicLimitOperator hT hE : E →L[ℝ] E` 是普通 Mathlib `ContinuousLinearMap`。参数 `hT`
与 `hE` 分别保留幂一致有界证据和双对偶典范嵌入满射证据；没有另建 projection structure，也没有
把点态极限误写成算子范数极限。

# 构造与连续性

对每个 `x` 选择 reflexive 批给出的唯一范数极限。平均算子的加法与数乘性质以及极限唯一性说明
选择函数线性。若 `‖Tⁿ‖≤c`，已有 decomposition 接口给出 `‖Sₙ‖≤c`；对范数取极限得到
`‖Sx‖≤c‖x‖`，于是 `LinearMap.mkContinuous` 将它提升为连续线性算子。

# 投影恒等式

平均极限属于 fixed space，故 `TS=S`。每个有限平均与 `T` 交换，取极限得到 `ST=TS`，从而
`ST=S`。极限算子在 fixed space 上恒等，因此再次作用得到 `S²=S`。

# Lean 对照

- `meanErgodicLimitOperator`：极限连续线性算子；
- `tendsto_meanErgodicAverage_meanErgodicLimitOperator`：逐点范数收敛；
- `meanErgodicLimitOperator_mem_fixed` 与 `meanErgodicLimitOperator_apply_fixed`：fixed-space 桥；
- `meanErgodicLimitOperator_commute`、`T_comp_meanErgodicLimitOperator`、
  `meanErgodicLimitOperator_idempotent`：三条分解恒等；
- `meanErgodicLimitOperator_identities`：教材 `ST=TS=S²=S` 的合并陈述。

# 边界

本条只断言逐向量范数收敛，不断言 `Sₙ→S` 的算子范数收敛。它不进入具体 Koopman 算子、点态
遍历定理或概率遍历分解，也不重证 fixed/difference closure decomposition。
