---
id: analysis.power-series.endpoints
kind: theorem
state: verified
title: "有限收敛半径的端点分类"
premises: ["analysis.power-series.radius", "analysis.series.conditional"]
mathlib: ["ENNReal.ofReal_toReal", "ENNReal.ofReal_le_ofReal_iff", "ENNReal.ofReal_lt_ofReal_iff", "abs_eq"]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

设实幂级数以 `c` 为中心，且收敛半径 `R` 有限。库中定义
`finiteRadius a c = R.toReal`，并把左右端点写成 `c-R` 与 `c+R`。

精确分类为：幂级数在 `x` 处收敛，当且仅当

- `|x-c|<R`；或
- `x=c-R`，并且左端点代入后的数项级数收敛；或
- `x=c+R`，并且右端点代入后的数项级数收敛。

绝对收敛也有完全平行的分类。这里“端点独立判定”的含义是：收敛半径只决定开区间
内部绝对收敛、外部发散，不能单凭半径判断任一端点；两个端点必须各自化为数项级数后
使用相应判别法。

# 证明思路

先把扩展非负实数不等式通过 `ENNReal.ofReal_toReal` 转回实数，得到任一收敛点满足
`|x-c|≤R`。严格小于时直接使用半径内绝对收敛定理；等号时由
`|x-c|=R` 分解为 `x-c=R` 或 `x-c=-R`，从而确认 `x` 恰为右端点或左端点。
反方向则分别使用内点绝对收敛以及端点假设。

# 公理依赖

核查得到依赖为命题外延、经典选择与商类型健全性。
