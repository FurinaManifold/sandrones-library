---
id: abstract-algebra.group.permutation
kind: theorem
state: verified
title: "置换群、循环分解与交错群"
summary: Cayley 定理、互不相交循环分解、换位分解、符号同态、奇偶性与交错群
premises: ["abstract-algebra.group.action"]
mathlib: ["Equiv.Perm.subgroupOfMulAction", "Equiv.Perm.cycleFactorsFinset", "Equiv.Perm.truncSwapFactors", "Equiv.Perm.sign", "alternatingGroup"]
provenance:
  source_type: book
  ref: "Rotman, An Introduction to the Theory of Groups（置换群）"
---

# 动机

置换群是群的具体模型。Cayley 定理说明任意抽象群都能嵌入对称群；有限置换的循环与
换位分解则提供实际计算方法，并自然引出置换奇偶性和交错群。

# 直觉

一个置换只是在重新排列集合。把被移动的点按“沿置换反复作用可互相到达”分组，便得到
互不相交循环。每个循环还能拆成换位；虽然拆法不唯一，换位数量的奇偶性却不变。

# 陈述（自然语言）

每个群同构于某个对称群的子群。有限置换唯一分解为互不相交循环（忽略循环次序），
并可写成换位乘积。符号同态把换位送到 `-1`，其核是偶置换组成的交错群；当底集至少
有两个元素时，交错群指数为二、阶为 `n!/2`。

# 陈述（Lean 对照）

`SymmetricGroup`、`cayleyEquiv`、`cycleFactor_isCycle`、
`cycleFactors_pairwise_disjoint`、`permutation_eq_product_cycleFactors`、
`exists_transposition_factorization`、`permutationSign`、`transposition_is_odd`、
`alternatingGroup_mem_iff_even`、`transposition_factorization_even_iff`、
`alternatingGroup_index_two/card`。

# 思维脉络（thinking trace）

Cayley 定理使用群在自身上的忠实正则作用。循环分解按轨道收集置换的支集；不交循环交换，
所以乘积恢复原置换。换位分解定义符号后，符号的乘法性保证任意两种换位分解具有相同奇偶性。

# 自然语言 ↔ Lean 映射

- 对称群 `Sym(X)` ↔ `Equiv.Perm X`。
- 支集 ↔ `σ.support`；循环 ↔ `Equiv.Perm.IsCycle`。
- 换位 ↔ `Equiv.swap x y` / `Equiv.Perm.IsSwap`。
- 符号 ↔ `Equiv.Perm.sign : Perm X →* ℤˣ`。
- 交错群 ↔ `alternatingGroup X`。

# 依赖（人话版）

依赖群作用、轨道、群同态、核与像以及有限集合。

# 应用与陷阱

- Cayley 定理给出的目标是置换群中的值域子群，而不是声称 `G` 等于整个对称群。
- 循环分解忽略不动点；不同循环次序不重要，因为不交循环彼此交换。
- 换位分解本身不唯一，只有长度奇偶性唯一。
- 符号取值属于整数单位群 `ℤˣ={±1}`，不是普通整数类型。
