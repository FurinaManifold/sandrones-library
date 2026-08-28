---
id: functional-analysis.fredholm.stability-compact
family: functional-analysis.operator
variant: compact-perturbation
kind: theorem
state: verified
title: Fredholm 算子的紧扰动稳定性
summary: Fredholm 算子加上紧算子仍为 Fredholm，且指数保持不变
premises: [functional-analysis.fredholm.stability, functional-analysis.fredholm.alternative-final, functional-analysis.compact-operator.composition]
mathlib: [ContinuousLinearMap.IsFredholm, LinearMap.IsQuasiInverse, LinearMap.FiniteRangeSetoid]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 紧扰动稳定性

设 `T : E →L[ℝ] F` 是 Fredholm，`K : E →L[ℝ] F` 紧。取 `T` 的连续拟逆
`S : F →L[ℝ] E`。拟逆关系说明 `TS-I` 是有限秩，因此也是紧算子；`KS` 由紧算子理想性质仍紧。
于是

`(T+K)S = I-C`，

其中 `C = (I-TS)-KS` 紧。此前 F5.6 已证明 `I-C` 有有限维核、有限维余核、闭值域且指数为零；
本条再用 Banach 开映射定理补出 Mathlib `IsFredholm` 所要求的 strictness。

若 `W` 是 `(T+K)S` 的拟逆，`IsQuasiInverse.of_comp_left` 将 `S` 消去，得到 `SW` 是 `T+K` 的
拟逆。因此 `T+K` 是 Fredholm。这不是对 Mathlib 最终紧扰动定理的包装。

# 指数不变

令 `U=T+K`。`US` 与 `TS` 都是恒等减紧算子，故指数均为零。复合稳定性 Entry 给出

`index(US)=index(U)+index(S)`，`index(TS)=index(T)+index(S)`。

消去同一个 `index(S)`，得到 `index(T+K)=index(T)`。证明因此真实消费复合指数公式，而没有另建
平行指数。

# Lean 对照

- `ContinuousLinearMap.IsFredholm.add_compact`：紧扰动保持 Fredholm 性；
- `fredholmIndex_add_compact`：紧扰动下指数不变。

# 边界

本条只处理紧扰动。小扰动稳定性需要独立的开性或分块论证，不能由紧扰动指数不变冒充。
