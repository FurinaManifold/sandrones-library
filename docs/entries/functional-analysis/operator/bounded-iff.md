---
id: functional-analysis.operator.bounded-iff
kind: theorem
state: staging
title: 线性算子有界与连续等价
premises: [functional-analysis.operator.continuous-linear-map]
mathlib: [LinearMap.mkContinuous, ContinuousLinearMap.continuous, ContinuousLinearMap.le_opNorm]
provenance: {source_type: book, ref: "Conway, A Course in Functional Analysis, Chapter I"}
---

# 动机

全局范数估计适合计算，拓扑连续性适合极限论证。线性结构使两种条件等价，因此可以在估计和极限
语言之间自由切换。

# 直觉

有全局界时，输入趋近零会迫使输出趋近零；线性性再把零点连续推广到处处连续。反过来，连续
线性映射的算子范数给出统一的全局放大倍数。

# 陈述（自然语言）

实赋范空间之间的线性映射连续，当且仅当存在常数统一控制所有输出范数。

# 陈述（Lean 对照）

- `continuous_of_isBoundedLinearOperator`：有界推出连续。
- `isBoundedLinearOperator_of_continuous`：连续推出全局有界。
- `isBoundedLinearOperator_iff_continuous`：合并成双向等价。

# 思维脉络

正向直接用定义中的常数构造连续线性映射。反向临时把连续证明与原线性映射打包，再用其算子范数
估计；打包对象没有泄漏到最终定理签名。

# 自然语言 ↔ Lean 映射

- “连续”对应 `Continuous T`。
- “有界”对应本库 `IsBoundedLinearOperator T`，不是集合像有界。
- `E →L[ℝ] F` 只在反向证明内部提供算子范数。

# 依赖

依赖前条有界线性算子定义及其到 `ContinuousLinearMap` 的桥。

# 应用与边界

这里的“有界算子”是把有界集合送到有界集合的线性版本，并等价于全局 Lipschitz 型估计；它不表示
函数值域本身是一个有界集合。
