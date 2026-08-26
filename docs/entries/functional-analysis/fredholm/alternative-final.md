---
id: functional-analysis.fredholm.alternative-final
family: functional-analysis.fredholm
variant: identity-minus-compact-injective-iff-surjective
kind: theorem
state: verified
title: 恒等减紧算子的 Fredholm 备择
summary: 由有限维核余核与指数零推出 I-K 单射当且仅当满射
premises: [functional-analysis.fredholm.cokernel, functional-analysis.fredholm.index-zero]
mathlib: [LinearMap.index_of_injective, LinearMap.index_of_surjective, Submodule.finrank_eq_zero]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 这条备择究竟在说什么

设 `K` 是实 Banach 空间上的紧算子，记 `D = I-K`。Fredholm 备择在这里不是说“单射或满射二者
恰有一个成立”，而是说二者等价：只要知道其中一个，就自动得到另一个。因此，对方程
`x-Kx=y`，唯一性与对每个右端项都可解是同一件事。

# 为什么前两窗是必要的

前面的开发已经证明 `ker D` 与余核 `E / range D` 都有限维，而且

`index D = dim(ker D) - dim(E / range D) = 0`。

这条整数等式是两边互相推出的桥。若 `D` 单射，则核维数为零；指数为零迫使余核维数也为零。
有限维商空间维数为零意味着商空间只有零元，也就是 `range D = E`，故 `D` 满射。反方向完全
对称：满射使余核为零，指数为零迫使核为零，故 `D` 单射。

# Lean 证明怎样对应这段话

`identitySubCompact_injective_iff_surjective` 先局部记 `D := identitySubCompact K`，并把前两窗给出的
核、余核有限维实例和 `index_identitySubCompact_eq_zero` 放入上下文。

- 单射方向使用 `LinearMap.index_of_injective`，把指数改写成余核维数的相反数；与指数零合并后，
  得到余核 `finrank = 0`，再由商空间平凡推出 `range = ⊤`。
- 满射方向使用 `LinearMap.index_of_surjective`，把指数改写成核维数；指数零于是给出
  `finrank ker = 0`，再由 `ker = ⊥` 得到单射。

`identitySubCompact_ker_eq_bot_iff_range_eq_top` 只是把同一结论改写成核与值域的子空间语言，方便
后续谱论消费者使用；它没有重新运行紧性、闭值域或 Fitting 分解证明。

# 容易误读的地方

- “指数为零”本身不保证单射或满射；它只保证有限维核和余核的维数相同。
- 从商空间维数为零到满射，要使用前窗已经保证的有限维余核，而不能把任意商空间的维数当作可用。
- 本条没有导入 Mathlib 的最终 Fredholm alternative package；它真实消费了本库前两窗冻结的中间
  定理，因此保留了教材证明链。
