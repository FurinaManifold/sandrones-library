---
id: functional-analysis.fredholm.stability-small
family: functional-analysis.operator
variant: norm-small-perturbation
kind: theorem
state: verified
title: Fredholm 算子的小扰动稳定性
summary: Fredholm 算子集合在算子范数拓扑中开放，且指数局部常值
premises: [functional-analysis.fredholm.stability, functional-analysis.fredholm.stability-compact]
mathlib: [LinearMap.IsQuasiInverse, isUnit_one_sub_of_norm_lt_one, ContinuousLinearMap.opNorm_comp_le]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 小扰动稳定性

设 `T : E →L[ℝ] F` 是 Fredholm。选择连续拟逆 `S : F →L[ℝ] E`，并取
`ε=(‖S‖+1)⁻¹>0`。若 `‖K‖<ε`，算子范数次乘性给出 `‖KS‖<1`，所以 Neumann 判据使
`B=I+KS` 可逆。可逆算子是 Fredholm，且指数为零。

# 消费紧扰动窗口

拟逆关系说明 `TS-I` 是有限秩连续线性映射，因而是紧算子，并且

`(T+K)S = B+(TS-I)`。

紧扰动 Entry 因此给出 `(T+K)S` Fredholm 且指数仍为零。再取该复合的拟逆，用
`IsQuasiInverse.of_comp_left` 消去右侧的 `S`，便得到 `T+K` Fredholm。

# 指数局部常值

复合指数公式把 `index((T+K)S)=0` 和 `index(TS)=0` 分别展开为

`index(T+K)+index(S)=0`，`index(T)+index(S)=0`。

消去 `index(S)` 得 `index(T+K)=index(T)`。同一个正半径同时保证 Fredholm 性和指数不变，因此
Fredholm 算子集合在算子范数拓扑中开放，指数在其上局部常值。

# Lean 对照与边界

- `exists_fredholm_smallPerturbation_radius`：返回共同正半径，并同时给出 Fredholm 性与指数等式。

本条直接使用 Mathlib 的算子范数和 Neumann 可逆性，不建立另一种扰动大小，也不进入紧自伴谱定理
或全纯函数演算。
