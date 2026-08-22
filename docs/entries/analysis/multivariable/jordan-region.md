---
id: analysis.multivariable.jordan-region
kind: definition
state: verified
title: "Jordan 可测区域"
premises: ["analysis.multivariable.rectangle-integral"]
mathlib: ["nullMeasurableSet_of_null_frontier", "closure_ae_eq_of_null_frontier"]
provenance:
  source_type: book
  ref: "数学分析：Jordan 可测区域与多重积分"
---

# 定义

有界集合 `D ⊆ ℝⁿ` 称为 Jordan 可测区域，当且仅当其边界具有零 `n` 维体积：

`volume (frontier D) = 0`。

Lean 中对应 `IsJordanMeasurable D`。这里的体积与后续积分均以 Lebesgue 测度实现；
多元 Riemann 理论随后证明其教材定义与该数值实现一致。

# 基本性质

- Jordan 可测区域对 `volume` 零可测且体积有限；
- 区域、内部和闭包具有相同体积；
- 闭包仍 Jordan 可测；
- 在区域上积分时加入边界不改变积分值。

# 教材意义

积分区域不必是开集或闭集。实际计算通常把区域替换为闭包，并进一步表示成由连续
函数围成的正常区域；边界零体积保证这些替换不改变积分。
