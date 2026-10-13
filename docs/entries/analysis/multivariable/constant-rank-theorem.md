---
id: analysis.multivariable.constant-rank-theorem
kind: theorem
state: verified
title: "Rudin 一般常秩定理"
premises: []
mathlib: ["ContDiffAt.toOpenPartialHomeomorph"]
provenance:
  source_type: book
  ref: spivak-calculus-manifolds-1965
---

# 陈述与证明路线

若 `F : ℝⁿ → ℝᵐ` 在开集上为 `C¹` 且导数秩恒为 `r`，则在每个基点附近可用局部
`C¹` 坐标把它写成线性秩 `r` 部分加上只依赖该线性部分的余项。

形式化严格采用 Rudin 的构造：令 `A=F'(a)`，取投影 `P` 到 `range A` 及右逆 `S`，
构造 `G(x)=x+SP(F(x)-Ax)`。由 `G'(a)=I` 取得局部逆，再证明余项沿 `ker A` 的纤维
保持常值并下降到 `range A`。

# Lean 对照

主定理为 `constant_rank_theorem_rudin_9_32`，局部逆由 `OpenPartialHomeomorph`
表达；结论中的 `φ` 取值于 `ker P`。
