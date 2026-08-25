---
id: functional-analysis.operator.continuous-linear-map
kind: definition
state: verified
title: 连续线性算子
premises: [topology.normed-space.def]
mathlib: [ContinuousLinearMap, ContinuousLinearMap.le_opNorm, ContinuousLinearMap.continuous]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

泛函分析的基本态射既保持线性运算，又保持极限。连续线性算子因此同时连接线性代数、拓扑和范数
估计。

# 教材定义与正式承载

教材定义是“线性且连续的映射”。Mathlib `ContinuousLinearMap` 正好打包这两项数据，没有额外
改变量词或数学边界，因此本库直接把 `E →L[ℝ] F` 作为正式公开承载，不建立同构包装。

# 陈述（自然语言）

每个连续线性算子都有一个非负常数 `C`，使 `‖Tx‖≤C‖x‖` 对所有向量成立；其底层函数连续。
零算子可取全局界零。

# 陈述（Lean 对照）

- `continuousLinearMap_exists_bound`：展示正式承载的全局范数刻画。
- `continuousLinearMap_continuous`：取出连续性字段。
- `continuousLinearMap_zero_bound`：直接验证零算子的基本估计。

# 思维脉络

Mathlib 已在打包类型上定义算子范数，并证明 `‖Tx‖≤‖T‖‖x‖`，因此取 `C=‖T‖` 即得全局界。
这不是把高级定理冒充定义，而是说明正式承载如何展开成教材可操作的性质。

# 自然语言 ↔ Lean 映射

- 线性且连续的算子：`T : E →L[ℝ] F`。
- 作用于向量：`T x`。
- 底层连续性：`T.continuous`。
- 全局放大界：`T.le_opNorm x`。

# 依赖

复用拓扑学已解释的 `NormedLinearSpace`，以及线性代数阶段的线性映射概念。

# 应用与边界

本批先讨论实赋范空间。`ContinuousLinearMap` 是语义一致的正式承载，不是私有后端；课程文档必须
继续解释其中的线性、连续和 typeclass 假设。
