---
id: functional-analysis.open-mapping
kind: theorem
state: staging
title: Banach 开映射定理
premises: [functional-analysis.baire.theorem, functional-analysis.operator.continuous-linear-map]
mathlib: [IsOpenMap, Topology.IsQuotientMap, ContinuousLinearMap.isOpenMap, ContinuousLinearMap.isQuotientMap]
provenance: {source_type: book, ref: "Conway, A Course in Functional Analysis, Chapter II"}
---

# 动机

连续性控制开集的原像，却通常不能保证开集的像仍开。Banach 开映射定理说明，在线性、满射和两端
完备的条件下，像方向也获得强拓扑控制；这正是有界逆定理的核心来源。

# 教材定义与正式承载

教材称 `T` 为开映射，是指每个开集 `U` 的像 `T '' U` 都是开集。Mathlib 的 `IsOpenMap T`
逐字表达这一量词，因此直接作为正式承载。算子仍使用 F1 已解释的 `ContinuousLinearMap`，满射写成
`Function.Surjective T`；不另建“开线性算子”结构。

# 陈述（自然语言）

设 `E,F` 是 Banach 空间。任何满射连续线性映射 `T : E → F` 都是开映射，即把每个开集映为开集；
连同其连续性和满射性，`T` 还是拓扑商映射。

# 陈述（Lean 对照）

对应 `surjective_continuousLinearMap_isOpenMap`、
`image_isOpen_of_surjective_continuousLinearMap` 和
`surjective_continuousLinearMap_isQuotientMap`。

# 思维脉络

利用满射性把值域写成一列闭球像之闭包的并。Baire 定理保证某个闭包有非空内部；线性平移与缩放
把这一局部信息移到原点。随后用逐次逼近构造真正的原像，得到值域原点附近的小球包含在定义域
单位球的像中，再平移便证明任意开集的像为开集。

# 自然语言 ↔ Lean 映射

- 连续线性映射：`T : E →L[ℝ] F`。
- 满射：`Function.Surjective T`。
- 开映射：`IsOpenMap T`，展开为 `∀ U, IsOpen U → IsOpen (T '' U)`。
- 拓扑商映射：`Topology.IsQuotientMap T`。
- 两端完备：`[BanachSpace E] [BanachSpace F]`。

# 依赖

依赖 Baire 定理、F1 的连续线性算子接口和 Banach 完备性；一致有界原理与本条共享 Baire 前置，但
两者的结论不互相依赖。

# 应用与边界

值域完备性是定理的一部分；一般赋范值域不能直接套用。本条不声称非线性连续满射必为开映射，
也不展开更一般拓扑群作用版本。商映射结论只是连续、满射、开映射三者的标准组合。
