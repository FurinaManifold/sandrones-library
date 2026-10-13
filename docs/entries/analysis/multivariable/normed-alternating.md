---
id: analysis.multivariable.normed-alternating
kind: definition
state: verified
title: "连续交替映射的规范范数模型"
premises: []
mathlib: ["ContinuousAlternatingMap", "ContinuousLinearMap.id"]
provenance:
  source_type: book
  ref: "spivak-calculus-manifolds-1965"
---

# 定义

`NormalizedAlternatingSpace E k` 是 Mathlib 连续交替映射空间
`E [⋀^Fin k]→L[ℝ] ℝ` 的透明类型别名。它不是在教材意义上定义一个新的数学对象，
而是为微分形式的连续性与求导固定一个**唯一的实例选择**。

Mathlib 的连续交替映射同时带有由半范数群构成的结构和由值域分离性得到的范数群实例；
在把高阶连续线性映射与 Fréchet 微分组合时，自动实例推断可能选中不同但数学上等价的
结构。本模块用独立命名实例 `normalizedAlternatingSpaceNormedAddCommGroup`、
`normalizedAlternatingSpaceNormedSpace` 固定选择，并提供与 Mathlib 原类型之间的恒等
连续线性桥 `toNormalizedAlternatingSpace`、`fromNormalizedAlternatingSpace`。

# 角色与边界（公开泄漏披露）

- **Mathlib 角色**：正式承载是 Mathlib 的 `ContinuousAlternatingMap`；本模块是
  **本库特殊定义的桥**，不是本库自建教材定义，也不是可退役的重复实现。
- **公开签名暴露 Mathlib 结构**：`NormalizedAlternatingSpace E k` 的定义右侧直接是
  Mathlib 类型，两个桥就是 `ContinuousLinearMap.id`。因此本条目的教材价值仅在于
  “固定实例、隔离推断”，不声称新增数学内容。
- **上层使用者**：`analysis.multivariable.differential-forms`
  （`SandronesLibrary/Analysis/DifferentialForms.lean`）中的
  `normalizedAlternatingSpace_differentiableAt`、`normalizedWedgeLinearMap`、
  `normalizedWedgeContinuousBilinear` 以该模型表达外微分与楔积的连续性与可微性。
- **未完成边界**：本条目不含一般 Banach 空间上的交替形式理论，也不替代
  `DifferentialForms.lean` 中已登记的形式代数接口。

# 来源说明

该桥为微分形式服务的动机见 Spivak, *Calculus on Manifolds* 关于微分形式与拉回的章节；
具体实例选择是 Lean 形式化层面的工程决定，不对应教材命题。
