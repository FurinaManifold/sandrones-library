---
id: complex-analysis.cauchy.derivatives
kind: theorem
state: verified
title: "Cauchy 高阶导数公式与估计"
summary: 以边界圆周积分表示圆心处的高阶导数，并由边界上界得到 Cauchy 估计
premises: ["complex-analysis.cauchy.formula"]
mathlib: ["DifferentiableOn.circleIntegral_one_div_sub_center_pow_smul", "Complex.norm_iteratedDeriv_le_of_forall_mem_sphere_norm_le", "iteratedDeriv"]
provenance:
  source_type: book
  ref: "Conway, Functions of One Complex Variable I（Cauchy 导数公式与估计）"
---

# 定义

`iteratedDeriv n f c` 是 `f` 在 `c` 处的 `n` 阶复导数。`Metric.sphere c R` 是边界圆周，
`n.factorial` 是 `n!`。

# 动机

高阶 Cauchy 公式表明全纯性自动带来任意阶可微性。对积分取范数后，边界值的一个简单上界
就能控制圆心处的所有高阶导数。

# 直觉

对 Cauchy 核对 `w` 反复求导，每次都多出一个 `1/(z-w)` 因子，并累积出 `n!`。
在半径 `R` 的边界上，`‖z-c‖=R`，因此分母给出 `Rⁿ` 的衰减。

# 陈述（自然语言）

若 `R>0` 且 `f` 在闭圆盘附近全纯，则圆心的 `n` 阶导数由核
`1/(z-c)^(n+1)` 的圆周积分给出。若边界上 `‖f z‖≤C`，则
`‖f⁽ⁿ⁾(c)‖ ≤ n! C / Rⁿ`。

# 陈述（Lean 对照）

`cauchy_integral_formula_iteratedDeriv` 和 `cauchy_estimate`。两者都接受
`HolomorphicOnTextbook f (Metric.closedBall c R)` 与 `0 < R`。

# 思维脉络（thinking trace）

先把教材全纯前提转成闭圆盘上的 Mathlib `DifferentiableOn`。高阶公式直接应用圆周积分
后端并改写复数标量乘法。估计则先将闭圆盘可微性限制到开圆盘，同时保留闭包上的
连续性，然后应用 Mathlib 的 Cauchy 估计。

# 自然语言 ↔ Lean 映射

- `f⁽ⁿ⁾(c)` ↔ `iteratedDeriv n f c`。
- `n!` ↔ `n.factorial`。
- 边界上界 ↔ `∀ z ∈ Metric.sphere c R, ‖f z‖ ≤ C`。
- `R>0` ↔ `hR : 0 < R`。

# 依赖（人话版）

依赖 Cauchy 积分公式的圆周后端、Mathlib 的迭代导数和圆周积分范数估计。

# 应用与陷阱

- 公式在圆心 `c` 处陈述；估计任意内点时需重新选择以该点为中心的圆盘。
- `R>0` 不可删除，否则边界核和 `Rⁿ` 分母失去意义。
- `C` 是对范数的实数上界，不要把它与复函数值直接比较。
- `n=0` 时估计退化为圆心函数值的边界控制。
