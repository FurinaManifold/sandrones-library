---
id: analysis.power-series.radius
kind: theorem
state: verified
title: "幂级数的收敛半径"
premises: ["analysis.power-series.definition", "analysis.series.tests"]
mathlib: ["summable_powerSeries_of_norm_lt", "lt_sSup_iff", "le_sSup", "ENNReal.ofReal_lt_ofReal_iff"]
provenance:
  source_type: textbook
  ref: "数学分析 II：幂级数收敛半径定理"
---

# 内容

收敛半径 `radius a c : ℝ≥0∞` 定义为所有可由收敛点支撑的距离之上确界。使用扩展非负
实数可以同时表达有限半径和半径 `∞`。

核心比较引理说明：若幂级数在 `x` 处收敛，则在任何满足
`|y-c|<|x-c|` 的点 `y` 处绝对收敛。由此得到：

- `|x-c|<R` 时绝对收敛；
- `|x-c|>R` 时自然顺序部分和不收敛；
- `|x-c|=R` 的边界情形不由半径定理决定，留给端点判定逐点处理。

# 证明思路

内点比较使用几何比值：在外侧收敛点处部分和为 Cauchy 列，而更内侧点多出一个模小于
`1` 的几何因子，因此绝对可和。收敛半径的两个方向随后分别由完整格上的 `lt_sSup_iff`
和 `le_sSup` 得出。

# 公理依赖

核查得到依赖为命题外延、经典选择与商类型健全性。
