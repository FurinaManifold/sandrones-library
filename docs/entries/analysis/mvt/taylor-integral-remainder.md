---
id: analysis.mvt.taylor-integral-remainder
kind: theorem
state: verified
title: "Taylor 公式的 Riemann 积分型余项"
premises: ["analysis.series.taylor", "real-analysis.riemann.eq-lebesgue"]
mathlib: ["taylor_integral_remainder", "iteratedDerivWithin_eq_iteratedDeriv", "intervalIntegral.integral_congr_uIoo"]
provenance:
  source_type: book
  ref: "数学分析 II：Taylor 公式的积分型余项"
---

# 陈述

若 `c<x`，且实函数 `f` 具有连续的 `n+1` 阶导数，则

\[
f(x)=\sum_{k=0}^{n}\frac{f^{(k)}(c)}{k!}(x-c)^k+
\int_c^x\frac{(x-t)^n}{n!}f^{(n+1)}(t)\,dt.
\]

这里的有限和是本库已有的 `TaylorSeries.polynomial`，积分是从 Darboux 下和定义的
`riemannIntegral`。

# 证明路线

Mathlib 的 `taylor_integral_remainder` 已经给出区间积分版本，但其陈述使用
`taylorWithinEval` 和 `iteratedDerivWithin`。本条目完成三个转换：

1. 由全局 `ContDiff` 把 `taylorWithinEval` 识别为教材 Taylor 多项式；
2. 闭区间非退化，因此具有唯一可微性；在开区间内部将区间内迭代导数识别为全局
   `iteratedDeriv`，端点差异不影响区间积分；
3. 高阶导数连续，余项被积函数也连续，故用 Riemann–Lebesgue 积分值桥把区间积分
   转为自建 Riemann 积分。

# Lean 对照

- `TaylorSeries.integral_remainder`：一般积分型余项；
- `TaylorSeries.exp_integral_remainder`：指数函数实例，其中所有高阶导数均化为 `exp`。

# 边界

当前版本按自建 Riemann 积分的正向区间接口要求 `c<x`。Mathlib 的底层有向区间公式
本身可处理反向区间；待自建积分补齐反向端点约定后，可以推广为 `c≠x`。

# 公理依赖

由注册审计脚本读取 Lean 定理得到。
