---
id: functional-analysis.functional-calculus.holomorphic-neighborhood
family: functional-analysis.operator
variant: spectrum-neighborhood
kind: definition
state: verified
title: 谱邻域上的全纯函数
summary: 全纯函数演算的输入是在谱的某个开邻域上全纯的复函数
premises: [functional-analysis.spectrum.nonempty-compact, complex-analysis.holomorphic.definition]
mathlib: [spectrum, IsOpen, DifferentiableOn]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 为什么需要谱邻域

设 `A` 是复 Banach 代数，`a : A`。教材中的全纯函数演算并不接收一个只定义在 `spectrum ℂ a` 上的
函数，也不要求函数在整个复平面全纯；它要求存在开集 `U`，使

`spectrum ℂ a ⊆ U`

且 `f` 在 `U` 上全纯。本库把这一量词直接冻结为
`HolomorphicOnNhdSpectrum a f`：

```lean
∃ U : Set ℂ, IsOpen U ∧ spectrum ℂ a ⊆ U ∧ DifferentiableOn ℂ f U
```

定义以显式 `[CompleteSpace A]` 参数固定复 Banach 代数 carrier；本条仍只描述输入条件，没有提前
定义 Dunford 积分。

# 见证规则

`holomorphicOnNhdSpectrum_of_open` 从一个显式开谱邻域建立定义。
`holomorphicOnNhdSpectrum_of_subset` 说明可以把已知全纯的集合缩小到仍包含谱的开子集。

若 `f` 与 `g` 各自在某个谱邻域上全纯，它们的见证邻域可能不同。
`HolomorphicOnNhdSpectrum.exists_inter` 取两个开集的交集，得到同时适用于二者的共同谱邻域。
因此加法和乘法的闭合性没有暗中假定两者一开始具有相同定义域。

# 基本正例

- `HolomorphicOnNhdSpectrum.const`：常函数；
- `HolomorphicOnNhdSpectrum.id`：恒等函数；
- `HolomorphicOnNhdSpectrum.polynomial`：`z ↦ p.eval z`；
- `HolomorphicOnNhdSpectrum.add`、`.mul`：逐点和与积。

这些结论只证明函数是合法的未来函数演算输入。特别地，本条没有定义 `f(a)`，没有建立 germ
quotient、Dunford integral、代数同态、谱映射或复合定理。Mathlib 的 `cfc` 是 C*-代数连续函数
演算，也不是本定义的实现。

# Lean 对照

- `HolomorphicOnNhdSpectrum`：存在开谱邻域的教材定义；
- `holomorphicOnNhdSpectrum_of_open`、`holomorphicOnNhdSpectrum_of_subset`：见证规则；
- `HolomorphicOnNhdSpectrum.exists_inter`：共同交集见证；
- `HolomorphicOnNhdSpectrum.const`、`.id`、`.polynomial`、`.add`、`.mul`：基本正例。
