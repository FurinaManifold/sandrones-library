---
id: complex-analysis.holomorphic.power-series
kind: theorem
state: verified
title: "复幂级数在收敛圆内全纯并可逐项求导"
summary: 用系数与中心定义复幂级数，建立收敛半径、圆内全纯性和显式逐项求导公式
premises: ["complex-analysis.holomorphic.definition"]
mathlib: ["FormalMultilinearSeries.ofScalars", "FormalMultilinearSeries.radius", "FormalMultilinearSeries.hasFPowerSeriesOnBall", "HasFPowerSeriesOnBall.comp_sub", "HasFPowerSeriesOnBall.differentiableOn", "HasFPowerSeriesOnBall.fderiv", "FormalMultilinearSeries.hasFDerivAt_sum", "FormalMultilinearSeries.derivSeries_coeff_one", "ContinuousLinearMap.map_tsum"]
provenance:
  source_type: book
  ref: "Conway, Functions of One Complex Variable I（幂级数与解析函数）"
---

# 定义

`complexPowerSeries a c z` 是教材中的 `∑ aₙ(z-c)ⁿ`。`powerSeriesRadius a` 是其扩展
非负实数值收敛半径，允许取 `∞`。`termwiseDerivativePowerSeries a c z` 是形式导级数的和；
在收敛圆内，它展开为 `∑ (n+1)aₙ₊₁(z-c)ⁿ`。

# 动机

幂级数是复分析中构造全纯函数的基本工具。核心事实不仅是圆内逐点收敛，而是圆内任意较小闭圆盘上
具有足够强的一致控制，因此极限仍可微，并且求导可与无限求和交换。

# 直觉

在严格小于收敛半径的位置，仍能向外留出一段余量。这个余量给各项及其导数提供几何级数型控制，
从而允许逐项求导。求导把第 `n+1` 项的幂次降为 `n`，同时带下系数 `n+1`。

# 陈述（自然语言）

- 底层标量形式幂级数的和就是显式级数 `∑ aₙ(z-c)ⁿ`。
- 正收敛半径时，该和函数在以 `c` 为中心、收敛半径为半径的开圆内全纯。
- 圆内每一点均可逐项求导，导数为 `∑ (n+1)aₙ₊₁(z-c)ⁿ`。

# 陈述（Lean 对照）

`complexPowerSeries_eq_tsum`、`termwiseDerivativePowerSeries_eq_tsum`、
`powerSeries_holomorphicOn_convergenceDisc`、`powerSeries_hasDerivAt_termwise`。

# 思维脉络（thinking trace）

先用 `FormalMultilinearSeries.ofScalars ℂ a` 将普通系数序列送入 Mathlib 的形式多线性级数后端。
其 `radius` 正是课程所需的收敛半径。中心为零的后端收敛球经 `comp_sub c` 平移到中心 `c`，再通过
`holomorphicOnTextbook_iff_differentiableOn` 返回本库教材接口。导数部分先取得后端导级数，随后用
`derivSeries_coeff_one` 识别第 `n` 个显式系数，并用连续线性求值映射交换 `tsum` 与在 `1` 处求值。

# 自然语言 ↔ Lean 映射

- `∑ aₙ(z-c)ⁿ` ↔ `complexPowerSeries a c z`。
- 收敛圆 ↔ `Metric.eball c (powerSeriesRadius a)`。
- “圆内全纯” ↔ `HolomorphicOnTextbook ... (Metric.eball ...)`。
- “逐项导数” ↔ `termwiseDerivativePowerSeries_eq_tsum` 与 `HasDerivAt` 证书。
- `tsum_congr` 表示逐项相同的两个无限和相同；`ContinuousLinearMap.map_tsum` 表示连续线性运算可穿过收敛和。

# 依赖（人话版）

依赖前一条教材全纯定义及其与 Mathlib `DifferentiableOn ℂ` 的开集桥。证明后端使用形式多线性幂级数的
收敛半径、收敛球证书和导级数接口；这些结构不出现在主要课程定理的公开输入中。

# 应用与陷阱

- 全纯区域是开收敛圆，不包括边界；边界上的收敛与可微性需要额外分析。
- `powerSeriesRadius` 取值于 `ℝ≥0∞`，因此可统一表达零半径、有限半径和整函数的无限半径。
- 逐项导数展开式只在收敛圆内陈述；圆外 `tsum` 的默认值不代表原级数实际收敛。
- `derivSeries.sum` 的值是连续线性映射，复一维导数需在 `1` 上求值后才成为复数。
