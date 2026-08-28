---
id: functional-analysis.fredholm.stability
family: functional-analysis.operator
variant: composition-first-window
kind: theorem
state: verified
title: Fredholm 算子的稳定性
summary: Fredholm 算子的复合稳定性与指数可加性
premises: [functional-analysis.fredholm.definition]
mathlib: [ContinuousLinearMap.IsFredholm, LinearMap.IsQuasiInverse, LinearMap.index_comp]
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

# Lean 对照

- `ContinuousLinearMap.IsFredholm.comp`：Fredholm 复合稳定；
- `fredholmIndex_comp`：指数可加；

# 后续边界

本条只登记复合稳定性与指数可加性。紧扰动由独立 Entry
`functional-analysis.fredholm.stability-compact` 承载，小扰动再使用独立文件开发。
