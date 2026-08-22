---
id: analysis.multivariable.rectangle-integral
kind: theorem
state: verified
title: "Lebesgue 闭矩形二重积分与 Fubini 教材接口"
premises: ["real-analysis.measure.fubini"]
mathlib: ["MeasureTheory.setIntegral_prod", "MeasureTheory.intervalIntegral_intervalIntegral_swap"]
provenance:
  source_type: book
  ref: "多元微积分：矩形区域上的二重积分"
---

# 定位

本条目不是用 Lebesgue 积分取代教材中的多元 Riemann 定义，而是建立全库真正依赖的
数值积分地基。后续将另行定义矩形/长方体上的多元 Riemann 积分，并证明二者在教材
可积函数上的数值一致性。

# 陈述

连续函数在闭矩形上可积；一般可积函数的矩形积分等于先纵后横的迭代集合积分；在
有向区间积分语言下，两种积分次序可以交换。常函数 `1` 的积分等于矩形面积
`(b-a)(d-c)`。

# Lean 对照

- 闭矩形：`closedRectangle a b c d`；
- 二重积分：`rectangleIntegral f a b c d`；
- Fubini 教材形式：`rectangleIntegral_eq_iterated`；
- 有向区间换序：`intervalIntegral_rectangle_swap`。
