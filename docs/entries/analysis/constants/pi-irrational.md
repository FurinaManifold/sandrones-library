---
id: analysis.constants.pi-irrational
kind: theorem
state: verified
title: "圆周率 π 的无理性"
premises: ["analysis.constants.pi-definition"]
mathlib: ["irrational_pi"]
provenance:
  source_type: book
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

教材层常数 `pi` 是无理数，即不存在有理数 `q` 使 `pi=q`。

# 证明思路

本库定义 `pi := Real.pi`，所以先用 `pi_eq_real_pi` 展开教材层接口，再应用
Mathlib 的 `irrational_pi`。后者并非公理或数值近似：其源码完整形式化了
Cartwright 的积分证明，通过构造整系数多项式与严格位于 `0`、`1` 之间的整数
得到矛盾。

# Lean 对照

`pi_irrational : Irrational pi` 先重写为 `Irrational Real.pi`，随后精确使用
`irrational_pi`。

# 依赖与公理

库内只依赖 `analysis.constants.pi-definition`；核心数学证明来自
`Mathlib.Analysis.Real.Pi.Irrational`。公理依赖由注册审计结果记录。

# 陷阱

`π` 的无理性弱于超越性。本条目不能替代未来的 `analysis.constants.pi-transcendence`，
也没有把十进制近似当作无理性的证据。
