---
id: functional-analysis.fredholm.stability
family: functional-analysis.operator
variant: composition-and-compact-perturbation
kind: theorem
state: verified
title: Fredholm 算子的稳定性
summary: Fredholm 算子的复合稳定性、指数可加性及紧扰动下的指数不变性
premises: [functional-analysis.fredholm.definition, functional-analysis.fredholm.alternative-final, functional-analysis.compact-operator.composition]
mathlib: [ContinuousLinearMap.IsFredholm, LinearMap.IsQuasiInverse, LinearMap.index_comp, LinearMap.FiniteRangeSetoid]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 复合稳定性

Mathlib 的 Fredholm 算子可等价地由连续拟逆刻画：`S'` 是 `S` 的拟逆，意味着 `S'S` 和 `SS'`
分别与恒等映射只差有限秩算子。若 `S : E → F` 与 `T : F → G` 都是 Fredholm，则拟逆按相反顺序
复合为 `S'T' : G → E`。有限秩误差组成的等价关系在左右复合下保持，因此 `S'T'` 是 `TS` 的拟逆，
从而 `TS` 仍为 Fredholm。

这不是把最终复合定理薄包装：Lean 证明实际提取两边的拟逆，调用拟逆的反序复合定理，再从拟逆
重新构造 `ContinuousLinearMap.IsFredholm`。

# 指数可加性

Fredholm 性提供 `ker S`、`ker T`、`F/range S` 与 `G/range T` 的有限维实例。Mathlib
`LinearMap.index_comp` 对复合的核与余核建立六项正合列，并由 Euler 特征数得到

`index(TS) = index(T) + index(S)`。

本条沿用本库已冻结的符号约定 `index = dim ker - dim coker`，没有创建另一种指数。

# 紧扰动稳定性

设 `T : E →L[ℝ] F` 是 Fredholm，`K : E →L[ℝ] F` 紧。取 `T` 的连续拟逆
`S : F →L[ℝ] E`。拟逆关系说明 `TS-I` 是有限秩，因此也是紧算子；`KS` 由紧算子理想性质仍紧。
于是

`(T+K)S = I-C`

其中 `C = (I-TS)-KS` 紧。此前 F5.6 已沿教材路线证明 `I-C` 有有限维核、有限维余核、闭值域，
且指数为零。本条用 Banach 开映射定理补出 Mathlib `IsFredholm` 所要求的 strictness，从而把该链
组织成 `identitySubCompact_isFredholm`。

若 `W` 是 `(T+K)S` 的拟逆，Mathlib 的 `IsQuasiInverse.of_comp_left` 将 `S` 消去，给出
`SW` 是 `T+K` 的拟逆。因此 `T+K` 是 Fredholm。这不是调用 Mathlib 最终紧扰动定理；Mathlib 当前
没有该最终接口。

# 紧扰动下指数不变

令 `U=T+K`。`US` 与 `TS` 都是恒等减紧算子，故指数均为零。复合窗口已经冻结

`index(US)=index(U)+index(S)`，`index(TS)=index(T)+index(S)`。

两式消去 `index(S)`，得到 `index(T+K)=index(T)`。因此紧扰动批真实消费了复合稳定性和指数加法
接口，而没有另建平行指数。

# Lean 对照

- `ContinuousLinearMap.IsFredholm.comp`：Fredholm 复合稳定；
- `fredholmIndex_comp`：指数可加；
- `ContinuousLinearMap.IsFredholm.add_compact`：紧扰动保持 Fredholm 性；
- `fredholmIndex_add_compact`：紧扰动下指数不变。

# 后续边界

F5.7 的复合与紧扰动两批已经完成。小扰动稳定性仍需独立的开性／分块论证；依 Main 协议，它在
本 handoff 后自动转为 `development_open`，但不能由“紧扰动指数不变”静默冒充。
