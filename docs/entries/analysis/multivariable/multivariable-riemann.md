---
id: analysis.multivariable.riemann-box
kind: definition
state: verified
title: "闭盒上的多元 Riemann 积分"
premises: ["analysis.multivariable.jordan-region"]
mathlib: ["BoxIntegral.IntegrationParams.Riemann", "ContinuousOn.hasBoxIntegral"]
provenance:
  source_type: book
  ref: "数学分析：闭长方体上的多元 Riemann 积分"
---

# 定义

`HasRiemannBoxIntegral f I y` 表示闭盒 `I` 的带标签细分所形成的 Riemann 和趋于
`y`。`RiemannIntegrableOnBox f I` 表示这样的极限存在，`riemannBoxIntegral f I`
给出积分值。

底层采用 `BoxIntegral.IntegrationParams.Riemann`。该参数要求控制所有小盒的尺度使用
同一个常数，因而确实对应多元 Riemann 积分，而不是一般的 Henstock 或 McShane 积分。

# 数值桥

若 `f` 在闭盒 `Box.Icc I` 上连续，则它 Riemann 可积，并且

`riemannBoxIntegral f I = ∫ x in I, f x`。

右侧是 Lebesgue 集合积分。因盒的边界零体积，半开盒 `I` 与闭盒 `Box.Icc I` 的
积分值相同。常函数 `1` 的积分进一步校准为所有边长之积。

# 后续

对 Jordan 可测区域，将函数在外包闭盒上作零延拓，由此定义区域上的 Riemann 积分；
区域边界零体积保证其值与 Lebesgue 区域积分一致。
