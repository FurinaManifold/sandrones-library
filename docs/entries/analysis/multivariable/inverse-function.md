---
id: analysis.multivariable.inverse-function
kind: theorem
state: verified
title: "多元反函数定理"
premises: ["analysis.multivariable.frechet", "analysis.multivariable.coordinates"]
mathlib: ["ContDiffAt.toOpenPartialHomeomorph", "HasStrictFDerivAt.to_localInverse"]
provenance:
  source_type: book
  ref: "spivak-calculus-manifolds-1965"
---

# 动机

非线性映射何时能在一点附近反解，是坐标变换、换元积分和隐函数理论的基础问题。

# 直觉

若函数在一点的最佳线性近似是可逆映射，那么充分靠近该点时，非线性误差不会破坏可逆性。

# 陈述（自然语言）

`C¹` 映射在一点的全微分可逆时，它在该点附近是局部同胚；局部逆仍为 `C¹`，
且逆映射导数等于原导数的逆。

# 陈述（Lean 对照）

结论构造 `OpenPartialHomeomorph`，并同时给出 source/target 基点成员、
`ContDiffAt` 和 `HasFDerivAt` 形式的逆导数公式。

# 思维脉络（thinking trace）

先把 `C¹ + HasFDerivAt` 提升为严格可微，再调用定量局部逆构造；最后在局部同胚的
逆映射上转移光滑性和导数。

# 自然语言 ↔ Lean 映射

- 可逆全微分 ↔ `E ≃L[ℝ] F`；局部同胚 ↔ `OpenPartialHomeomorph`。
- 逆导数 ↔ `L.symm : F →L[ℝ] E`。

# 依赖（人话版）

依赖 Fréchet 全微分、连续线性同构及多元链式法则。

# 应用与陷阱

结论是局部而非全局可逆；可逆导数只控制基点附近，不能推出函数在整个空间单射。
