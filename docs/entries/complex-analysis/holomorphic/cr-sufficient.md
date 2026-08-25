---
id: complex-analysis.holomorphic.cr-sufficient
kind: theorem
state: verified
title: "Cauchy–Riemann 方程的充分性"
summary: 实 Fréchet 可微函数若在一点满足 CR 方程，则该点复可微，并确定复导数
premises: ["complex-analysis.holomorphic.cauchy-riemann"]
mathlib: ["differentiableAt_complex_iff_differentiableAt_real", "complexOfReal_hasDerivAt"]
provenance:
  source_type: book
  ref: "ahlfors-complex-analysis-1979"
---

# 动机

只从复可微推出 CR 还不够；教材判据还要回答反向何时成立。正确前提不是“存在四个
方向偏导”，而是整个二元映射在该点实 Fréchet 可微。

# 直觉

实 Fréchet 可微给出一个统一控制所有方向误差的实线性主部 `L`。CR 方程说明
`L(I)=iL(1)`，从而 `L` 实际尊重复标量乘法，是一个复线性映射。因此同一个一阶近似
就是复 Fréchet 导数，复导数值为 `L(1)=uₓ+ivₓ`。

# 陈述（自然语言）

- 若 `f` 在 `z` 实 Fréchet 可微并满足 CR，则 `f` 在 `z` 复可微。
- 在这些条件下，复导数就是实 Fréchet 导数沿 x 方向 `1` 的值。

# 陈述（Lean 对照）

`complexDifferentiableAt_of_realDifferentiableAt_cauchyRiemann`、
`hasComplexDerivAt_of_realDifferentiableAt_cauchyRiemann`。

# 思维脉络（thinking trace）

先用上一条目的坐标桥把两条 CR 方程合成为 `L(I)=iL(1)`。Mathlib 的
`differentiableAt_complex_iff_differentiableAt_real` 把“实可微且 L 复线性”组装为
复 Fréchet 可微，再通过本库公共桥回到差商定义；更精确的导数定理把 `L` 转成连续
复线性映射，并在 `1` 处求值得到导数。

# 自然语言 ↔ Lean 映射

- “实 Fréchet 可微” ↔ `DifferentiableAt ℝ f z`。
- “复可微” ↔ `ComplexDifferentiableAtTextbook f z`。
- “复导数为 `uₓ+ivₓ`” ↔ `HasDerivAt f (fderiv ℝ f z 1) z`。

# 依赖（人话版）

依赖本库 CR 定义及其复线性桥，并复用 Mathlib 从实线性导数构造复线性导数的可靠后端。

# 应用与陷阱

- 只有 CR 方程而没有实可微性不够；各偏导存在也不自动给出 Fréchet 可微。
- 常见更强假设“偏导在邻域连续”可用来证明实可微，但不属于本条目的最小前提。
- 结论是单点复可微；要推出邻域全纯，必须在邻域每一点验证相应条件。
