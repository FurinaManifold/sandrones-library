---
id: real-analysis.riemann.mean-value
kind: theorem
state: verified
title: "Riemann 积分中值定理与周期积分"
premises: ["real-analysis.riemann.algebra", "analysis.continuity.max-min", "analysis.continuity.intermediate-value"]
mathlib: ["intermediate_value_uIcc", "Function.Periodic.intervalIntegral_add_eq"]
provenance:
  source_type: book
  ref: "folland-real-analysis-1999"
---

# 内容

本条目包含两个教材结论：闭区间连续函数的第一积分中值定理，以及连续周期函数
在任意一个完整周期上的积分与起点无关。

# 积分中值定理

若 `a<b` 且 `f` 在 `[a,b]` 连续，则存在 `ξ∈[a,b]`，使

`riemannIntegral f a b = f ξ · (b-a)`。

证明先取函数的最小值点 `xm` 和最大值点 `xM`。由积分单调性，积分平均值
`A=(∫f)/(b-a)` 位于 `f xm` 与 `f xM` 之间；再在连接两个极值点的无序闭区间
上应用介值定理，取得满足 `f ξ=A` 的点。

# 周期积分

若 `T>0`、`f` 连续且以 `T` 为周期，则对任意 `s,t`，

`riemannIntegral f t (t+T) = riemannIntegral f s (s+T)`。

该结论经连续函数积分值桥梁转到区间积分侧，再使用周期函数整周期积分的平移
不变性。

# Lean 对照

- `riemannIntegral_mean_value`：第一积分中值定理；
- `riemannIntegral_periodic_one_period`：完整周期积分与起点无关。

# 依赖与陷阱

中值定理依赖上一批积分单调性、连续函数最值定理和介值定理。`a<b` 不仅保证
区间非退化，也保证除以 `b-a` 合法。周期定理要求 `T>0`，从而与当前只对正向
非退化区间建立的 Riemann 积分值桥梁对齐。

# 公理依赖

由注册审计脚本直接读取 Lean 的 `#print axioms` 结果。
